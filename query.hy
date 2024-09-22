(import trytond.model [ModelSQL ModelView fields]
        trytond.pool [Pool]
        trytond.transaction [Transaction]
        trytond.modules.hyton.utils [first]
        trytond.modules.hyton.context [context-company]
        io [BytesIO]
        openpyxl [Workbook]
        datetime)

(setv QUEUE_NAME "data_harvest"
      CONTEXT_COMPANY "context-company")

(defn is-read-only-sql [sql]
  "Check if the SQL is read-only - DQL"
  (let [write-keywords ["INSERT "
                        "UPDATE "
                        "DELETE "
                        "CREATE "
                        "TRUNCATE "
                        "ALTER "
                        "DROP "
                        "RENAME "
                        "REPLACE "
                        "GRANT "
                        "REVOKE "
                        "LOCK "
                        "INTO "
                        "EXPLAIN "]
        sql-upper (.strip (.upper sql))]
    (for [keyword write-keywords]
      (when (in keyword sql-upper)
        (return False)))
    (.startswith sql-upper "SELECT ")))

(defn now-formatted-str []
  (.strftime (datetime.datetime.now)
             "_%d%m%Y_%H%M%S"))

(defclass HarvestQuery [ModelSQL ModelView]
  "Harvest Query"
  (setv __name__ "harvest.query"
        name (fields.Char "Name" :required True)
        query (fields.Text "Query" :required True)
        group (fields.Many2One "res.group" "Group")
        )

  (defn is-context-company-required [self]
    (in CONTEXT_COMPANY self.query))
  ;;setup with a button to execute method execute
  (defn [classmethod] __setup__ [cls]
    (.__setup__ (super))
    (.update cls._buttons
             {"harvest"
              {"invisible"
               False}
              }))

  (defn [classmethod
         ModelView.button]
    harvest [cls records]
    (with [(.set_context (Transaction) :queue_name QUEUE_NAME)]
      (for [record records]
        (._execute-query cls.__queue__ record))))

  (defn _execute-query [self]
    (when (is-read-only-sql self.query)
      (with [transaction (.new-transaction (Transaction))]
        (let [cursor (.cursor transaction.connection)]
          (.execute cursor self.query
                    {CONTEXT_COMPANY (context-company)})
          (.export-workbook self
                            (list (map first cursor.description))
                            (.fetchall cursor))))))

  (defn export-workbook [self header records]
    (setv workbook (Workbook)
          ws workbook.active
          result  ((.get (Pool) "harvest.result"))
          output (BytesIO)
          )
    (ws.append header)
    (for [record records]
      (ws.append (list record)))
    ;;  auto-filter first row
    (setv ws.auto_filter.ref ws.dimensions)
    (.save workbook output)
    (setv
      result.name (+ self.name (now-formatted-str) ".xlsx")
      result.data  (.getvalue output)
      result.group  self.group)
    (when (.is-context-company-required self)
      (setv result.company (context-company)))
    (.save result))

  )

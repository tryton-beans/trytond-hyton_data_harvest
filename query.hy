(import trytond.model [ModelSQL ModelView fields]
        trytond.pool [PoolMeta]
        trytond.transaction [Transaction]
        trytond.modules.hyton.utils [first]
        trytond.modules.hyton.context [context-company]
        openpyxl [Workbook])

(setv QUEUE_NAME "data_harvest")

(defclass HarvestQuery [ModelSQL ModelView]
  "Harvest Query"
  (setv __name__ "harvest.query"
        name (fields.Char "Name" :required True)
        query (fields.Text "Query" :required True)
        group (fields.Char "Group" :required True))

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
    (with [transaction (.new-transaction (Transaction))]
      (let [cursor (.cursor transaction.connection)]
        (.execute cursor self.query {"company" (context-company)})
        (.export-workbook self
                          (list (map first cursor.description))
                          (.fetchall cursor)))))

  (defn export-workbook [self header records]
    (setv workbook (Workbook)
          ws workbook.active)
    (ws.append header)
    (for [record records]
      (ws.append (list record)))
    ;;  auto-filter first row
    (setv ws.auto_filter.ref ws.dimensions)
    (.save workbook "/tmp/table-test.xlsx")
    )

  )

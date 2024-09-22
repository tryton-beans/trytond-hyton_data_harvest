(import trytond.model [ModelView fields]
        trytond.pool [Pool]
        trytond.wizard [Wizard StateAction StateReport
                        StateView StateTransition Button])

(defclass HarvestExecuteQueryStart [ModelView]
  "Execute Query Form"
  (setv __name__ "harvest.execute.query.start"
        query (.Many2One fields "harvest.query" "Query" :required True)))

(defclass HarvestExecuteQueryWizard [Wizard]
  "Execute Query Wizard"
  (setv __name__ "harvest.execute.query.wizard"
        start (StateView "harvest.execute.query.start"
                         "hyton_data_harvest.execute_query_start_form"
                         [(Button "Cancel" "end" "tryton-cancel")
                          (Button
                            "Execute"
                            "execute_query"
                            "tryton-ok")])
        execute-query  (StateTransition))

  (defn transition-execute-query [self]
    (.harvest (.get (Pool)
                    "harvest.query")
              [self.start.query] )
    "end"))

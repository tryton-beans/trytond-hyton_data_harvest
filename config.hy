(import trytond.model [ModelSingleton ModelSQL ModelView fields])

(defclass HarvestConfig [ModelSingleton ModelSQL ModelView]
  "Harvest Configuration"
  (setv __name__ "harvest.config"
        queue_name (fields.Char "Queue Name" :required True 
                                :help "Name of the task queue for harvest operations")))

  (defn [classmethod] default_queue_name []
    "data_harvest")

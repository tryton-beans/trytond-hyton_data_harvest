(import trytond.model [ModelView ModelSQL fields]
        trytond.modules.hyton.common-fields [immutable]        )

(defclass HarvestResult [ModelView ModelSQL]
  "Harvest"
  (setv __name__ "harvest.result"
        name (immutable (fields.Char "Name" :required True)) 
        ;;company (immutable (fields.Many2One "company.company" "Company"))
        data (immutable (.Binary fields
                             "File" :filename "name" :required True :depends ["name"]))

        ))

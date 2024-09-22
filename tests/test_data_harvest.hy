(import
  unittest
  trytond.tests.test_tryton [ModuleTestCase with_transaction]
  trytond.modules.hyton-data-harvest.query [is_read_only_sql]
  )

(defclass DataHarvestTestCase [ModuleTestCase]
  "Test Data Harvest module"
  (setv module "hyton_data_harvest")


  (defn test-is-read-only-sql [self]
    "Test is_read_only_sql"
    (self.assertTrue (is_read_only_sql "SELECT 1"))
    (self.assertTrue (is_read_only_sql " SELECT update_time FROM table"))
    (self.assertTrue (is_read_only_sql "  select * FROM table WHERE 1=0 "))
    ;; false
    (self.assertFalse (is_read_only_sql " UPDATE * FROM table"))
    (self.assertFalse (is_read_only_sql " update * FROM table"))
    (self.assertFalse (is_read_only_sql " select * into table")))
  
)

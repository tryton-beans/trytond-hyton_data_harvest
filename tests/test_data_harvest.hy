(import
  unittest
  trytond.tests.test_tryton [ModuleTestCase with_transaction])

(defclass DataHarvestTestCase [ModuleTestCase]
  "Test Data Harvest module"
  (setv module "hyton_data_harvest")
)

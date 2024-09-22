import hy
from trytond.pool import Pool
from . import query, result, execute

def register():
    Pool.register(
        query.HarvestQuery,
        result.HarvestResult,
        execute.HarvestExecuteQueryStart,
        module='hyton_data_harvest', type_='model')
    Pool.register(
        execute.HarvestExecuteQueryWizard,
        module='hyton_data_harvest', type_='wizard')

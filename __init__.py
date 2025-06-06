import hy
from trytond.pool import Pool
from . import query, result, execute, config

def register():
    Pool.register(
        query.HarvestQuery,
        result.HarvestResult,
        execute.HarvestExecuteQueryStart,
        config.HarvestConfig,
        module='hyton_data_harvest', type_='model')
    Pool.register(
        execute.HarvestExecuteQueryWizard,
        module='hyton_data_harvest', type_='wizard')

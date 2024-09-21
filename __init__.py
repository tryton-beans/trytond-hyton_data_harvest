import hy
from trytond.pool import Pool
from . import query, result

def register():
    Pool.register(
        query.HarvestQuery,
        result.HarvestResult,
        module='hyton_data_harvest', type_='model')

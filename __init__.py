import hy
from trytond.pool import Pool
from . import query

def register():
    Pool.register(
        query.HarvestQuery,
        module='hyton_data_harvest', type_='model')

select kafka_partition, kafka_offset, count(*)
from FINANCIALS.dev_suyog.stg_orders
group by kafka_partition, kafka_offset
having count(*) > 1
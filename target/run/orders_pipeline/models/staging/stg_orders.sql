
  create or replace   view FINANCIALS.dev_suyog.stg_orders
  
  
  
  
  as (
    select *
from financials.raw.spark_orders_clean
qualify row_number() over (
partition by kafka_partition, kafka_offset
order by loaded_at
) = 1
  );



    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  select kafka_partition, kafka_offset, count(*)
from FINANCIALS.dev_suyog.stg_orders
group by kafka_partition, kafka_offset
having count(*) > 1
  
  
      
    ) dbt_internal_test
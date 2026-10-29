
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  select *
from FINANCIALS.dev_suyog.stg_orders
where quantity <= 0
  
  
      
    ) dbt_internal_test
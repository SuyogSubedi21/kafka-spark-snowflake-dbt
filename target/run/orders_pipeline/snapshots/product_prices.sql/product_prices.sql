
      
  
    

create or replace transient table FINANCIALS.dev_suyog.product_prices
    
    
    
    
    

    as (
    

    select *,
        md5(coalesce(cast(product_id as varchar ), '')
         || '|' || coalesce(cast(to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as varchar ), '')
        ) as dbt_scd_id,
        to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as dbt_updated_at,
        to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as dbt_valid_from,
        
  
  coalesce(nullif(to_timestamp_ntz(convert_timezone('UTC', current_timestamp())), to_timestamp_ntz(convert_timezone('UTC', current_timestamp()))), null)
  as dbt_valid_to
from (
        



select product_id, product_name, cost_price
from FINANCIALS.dev_suyog.stg_orders
qualify row_number() over (
    partition by product_id
    order by loaded_at desc
) = 1

    ) sbq



    )
;


  
  

  
    

create or replace transient table FINANCIALS.dev_suyog.rejection_summary
    
    
    
    
    

    as (select
    reason,
    count(*) as rejected_rows,
    min(loaded_at) as first_seen,
    max(loaded_at) as last_seen
from financials.raw.spark_orders_rejected
group by reason
    )
;


  
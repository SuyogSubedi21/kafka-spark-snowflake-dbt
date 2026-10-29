



select product_id, product_name, cost_price
from FINANCIALS.dev_suyog.stg_orders
qualify row_number() over (
    partition by product_id
    order by loaded_at desc
) = 1

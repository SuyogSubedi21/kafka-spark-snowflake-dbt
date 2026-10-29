select
*,
cost_price * quantity as total_cost,
revenue - (cost_price * quantity) as profit,
case when is_returned then 0 else revenue end as net_revenue
from FINANCIALS.dev_suyog.stg_orders
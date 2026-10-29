with __dbt__cte__int_orders_enriched as (
select
*,
cost_price * quantity as total_cost,
revenue - (cost_price * quantity) as profit,
case when is_returned then 0 else revenue end as net_revenue
from FINANCIALS.dev_suyog.stg_orders
) select
    order_date,
    region,
    count(*) as orders,
    sum(quantity) as units,
    sum(net_revenue) as net_revenue,
    sum(profit) as profit
from __dbt__cte__int_orders_enriched
group by order_date, region
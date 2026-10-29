select
    order_date,
    region,
    count(*) as orders,
    sum(quantity) as units,
    sum(net_revenue) as net_revenue,
    sum(profit) as profit
from {{ ref('int_orders_enriched') }}
group by order_date, region
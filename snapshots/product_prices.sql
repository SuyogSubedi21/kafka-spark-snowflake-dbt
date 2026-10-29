    {% snapshot product_prices %}

{{ config(
    target_schema='dev_suyog',
    unique_key='product_id',
    strategy='check',
    check_cols=['cost_price']
) }}

select product_id, product_name, cost_price
from {{ ref('stg_orders') }}
qualify row_number() over (
    partition by product_id
    order by loaded_at desc
) = 1

{% endsnapshot %}
with orders as (
    select * from {{ ref('stg_orders') }}
),

payments as (
    select
        order_id,
        sum(amount) as amount
    from {{ ref('stg_payments') }}
    group by order_id
),

customer_orders as (
    select
        o.customer_id,
        min(o.order_date) as first_order_date,
        max(o.order_date) as last_order_date,
        count(*) as number_of_orders,
        sum(p.amount) as lifetime_value
    from orders o
    left join payments p using (order_id)
    where o.status != 'returned'
    group by o.customer_id
)

select
    c.customer_id,
    c.first_name,
    c.last_name,
    co.first_order_date,
    co.last_order_date,
    coalesce(co.number_of_orders, 0) as number_of_orders,
    coalesce(co.lifetime_value, 0) as lifetime_value
from {{ ref('stg_customers') }} c
left join customer_orders co using (customer_id)

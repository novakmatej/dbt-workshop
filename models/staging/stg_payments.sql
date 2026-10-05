select
    id as payment_id,
    order_id,
    payment_method,
    amount / 100.0 as amount  -- halere -> Kc
from {{ ref('raw_payments') }}

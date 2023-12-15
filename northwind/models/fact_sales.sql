with stg_orders as 
(
    select
        OrderID,
        {{ dbt_utils.generate_surrogate_key(["employeeid"]) }} as employeekey,
        {{ dbt_utils.generate_surrogate_key(["customerid"]) }} as customerkey,
        replace(to_date(orderdate)::varchar, '-', '')::int as orderdatekey

    from {{ source("northwind", "Orders") }}
),

stg_order_details as 
(
    select
        orderid,
        {{ dbt_utils.generate_surrogate_key(["productid"]) }} as productkey,
        discount,
        sum(quantity) as quantityonorder,
        sum(quantity * unitprice) as extendedpriceamount
    from {{ source("northwind", "Order_Details") }}
    group by orderid, productkey, discount
)
select
    o.*,
    od.productkey, od.quantityonorder,
    od.extendedpriceamount, 
    (extendedpriceamount * discount) as discountamount,
    (extendedpriceamount - (extendedpriceamount * discount)) as soldamount

from stg_orders o
    join stg_order_details od on o.orderid = od.orderid

with stg_customers as (
    select * from {{ source('events_projectdb','people')}}
)
select  
    {{ dbt_utils.generate_surrogate_key(['stg_customers.person_id'])}} as customerkey,
    person_id as customerid,
    concat(person_firstname  , ' ' , person_lastname) as customername,
    person_email as customeremail,
    person_phone_no as customerphoneno,
    person_street_address as customeraddress
from stg_customers
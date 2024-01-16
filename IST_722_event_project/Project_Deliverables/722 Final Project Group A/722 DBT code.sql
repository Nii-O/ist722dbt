-- Sources.yml

version: 2

sources:
  - name: conformed
    database: raw
    schema: conformed

    tables:
      - name: DateDimension
        columns:
          - name: DateKey
            tests:
              - unique

  - name: events_projectdb
    database: raw
    schema: myEvent_v1

    tables:
      - name: zipcodes
        columns:
          - name: zipcode
            tests:
              - unique

      - name: organization_type_lookup
        columns:
          - name: org_type_name
            tests:
              - unique

      - name: organizations
        columns:
          - name: organization_id
            tests:
              - unique

      - name: type_of_services
        columns:
          - name: type_id
            tests:
              - unique
          - name: type_name
            tests:
              - unique

      - name: services
        columns:
          - name: service_id
            tests:
              - unique
          - name: my_service_name
            tests:
              - unique

      - name: service_type
        tests:
          - dbt_utils.unique_combination_of_columns:
              combination_of_columns:
                - service_id
                - type_id

      - name: venues
        columns:
          - name: venue_id
            tests:
              - unique
          - name: venue_name
            tests:
              - unique

      - name: request_statuses
        columns:
          - name: status_type
            tests:
              - unique

      - name: event_types
        columns:
          - name: event_type
            tests:
              - unique

      - name: requests
        columns:
          - name: request_id
            tests:
              - unique
          - name: request_event_name
            tests:
              - unique

      - name: events
        columns:
          - name: event_id
            tests:
              - unique
          - name: event_name
            tests:
              - unique

      - name: people
        columns:
          - name: person_id
            tests:
              - unique
          - name: person_email
            tests:
              - unique

      - name: reviews
        columns:
          - name: review_id
            tests:
              - unique
          - name: review_text
            tests:
              - unique

      - name: tickets
        columns:
          - name: ticket_id
            tests:
              - unique
---------------------------------------------------------------------------------------------------------------
--dim_date.yml
version: 2

models:
  - name: dim_date
    description: Conformed Date Dimension. One row per day of the year.
    columns:
      - name: datekey 
        data_type: int 
        description: The surrogate key of the date YYYYMMDD
        tests:
          - not_null
          - unique
      - name: date
        description: The date of the date key
        tests:
          - not_null
          - unique
      - name: year
        description: The year of the date key
        tests:
          - not_null
      - name: month
        description: The month of the date key
        tests:
          - not_null
      - name: quarter
        description: The quarter of the date key
        tests:
          - not_null
      - name: day
        description: The day of the date key
        tests:
          - not_null
      - name: dayofweek
        description: The dayofweek of the date key
        tests:
          - not_null
      - name: weekofyear
        description: The weekofyear of the date key
        tests:
          - not_null
      - name: dayofyear
        description: The dayofyear of the date key
        tests:
          - not_null


--dim_date.sql
select     
    datekey::int as datekey,
    date,
    year,
    month,
    quarter,
    day, 
    dayofweek,
    weekofyear,
    dayofyear
    from {{ source('conformed','DateDimension')}}

---------------------------------------------------------------------------------------------------------------------
-- dim_customer.yml

version: 2

models:
  - name: dim_customer
    description: Customer Dimension. One row per customer
    columns:
      - name: customerkey
        description: The surrogate key of the customer
        tests:
          - not_null
          - unique
      - name: customerid
        description: The business / source key of the customer
        tests:
          - not_null
          - unique
      - name: customername
        description: The name of the customer
        tests:
          - not_null
      - name: customeremail
        description: The email of the customer
        tests:
          - not_null
          - unique
      - name: customerphoneno
        description: The phone number of the customer
        tests:
          - not_null
          - unique
      - name: customeraddress
        description: The address of the customer

        
--dim_customer.sql

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

-------------------------------------------------------------------------------------------------------------
--dim_event.yml

version: 2

models:
  - name: dim_events
    columns:
      - name: eventkey
        description: "Dimension key surrogate key"
        tests:
          - unique
          - not_null

      - name: eventid
        description: "Primary key of the source system (business key)"
        tests:
          - unique
          - not_null

      - name: eventname
        description: "Name of the event"
        tests:
          - not_null

      - name: eventtype
        description: "Type of the event"
        tests:
          - not_null

      - name: eventdate
        description: "Date of the event"
        tests:
          - not_null

      - name: eventdays
        description: "Number of days of the event"

      - name: eventdescription
        description: "Description of the event"


--dim_event.sql

with stg_events as (
    select* from {{ source('events_projectdb','events')}}
)
select  
    {{ dbt_utils.generate_surrogate_key(['stg_events.event_id'])}} as eventkey,
    event_id as eventid,
    event_name as eventname,
    event_type as eventtype,
    event_date as eventdate,
    event_description as eventdescription
from stg_events

-------------------------------------------------------------------------------------------------------------
--dim_requests.yml

version: 2

models:
  - name: dim_requests
    columns:
      - name: requestkey
        description: "Surrogate key"
        tests:
          - unique
          - not_null

      - name: requestid
        description: "Primary key of source table"
        data_type: int
        tests:
          - unique
          - not_null

      - name: requesteventname
        description: "Proposed event name"
        data_type: varchar
        tests:
          - not_null

      - name: requestdate
        description: "Date request was made"
        data_type: varchar
        tests:
          - not_null

      - name: requestdays
        description: "Requested event duration"
        data_type: int
        tests:
          - not_null

      - name: requestattendance
        description: "Estimated attendance to event"
        data_type: int
        tests:
          - not_null

      - name: requesteventtype
        description: "Type of event"
        data_type: varchar
        tests:
          - not_null

      - name: requestdescription
        description: "Request event description"
        data_type: varchar

      - name: requeststatus
        description: "Request status"
        data_type: varchar
        tests:
          - not_null

      - name: requestmadebyid
        description: "Request made by"
        data_type: int
        tests:
          - not_null

      - name: requestsubmittedtoid
        description: "Request submitted to"
        data_type: int
        tests:
          - not_null

      - name: requestvenueid
        description: "Request event venue"
        data_type: int
        tests:
          - not_null


--dim_requests.sql

with stg_requests as (
    select* from {{ source('events_projectdb','requests')}}
)
select  
    {{ dbt_utils.generate_surrogate_key(['stg_requests.request_id'])}} as requestkey,
    request_id as requestid,
    request_event_name as requesteventname,
    request_date as requestdate,
    request_number_of_days as requestdays,
    request_estimated_attendance as requestattendance,
    request_event_type as requesteventtype,
    request_description as requestdescription,
    request_status as requeststatus,
    request_made_by_id as requestmadebyid,
    request_submitted_to_id as requestsubmittedtoid,
    request_venue_id as requestvenueid
from stg_requests

-------------------------------------------------------------------------------------------------------------

--dim_venue.yml
version: 2

models:
  - name: dim_venue
    columns:
      - name: venuekey
        description: "Surrogate key"
        tests:
          - unique
          - not_null

      - name: venueid
        description: "Primary key of the source system (business key)"
        tests:
          - unique
          - not_null

      - name: venuename
        description: "Name of the venue"
        tests:
          - not_null

      - name: venuecapacity
        description: "Capacity of the venue"
        tests:
          - not_null

      - name: venueaddress
        description: "Address of the venue"
        tests:
          - not_null


--dim_venue.sql

with stg_venue as (
    select * from {{ source('events_projectdb','venues')}}
)
select  
    {{ dbt_utils.generate_surrogate_key(['stg_venue.venue_id'])}} as venuekey,
    venue_id as venueid,
    venue_name as venuename,
    venue_capacity as venuecapacity,
    venue_street_address as venueaddress
from stg_venue


------------------------------------------------------------------------------------------------------------

--dim_review.yml

version: 2

models:
  - name: dim_review
    columns:
      - name: reviewkey
        description: "Surrogate key"
        data_type: int
        tests:
          - unique
          - not_null

      - name: reviewid
        description: "Primary key of source table"
        data_type: int
        tests:
          - unique
          - not_null

      - name: reviewtext
        description: "Review text description"
        data_type: varchar
        tests:
          - not_null

      - name: reviewdate
        description: "Review made by date"
        data_type: varchar
        tests:
          - not_null

      - name: reviewrating
        description: "Review rating"
        data_type: int
        tests:
          - not_null

      - name: revieweventid
        description: "ID of event review was made for"
        data_type: int
        tests:
          - not_null

      - name: reviewpersonid
        description: "ID of person who wrote review"
        data_type: int
        tests:
          - not_null


--dim_review.sql

with stg_reviews as (
    select* from {{ source('events_projectdb','reviews')}}
)
select  
    {{ dbt_utils.generate_surrogate_key(['stg_reviews.review_id'])}} as reviewkey,
    review_id as reviewid,
    review_text as reviewtext,
    review_date as reviewdate,
    review_rating as reviewrating,
    review_event_id as revieweventid,
    review_person_id as reviewpersonid
from stg_reviews

--------------------------------------------------------------------------------------------------------------

--fact_event_ticket_sales.yml

version: 2

models:
  - name: fact_event_ticket_sales
    description: Periodic snapshot fact table. One row per event per day
    columns:
      - name: eventkey
        description: Degenerate dimension for the event.
        tests:
            - unique
            - not_null
      - name: venuekey
        description: Degenerate dimension for the venue.
        tests:
            - unique
            - not_null
      - name: numofticketssold
        description: Number of tickets that were sold for an event

      

--fact_event_ticket_sales.sql

with stg_tickets as 
(
    select ticket_event_id, count(ticket_id) as numofticketssold
    from {{source('events_projectdb','tickets')}}
    group by ticket_event_id
),

stg_events as (
    select {{ dbt_utils.generate_surrogate_key(['event_id']) }} as eventkey,
    * from {{source('events_projectdb','events')}}
),

stg_venues as (
    select {{ dbt_utils.generate_surrogate_key(['venue_id']) }} as venuekey,
    * from {{source('events_projectdb','venues')}}
)

select  
    e.eventkey, v.venuekey, t.numofticketssold
from stg_tickets t
    join stg_events e on e.event_id = t.ticket_event_id
    join stg_venues v on v.venue_id = e.event_venue_id
     
--fact_popular_cities.yml

version: 2

models:
  - name: fact_popular_cities
    columns:
      - name: citykey
        description: "Source key used for drillthrough"
        tests:
          - unique
          - not_null

      - name: eventkey
        description: "Dimension foreign key for dim_event"

      - name: venuekey
        description: "Dimension foreign key for dim_venue"

      - name: ratingkey
        description: "Dimension foreign key for dim_rating"

      - name: numofticketssold
        description: "Number of tickets sold"

      - name: avgrating
        description: "Average rating of the events"


 --fact_popular_cities.sql

with stg_tickets as 
(
    select ticket_event_id, count(ticket_id) as numofticketssold
    from {{source('events_projectdb','tickets')}}
    group by ticket_event_id
),

stg_cities as (
    select zipcode,
    {{ dbt_utils.generate_surrogate_key(['zipcode_city']) }} as citykey 
    from {{source('events_projectdb','zipcodes')}}
    group by citykey,zipcode
),

stg_events as (
    select {{ dbt_utils.generate_surrogate_key(['event_id']) }} as eventkey, 
    * from {{source('events_projectdb','events')}}
),

stg_ratings as (
    select {{ dbt_utils.generate_surrogate_key(['review_id']) }} as ratingkey,
    *
    from {{source('events_projectdb','reviews')}}
),

stg_venues as (
    select {{ dbt_utils.generate_surrogate_key(['venue_id']) }} as venuekey, 
    * from {{source('events_projectdb','venues')}}
)

SELECT c.citykey,e.eventkey,v.venuekey, AVG(r.review_rating) AS avg_rating
FROM stg_ratings r
JOIN stg_events e ON r.review_event_id = e.event_id
JOIN stg_venues v ON e.event_venue_id = v.venue_id
JOIN stg_cities c ON v.venue_zipcode = c.zipcode
GROUP BY c.citykey,e.eventkey,v.venuekey
ORDER BY avg_rating DESC


--fact_request_approval.yml

version: 2

models:
  - name: fact_request_approval
    columns:

      - name: venuekey
        description: "Dimension foreign key for dim_venue"
        data_type: int

      - name: numofapprovedrequests
        description: "The number of approved requests"
        data_type: int
 --fact_request_approval.sql

with stg_requests as (
    select request_venue_id,
    count(request_id) as numofapprovedrequests 
    from {{source('events_projectdb','requests')}}
    where request_status='approved'
    group by request_venue_id

),
stg_venue as (
    select {{ dbt_utils.generate_surrogate_key(['venue_id']) }} as venuekey,
    * 
    from {{source('events_projectdb','venues')}}
)
select v.venuekey, r.numofapprovedrequests 
from stg_requests r
    join stg_venue v on v.venue_id = r.request_venue_id




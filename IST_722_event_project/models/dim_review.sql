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
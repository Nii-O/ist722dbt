--IST722 Data Warehousing Project - Raw Data Up-Down Script 

  

create schema if not exists raw.myEvent_v1; 

use raw.myEvent_v1; 

 

-- define file formats 

create or replace file format RAW.PUBLIC.PARQUET  

    TYPE = parquet 

    REPLACE_INVALID_CHARACTERS = TRUE; 

 

create or replace file format RAW.PUBLIC.JSONARRAY  

    TYPE = json 

    STRIP_OUTER_ARRAY = TRUE; 

 

create or replace file format RAW.PUBLIC.JSON 

    TYPE = json 

    STRIP_OUTER_ARRAY = FALSE; 

 

create or replace file format RAW.PUBLIC.CSVHEADER 

    TYPE = 'csv' 

    FIELD_DELIMITER  = ',' 

    SKIP_HEADER=1; 

     

create or replace file format RAW.PUBLIC.CSV 

    TYPE = csv 

    FIELD_DELIMITER  = ',' 

    PARSE_HEADER = FALSE 

    SKIP_HEADER  = 0;   

 

 

  

  

-- --DOWN 

  

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_tickets_ticket_person_id') 

--     alter table tickets drop constraint fk_tickets_ticket_person_id; 

  

 

-- drop table if exists tickets; 

  

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_reviews_review_person_id') 

--     alter table reviews drop constraint fk_reviews_review_person_id; 

  

-- drop table if exists reviews; 

 

  

  

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_people_person_zipcode') 

--     alter table people drop constraint fk_people_person_zipcode; 

  

 

-- drop table if exists people; 

 

  

  

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_events_event_type') 

--     alter table events drop constraint fk_events_event_type; 

  

 

  

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_events_event_venue_id') 

--     alter table events drop constraint fk_events_event_venue_id; 

  

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_events_event_service_id') 

--     alter table events drop constraint fk_events_event_service_id; 

 

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_events_event_organizer_id') 

--     alter table events drop constraint fk_events_event_organizer_id; 

  

 

-- drop table if exists events; 

 

  

  

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_requests__request_venue_id') 

--     alter table requests drop constraint fk_requests__request_venue_id; 

 

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_request_made_by_id ') 

--     alter table requests drop constraint fk_request_made_by_id; 

 

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_request_submitted_to_id') 

--     alter table requests drop constraint fk_request_submitted_to_id; 

 

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_request_submitted_to_id') 

--     alter table requests drop constraint fk_request_submitted_to_id; 

  

 

  

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS /*Foreign key for event type in requests */ 

--     where CONSTRAINT_NAME='fk_requests_event_type') 

--     alter table requests drop constraint fk_requests_event_type; 

 

-- drop table if exists requests; 

  

-- drop table if exists event_types; 

 

  

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_service_type_service_id') 

--     alter table service_type drop constraint fk_service_type_service_id; 

  

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_service_type_type_id') 

--     alter table service_type drop constraint fk_service_type_type_id; 

  

  

 

-- drop table if exists service_type; 

 

  

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_service_provider_id') 

--     alter table services drop constraint fk_service_provider_id; 

  

 

-- drop table if exists services; 

 

-- drop table if exists types_of_services; 

 

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_venues_venue_zipcode') 

--     alter table venues drop constraint fk_venues_venue_zipcode; 

  

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_venue_owner_id') 

--     alter table venues drop constraint fk_venue_owner_id; 

  

-- drop table if exists venues; 

 

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_organization_zipcode') 

--     alter table organizations drop constraint fk_organization_zipcode; 

  

-- if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 

--     where CONSTRAINT_NAME='fk_organization_type') 

--     alter table organizations drop constraint fk_organization_type;   

  

 

-- drop table if exists organizations; 

 

-- drop table if exists organization_type_lookup; 

 

-- drop table if exists zipcodes; 

 

-- drop table if exists request_statuses; 

 

-- drop table if exists type_of_services; 

  

-- UP Metadata 

  

create or replace table raw.myEvent_v1.zipcodes ( 

    zipcode char(5) not null, 

    zipcode_area_name varchar(20) not null, 

    zipcode_city varchar(20) not null, 

    zipcode_state char(2) not null, 

    constraint pk_zipcodes_zipcode primary key(zipcode) 

); 

 

  

create or replace table raw.myEvent_v1.organization_type_lookup ( 

    org_type_name varchar(20) not null, 

    constraint pk_organization_organization_type  primary key(org_type_name) 

); 

  

 

create or replace table raw.myEvent_v1.organizations ( 

   organization_id int identity not null, 

    organization_type varchar(20) not null, 

    organization_name varchar(30) not null, /* Changed the varchar */ 

    organization_email varchar(50) not null, 

    organization_phone_no char(10) not null, 

    organization_reg_no char(6) not null, 

    organization_street_address varchar(50) not null, 

    organization_zipcode char(5) not NULL, 

    constraint pk_organization_id primary key (organization_id), 

    constraint u_organization_email unique (organization_email), 

    constraint u_organization_reg_no unique (organization_reg_no) 

); 

  

alter table  organizations 

    add constraint fk_organization_zipcode foreign key (organization_zipcode) 

        references zipcodes(zipcode); 

  

alter table organizations 

    add constraint  fk_organization_type foreign key (organization_type) 

        references organization_type_lookup(org_type_name); 

  

  

  

create or replace table type_of_services ( 

    type_id int identity not null, 

    type_name varchar(20) not null, 

    type_food_offered int not null default 0, 

    type_alcohol_offered int not null default 0, 

    constraint pk_services_types_type_id primary key (type_id)  

 ); 

  

  

 

create or replace table services ( 

    service_id int identity not null, 

    my_service_name varchar(20) not null, 

    service_price number(10,2) not null, 

    service_provider_id int not null, 

    constraint pk_services_service_id primary key (service_id) 

 ); 

 

alter table services 

    add constraint  fk_service_provider_id foreign key (service_provider_id) 

        references organizations(organization_id); 

  

  

 create or replace table service_type ( 

    service_id int not null, 

    type_id int not null, 

    constraint pk_service_type primary key(service_id, type_id ) 

); 

 

alter table  service_type 

    add constraint fk_service_type_service_id foreign key (service_id) 

        references services(service_id); 

  

alter table service_type 

    add constraint  fk_service_type_type_id foreign key (type_id) 

        references type_of_services(type_id); 

  

 

create or replace table venues ( 

    venue_id int identity not null, 

    venue_name varchar(50) not null, 

    venue_capacity int not null, 

    venue_street_address varchar(50) not null, 

    venue_zipcode char(5) not null, 

    venue_owner_id int not null, 

    constraint pk_venues_venue_id primary key (venue_id)      

 ); 

 

alter table venues 

    add constraint fk_venues_venue_zipcode foreign key (venue_zipcode) 

        references zipcodes(zipcode); 

  

alter table venues 

    add constraint  fk_venue_owner_id foreign key (venue_owner_id) 

        references organizations(organization_id); 

 

  

create or replace table request_statuses ( 

status_type varchar(10) not null, 

constraint pk_requests_status primary key (status_type)   

); 

  

create or replace table event_types ( 

    event_type varchar(50) not null, 

    constraint pk_event_type  primary key (event_type)   

); 

  

create or replace table requests ( 

    request_id int identity not null, 

    request_event_name varchar(30) not null, 

    request_date date not null,         /* Added name, type, description, date, and number of days to request */ 

    request_number_of_days int, 

    request_estimated_attendance varchar(10) not null, 

    request_event_type varchar(50) not null, 

    request_description varchar(70) null, 

    request_status varchar(10) not null default 'pending', --pending,  approved, rejected 

    request_made_by_id int not null, 

    request_submitted_to_id int not null, 

    request_venue_id int not null, 

    constraint pk_requests_request_id primary key (request_id)        

 ); 

 

alter table requests 

    add constraint  fk_request_submitted_to_id foreign key (request_submitted_to_id) 

        references organizations(organization_id); 

 

alter table requests 

    add constraint  fk_request_made_by_id foreign key (request_made_by_id) 

        references organizations(organization_id);       

 

alter table requests 

    add constraint  fk_requests__request_venue_id foreign key (request_venue_id) 

        references venues (venue_id);   

         

alter table requests 

    add constraint  fk_requests__request_status foreign key (request_status) 

        references request_statuses (status_type);             

 

alter table requests 

    add constraint fk_requests_event_type foreign key (request_event_type)  /*Added foreign key for event type in requests */ 

        REFERENCES event_types(event_type); 

 

  

create or replace table events ( 

    event_id int identity not null, 

    event_name varchar(30) not null, 

    event_type varchar(50) not null, 

    event_date datetime not null, 

    event_length int not null, 

    event_organizer_id int not null, 

    event_venue_id int not null, 

    event_service_id int not null, 

    event_description varchar(100),   

    constraint pk_events_event_id primary key (event_id) 

); 

 

alter table events 

    add constraint fk_events_event_type foreign key (event_type) 

        references event_types(event_type); 

 

alter table events 

    add constraint fk_events_event_venue_id foreign key (event_venue_id) 

        references venues(venue_id); 

      

alter table events 

    add constraint fk_events_event_service_id foreign key (event_service_id) 

        references services(service_id); 

 

alter table events 

    add constraint fk_events_event_organizer_id foreign key (event_organizer_id) 

        references organizations(organization_id); 

 

 

create or replace table people ( 

    person_id int identity not null, 

    person_email varchar(50) not null, 

    person_firstname varchar(50) not null, 

    person_lastname varchar(50) not null, 

    person_phone_no char(10) not null, 

    person_year varchar(10), 

    person_street_address varchar(50) not null, 

    person_house_no varchar(6), 

    person_zipcode char(5) not NULL, 

    constraint pk_people_person_id primary key (person_id), 

    constraint u_people_person_email unique (person_email)   

); 

 

alter table people 

    add constraint fk_people_person_zipcode foreign key (person_zipcode) 

        references zipcodes(zipcode); 

  

create or replace table reviews ( 

    review_id int identity not null, 

    review_text varchar(200) not null, 

    review_date DATETIME not null, 

    review_rating int not null, 

    review_event_id int not null, 

    review_person_id int not null, 

    constraint pk_reviews_review_id primary key (review_id) 

);         

  

alter table reviews 

    add constraint fk_reviews_review_person_id foreign key (review_person_id) 

        references people(person_id); 

 

alter table reviews 

    add constraint fk_reviews_review_event_id foreign key (review_event_id) 

        references events(event_id); 

 

create or replace table tickets ( 

    ticket_id int identity not null, 

    ticket_attended int not null default 0 , 

    ticket_issued_date DATETIME not null, 

    ticket_event_id int not null, 

    ticket_person_id int not null,  

    constraint pk_tickets_ticket_id primary key (ticket_id)  

)         

  

 

alter table tickets 

    add constraint fk_tickets_ticket_person_id foreign key (ticket_person_id) 

        references people(person_id); 

 

alter table tickets 

    add constraint fk_tickets_ticket_event_id foreign key (ticket_event_id) 

        references events(event_id); 

  

  

  

-- UP Data 

  

  

insert into zipcodes 

    (zipcode, zipcode_area_name, zipcode_city,zipcode_state ) 

    values 

    ('13210','Brighton PL', 'Syracuse', 'NY'), 

    ('98109','Westlake','Seattle','WA'), 

    ('98121','Downtown','Seattle','WA'), 

    ('10023','Upper West Side','New York City','NY'), 

    ('11590','Carman Ave','Westbury','NY'), 

    ('98101','Minor Ave','Seattle','WA'), 

    ('20742','Berwyn Heights','College Park','MD'), 

    ('06716','Wolcott','Watterbury','CT'), 

    ('32412', 'Livinston','Chicago','IL'), 

    ('04321','Fort Worth','Dallas', 'TX'), 

    ('24113','Wavey','San Diego','CA'), 

    ('13220','Salt Way', 'Syracuse', 'NY'), 

    ('44430', 'Lake View', 'Rochester', 'NY'); 

  

insert into organization_type_lookup 

values 

('Host'),('Service Provider'),('Venue Owner'), ('Individual'); 

 

-- New inserts into organizations, venues, event types, services, ticket, 

insert into organizations 

(organization_type, organization_name, organization_email, organization_phone_no,organization_reg_no,organization_street_address,organization_zipcode) 

values 

('Host', 'iGSO', 'iGSO@syr.edu', '315676630', 'R01231', 'ischool','13210'), 

('Service Provider', 'PANDA EXPRESS', 'PEXPRESS@syr.edu', '315699630', 'R01232', 'Shine Student Center','13210'), 

('Venue Owner', 'ischool', 'ischool@syr.edu', '315676622', 'R01233', 'ischool','13210'), 

('Host','University Union','uu@syr.edu','315220099','R01234','Schine Student Center','13210'), 

('Host','International Students Service','reach@umd.edu','3334445511','R01235','Center for International Students','20742'), 

('Service Provider','Burger King','cc@burgerking.com','884422113','R01236','555 King Ave','98101'), 

('Venue Owner','JMA','contact@jma.com','422555112','R01237','510 Stadium Rd','11590'), 

('Venue Owner', 'Union Board','unionboard@syr.edu','3347282718','R01238','Schine Student Center','13210'), 

('Service Provider', 'Funky DJ', 'funkydj@gmail.com','4625165222','R01239','S Colbert ST', '44430'), 

('Service Provider', 'Orderly Arrangers', 'orderly@yahoo.com','2256515243','R01240','12 Waterfront ST','13220'), 

('Service Provider', 'Syracuse First Aid', 'syracuse@aid.com','1909827364','R01241','20 Garden Lane','13210'), 

('Service Provider', 'Potter Potty','potty@potter.com','0800238273','R01242','873 Control ST','44430'); 

  

  

insert into venues 

    ( venue_name,venue_capacity, venue_street_address, venue_zipcode,venue_owner_id)   

    values 

    ('Hinds iCafe', 50,'school of Information Studies','13210',3), 

    ('JMA Dome',50000,'Syracuse University','13210',7), 

    ('Crouse-Hinds Hall',150,'school of Information Studies','13210',3), 

    ('Sky Barn', 1000, '22 Sky Top','13210',8), 

    ('Friendly Bar', 400, '87 Marshal ST','13210',8), 

    ('JMA Fun Zone',500, 'E Colvin ST', '13210',7), 

    ('Information Hall',200, '618 College Ave', '13210',3); 

  

 

insert into request_statuses 

(status_type) 

VALUES 

('pending'),('approved'),('rejected'); 

  

  

 

insert into event_types 

    (event_type)   

    values 

    ('Conference'),('Seminar'),('Hangout'),('Food festival'),('Concert'); 

  

 

insert into requests 

    (request_event_name,request_date,request_number_of_days, request_estimated_attendance,request_event_type,request_description,request_status, request_made_by_id, request_submitted_to_id ,request_venue_id )   

    values 

    ('Data Science Day','2022-12-01',3,'20','Conference',NULL,'approved',1,3,1), 

    ('Crazy meals','2023-01-15', 1,'200','Food festival','Come enjoy great food','approved',4,8,5), 

    ('Lofi Music Vibes','2022-12-28',1,'40','Concert','Chill Vibes all day','approved',1,3,1), 

    ('International Students retreat', '2023-04-18',1,'1450','Conference','Check-in event for international students','rejected',4,8,4), 

    ('Mental Health awareness','2023-02-03',1,'160','Seminar',NULL,'pending',4,3,7), 

    ('Movie night','2023-03-14',1,'40','Hangout','Valentines day movie night','pending',1,3,1), 

    ('Jump away', '2023-02-17',1,'200','Hangout','Have fun at the trampoline park','approved',4,7,6), 

    ('Future Engineer Conference', '2023-04-25',1,'898','Conference','Conference for all engineering enthusiasts','approved',5,8,4); 

  

insert into services 

    ( my_service_name,service_price, service_provider_id)   

    values 

    ('Food and Beverage', 20,2), 

    ('Food and Beverages', 10,6), 

    ('Music',60,9), 

    ('Organizing', 30, 10), 

    ('Health', 90, 11), 

    ('Restroom',23,12); 

 

insert into type_of_services 

    (type_name) 

    values 

    ('Food and Beverage'), ('Music'), ('Organizing'),('Health'),('Restroom'); 

 

insert into service_type 

(service_id, type_id) 

VALUES 

(1,2); 

  

  

  

 insert into events 

    (event_name,event_type,event_date, event_length, event_organizer_id,event_venue_id, event_service_id,event_description) 

    VALUES 

    ('Data Science Day','Conference','2022-12-01',3,1,1,1,NULL), 

    ('Crazy meals','Food festival','2023-01-15', 1,4,5,2,'Come enjoy great food'), 

    ('Lofi Music Vibes','Concert','2022-12-28',1,1,1,3,'Chill Vibes all day'), 

    ('Jump away','Hangout', '2023-02-17',1,4,6,5,'Have fun at the trampoline park'), 

    ('Future Engineer Conference','Conference', '2023-04-25',1,5,4,4,'Conference for all engineering enthusiasts'); 

  

 

insert into people 

    (person_email, person_firstname, person_lastname, person_phone_no, person_year, person_street_address,person_house_no,person_zipcode )   

    values 

    ('sabdelra@syr.edu', 'Somia', 'Abdelrahman', '3157607703', 'Graduate', '4101 Brighton Pl', '3413', '13210'), 

    ('nvrattan@syr.edu','Nakul','Rattan','3152120660','Graduate','800 Maryland Ave','2','13210'), 

    ('dsacks@gmail.com','David','Sacks','8883124263','None','Billionaire Row','1101','10023'), 

    ('rfrank@yahoo.com','Robert','Frank','8439127212','None','Mango Ave','33','98121'), 

    ('gclooney@syr.edu', 'George','Clooney','3327639173','Freshmen','South Cedar ST','118', '20742'), 

    ('swilliams@syr.edu','Susie','Williams','555315808','Junior', 'Ocean Drive', '898','06716'), 

    ('mdurdle@syr.edu','Matthew','Durdle','8377268889','Sophmore','Columbus Ave','3233','44430'), 

    ('mcastagne@syr.edu','Melody','Castagne','9285124444','Senior','South Cedar ST','22','32412'), 

    ('mfoden@syr.edu','Mary','Foden','6251538726','Freshmen','Vicarage Rd','463','11590'), 

    ('ckieff@syr.edu','Chief','Kieff','1324132241','Senior','Local ST','12','04321'), 

    ('lgomer@syr.edu','Lizzy','Gomer','8827626194','Junior','Cottage Rd','8364','10023'), 

    ('bsuarez@syr.edu','Belinda','Suarez','0832718742','Senior','3rd Bowl Ave','645','98101'), 

    ('cdik@syr.edu','Candace','Dik','8265323217','Sophmore','Ring Rd','332','11590'), 

    ('rmartin@syr.edu','Ralph','Martin','6237126432','Sophmore','Colgate Drive','1524','24113'), 

    ('denda@syr.edu','Douglas','Enda','5231237623','Junior', 'French Close','99','13220'), 

    ('kanderson@syr.edu','Kate','Anderson','3526352764','Freshmen','Cofee Ave','9033','20742'), 

    ('awhite@gmail.com','Aaron','White','8088884192','None','Corrola Camry','089','24113'), 

    ('sbanner@yahoo.com','Sandrine','Banner','4472738748','None','Cicero', '5662','98109'), 

    ('mcucurella@chelsea.com','Mary','Cucurella','2231173627','None','Mallorca Rd','9724','20742'), 

    ('dlipa@famous.com','Dua','Lipa','6307067263','None','Oxford ST', '0012','44430'); 

  

 

insert into reviews 

    (review_text, review_date, review_rating, review_event_id, review_person_id )   

    values 

    ('The event was excellent','2022-02-01' ,5, 1, 1), 

    ('Food was terrible','2022-11-03',2,1,3); 

  

insert into tickets 

    (ticket_issued_date, ticket_event_id, ticket_person_id )   

    values 

    ('2022-02-01' , 1, 1),('2022-11-03',1,3),('2022-12-02',2,12), 

    ('2022-12-04',3,10),('2022-11-30',5,9),('2022-09-23',5,9), 

    ('2022-12-21',1,2),('2022-12-03',1,4),('2022-11-23',2,5), 

    ('2022-11-02',2,8),('2022-12-13',3,18),('2022-11-19',3,17), 

    ('2022-12-01',4,11),('2022-12-05',4,15),('2022-12-15',5,20); 

  

  

-- Verify 

select * from zipcodes; 

select * from people; 

select * from reviews; 

select * from tickets; 

select * from event_types; 

select * from events; 

select * from venues; 

select * from services; 

select * from type_of_services; 

select * from service_type; 

select * from organization_type_lookup; 

select * from organizations; 

select * from requests where request_status='approved'; 

select * from request_statuses; 

 

  

select person_firstname || ' ' || person_lastname as person_fullname from people 

    join zipcodes on person_zipcode=zipcode 

    where zipcode='13210'; 

  

  

  

--Viewing reviews by person/event 

select event_name,review_text,review_date,review_rating,person_firstname || ' ' || person_lastname as person_fullname from reviews 

    join events on review_event_id=event_id 

    join people on review_person_id=person_id; 

  

--Owners viewing requests 

drop view if exists v_view_requests; 

 

create view v_view_requests AS 

select request_event_name,request_date,request_number_of_days,o1.organization_name as requester, o1.organization_phone_no as requester_phone_number,request_estimated_attendance,venue_name 

    from requests 

    join organizations o1 on request_made_by_id=o1.organization_id 

    join organizations o2 on request_submitted_to_id=o2.organization_id 

    join venues on request_venue_id = venue_id 

    where request_status='pending'; 

 

select * from v_view_requests; 

  

 --viewing available events 

drop view if exists v_available_events; 

 

create view v_available_events as 

 select event_name,event_type,venue_name,event_date 

    from events 

    join organizations on event_organizer_id=organization_id 

    join venues on event_venue_id=venue_id 

    join services on event_service_id=service_id 

 

select * from v_available_events; 

  

--viewing tickets by person 

drop view if EXISTS v_view_ticket; 

  

create view v_view_ticket as 

select person_id,event_name,event_type,event_date,ticket_issued_date,venue_name 

    from people 

    join tickets on person_id=ticket_person_id 

    join events on ticket_event_id=event_id 

    join venues on event_venue_id=venue_id; 

  

select * from v_view_ticket; 

  

--Owner viewing events 

drop view if exists v_owner_events; 

 

create view v_owner_events as 

select o1.organization_id,o2.organization_name,event_date,event_description,event_type 

    from events 

    join venues on event_venue_id=venue_id 

    join organizations o1 on venue_owner_id=o1.organization_id 

    join organizations o2 on event_organizer_id=o2.organization_id; 

 

select * from v_owner_events; 

  

--Hosts being able to see reviews 

drop view if exists v_view_reviews; 

 

create view v_view_reviews as 

select organization_id,person_firstname || ' ' || person_lastname as person_fullname, 

    person_email, event_name, event_date, 

    review_date, review_rating, review_text 

    from reviews 

    join events on review_event_id=event_id 

    join people on review_person_id=person_id 

    join organizations on event_organizer_id=organization_id; 

 

select * from v_view_reviews; 

  

 

drop view if exists v_view_owners; 

 

create view v_view_owners as 

select * 

    from organizations 

    where organization_type = 'Venue Owner'; 

 

-------------------------------------------------------------------------------------------------------- 

 

select TABLE_CATALOG,TABLE_SCHEMA,TABLE_NAME,ROW_COUNT  

    from RAW.INFORMATION_SCHEMA.TABLES 

    where TABLE_SCHEMA='MYEVENT_V1' order by TABLE_NAME; 

 

 

 
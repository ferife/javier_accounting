-- 15) FK alterations to requests & clients

ALTER TABLE dbo.alterations
    DROP CONSTRAINT CHK_clientOrRequest;



-- 14) Create Alterations Table

DROP TABLE dbo.alterations;



-- 13) Create MtM connection between User Types table and Permissions Table

DROP TABLE dbo.mtm_alteration_types_user_types;



-- 12) Create Permissions Table

DROP TABLE dbo.alteration_types;



-- 11) FK Users Table to User Types Table

ALTER TABLE dbo.users
    DROP CONSTRAINT fk_users_user_types;



-- 10) Create User Types Table

DROP TABLE dbo.user_types;



-- 9) FK Request Table to Concepts Table

ALTER TABLE dbo.requests
    DROP CONSTRAINT fk_requests_concepts;

ALTER TABLE dbo.requests
    DROP COLUMN concept_id;



-- 8) Create Concepts Table

DROP TABLE dbo.concepts;



-- 7) FK Client Table to Location Table

ALTER TABLE dbo.clients
    DROP CONSTRAINT fk_clients_locations;

ALTER TABLE dbo.clients
    DROP COLUMN location_id;



-- 6) Create Users Table

DROP TABLE dbo.users;



-- 5) Create Locations Table

DROP TABLE dbo.locations;



-- 4) Create Request Details Table

DROP TABLE dbo.requests_details;



-- 3) FK Request Table to Client Table

ALTER TABLE dbo.requests
    DROP CONSTRAINT fk_requests_clients;

ALTER TABLE dbo.requests
    DROP COLUMN client_id;



-- 2) Create Request Table

DROP TABLE dbo.requests;



-- 1) Create Client Table

DROP TABLE dbo.clients;
-- 15) FN convert clients table row to JSON

DROP FUNCTION IF EXISTS fnJSON_clientsRow;



-- 14) Create Alterations Table

DROP TABLE IF EXISTS dbo.alterations;



-- 13) Create MtM connection between User Types table and Permissions Table

DROP TABLE IF EXISTS dbo.mtm_alteration_types_user_types;



-- 12) Create Permissions Table

DROP TABLE IF EXISTS dbo.alteration_types;



-- 11) FK Users Table to User Types Table

ALTER TABLE dbo.users
    DROP CONSTRAINT IF EXISTS fk_users_user_types;



-- 10) Create User Types Table

DROP TABLE IF EXISTS dbo.user_types;



-- 9) FK Request Table to Concepts Table

ALTER TABLE dbo.requests
    DROP CONSTRAINT IF EXISTS fk_requests_concepts;

ALTER TABLE dbo.requests
    DROP COLUMN IF EXISTS concept_id;



-- 8) Create Concepts Table

DROP TABLE IF EXISTS dbo.concepts;



-- 7) FK Client Table to Location Table

ALTER TABLE dbo.clients
    DROP CONSTRAINT IF EXISTS fk_clients_locations;

ALTER TABLE dbo.clients
    DROP COLUMN IF EXISTS location_id;



-- 6) Create Users Table

DROP TABLE IF EXISTS dbo.users;



-- 5) Create Locations Table

DROP TABLE IF EXISTS dbo.locations;



-- 4) Create Request Details Table

DROP TABLE IF EXISTS dbo.requests_details;



-- 3) FK Request Table to Client Table

ALTER TABLE dbo.requests
    DROP CONSTRAINT IF EXISTS fk_requests_clients;

ALTER TABLE dbo.requests
    DROP COLUMN IF EXISTS client_id;



-- 2) Create Request Table

DROP TABLE IF EXISTS dbo.requests;



-- 1) Create Client Table

DROP TABLE IF EXISTS dbo.clients;
-- 1) Create Client Table

CREATE TABLE clients (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(128) UNIQUE NOT NULL
);

-- Testing

-- 2) Create Request Table

CREATE TABLE requests (
    id INT IDENTITY(1,1) PRIMARY KEY,
    request_date DATETIME DEFAULT GETDATE(),
    resolved BIT NOT NULL DEFAULT 0
);



-- 3) FK Request Table to Client Table

ALTER TABLE dbo.requests
    ADD client_id INT NOT NULL;

ALTER TABLE dbo.requests
    ADD CONSTRAINT fk_requests_clients
    FOREIGN KEY (client_id) 
        REFERENCES dbo.clients(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;



-- 4) Create Request Details Table

CREATE TABLE requests_details (
    id INT IDENTITY(1,1) PRIMARY KEY,
    request_source VARCHAR(128),
    request_description VARCHAR(max),
    request_message VARCHAR(max),
    request_resolution VARCHAR(max),
    request_id INT UNIQUE NOT NULL,
    CONSTRAINT fk_requests_details_requests
        FOREIGN KEY (request_id)
            REFERENCES dbo.requests(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);



-- 5) Create Locations Table

CREATE TABLE locations (
    id INT IDENTITY(1,1) PRIMARY KEY,
    city VARCHAR(128) NOT NULL,
    state_province VARCHAR(128),
    country VARCHAR(128) NOT NULL,
    CONSTRAINT unique_locations UNIQUE (city, state_province, country)
    -- Rows can share values, but not fully be duplicates of each other
);



-- 6) Create Users Table

CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(128) NOT NULL,
    middle_name VARCHAR(128),
    last_name VARCHAR(128) NOT NULL,
    employee_id VARCHAR(128) UNIQUE NOT NULL, -- Data type should be changed based on the way the client formats their employee id's
    user_type INT NOT NULL DEFAULT 1, -- FK to user types table
);



-- 7) FK Client Table to Location Table

ALTER TABLE dbo.clients
    ADD location_id INT NOT NULL;

ALTER TABLE dbo.clients
	ADD CONSTRAINT fk_clients_locations
	FOREIGN KEY (location_id)
		REFERENCES dbo.locations(id)
		ON DELETE CASCADE
		ON UPDATE CASCADE;



-- 8) Create Concepts Table

CREATE TABLE concepts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    concept_name VARCHAR(128) UNIQUE NOT NULL
);



-- 9) FK Request Table to Concepts Table

ALTER TABLE dbo.requests
    ADD concept_id INT;

ALTER TABLE dbo.requests
    ADD CONSTRAINT fk_requests_concepts
    FOREIGN KEY (concept_id)
        REFERENCES dbo.concepts
        ON DELETE SET NULL
        ON UPDATE CASCADE;



-- 10) Create User Types Table

CREATE TABLE user_types (
    id INT IDENTITY(1,1) PRIMARY KEY,
    type_name VARCHAR(128) UNIQUE NOT NULL
);

INSERT INTO dbo.user_types
    VALUES ('Basic Data Entry');



-- 11) FK Users Table to User Types Table

ALTER TABLE dbo.users
    ADD CONSTRAINT fk_users_user_types
    FOREIGN KEY (user_type)
        REFERENCES dbo.user_types
        ON DELETE SET DEFAULT
        ON UPDATE CASCADE;



-- 12) Create Permissions Table

CREATE TABLE alteration_types (
    id INT IDENTITY(1,1) PRIMARY KEY,
    permission_name VARCHAR(128) UNIQUE NOT NULL
);



-- 13) Create MtM connection between User Types table and Permissions Table

CREATE TABLE mtm_alteration_types_user_types (
    alteration_type_id INT NOT NULL FOREIGN KEY REFERENCES alteration_types(id),
    user_type_id INT NOT NULL FOREIGN KEY REFERENCES user_types(id),
    CONSTRAINT pk_alterationTypes_userTypes PRIMARY KEY (alteration_type_id, user_type_id)
);



-- 14) Create Alterations Table

CREATE TABLE alterations (
    id INT IDENTITY(1,1) PRIMARY KEY,
    alteration_time DATETIME DEFAULT GETDATE(),
    user_id INT NOT NULL,
    alteration_type_id INT NOT NULL,
    table_altered VARCHAR(128) NOT NULL,
    row_id INT NOT NULL,
    old_values NVARCHAR(MAX) NOT NULL, -- Contains JSON of old values
    new_values NVARCHAR(MAX) NOT NULL, -- Contains JSON of new values
);



-- 15) FN convert clients table row to JSON
    -- MUST BE THE ONLY STATEMENT IN BATCH

-- CREATE FUNCTION fnJSON_clientsRow
-- (@row_id INT)
-- RETURNS VARCHAR(MAX)
-- AS BEGIN
--     DECLARE @result VARCHAR(MAX)

--     DECLARE @pName VARCHAR(128) = (SELECT name FROM dbo.clients WHERE id=@row_id)
--     DECLARE @pLoc INT = (SELECT location_id FROM dbo.clients WHERE id=@row_id)

--     SET @result = '{"id":' + CONVERT(VARCHAR,@row_id) + ',"name":"' + CONVERT(VARCHAR,@pName) + '","location_id":' + CONVERT(VARCHAR,@pLoc) + '}' 

--     RETURN @result
-- END



-- 16) FN convert locations table row to JSON
    -- MUST BE THE ONLY STATEMENT IN BATCH

-- CREATE FUNCTION fnJSON_locationsRow
-- (@row_id INT)
-- RETURNS VARCHAR(MAX)
-- AS BEGIN
--     DECLARE @result VARCHAR(MAX)

--     DECLARE @pCity VARCHAR(128) = (SELECT city FROM dbo.locations WHERE id=@row_id)
--     DECLARE @pCountry VARCHAR(128) = (SELECT country FROM dbo.locations WHERE id=@row_id)

--     IF (SELECT state_province FROM dbo.locations WHERE id=@row_id) IS NULL
--         BEGIN
--             SET @result = '{' + 
--                 '"id":' + CONVERT(VARCHAR,@row_id) + ',' + 
--                 '"city":' + '"' + CONVERT(VARCHAR,@pCity) + '",' + 
--                 '"country":' + '"' + CONVERT(VARCHAR,@pCountry) + '"' + 
--             '}'
--         END
--     ELSE
--         BEGIN
--             DECLARE @pState VARCHAR(128) = (SELECT state_province FROM dbo.locations WHERE id=@row_id)
--             SET @result = '{' + 
--                 '"id":' + CONVERT(VARCHAR,@row_id) + ',' + 
--                 '"city":' + '"' + CONVERT(VARCHAR,@pCity) + '",' + 
--                 '"state_province":' + '"' + CONVERT(VARCHAR,@pState) + '",' + 
--                 '"country":' + '"' + CONVERT(VARCHAR,@pCountry) + '"' + 
--             '}'
--         END

--     RETURN @result
-- END



-- 17) FN convert concepts table row to JSON
    -- MUST BE THE ONLY STATEMENT IN BATCH

-- CREATE FUNCTION fnJSON_conceptsRow
-- (@row_id INT)
-- RETURNS VARCHAR(MAX)
-- AS BEGIN
--     DECLARE @result VARCHAR(MAX)

--     DECLARE @pConceptName VARCHAR(128) = (SELECT concept_name FROM dbo.concepts WHERE id=@row_id)

--     SET @result = '{' + 
--         '"id":' + CONVERT(VARCHAR,@row_id) + ',' + 
--         '"name":' + '"' + CONVERT(VARCHAR,@pConceptName) + '"' + 
--     '}'

--     RETURN @result
-- END



-- 18) FN convert requests table row to JSON
    -- MUST BE THE ONLY STATEMENT IN BATCH

-- CREATE FUNCTION fnJSON_requestsRow
-- (@row_id INT)
-- RETURNS VARCHAR(MAX)
-- AS BEGIN
--     DECLARE @result VARCHAR(MAX)

--     DECLARE @pRequestDate DATETIME = (SELECT request_date FROM dbo.requests WHERE id=@row_id)
--     DECLARE @pResolvedInt BIT = (SELECT resolved FROM dbo.requests WHERE id=@row_id)

--     DECLARE @pResolvedTF VARCHAR(5)
--     IF @pResolvedInt = 1
--         BEGIN
--             SET @pResolvedTF = 'true'
--         END
--     ELSE
--         BEGIN
--             SET @pResolvedTF = 'false'
--         END


--     DECLARE @pClientId INT = (SELECT client_id FROM dbo.requests WHERE id=@row_id)
--     DECLARE @pConceptId INT = (SELECT concept_id FROM dbo.requests WHERE id=@row_id)

--     SET @result = 
--     '{' + 
--         '"id":' + CONVERT(VARCHAR,@row_id) + ',' + 
--         '"request_date":' + '"' + CONVERT(VARCHAR,@pRequestDate) + '",' + 
--         '"resolved":' + CONVERT(VARCHAR,@pResolvedTF) + ',' +
--         '"client_id":' + CONVERT(VARCHAR,@pClientId) + ',' +
--         '"concept_id":' + CONVERT(VARCHAR,@pConceptId) + '"' +
--     '}'

--     RETURN @result
-- END



-- 19) FN convert request details table row to JSON
    -- MUST BE THE ONLY STATEMENT IN BATCH

-- //TODO Create function to convert request details table row to JSON
-- //TODO Compare old row content JSON to new row content JSON
-- //TODO If there's a difference between old row content JSON and new row content JSON, then create new Alterations row
-- //TODO Create function to create new Alterations row on row insert for all main tables
-- //TODO Create function to create new Alterations row on row update for all main tables
-- //TODO Create function to create new Alterations row on row delete for all main tables
-- 1) Create Client Table

CREATE TABLE clients (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(128) UNIQUE NOT NULL
);



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
    client_id INT,
    request_id INT,
);



-- 15) FK alterations to requests & clients

ALTER TABLE dbo.alterations     -- This constraint ensures that the alteration can happen to a client or a request, but not both
    ADD CONSTRAINT CHK_clientOrRequest CHECK
    ((client_id IS NOT NULL OR request_id IS NOT NULL)
    AND NOT (client_id IS NOT NULL AND request_id IS NOT NULL));

ALTER TABLE dbo.alterations
    ADD CONSTRAINT FK_alterations_clients
    FOREIGN KEY (client_id)
        REFERENCES dbo.clients
        ON DELETE CASCADE
        ON UPDATE CASCADE;

ALTER TABLE dbo.alterations
    ADD CONSTRAINT FK_alterations_requests
    FOREIGN KEY (request_id)
        REFERENCES dbo.requests
        ON DELETE CASCADE
        ON UPDATE CASCADE;



-- 16) FK alterations to alteration types

ALTER TABLE dbo.alterations
    ADD CONSTRAINT fk_alterations_alteration_types
    FOREIGN KEY (alteration_type_id)
        REFERENCES dbo.alteration_types
        ON DELETE CASCADE
        ON UPDATE CASCADE;



-- 17) FK Alterations to Users

ALTER TABLE dbo.alterations
    ADD CONSTRAINT fk_alterations_users
    FOREIGN KEY (user_id)
        REFERENCES dbo.alterations
        ON DELETE CASCADE
        ON UPDATE CASCADE;
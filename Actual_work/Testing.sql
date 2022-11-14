-- 1) Create Client Table

INSERT INTO dbo.clients VALUES
    ('testName1','LOC1'),
    ('testName2','LOC2');

SELECT * FROM dbo.clients;



-- 2) Create Request Table

INSERT INTO dbo.requests(resolved) VALUES
    (0),
    (0);

SELECT * FROM dbo.requests;



-- 3) FK Request Table to Client Table

INSERT INTO dbo.clients VALUES
    ('testName1','LOC1'),
    ('testName2','LOC2'),
    ('testName3','LOC3');

INSERT INTO dbo.requests(client_id) VALUES
    (2),(1),(3);

SELECT * FROM dbo.clients;
SELECT * FROM dbo.requests;

DELETE FROM dbo.clients
    WHERE id = 1;

SELECT * FROM dbo.clients;
SELECT * FROM dbo.requests;



-- 4) Create Request Details Table

INSERT INTO dbo.clients VALUES
    ('testName1','LOC1'),
    ('testName2','LOC2'),
    ('testName3','LOC3');

INSERT INTO dbo.requests(client_id) VALUES
    (2),(1),(3);

INSERT INTO dbo.requests_details(request_source, request_description, request_message, request_resolution, request_id) VALUES 
    ('source3','desc3','mess3','reso3',3),
    ('source1','desc1','mess1','reso1',1),
    ('source2','desc2','mess2','reso2',2);



-- 5) Create Locations Table

INSERT INTO dbo.locations VALUES
    ('Salem', 'Massachussets', 'USA'),
    ('Salem', 'Oregon', 'USA');

SELECT * FROM dbo.locations;



-- 6) Create Users Table

INSERT INTO dbo.users VALUES
    ('first1','middle1','last1','empid1',1),
    ('first2','middle2','last2','empid2',2),
    ('first1','middle1','last1','empid3',1);

SELECT * FROM dbo.users;



-- 7) FK Client Table to Location Table

INSERT INTO dbo.locations VALUES
    ('Salem', 'Massachussets', 'USA'),
    ('Salem', 'Oregon', 'USA');

INSERT INTO dbo.clients VALUES
    ('testName1',2),
    ('testName2',1);

SELECT C.name AS Name, L.city + ', ' + L.state_province AS 'City, State' 
FROM clients C
JOIN locations L ON C.location_id=L.id;
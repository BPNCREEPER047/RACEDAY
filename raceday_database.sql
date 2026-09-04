-- ============================================================
-- RaceDay - SQL Database Script
-- Part 1 - Section C: SQL Database Script
-- SQL Server 2022 / SSMS 2022 Compatible
-- ============================================================

-- Step 1: Drop the database if it already exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'RaceDay')
BEGIN
    ALTER DATABASE RaceDay SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RaceDay;
END
GO

-- Step 2: Create the database
CREATE DATABASE RaceDay;
GO

-- Step 3: Switch into RaceDay database
-- Using EXEC so SQL Server resolves this at runtime, not parse time
EXEC('USE RaceDay');
GO

-- ============================================================
-- TABLE 1: Users
-- Stores all users - both Organisers and Participants
-- ============================================================
CREATE TABLE RaceDay.dbo.Users (
    UserID    INT           IDENTITY(1,1) PRIMARY KEY,
    FullName  NVARCHAR(100) NOT NULL,
    Email     NVARCHAR(150) NOT NULL UNIQUE,
    Password  NVARCHAR(255) NOT NULL,
    Role      NVARCHAR(20)  NOT NULL CHECK (Role IN ('Organiser', 'Participant')),
    CreatedAt DATETIME      NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================================
-- TABLE 2: Categories
-- Event categories e.g. Road Running, Cycling, Walking
-- ============================================================
CREATE TABLE RaceDay.dbo.Categories (
    CategoryID   INT           IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    Description  NVARCHAR(500) NULL
);
GO

-- ============================================================
-- TABLE 3: Events
-- Created by Organisers, each linked to one Category
-- ============================================================
CREATE TABLE RaceDay.dbo.Events (
    EventID         INT            IDENTITY(1,1) PRIMARY KEY,
    EventName       NVARCHAR(200)  NOT NULL,
    Description     NVARCHAR(1000) NULL,
    EventDate       DATETIME       NOT NULL,
    Location        NVARCHAR(300)  NOT NULL,
    Distance        DECIMAL(6,2)   NOT NULL,
    MaxParticipants INT            NOT NULL DEFAULT 100,
    CategoryID      INT            NOT NULL,
    OrganiserID     INT            NOT NULL,
    CreatedAt       DATETIME       NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Events_Category  FOREIGN KEY (CategoryID)  REFERENCES RaceDay.dbo.Categories(CategoryID),
    CONSTRAINT FK_Events_Organiser FOREIGN KEY (OrganiserID) REFERENCES RaceDay.dbo.Users(UserID)
);
GO

-- ============================================================
-- TABLE 4: Enrolments
-- Tracks which Participant signed up for which Event
-- Resolves the Many-to-Many between Users and Events
-- ============================================================
CREATE TABLE RaceDay.dbo.Enrolments (
    EnrolmentID   INT          IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT          NOT NULL,
    EventID       INT          NOT NULL,
    EnrolledAt    DATETIME     NOT NULL DEFAULT GETDATE(),
    Status        NVARCHAR(20) NOT NULL DEFAULT 'Registered'
        CHECK (Status IN ('Registered', 'Cancelled')),

    CONSTRAINT UQ_Enrolment              UNIQUE (ParticipantID, EventID),
    CONSTRAINT FK_Enrolments_Participant FOREIGN KEY (ParticipantID) REFERENCES RaceDay.dbo.Users(UserID),
    CONSTRAINT FK_Enrolments_Event       FOREIGN KEY (EventID)       REFERENCES RaceDay.dbo.Events(EventID)
);
GO

-- ============================================================
-- TABLE 5: Results
-- Finish time and position per enrolment, captured by Organisers
-- ============================================================
CREATE TABLE RaceDay.dbo.Results (
    ResultID    INT           IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT           NOT NULL UNIQUE,
    FinishTime  NVARCHAR(20)  NOT NULL,
    Position    INT           NULL,
    Notes       NVARCHAR(500) NULL,

    CONSTRAINT FK_Results_Enrolment FOREIGN KEY (EnrolmentID) REFERENCES RaceDay.dbo.Enrolments(EnrolmentID)
);
GO

-- ============================================================
-- TABLE 6: Routes
-- Route information for each event (one route per event)
-- ============================================================
CREATE TABLE RaceDay.dbo.Routes (
    RouteID       INT            IDENTITY(1,1) PRIMARY KEY,
    EventID       INT            NOT NULL UNIQUE,
    RouteMapURL   NVARCHAR(500)  NULL,
    StartPoint    NVARCHAR(200)  NOT NULL,
    EndPoint      NVARCHAR(200)  NOT NULL,
    ElevationGain DECIMAL(6,2)   NULL,
    Description   NVARCHAR(1000) NULL,

    CONSTRAINT FK_Routes_Event FOREIGN KEY (EventID) REFERENCES RaceDay.dbo.Events(EventID)
);
GO

-- ============================================================
-- SEED DATA: 2 Organisers and 2 Participants
-- ============================================================
INSERT INTO RaceDay.dbo.Users (FullName, Email, Password, Role) VALUES
('Sarah Dlamini',  'sarah@raceday.co.za', 'hashed_password_1', 'Organiser'),
('James Nkosi',    'james@raceday.co.za', 'hashed_password_2', 'Organiser'),
('Lerato Mokoena', 'lerato@gmail.com',    'hashed_password_3', 'Participant'),
('Thabo Sithole',  'thabo@gmail.com',     'hashed_password_4', 'Participant');
GO

-- ============================================================
-- SEED DATA: 4 Categories
-- ============================================================
INSERT INTO RaceDay.dbo.Categories (CategoryName, Description) VALUES
('Road Running',  'Running events on tarred roads, ranging from 5km to full marathon'),
('Cycling',       'Road and trail cycling events for all fitness levels'),
('Walking',       'Casual and competitive walking events, great for all ages'),
('Trail Running', 'Off-road running on natural terrain and mountain paths');
GO

-- ============================================================
-- SEED DATA: 3 Events
-- OrganiserID 1 = Sarah, OrganiserID 2 = James
-- ============================================================
INSERT INTO RaceDay.dbo.Events (EventName, Description, EventDate, Location, Distance, MaxParticipants, CategoryID, OrganiserID) VALUES
('Cape Town Half Marathon',
 'A scenic 21km run through the heart of Cape Town ending at the Waterfront.',
 '2026-11-15 07:00:00', 'Cape Town CBD, Western Cape', 21.10, 500, 1, 1),

('Soweto Cycle Challenge',
 'A 94km cycling event through Soweto and surrounds.',
 '2026-10-25 06:30:00', 'Soweto, Johannesburg, Gauteng', 94.00, 1000, 2, 2),

('Durban Fun Walk',
 'A 10km community walk along the Durban beachfront. Suitable for all ages.',
 '2026-09-20 08:00:00', 'Durban Beachfront, KwaZulu-Natal', 10.00, 300, 3, 1);
GO

-- ============================================================
-- SEED DATA: 3 Enrolments
-- ParticipantID 3 = Lerato, ParticipantID 4 = Thabo
-- ============================================================
INSERT INTO RaceDay.dbo.Enrolments (ParticipantID, EventID, Status) VALUES
(3, 1, 'Registered'),
(4, 1, 'Registered'),
(3, 2, 'Registered');
GO

-- ============================================================
-- SEED DATA: 2 Results
-- EnrolmentID 1 = Lerato in Event 1, EnrolmentID 2 = Thabo in Event 1
-- ============================================================
INSERT INTO RaceDay.dbo.Results (EnrolmentID, FinishTime, Position, Notes) VALUES
(1, '01:52:34', 1, 'Excellent performance, strong finish'),
(2, '02:05:12', 2, 'Consistent pace throughout');
GO

-- ============================================================
-- SEED DATA: 2 Routes
-- ============================================================
INSERT INTO RaceDay.dbo.Routes (EventID, RouteMapURL, StartPoint, EndPoint, ElevationGain, Description) VALUES
(1, 'https://raceday.co.za/routes/ctmarathon-map.png',
 'Grand Parade, Cape Town', 'V&A Waterfront, Cape Town', 145.50,
 'Start at Grand Parade, through the CBD, along Sea Point promenade, finishing at the V&A Waterfront.'),

(2, 'https://raceday.co.za/routes/sowetocycle-map.png',
 'FNB Stadium, Soweto', 'FNB Stadium, Soweto', 320.00,
 'Circular route starting and ending at FNB Stadium, passing through Diepkloof and Orlando.');
GO

-- ============================================================
-- VERIFY: Show row counts for all 6 tables
-- Expected: Users=4, Categories=4, Events=3,
--           Enrolments=3, Results=2, Routes=2
-- ============================================================
SELECT 'Users'       AS TableName, COUNT(*) AS Rows FROM RaceDay.dbo.Users
UNION ALL
SELECT 'Categories',               COUNT(*)          FROM RaceDay.dbo.Categories
UNION ALL
SELECT 'Events',                   COUNT(*)          FROM RaceDay.dbo.Events
UNION ALL
SELECT 'Enrolments',               COUNT(*)          FROM RaceDay.dbo.Enrolments
UNION ALL
SELECT 'Results',                  COUNT(*)          FROM RaceDay.dbo.Results
UNION ALL
SELECT 'Routes',                   COUNT(*)          FROM RaceDay.dbo.Routes;
GO
-- ============================================================
-- END OF SCRIPT
-- ============================================================



/*---------------------------------------
          ADMIN SECTION
----------------------------------------*/
CREATE TABLE Admin (
    AdminID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    Role NVARCHAR(50) NOT NULL,
    Gender NVARCHAR(10) NOT NULL, -- Added Gender column
    CreatedAt DATETIME DEFAULT GETDATE(),
);


INSERT INTO Admin (FullName, Email, Password, Role, Gender)
VALUES 
('Satyam Yadav', 'satyamyadav210903@gmail.com', 'password123', 'Admin','Male');

select * from Admin

/*----------------------------------------
          CLIENT SECTION
-------------------------------------------*/
CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ProfilePicture NVARCHAR(MAX) NULL,
    Name NVARCHAR(255) NOT NULL,
    Gender NVARCHAR(10) NOT NULL, -- Added Gender column
    Password NVARCHAR(255) NOT NULL,  -- Enclosed in brackets due to reserved keyword
    Email NVARCHAR(255) NOT NULL UNIQUE,
    Mobile NVARCHAR(10) NOT NULL ,
    Address NVARCHAR(500) NOT NULL,
    Pincode NVARCHAR(6) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    State NVARCHAR(255) NOT NULL,
    Country NVARCHAR(100) NOT NULL,  -- Increased length for country names
    BloodType NVARCHAR(10) NOT NULL,
    AdminID INT,  -- Column to reference Admin table
    MedicalCondition BIT NULL,  -- New column
    Message NVARCHAR(MAX) NULL,  -- New column
	UpdateDate DATETIME NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Users_AdminID FOREIGN KEY (AdminID) REFERENCES Admin(AdminID)
);

select * from Users


/*--------------------------------------------------------------
                      HOSPITALS SECTION
-----------------------------------------------------------------*/

CREATE TABLE Hospitals (
    HospitalId INT IDENTITY(1,1) PRIMARY KEY, -- Unique identifier for each hospital
    HospitalName NVARCHAR(255) NOT NULL,     -- Name of the hospital
    Email NVARCHAR(255) NOT NULL,            -- Email of the hospital
    Password NVARCHAR(255) NOT NULL,         -- Password for the hospital
    Address NVARCHAR(500) NOT NULL,          -- Address of the hospital
    City NVARCHAR(100) NOT NULL,             -- City where the hospital is located
    State NVARCHAR(100) NOT NULL,            -- State where the hospital is located
    Pincode NVARCHAR(10) NOT NULL,           -- Pincode of the hospital location
    ContactNumber NVARCHAR(20) NOT NULL,     -- Contact number of the hospital
    AdminId INT NOT NULL,                    -- Admin ID for access control

    -- Foreign key constraint referencing the Admin table
    CONSTRAINT FK_Hospitals_Admin FOREIGN KEY (AdminId) REFERENCES Admin(AdminID)
);

/*--------------------------------------------------------------
                      BLOOD-STOCK SECTION
-----------------------------------------------------------------*/
CREATE TABLE BloodStock (
    StockId INT IDENTITY(1,1) PRIMARY KEY, 
    BloodType NVARCHAR(10) NOT NULL,      
    Quantity INT NOT NULL,                 
    ExpiryDate DATE NOT NULL,  -- New column with default value
    HospitalId INT NOT NULL,               
    AdminId INT NOT NULL,                  

    -- Foreign key constraints
    CONSTRAINT FK_BloodStock_Hospitals FOREIGN KEY (HospitalId) REFERENCES Hospitals(HospitalId),
    CONSTRAINT FK_BloodStock_Admin FOREIGN KEY (AdminId) REFERENCES Admin(AdminID)
);



/*--------------------------------------------------
          DONOR APPOINTMENT SECTION
----------------------------------------------------*/
CREATE TABLE DonorAppointment (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    Gender NVARCHAR(10) NOT NULL, -- Added Gender column
    Email NVARCHAR(255) NOT NULL,
    Phone NVARCHAR(10) NOT NULL,
    Center NVARCHAR(255) NOT NULL,
    Date DATETIME NOT NULL,
    Time NVARCHAR(50) NOT NULL,  -- Consider using TIME data type if only time is needed
    BloodType NVARCHAR(10) NOT NULL,
    
    -- Foreign key columns
	UsersId INT NOT NULL,
    AdminId INT NOT NULL,
    HospitalId INT NOT NULL,
	
    -- Foreign key constraints
    CONSTRAINT FK_DonorAppointment_Users FOREIGN KEY (UsersId) REFERENCES Users(Id),
    CONSTRAINT FK_DonorAppointment_Admin FOREIGN KEY (AdminId) REFERENCES Admin(AdminID),
    CONSTRAINT FK_DonorAppointment_Hospital FOREIGN KEY (HospitalId) REFERENCES Hospitals(HospitalId)

);


select * from DonorAppointment




/*------------------------------------------------------------
          RECIEPIENT APPOINTMENT SECTION
--------------------------------------------------------------*/
CREATE TABLE BloodRequest (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Phone NVARCHAR(15) NOT NULL,
    Address NVARCHAR(500) NOT NULL,
    BloodType NVARCHAR(10) NOT NULL,
    Gender NVARCHAR(10) NOT NULL, -- Added Gender column
	Relation NVARCHAR(30) NOT NULL,
    Center NVARCHAR(255) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    
    -- Foreign key columns
	UsersId INT NOT NULL,
    AdminId INT NOT NULL,
    HospitalId INT NOT NULL,
    
    -- Foreign key constraints
    CONSTRAINT FK_Request_Users FOREIGN KEY (UsersId) REFERENCES Users(Id),
    CONSTRAINT FK_Request_Admin FOREIGN KEY (AdminId) REFERENCES Admin(AdminID),
    CONSTRAINT FK_Request_Hospital FOREIGN KEY (HospitalId) REFERENCES Hospitals(HospitalId)
);







/*-------------------------------------------------
          CAMPAIGN SECTION
---------------------------------------------------*/
CREATE TABLE Campaign (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    ImageUrl NVARCHAR(MAX) NULL,
    Date NVARCHAR(50) NOT NULL,
    Time NVARCHAR(50) NOT NULL,  -- Consider using TIME data type if only time is needed
    Location NVARCHAR(255) NOT NULL,

    AdminId INT NOT NULL,
    
    CONSTRAINT FK_Campaign_Admin FOREIGN KEY (AdminId) REFERENCES Admin(AdminID)
);


-- BOOK SLOT
CREATE TABLE CampaignSlot (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Phone NVARCHAR(10) NOT NULL,
    Gender NVARCHAR(10) NOT NULL, -- Added Gender column
    Center NVARCHAR(255) NOT NULL,
    Date DATETIME NOT NULL,
    Time NVARCHAR(50) NOT NULL,   -- using SQL Server TIME type for time data
    BloodType NVARCHAR(10) NOT NULL,
    FeelingWell BIT NOT NULL,
    MedicalCondition BIT NOT NULL,
    
    -- Foreign key columns for Admin access
    UsersId INT NOT NULL,
    AdminId INT NOT NULL,
    CampaignId INT NOT NULL,
    
    -- Foreign key constraints 
    CONSTRAINT FK_CampaignSlot_Users FOREIGN KEY (UsersId) REFERENCES Users(Id),
    CONSTRAINT FK_CampaignSlot_Admin FOREIGN KEY (AdminId) REFERENCES Admin(AdminID),
    CONSTRAINT FK_CampaignSlot_Campaign FOREIGN KEY (CampaignId) REFERENCES Campaign(Id)

);

select * from Campaign

--------------------------CAMPAIGN DONORS ---------------------------------------

CREATE TABLE CampaignDonor (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ImageUrl NVARCHAR(MAX) NULL,
    Name NVARCHAR(255) NOT NULL,
    Gender NVARCHAR(10) NOT NULL, -- Added Gender column
    BloodType NVARCHAR(10) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Address NVARCHAR(500) NOT NULL,
    Mob NVARCHAR(20) NOT NULL,
    
    -- Foreign key column for Admin
    AdminId INT NOT NULL,
    CampaignId INT NOT NULL,

    -- Foreign key constraint
    CONSTRAINT FK_CampaignDonor_Admin FOREIGN KEY (AdminId) REFERENCES Admin(AdminID),
    CONSTRAINT FK_CampaignDonor_Campaign FOREIGN KEY (CampaignId) REFERENCES Campaign(Id)
);


/*-------------------------------------------------------
          DONOR SECTION
--------------------------------------------------------*/

CREATE TABLE Donor (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ImageUrl NVARCHAR(MAX) NULL,
    Name NVARCHAR(255) NOT NULL,
    Gender NVARCHAR(10) NOT NULL, -- Added Gender column
    BloodType NVARCHAR(10) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Address NVARCHAR(500) NOT NULL,
    Mob NVARCHAR(20) NOT NULL,
    
    -- Foreign key column for Admin
    AdminId INT NOT NULL,
    HospitalId INT NOT NULL,

    -- Foreign key constraint
    CONSTRAINT FK_Donor_Admin FOREIGN KEY (AdminId) REFERENCES Admin(AdminID),
    CONSTRAINT FK_Donor_Hospital FOREIGN KEY (HospitalId) REFERENCES Hospitals(HospitalId)
);

select * from Donor



/*-------------------------------------------------------
          FEEDBACK SECTION
--------------------------------------------------------*/
CREATE TABLE FeedbackForm (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserName NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Subject NVARCHAR(255) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(), -- Auto-set timestamp
    
    -- Foreign key for Admin access
    AdminId INT NOT NULL,  
    CONSTRAINT FK_FeedbackForm_Admin FOREIGN KEY (AdminId) REFERENCES Admin(AdminID)
);



/*-------------------------------------------------------------------------
                          VOLUNTEER SECTION
--------------------------------------------------------------------------*/

CREATE TABLE Workers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    ProfilePicture NVARCHAR(MAX) NULL,
    Phone CHAR(10) NOT NULL,
    Gender NVARCHAR(10) NOT NULL,
    Address NVARCHAR(500) NOT NULL,
    Role NVARCHAR(100) NOT NULL,
    Experience NVARCHAR(500) NULL,
    Availability NVARCHAR(100) NULL,
    Center NVARCHAR(255) NOT NULL,
    JoinedAt DATETIME DEFAULT GETDATE(),  -- **Comma added here**

    -- Foreign key columns
    AdminId INT NOT NULL,
    HospitalId INT NOT NULL,

    -- Foreign key constraints
    CONSTRAINT FK_WorkingVolunteer_Admin FOREIGN KEY (AdminId) REFERENCES Admin(AdminID),
    CONSTRAINT FK_WorkingVolunteer_Hospital FOREIGN KEY (HospitalId) REFERENCES Hospitals(HospitalId)
);



CREATE TABLE Volunteer (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    Phone CHAR(10) NOT NULL,
    Gender NVARCHAR(10) NOT NULL,
    Address NVARCHAR(500) NOT NULL,
    Role NVARCHAR(100) NOT NULL,
    Experience NVARCHAR(500) NULL,
    Availability NVARCHAR(100) NULL,
    PreferredCenter NVARCHAR(255) NOT NULL,
    Message NVARCHAR(1000) NULL,
	Status NVARCHAR(50) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),  -- **Comma added here**

    -- Foreign key columns
    UsersId INT NOT NULL,
    AdminId INT NOT NULL,
    HospitalId INT NOT NULL,

    -- Foreign key constraints
    CONSTRAINT FK_Volunteer_Users FOREIGN KEY (UsersId) REFERENCES Users(Id),
    CONSTRAINT FK_Volunteer_Admin FOREIGN KEY (AdminId) REFERENCES Admin(AdminID),
    CONSTRAINT FK_Volunteer_Hospital FOREIGN KEY (HospitalId) REFERENCES Hospitals(HospitalId)
);

select * from Volunteer






select * from Admin
Entity: password

Description: Stores user passwords

Field	Size	Data Type	Description
passwordId	10	INTEGER	Primary key for passwords
password	20	VARCHAR	Password value

Relationships:

Entity: email

Description: Stores user emails

Field	Size	Data Type	Description
emailId	10	INTEGER	Primary key for emails
email	50	VARCHAR	User email address

Relationships:

Entity: page

Description: Stores application pages

Field	Size	Data Type	Description
pageId	10	INTEGER	Primary key for pages
page	40	VARCHAR	Page name
url	—	TEXT	Page URL

Relationships:

Entity: role

Description: Stores user roles

Field	Size	Data Type	Description
roleId	10	INTEGER	Primary key for roles
role	20	VARCHAR	Role name
permissionDescription	100	VARCHAR	Description of role permissions

Relationships:

Entity: rolePage

Description: Many-to-many relationship between roles and pages

Field	Size	Data Type	Description
rolePageId	10	INTEGER	Primary key
pageId	40	VARCHAR	Foreign key referencing page
roleId	—	TEXT	Foreign key referencing role

Relationships: role, page

Entity: user

Description: Stores users

Field	Size	Data Type	Description
userId	10	INTEGER	Primary key for users
username	60	VARCHAR	Username
passwordId	10	INTEGER	FK to password
emailId	10	INTEGER	FK to email
roleId	10	INTEGER	FK to role
identification	10	BIGINTEGER	Identification number
phone	10	INTEGER	Phone number
modificationTime	10	INTEGER	Allowed modification time

Relationships: password, email, role

Entity: vehicleType

Description: Stores vehicle types

Field	Size	Data Type	Description
vehicleTypeId	10	INTEGER	Primary key
vehicleType	40	VARCHAR	Vehicle type name

Relationships:

Entity: vehicle

Description: Stores vehicles

Field	Size	Data Type	Description
vehicleId	10	INTEGER	Primary key
vehicleTypeId	10	INTEGER	FK to vehicleType
plate	30	VARCHAR	Vehicle plate/name
registrationDate	14	DATETIME	Registration date
state	—	BOOLEAN	Availability (active/inactive)

Relationships: vehicleType

Entity: typeMachinery

Description: Stores machinery types

Field	Size	Data Type	Description
typeMachineryId	10	INTEGER	Primary key
typeMachinery	40	VARCHAR	Machinery type name

Relationships:

Entity: machine

Description: Stores machines

Field	Size	Data Type	Description
machineId	10	INTEGER	Primary key
typeMachineryId	10	INTEGER	FK to typeMachinery
plate	30	VARCHAR	Machine identifier
registrationDate	14	DATETIME	Registration date
state	—	BOOLEAN	Availability

Relationships: typeMachinery

Entity: department

Description: Stores Colombian departments

Field	Size	Data Type	Description
departmentId	10	INTEGER	Primary key
departmentName	50	VARCHAR	Department name
daneCode	11	INTEGER	DANE code

Relationships:

Entity: municipality

Description: Stores municipalities

Field	Size	Data Type	Description
municipalityId	10	INTEGER	Primary key
departmentId	10	INTEGER	FK to department
municipalityName	50	VARCHAR	Municipality name
daneCode	10	INTEGER	DANE code

Relationships: department

Entity: activity

Description: Stores activities

Field	Size	Data Type	Description
activityId	10	INTEGER	Primary key
activity	100	VARCHAR	Activity name

Relationships:

Entity: work

Description: Stores works/projects

Field	Size	Data Type	Description
workId	10	INTEGER	Primary key
work	100	VARCHAR	Work name

Relationships:

Entity: machineryReport

Description: Stores machine reports

Field	Size	Data Type	Description
machineryReportId	10	INTEGER	Primary key
dateReport	—	DATE	Activity date
municipalityId	10	INTEGER	FK to municipality
machineId	10	INTEGER	FK to machine
workId	10	INTEGER	FK to work
activityId	100	INTEGER	FK to activity
initialHourMeter	38	DECIMAL	Start hour meter
finalHourMeter	38	DECIMAL	End hour meter
totalHours	38	DECIMAL	Total hours
hoursValue	38	DECIMAL	Hourly value
totalValue	38	DECIMAL	Total daily value
gallons	38	DECIMAL	Fuel used
fuelValue	38	DECIMAL	Fuel price
tankHour	38	DECIMAL	Refueling hour
performance	38	DECIMAL	Fuel efficiency
gps	38	DECIMAL	GPS location
observation	150	VARCHAR	Observations
userId	10	INTEGER	Operator
report	10	INTEGER	Report identifier

Relationships: machine, municipality, user, activity, work

Entity: reportVehicle

Description: Stores vehicle reports

Field	Size	Data Type	Description
reportVehicleId	10	INTEGER	Primary key
dateReport	—	DATE	Activity date
municipalityId	10	INTEGER	FK to municipality
machineId	10	INTEGER	FK (should be vehicleId)
workId	10	INTEGER	FK to work
activityId	10	INTEGER	FK to activity
quantity	10	INTEGER	Number of trips
value	38	DECIMAL	Value per trip
gallons	38	DECIMAL	Fuel used
fuel	38	DECIMAL	Fuel cost
tankKM	38	DECIMAL	Refueling kilometer
performance	38	DECIMAL	Fuel efficiency (Km/Gal)
gps	38	DECIMAL	GPS location
maxSpeed	38	DECIMAL	Max speed
observation	150	VARCHAR	Observations
userId	50	VARCHAR	Operator
report	11	INTEGER	Report identifier

Relationships: vehicle, municipality, user, activity, work
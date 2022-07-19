-- create database DBTesting;
create database DBTesting;
use DBTesting;
 --drop database DBTesting;
-- use master;
--User Table
--drop table usertbl;

create table usertbl
(
 id int identity(1,1) primary key,
 media_id int ,
 name varchar(45)
);
drop table usertbl;
create table project
(
id int identity(100,1) primary key,
name varchar(45)
);
drop table project 
-- [ User Table has many to many relationship with Project Table ]
create table project_hasRelationWith_user(
userid int not null ,
project_id int not null ,
manager tinyint, --0 to 255 size
foreign key (userid) references usertbl(id),
foreign key (project_id) references project(id)
);
select * from project_hasRelationWith_user;

 drop table project_hasRelationWith_user;



select * from usertbl
-- Media Table has one to many && one to one relationship with usertbl.
create table media
(
   id int primary key identity (1,1),
   userid int references usertbl(id) ,
   pathh varchar(70),
   filetype varchar(20),
   filesize decimal(38,2), -- means totla number of digits canot exceed 38 and 2 digits can be placed to the right of decimal

);
 -- trying to apply one to one to media and usertbl if there is not one to many relationship
  -- ALTER TABLE usertbl add CONSTRAINT fk_Media_id FOREIGN KEY (media_id) REFERENCES media
select * from media;
 drop table media;
-- Insert , Update and Delete
--- INSERT INTO USERTBL ----------------------------------------------
insert into usertbl (media_id,name) values
(100,'islam'),
(101,'adnan'),
(102,'mahmoud '),
(103,'Seif'),
(105,'asd'),
(106,'asd2 ');


select * from usertbl
----- INSERT IN Project table -------------------------------
insert into project(name) values
('project1'),
('project2'),
('project3');
insert into project(name) values('project4');
select * from project;
---------------------INSERT INTO Media Table -------------------------
insert into media (userid,pathh,filetype,filesize) values
 (1,'c:/Usres/islam','video',50),
 (2,'c:/Usres/islam','img',20),
 (3,'c:/Usres/islam','document',15),
 (4,'c:/Usres/islam','pdf',25),
 (5,'c:/Usres/islam','video',50),
 (6,'c:/Usres/islam','img',20);
select * from media;
------------------------------------- Insert Values in project_hasRelationWith_user ---------------
select*from usertbl;
select*from project;
insert into project_hasRelationWith_user (userid,project_id,manager) values
(1,100,200),(1,101,201),(1,102,202),
(2,101,203),
(3,102,204),(4,102,204),(5,102,206),(5,102,206);
select * from project_hasRelationWith_user;
--drop table project_hasRelationWith_user;
-------------------------------------------------------------------
-- Getting All Projects For User islam

select usertbl.id,project_id 
from  project_hasRelationWith_user inner join usertbl 
on project_hasRelationWith_user.userid= usertbl.id
where usertbl.name='islam';
----------------------------------
-- Getting all Users For Projec (project3 its id =102)

select userid,project.name
from  project_hasRelationWith_user inner join project 
on project_hasRelationWith_user.project_id= project.id
where project.id=102
---------------------------------------------------------
-- Getting Num Of Users For Each Projec

select project.name,count(userid) as NumOfUsers
from  project_hasRelationWith_user inner join project 
on project_hasRelationWith_user.project_id= project.id
group by project.name

-------------------------------------------------------------------
update usertbl set media_id=8 where name ='adnan';
select media_id from usertbl where name = 'adnan';
select * from usertbl;
----------------------------------------------- Select staements ---------------------------------------------

select * from media where filetype like 'p%';
select * from media;
select * from media where filetype like '%o';
select * from media where filesize=15 ;

--Group by------

-- find sum of filesize for each file type

select filetype,sum (filesize) as Total_Size 
from media 
group by filetype 
ORDER BY sum(filesize) desc;

----------------HAVING------------------------

-- find sum of filesize for each file type where size is more than 20  

select filetype,sum (filesize) as Total_Size 
from media 
group by filetype 
HAVING  sum(filesize)>20 ; -- means where condtiton 

--------------JOINS-----------------------------------------
select * from usertbl;
select * from project;
select * from media;
select * from project_hasRelationWith_user 
-----------------------------------------------------------
--1)full JOIN  

select * from usertbl;
select * from project_hasRelationWith_user 

select usertbl.name,project_hasRelationWith_user.manager
from usertbl full outer join project_hasRelationWith_user 
on usertbl.id = project_hasRelationWith_user.userid;

--2)INNER JOIN 
select * from usertbl;
select * from project_hasRelationWith_user ;
---------------------------------------
select usertbl.id,project_hasRelationWith_user.manager
from usertbl inner join project_hasRelationWith_user 
on usertbl.id = project_hasRelationWith_user.userid;

--3)Left JOIN 

select * from project;
select * from project_hasRelationWith_user 
----------------------------------------
select *
from project
left join project_hasRelationWith_user 
on project.id = project_hasRelationWith_user.project_id; -- (num o rows dependes on specified condition which defines num of common rows)



--4)Right JOIN  (all the right table rows with the common rows from the left table )

select * from project;
select * from project_hasRelationWith_user 
-------------------------------------------------------
select *
from project
right join  project_hasRelationWith_user
on project_hasRelationWith_user.project_id=project.id ;

---------------------------------------------------------------------Table-Valued-Functions Ex-----------------

go
CREATE function GetUserListmediamorethanOne(@media_id int)
RETURNS TABLE
    AS
    RETURN
        SELECT * FROM usertbl where usertbl.media_id>@media_id;
        

go
-- U must declare db.schema.funcName to call it
select * from DBTesting.dbo.GetUserListmediamorethanOne(1);

------------------------------------------------------------------StoredProcedure-For insertion Example------------------------
go

CREATE PROCEDURE InsertUsers
(
@media_id int,
@name nvarchar(50)
)
AS
BEGIN
	INSERT INTO usertbl (media_id,name)
    VALUES
	(
		@media_id,@name
	)
 END
 go
 --DROP PROCEDURE InsertUsers;
 --Call Procedure
 exec InsertUsers @media_id=101,@name='Mohamed';
 select * from usertbl;
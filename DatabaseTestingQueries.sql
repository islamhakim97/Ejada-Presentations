-- Database Testing 
create table sales (
id int identity (1,1),
product varchar(100) not null,
quantity int not null default 0 ,
fiscalyear smallint not null,
fiscalmonth smallint not null,
check(fiscalmonth>=1 and fiscalmonth<=12),
check(fiscalyear between 2000 and 2050),
check (quantity>=0),
unique(product,fiscalyear ,fiscalmonth),
primary key (id)
);
-- drop table if exists sales;
-------------------------------------------------------------------Quantity Column Testing ---------------------------------------------------------------
insert into sales (product,quantity,fiscalyear,fiscalmonth) values
('MobilePhone',50,2022,4);
select * from sales;
------------------------------------------------------------------------------ validate check for year
insert into sales (product,quantity,fiscalyear,fiscalmonth) values
('MobilePhone',50,1997,4);
select * from sales;
------------------------------------------------------------------------------ validate Unique for year
insert into sales (product,quantity,fiscalyear,fiscalmonth) values
('MobilePhone',50,2022,4);
select * from sales;
---------------------------------------------------------------------------------Validate Quantity null value
insert into sales (product,quantity,fiscalyear,fiscalmonth) values
('Mobile',null,2020,11);
select * from sales;
---------------------------------------------------------------------------------Validate Quantity int DataType
insert into sales (product,quantity,fiscalyear,fiscalmonth) values
('PC','sdfdgfhghj',2019,10);
select * from sales;
--------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------StoredProcedures Testing ------------------------------------------------------
---------------------------------------------------------------------------------------------------------
-- ALTER DATABASE DBTesting
-- SET RECURSIVE_TRIGGERS OFF -- For preventing Recurion Triggers ON|OFF To avoid errors in stored procedure
---------------------------------------------------------------------------------------------------------
--1)Test iff the StoredProcedure works as Expected
-------------------
use DBTesting;
-- single patch for creating Procedure
go
CREATE PROCEDURE SelectAllFilesByType @filetype varchar(30)
AS
begin

SELECT * FROM media WHERE filetype = @filetype 

end
Go
--------------------------------------------------- Show The Stored Procedure------
GO  
EXEC sp_helptext N'SelectAllFilesByType'; 
------------Executing Procedure--------------------
Exec SelectAllFilesByType @filetype ='video';
---------------------------------------------------- Validate Prcedure Result with valid data --
SELECT * FROM media WHERE filetype = 'video' ;
---------------------------------------------------- Validate Prcedure Result with unvalid data --
Exec SelectAllFilesByType @filetype ='vieo';
SELECT * FROM media WHERE filetype = 'vieo' ;
---------------------------------------------------
-- drop procedure SelectAllFilesByType;
----------------------------------------------------------------------------- Stored Functions Testing --------------------------------

go
CREATE FUNCTION Returnsiz
( @size INT )

RETURNS VARCHAR(50)

AS

BEGIN

   DECLARE @name VARCHAR(50);

   IF @size > 25
      SET @name = 'Larg';
   ELSE
      SET @name = 'Small';

   RETURN @name;

END;
go
-- Call Function by using select 
-- DROP FUNCTION ReturnSize;
GO

SELECT dbo.Returnsiz(20) as size ;

GO
--------------------------------------------------------------- validate function with in valid data ------------------------
GO

SELECT dbo.Returnsiz('asdsfdsg') as size ;

GO
---------------------------------- SCalar Function with two parameters ----------------------------
go
CREATE FUNCTION Multiply(
    @firstnum INT,
    @secondnum DEC(10,2)

)
RETURNS DEC(10,2)
AS 
BEGIN
    RETURN @firstnum * @secondnum ;
END;
go
---------------- Call The Function ---------------------
GO

SELECT dbo.Multiply(2,4) as Result  ;

GO
----------------- Validate  calling function with unvalid data---------------

GO
SELECT dbo.Multiply(4,'asdf') as Result  ;
GO

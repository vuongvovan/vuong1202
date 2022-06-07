
CREATE DATABASE QuanLyQuanCafe
GO
USE QuanLyQuanCafe
GO

-- Food
-- Table
-- FoodCategory
-- Account
-- Bill
-- BillInfo

CREATE TABLE TableFood
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) NOT NULL DEFAULT N'Bàn chưa có tên',
	status NVARCHAR(100) NOT NULL DEFAULT N'Trống'	-- Trống || Có người
)
GO

CREATE TABLE Account
(
	UserName NVARCHAR(100) PRIMARY KEY,	
	DisplayName NVARCHAR(100) NOT NULL DEFAULT N'Kter',
	PassWord NVARCHAR(1000) NOT NULL DEFAULT 0,
	Type INT NOT NULL  DEFAULT 0 -- 1: admin && 0: staff
)
GO

CREATE TABLE FoodCategory
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) NOT NULL DEFAULT N'Chưa đặt tên'
)
GO

CREATE TABLE Food
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) NOT NULL DEFAULT N'Chưa đặt tên',
	idCategory INT NOT NULL,
	price FLOAT NOT NULL DEFAULT 0
	
	FOREIGN KEY (idCategory) REFERENCES dbo.FoodCategory(id)
)
GO

CREATE TABLE Bill
(
	id INT IDENTITY PRIMARY KEY,
	DateCheckIn DATE NOT NULL DEFAULT GETDATE(),
	DateCheckOut DATE,
	idTable INT NOT NULL,
	status INT NOT NULL DEFAULT 0, -- 1: đã thanh toán && 0: chưa thanh toán
	totalPrice float not null default 0,
	discount float not null default 0

	FOREIGN KEY (idTable) REFERENCES dbo.TableFood(id)
)
GO

CREATE TABLE BillInfo
(
	id INT IDENTITY PRIMARY KEY,
	idBill INT NOT NULL,
	idFood INT NOT NULL,
	count INT NOT NULL DEFAULT 0
	
	FOREIGN KEY (idBill) REFERENCES dbo.Bill(id),
	FOREIGN KEY (idFood) REFERENCES dbo.Food(id)
)
GO

INSERT INTO dbo.Account
        ( UserName ,
          DisplayName ,
          PassWord ,
          Type
        )
VALUES  ( N'admin' , -- UserName - nvarchar(100)
          N'Admin' , -- DisplayName - nvarchar(100)
          N'0' , -- PassWord - nvarchar(1000)
          1  -- Type - int
        )
INSERT INTO dbo.Account
        ( UserName ,
          DisplayName ,
          PassWord ,
          Type
        )
VALUES  ( N'ThuNgan' , -- UserName - nvarchar(100)
          N'Thu Ngân' , -- DisplayName - nvarchar(100)
          N'0' , -- PassWord - nvarchar(1000)
          0  -- Type - int
        )
GO


CREATE PROC USP_GetAccountByUserName
@userName nvarchar(100)
AS 
BEGIN
	SELECT * FROM dbo.Account WHERE UserName = @userName
END
GO

EXEC dbo.USP_GetAccountByUserName @userName = N'k9' -- nvarchar(100)

GO

CREATE PROC USP_Login
@userName nvarchar(100), @passWord nvarchar(100)
AS
BEGIN
	SELECT * FROM dbo.Account WHERE UserName = @userName AND PassWord = @passWord
END
GO

-- thêm bàn
DECLARE @i INT = 0

WHILE @i <= 25
BEGIN
	INSERT dbo.TableFood ( name)VALUES  ( N'Bàn ' + CAST(@i AS nvarchar(100)))
	SET @i = @i + 1
END
GO
------------------------------------------------------------------------------------

CREATE  PROCEDURE USP_GetTableList
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM dbo.TableFood
END

GO

EXEC dbo.USP_GetTableList
GO

-- thêm category
INSERT dbo.FoodCategory
        ( name )
VALUES  ( N'Ăn chính'  -- name - nvarchar(100)
          )
INSERT dbo.FoodCategory
        ( name )
VALUES  ( N'Ăn vặt' )
INSERT dbo.FoodCategory
        ( name )
VALUES  ( N'Chè' )
INSERT dbo.FoodCategory
        ( name )
VALUES  ( N'Kem' )
INSERT dbo.FoodCategory
        ( name )
VALUES  ( N'Nước' )

select * from FoodCategory

-- thêm món ăn
INSERT dbo.Food
        ( name, idCategory, price )
VALUES  ( N'Mực một nắng nước sa tế', -- name - nvarchar(100)
          1, -- idCategory - int
          120000)
INSERT dbo.Food
        ( name, idCategory, price )
VALUES  ( N'Nghêu hấp xả', 1, 50000)
INSERT dbo.Food
        ( name, idCategory, price )
VALUES  ( N'Xúc xích chiên', 2, 60000)
INSERT dbo.Food
        ( name, idCategory, price )
VALUES  ( N'Chè đậu đỏ', 3, 75000)
INSERT dbo.Food
        ( name, idCategory, price )
VALUES  ( N'Kem sầu riêng', 4, 999999)
INSERT dbo.Food
        ( name, idCategory, price )
VALUES  ( N'7Up', 5, 15000)
INSERT dbo.Food
        ( name, idCategory, price )
VALUES  ( N'Cafe', 5, 12000)

-- thêm bill
INSERT	dbo.Bill
        ( DateCheckIn ,
          DateCheckOut ,
          idTable ,
          status
        )
VALUES  ( GETDATE() , -- DateCheckIn - date
          NULL , -- DateCheckOut - date
          3 , -- idTable - int
          0  -- status - int
        )
        
INSERT	dbo.Bill
        ( DateCheckIn ,
          DateCheckOut ,
          idTable ,
          status
        )
VALUES  ( GETDATE() , -- DateCheckIn - date
          NULL , -- DateCheckOut - date
          4, -- idTable - int
          0  -- status - int
        )
INSERT	dbo.Bill
        ( DateCheckIn ,
          DateCheckOut ,
          idTable ,
          status
        )
VALUES  ( GETDATE() , -- DateCheckIn - date
          GETDATE() , -- DateCheckOut - date
          5 , -- idTable - int
          1  -- status - int
        )

-- thêm bill info
INSERT	dbo.BillInfo
        ( idBill, idFood, count )
VALUES  ( 1, -- idBill - int
          1, -- idFood - int
          2  -- count - int
          )
INSERT	dbo.BillInfo
        ( idBill, idFood, count )
VALUES  ( 1, -- idBill - int
          3, -- idFood - int
          4  -- count - int
          )
INSERT	dbo.BillInfo
        ( idBill, idFood, count )
VALUES  ( 1, -- idBill - int
          5, -- idFood - int
          1  -- count - int
          )
INSERT	dbo.BillInfo
        ( idBill, idFood, count )
VALUES  ( 2, -- idBill - int
          1, -- idFood - int
          2  -- count - int
          )
INSERT	dbo.BillInfo
        ( idBill, idFood, count )
VALUES  ( 2, -- idBill - int
          6, -- idFood - int
          2  -- count - int
          )
INSERT	dbo.BillInfo
        ( idBill, idFood, count )
VALUES  ( 3, -- idBill - int
          5, -- idFood - int
          2  -- count - int
          )         
          
GO

-----------------------------------------------------------------------------------

CREATE PROC USP_InsertBill ( @idTable INT)
AS
BEGIN
	INSERT Bill( DateCheckIn, DateCheckOut, idTable, status)
	VALUES ( GETDATE(), NULL, @idTable, 0)
END
GO

------------------------------------------------------------------------------------

CREATE PROC USP_InsertBillInfo ( @idBill INT, @idFood INT, @count INT )
AS
BEGIN
	DECLARE @isExitsBillInfo INT
	DECLARE @foodCount INT = 1

	SELECT @isExitsBillInfo = id, @foodCount = b.count 
	FROM BillInfo AS b
	WHERE idBill = @idBill AND idFood = @idFood

	IF(@isExitsBillInfo > 0)
	BEGIN
		DECLARE @newCount INT = @foodCount + @count
		IF(@newCount > 0)
		BEGIN
			UPDATE BillInfo SET count = @foodCount + @count WHERE idFood = @idFood
		END
		ELSE
			DELETE BillInfo WHERE idBill = @idBill AND idFood = @idFood
	END
	ELSE
	BEGIN
		INSERT BillInfo( idBill, idFood,count)
		VALUES ( @idBill, @idFood, @count )
	END
END
GO
------------------------------------------------------------------------------------

CREATE TRIGGER UTG_UpdateBillInfo
ON BillInfo
FOR INSERT, UPDATE
AS 
BEGIN
	DECLARE @idBill INT

	SELECT @idBill = idBill FROM inserted

	DECLARE @idTable INT

	SELECT @idTable	= idTable FROM Bill WHERE id = @idBill AND status = 0

	DECLARE @count INT
	SELECT @count = COUNT(*) FROM BillInfo WHERE idBill = @idBill

	IF(@count > 0) 
		UPDATE TableFood SET status = N'Có Người' WHERE id = @idTable 
	ELSE
		UPDATE TableFood SET status = N'Trống' WHERE id = @idTable 
END
GO
-------------------------------------------------------------------------------------
/*
CREATE TRIGGER UTG_UpdateTable
ON TableFood FOR UPDATE
AS
BEGIN
	DECLARE @idTable INT
	DECLARE @status NVARCHAR(100)

	SELECT @idTable = id, @status = inserted.status FROM inserted

	DECLARE @idBill INT
	SELECT @idBill = id FROM Bill WHERE idTable = @idTable AND status = 0

	DECLARE @countBillInfo INT
	SELECT @countBillInfo = COUNT(*) FROM BillInfo WHERE idBill = @idBill

	IF(@countBillInfo > 0 AND @status <> N'Có Người')
		UPDATE TableFood SET status = N'Có Người' WHERE id = @idTable
	ELSE IF (@countBillInfo <=0 AND @status <> N'Trống')
		UPDATE TableFood SET status = N'Trống' WHERE id = @idTable
END
*/
-------------------------------------------------------------------------------------
GO
CREATE TRIGGER UTG_UpdateBill
ON Bill
FOR UPDATE
AS
BEGIN
	DECLARE @idBill INT

	SELECT @idBill = id FROM inserted

	DECLARE @idTable INT

	SELECT @idTable = idTable FROM Bill WHERE id = @idBill

	DECLARE @count INT = 0

	SELECT @count = COUNT(*) FROM Bill WHERE idTable = @idTable AND status = 0

	IF(@count = 0)
		UPDATE TableFood SET status = N'Trống' WHERE id = @idTable
END
GO
-------------------------------------------------------------------------------------

CREATE PROC USP_SwitchTable( @idTable1 INT, @idTable2 INT)
AS
BEGIN
	DECLARE @idFirstBill INT
	DECLARE @idSeconrdBill INT

	DECLARE @isFirstTablEmty INT = 1
	DECLARE @isSecondTablEmty INT = 1

	SELECT @idSeconrdBill = id FROM Bill WHERE idTable = @idTable2 AND status = 0
	SELECT @idFirstBill = id FROM Bill WHERE idTable = @idTable1 AND status = 0

	IF(@idFirstBill IS NULL)
	BEGIN
		INSERT INTO Bill(DateCheckIn, DateCheckOut, idTable, status)
		VALUES (GETDATE(), NULL, @idTable1, 0)
		SELECT @idFirstBill = MAX(id) FROM Bill WHERE idTable = @idTable1 AND status = 0
	END
	SELECT @isFirstTablEmty = COUNT(*) FROM BillInfo WHERE idBill = @idFirstBill


	IF(@idSeconrdBill IS NULL)
	BEGIN
		INSERT INTO Bill(DateCheckIn, DateCheckOut, idTable, status)
		VALUES (GETDATE(), NULL, @idTable2, 0)
		SELECT @idSeconrdBill = MAX(id) FROM Bill WHERE idTable = @idTable2 AND status = 0
	END
	SELECT @isSecondTablEmty = COUNT (*) FROM BillInfo WHERE idBill = @idSeconrdBill


	SELECT id INTO IDBillInfoTable FROM BillInfo WHERE idBill = @idSeconrdBill

	UPDATE BillInfo SET idBill = @idSeconrdBill WHERE idBill = @idFirstBill

	UPDATE BillInfo SET idBill = @idFirstBill WHERE id IN (SELECT * FROM IDBillInfoTable)

	DROP TABLE IDBillInfoTable	

	IF(@isFirstTablEmty = 0)
		UPDATE TableFood SET status = N'Trống' WHERE id = @idTable2

	IF(@isSecondTablEmty = 0)
		UPDATE TableFood SET status = N'Trống' WHERE id = @idTable1

END

-------------------------------------------------------------------------------------

GO
CREATE PROC USP_GetListBillByDate ( @checkIn date, @checkOut date)
AS
BEGIN
	SELECT T.name AS N'Tên bàn', B.totalPrice AS N'Tổng tiền', DateCheckIn AS N'Ngày vào', DateCheckOut N'Ngày ra', discount N'Giảm giá'
	FROM Bill AS B, TableFood AS T
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND B.status = 1
	AND T.id = B.idTable
END

select * from bill
select * from TableFood
--------------------------------------------------------------------------------------
GO
CREATE PROC USP_UpdateAccount
@userName NVARCHAR(100), @displayName NVARCHAR(100), @password NVARCHAR(100), @newPassword NVARCHAR(100)
AS 
BEGIN
	DECLARE @isRightPass INT = 0

	SELECT @isRightPass = COUNT(*) FROM Account WHERE USERName = @userName AND PassWord = @password

	IF(@isRightPass = 1)
	BEGIN
		IF(@newPassword = NULL OR @newPassword = '')
		BEGIN
			UPDATE Account SET DisplayName = @displayName WHERE USERName = @userName
		END
		ELSE
			UPDATE Account SET DisplayName = @displayName, PassWord = @newPassword WHERE USERName = @userName
	END
END
GO
---------------------------------------------------------------------------------------
GO
CREATE TRIGGER UTG_DeleteBillInfo
ON BillInfo 
FOR DELETE
AS
BEGIN
	DECLARE @idBillInfo INT
	DECLARE @idBill INT
	SELECT @idBillInfo = id, @idBill = deleted.idBill FROM deleted

	DECLARE @idTable INT
	SELECT @idTable = idTable FROM Bill WHERE id = @idBill

	DECLARE @count INT = 0

	SELECT @count = COUNT(*) FROM BillInfo AS bi, Bill AS b WHERE b.id = bi.idBill AND b.id = @idBill AND status = 0

	IF(@count = 0)
		UPDATE TableFood SET status = N'Trống' WHERE id = @idTable
END
GO

---------------------------------------------------------------------------------------
GO
CREATE FUNCTION [dbo].[fuConvertToUnsign1] ( @strInput NVARCHAR(4000) ) RETURNS NVARCHAR(4000) AS BEGIN IF @strInput IS NULL RETURN @strInput IF @strInput = '' RETURN @strInput DECLARE @RT NVARCHAR(4000) DECLARE @SIGN_CHARS NCHAR(136) DECLARE @UNSIGN_CHARS NCHAR (136) SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' +NCHAR(272)+ NCHAR(208) SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' DECLARE @COUNTER int DECLARE @COUNTER1 int SET @COUNTER = 1 WHILE (@COUNTER <=LEN(@strInput)) BEGIN SET @COUNTER1 = 1 WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1) BEGIN IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) ) BEGIN IF @COUNTER=1 SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1) ELSE SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER) BREAK END SET @COUNTER1 = @COUNTER1 +1 END SET @COUNTER = @COUNTER +1 END SET @strInput = replace(@strInput,' ','-') RETURN @strInput END
---------------------------------------------------------------------------------------
GO
CREATE PROC USP_GetListBillByDateAndPage ( @checkIn date, @checkOut date, @page int)
AS
BEGIN

	DECLARE @pageRows INT = 10
	DECLARE @selectRows INT = @pageRows 
	DECLARE @exceptRows INT = (@page - 1) * @pageRows

	;WITH BillShow AS
	(
		SELECT B.id, T.name AS N'Tên bàn', B.totalPrice AS N'Tổng tiền', DateCheckIn AS N'Ngày vào', DateCheckOut N'Ngày ra', discount N'Giảm giá'
		FROM Bill AS B, TableFood AS T
		WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND B.status = 1
		AND T.id = B.idTable
	)

	SELECT TOP (@selectRows) * FROM BillShow WHERE id NOT IN (SELECT TOP (@exceptRows) id FROM BillShow)
END
---------------------------------------------------------------------------------------
GO
CREATE PROC USP_GetNumBillByDate ( @checkIn date, @checkOut date)
AS
BEGIN
	SELECT COUNT(*)
	FROM Bill AS B, TableFood AS T
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND B.status = 1
	AND T.id = B.idTable
END
---------------------------------------------------------------------------------------

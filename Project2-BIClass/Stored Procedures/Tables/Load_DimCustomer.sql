SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Benjamin Zhong
-- Create date: 11/16/2024
-- Description: Load DimCustomers table
--
-- @GroupMemberUserAuthorizationKey is the 
-- UserAuthorizationKey of the Group Member who completed 
-- this stored procedure.
--
-- =============================================

-- ALTER TABLE [CH01-01-Dimension].[DimCustomer]
--     DROP COLUMN IF EXISTS [UserAuthorizationKey]

-- ALTER TABLE [CH01-01-Dimension].[DimCustomer]
--     ADD [UserAuthorizationKey] INT NULL

DROP PROCEDURE IF EXISTS [Project2].[Load_DimCustomer]
GO

CREATE PROCEDURE [Project2].[Load_DimCustomer]
    @UserAuthorizationKey INT
AS
BEGIN 
    SET NOCOUNT ON
    DECLARE @ModifiedRowsCount INT

    INSERT INTO [CH01-01-Dimension].[DimCustomer] (CustomerKey, CustomerName, UserAuthorizationKey)
        SELECT 
            NEXT VALUE FOR /*insert customer sequence key object*/ as customerkey,
            old.CustomerName,
            @UserAuthorizationKey
        FROM (
            SELECT DISTINCT 
            old.CustomerName
            FROM FileUpload.OriginallyLoadedData as old
        )

END
GO

EXEC [Project2].[Load_DimCustomer] @UserAuthorizationKey = 2;

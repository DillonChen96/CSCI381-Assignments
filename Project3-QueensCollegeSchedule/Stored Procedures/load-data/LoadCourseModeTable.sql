-- =============================================
-- Author: Nafisul Islam
-- Create date: 12/3/2024
-- Description: Load CourseMode Table Stored Procedure
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS [Project3].[LoadCourseModeData]
GO

CREATE PROCEDURE [Project3].[LoadCourseModeData]
    @UserAuthorizationKey INT
AS 
BEGIN
    -- Variable to store row count
    DECLARE @RowCount INT;

    -- Truncate the CourseMode table to remove old data
    TRUNCATE TABLE [Project3].[CourseMode];

    -- Insert data into the CourseMode table
    INSERT INTO [Project3].[CourseMode] (CourseID, ModeID, UserAuthorizationKey)
    SELECT DISTINCT
        c.CourseID,
        m.ModeID,
        @UserAuthorizationKey
    FROM Uploadfile.CurrentSemesterCourseOfferings AS o
    INNER JOIN [Project3].[Courses] AS c ON c.CourseName = o.course
    INNER JOIN [Project3].[ModeOfInstruction] AS m ON m.ModeName = o.mode;

    -- Get the row count
    SELECT @RowCount = COUNT(*) FROM [Project3].[CourseMode];

    -- Track workflow for the operation
    EXEC [Process].[usp_TrackWorkFlow]
        @WorkFlowStepDescription = 'Load CourseMode Data',
        @UserAuthorizationKey = @UserAuthorizationKey,
        @WorkFlowStepTableRowCount = @RowCount;
END
GO

-- To execute the procedure:
-- EXEC [Project3].[LoadCourseModeData] @UserAuthorizationKey = 1;
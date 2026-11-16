
CREATE  OR ALTER PROCEDURE [stg].[usp_TruncateTable]
(
    @StagingTableName NVARCHAR(200),
    @TargetTableName NVARCHAR(200)
)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);

    SET @SQL = 'TRUNCATE TABLE ' + @StagingTableName;

    EXEC sp_executesql @SQL;

END;
GO



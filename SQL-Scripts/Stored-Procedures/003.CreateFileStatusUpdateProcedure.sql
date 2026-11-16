CREATE OR ALTER PROCEDURE dw.usp_updateFileStatus
(
    @FolderName VARCHAR(50),
    @Processed char(1)
)
AS
BEGIN

    DECLARE @SQL NVARCHAR(MAX)

    SET @SQL = '
        UPDATE audit.FileControl
        SET IsProcessed =' + @Processed + '
        WHERE TableName = ''' + @FolderName + '''
    '

    PRINT(@SQL)

    EXEC sp_executesql @SQL

END


--EXEC dw.usp_updateFileStatus 'products' ,0



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [audit].[usp_RegisterFileMetadata]
    @TableName NVARCHAR(100),
    @FileName NVARCHAR(300),
    @LastModified DATETIME2,
    @FileSize BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    
    

    MERGE audit.FileControl AS target
    USING (
        SELECT @TableName AS TableName,
               @FileName AS FileName
    ) AS source
    ON target.TableName = source.TableName
       AND target.FileName = source.FileName

    WHEN MATCHED AND (
            target.LastModified <> @LastModified
            OR ISNULL(target.FileSize,0) <> ISNULL(@FileSize,0)
        )
        THEN UPDATE SET
            LastModified = @LastModified,
            FileSize = @FileSize,
            IsProcessed = 0,
            Status = 'UPDATED',
            UpdatedDate = GETDATE()

    WHEN NOT MATCHED THEN
        INSERT (TableName, FileName, LastModified, FileSize, IsProcessed, Status, InsertedDate)
        VALUES (@TableName, @FileName, @LastModified, @FileSize, 0, 'REGISTERED', GETDATE());
END;
GO





--select * from audit.FileControl
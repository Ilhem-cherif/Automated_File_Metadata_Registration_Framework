CREATE OR ALTER PROCEDURE dw.usp_SCD2_Generic
(
    @StagingTable NVARCHAR(200)
    --@TargetTable NVARCHAR(200),
    --@BusinessKey NVARCHAR(100),
    --@BusinessColumns NVARCHAR(MAX),
    --@SCDColumns NVARCHAR(1000)
)
AS
BEGIN

SET NOCOUNT ON;


DECLARE
@Folderpath    NVARCHAR(100),
@TargetTableName NVARCHAR(100),
@BusinessKeyName NVARCHAR(100),
@BusinessColumnNames NVARCHAR(MAX),
@SCDColumnNames NVARCHAR(MAX),
@HashExpr NVARCHAR(MAX),
@SQL NVARCHAR(MAX),
@BusinessColumnsWithAlias NVARCHAR(MAX),
@DateColumns NVARCHAR(MAX),
@DateConversionColumns NVARCHAR(MAX)


EXEC dw.usp_updateFileStatus @Folderpath , 0

/* ======================================================
   Read configuration from ETL_Config
====================================================== */

SELECT
@Folderpath     = Folderpath,
@TargetTableName     = TargetTable,
@BusinessKeyName     = BusinessKeyColumn,
@BusinessColumnNames = BusinessColumns,
@SCDColumnNames      = SCDColumns,
@DateColumns         = DateColumns
FROM audit.ETL_Config
WHERE StagingTable = @StagingTable
--AND IsActive = 1

SELECT 
@BusinessColumnsWithAlias =
STRING_AGG('S.' + LTRIM(RTRIM(value)), ',')
FROM STRING_SPLIT(@BusinessColumnNames, ',')
--print(@BusinessColumnsWithAlias)
SELECT
@DateConversionColumns =
STRING_AGG(
'TRY_CONVERT(date,S.' + LTRIM(RTRIM(value)) + ',105) AS ' + LTRIM(RTRIM(value)),
',')
FROM STRING_SPLIT(@DateColumns,',')

print(@DateConversionColumns)
/* ======================================================
   Build dynamic HASH expression from SCD columns
====================================================== */

SELECT
@HashExpr =
STRING_AGG(
'ISNULL(CAST(S.' + LTRIM(RTRIM(value)) + ' AS NVARCHAR(200)),'''')',
',')
FROM STRING_SPLIT(@SCDColumnNames,',')
--print(@HashExpr)
/* ==========================================
   Dynamic SQL
========================================== */

SET @SQL = N'

IF OBJECT_ID(''#PreparedSource'') IS NOT NULL
DROP TABLE #PreparedSource

/* ======================================
   Build Prepared Source Dataset
====================================== */

SELECT *
INTO #PreparedSource
FROM
(
    SELECT
        S.' + @BusinessKeyName + ',
        ' + @BusinessColumnNames + ',
        ' + @DateConversionColumns + ',
        F.LastModified AS SnapshotDate,

        HASHBYTES(''SHA2_256'', CONCAT(' + @HashExpr + ')) AS HashValue,

        LAG(
            HASHBYTES(''SHA2_256'', CONCAT(' + @HashExpr + '))
        ) OVER
        (
            PARTITION BY S.' + @BusinessKeyName + '
            ORDER BY F.LastModified
        ) AS PrevHash

    FROM ' + @StagingTable + ' S
    JOIN audit.FileControl F
      ON S.FileName = F.FileName AND
      F.TableName = ''' + @Folderpath + '''
) X

WHERE PrevHash IS NULL
   OR PrevHash <> HashValue


/* ==========================================
   STEP 1 � Expire current records
========================================== */

UPDATE T
SET 
EndDate   = DATEADD(day,-1,S.SnapshotDate),
IsCurrent = 0

FROM ' + @TargetTableName + ' T
JOIN #PreparedSource S
  ON T.' + @BusinessKeyName + ' = S.' + @BusinessKeyName + '
 AND T.IsCurrent = 1
WHERE T.HashValue <> S.HashValue
;

/* ==========================================
   STEP 2 � Insert new records
========================================== */
INSERT INTO ' + @TargetTableName + '
(
    ' + @BusinessKeyName + ',
    ' + @BusinessColumnNames + ',
    ' + @DateColumns + ',
    StartDate,
    EndDate,
    IsCurrent,
    HashValue
)

SELECT
    S.' + @BusinessKeyName + ',
    ' + @BusinessColumnsWithAlias + ',
    ' + @DateConversionColumns + ',
    S.SnapshotDate,
    DATEADD(day,-1,
        LEAD(S.SnapshotDate) OVER
        (
            PARTITION BY S.' + @BusinessKeyName + '
            ORDER BY S.SnapshotDate
        )
    ),
    CASE 
        WHEN LEAD(S.SnapshotDate) OVER
        (
            PARTITION BY S.' + @BusinessKeyName + '
            ORDER BY S.SnapshotDate
        ) IS NULL THEN 1
        ELSE 0
    END,
    S.HashValue

FROM #PreparedSource S
'
PRINT(@SQL)
EXEC sp_executesql @SQL

/* ==========================================================================
   STEP 3 � Update file status(IsProcessed) in audit.FileControl table to 1
============================================================================= */


EXEC dw.usp_updateFileStatus @Folderpath , 1

IF OBJECT_ID('#PreparedSource') IS NOT NULL
DROP TABLE #PreparedSource

END



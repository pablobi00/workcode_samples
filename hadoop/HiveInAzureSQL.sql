-- DBS ---- get databases - DB_ID 

SELECT [DB_ID]
      ,[DB_LOCATION_URI]
      ,[NAME]
      ,[OWNER_NAME]
  FROM [dbo].[DBS]

-- TBLS --- get tables DB_ID --> TBL_ID and SD_ID

SELECT [TBL_ID]
      ,[CREATE_TIME]
      ,[DB_ID]
      ,[OWNER]
      ,[SD_ID]
      ,[TBL_NAME]
  FROM [dbo].[TBLS]

-- SDS get SD_ID and CD_ID, format and location

SELECT [SD_ID]
      ,[CD_ID]
      ,[INPUT_FORMAT]
      ,[LOCATION]
      ,[SERDE_ID]
  FROM [dbo].[SDS]

-- COLUMNS_V2 ----- get table schema CD_ID = TBL_ID

SELECT [CD_ID]
      ,[COMMENT]
      ,[COLUMN_NAME]
      ,[TYPE_NAME]
  FROM [dbo].[COLUMNS_V2]
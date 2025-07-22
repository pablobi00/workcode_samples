COPY INTO hive_metastore.cdp501db.table04
FROM
(
	SELECT  CAST(_col0 AS int)    AS id
	       ,CAST(_col1 AS string) AS name
	FROM '/'
) FILEFORMAT = ORC FILES = ('/mnt/g2w2-2/warehouse/tablespace/managed/hive/cdp501db.db/table04/delta_0000001_0000001_0000') COPY_OPTIONS ('force' = 'true'), exception [Databricks][DatabricksJDBCDriver](500051);

-- Shift-cmd-P ---> beautify;  .hql, .q, or .ql extension, or press F1, type 'Change Language Mode', 
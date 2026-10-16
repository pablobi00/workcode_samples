// Databricks notebook source
// MAGIC %md
// MAGIC https://docs.microsoft.com/en-us/azure/databricks/data/data-sources/sql-databases

// COMMAND ----------

Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver")

// COMMAND ----------

val jdbcUsername = dbutils.secrets.get(scope = "jdbc", key = "username")
val jdbcPassword = dbutils.secrets.get(scope = "jdbc", key = "password")

// COMMAND ----------

val jdbcHostname = "pablob-sql-001.database.windows.net"
val jdbcPort = 1433
val jdbcDatabase = "sql001"

// Create the JDBC URL without passing in the user and password parameters.
val jdbcUrl = s"jdbc:sqlserver://${jdbcHostname}:${jdbcPort};database=${jdbcDatabase}"

// Create a Properties() object to hold the parameters.
import java.util.Properties
val connectionProperties = new Properties()

connectionProperties.put("user", s"${jdbcUsername}")
connectionProperties.put("password", s"${jdbcPassword}")

// COMMAND ----------

val driverClass = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
connectionProperties.setProperty("Driver", driverClass)

// COMMAND ----------

val table_tables = spark.read.jdbc(jdbcUrl, "TBLS", connectionProperties)
val table_databases = spark.read.jdbc(jdbcUrl, "DBS", connectionProperties)
val table_sds = spark.read.jdbc(jdbcUrl, "SDS", connectionProperties)
val table_headers = spark.read.jdbc(jdbcUrl, "COLUMNS_V2", connectionProperties)


// COMMAND ----------

//table_tables.printSchema
//table_databases.printSchema
//table_sds.printSchema
table_headers.printSchema

// COMMAND ----------

display (table_databases.select("DB_ID","NAME","DB_LOCATION_URI"))

// COMMAND ----------

display (table_sds.select("SD_ID","CD_ID","SERDE_ID","LOCATION"))

// COMMAND ----------

display (table_tables.select("TBL_ID","DB_ID","SD_ID","TBL_NAME"))

// COMMAND ----------

display (table_headers.select("CD_ID","COLUMN_NAME","TYPE_NAME"))

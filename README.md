# Work Code Samples

A collection of scripts, queries, and configuration files from real-world data replication and migration projects. The work spans on-premises Hadoop clusters, cloud storage (Azure and AWS S3), and analytics platforms such as Databricks and Snowflake.

## Purpose

These samples were written to solve specific problems during customer and internal projects, including:

- **Demos** – showing product features to customers.
- **Labs** – building and testing environments for training and practice.
- **Proof of Concept (POC)** – proving that a solution works technically.
- **Proof of Value (POV)** – showing the business value of a solution in the customer's environment.
- **Production** – supporting live migrations and day-to-day operations.

> [!WARNING]
> **Disclaimer:** Some of these scripts were used in production in their original setting. They are shared here as reference samples, provided as-is, and must be reviewed and tested before use in any environment.

## Repository structure

| Folder | Contents |
|---|---|
| [`scripts/`](scripts/) | Shell, PowerShell, and Python utilities for server setup, cloud storage, and networking |
| [`python/`](python/) | Python tools for cloud storage testing and LiveData Migrator automation |
| [`SQL/`](SQL/) | Hive and SQL queries for test databases and migration validation |
| [`docker/`](docker/) | Generic Docker and Docker Compose samples |
| [`archive/`](archive/) | Retired scripts and projects |

### `scripts/`

General-purpose utilities written in Bash, PowerShell, and Python:

- **Server setup** – prepare Ubuntu servers (`prepubuntu11.sh`) and test Rocky Linux VM performance (`rocky_vm_performance_test.sh`).
- **Cloud storage** – upload files and measure transfer times for Azure Blob Storage and AWS S3; mount Azure storage.
- **Networking and storage** – configure NFS, firewall rules (UFW), and network interfaces; set up local S3-compatible object storage (RustFS) for replication tests.
- **Security** – SSL/TLS configuration.
- **Hadoop** – bulk Hadoop (CDP) setup.

### `python/`

Python tools for three main areas:

- **Cloud storage testing** – timed uploads to Azure and CRC32C checksum validation for data integrity.
- **LiveData Migrator (LDM) automation** – create, list, and monitor migrations through the LDM REST API. LiveData Migrator is a tool for migrating and replicating big data.
- **Data parsing** – JSON and XML parsing samples.

### `SQL/`

Hive (`.hql`, `.hsq`) and SQL scripts used to create test databases, generate sample data, and validate migrated data, including Hive metadata hosted in Azure SQL.

### `docker/`

Generic Dockerfile and Docker Compose samples for building and running containerized test environments.

### `archive/`

Retired scripts and projects, kept for reference and no longer maintained. Contains Python, SQL, and Bash scripts.

| Folder | Contents |
|---|---|
| `Projects-Wave2/` | Migration project scripts: WANdisco Fusion installation and setup, bulk migration creation and management, and **security tooling for SSL/TLS certificate management** (generating certificates in PEM and PFX formats for single and multi-server deployments) |
| `cirata/` | Cirata (formerly WANdisco) LiveData Migrator automation: bulk migrations, verifications, rescans, and diagnostics |
| `databricks/` | Databricks notebooks (Scala) for Azure SQL integration and LiveData Migrator testing |
| `hadoop/` | Hadoop cluster setup scripts and Hive/SQL queries |
| `perforce/` | Puppet code and configuration for Perforce environments |

The top level of `archive/` also holds older setup scripts for CentOS 7, Ubuntu, and Cloudera (CDH 7), plus a log cleanup script.

## Requirements

Requirements depend on the script. In general:

- **Bash** – Linux (Ubuntu, Rocky Linux, CentOS) or macOS.
- **Python 3** – common packages include `requests`, `boto3`, `azure-storage-blob`, and `crc32c`. Install them with `pip install <package>`.
- **PowerShell** – PowerShell 7 or later, with the Azure PowerShell module for Azure scripts.
- **Docker** – Docker Engine with Docker Compose.
- **Cloud access** – valid Azure or AWS credentials for cloud storage scripts.

## How to use

1. Browse the folder that matches your task.
2. Read the comments at the top of the script to understand what it does and how to run it.
3. Update hostnames, paths, and credentials for your environment.
4. Run the script in a test environment first. Use the dry-run option (`--dry-run`) where it is available.

## License

No license is granted. These samples are shared for reference only and are provided as-is, without warranty of any kind. Use them at your own risk.

## Author

Maintained by [pablobi00](https://github.com/pablobi00).

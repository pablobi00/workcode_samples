#!/bin/bash

#################################################
# THIS IS A SAMPLE CODE - NOT FOR PRODUCTION    #
#################################################
# 
# This script creates a date based exclusion rule, adds it to a migration and triggeres a path rescan
#
# Access to API list:
# 
# vim /etc/wandisco/livedata-migrator/application.properties
# comment '# server.address' entry
# systemctl restart livedata-migrator
# Open on browser - http://<server-url>:18080/ldm-api.html
###################################################################################

# ----------------- General parameters ---------------------------------------

LDM_SERVER='http://localhost'
M_NAME="data-c"
M_PATH="/data-c"

M_SOURCE="localFSdata"
M_TARGET="gen2-001"

M_POLICY="com.wandisco.livemigrator2.migration.SkipIfSizeMatchActionPolicy"
M_SCANONLY="true"
M_AUTOSTART="true"

# ----------------- Exclusion parameters ------------------------------------


# Date for Exclusion rule - Two examples on how to get date:

# Option 1: Current time
E_DATE=$(date +"%Y-%m-%dT%R:00%:z")

# Option2: Current date plus a fixed time
# E_DATE=$(date +"%Y-%m-%d")'T10:10:00-07:00'

E_NAME="Exclusion_Test_001"
E_DES="Exclude_files_before_a_date"

# ---------------------------------------------------------------------------

# Create migration

# curl -v -X PUT "$LDM_SERVER:18080/migrations/$M_NAME?path=$M_PATH&source=$M_SOURCE&target=$M_TARGET&actionPolicy=$M_POLICY&autoStart=$M_AUTOSTART&scanOnlyMigration=$M_SCANONLY"


# =============== EXCLUSIONS ==========================================================================


# ----------------- Migration exists and exclusion had been added before ------------------------------

# Remove exclusion from migration
curl -X DELETE "$LDM_SERVER:18080/migrations/$M_NAME/exclusions/$E_NAME"

# Delete exclusion
curl -X DELETE "$LDM_SERVER:18080/exclusions/$E_NAME"

# ----------------- Create and add exclusion to migration ---------------------------------------------

# Create exclusion again
curl -X PUT "$LDM_SERVER:18080/exclusions/date/$E_NAME?description=$E_DES&beforeIsoDateTime=$E_DATE"

# Add exclusion to migration
curl -X PUT "$LDM_SERVER:18080/migrations/$M_NAME/exclusions/$E_NAME"

# Rescan migration
curl -v -X POST "$LDM_SERVER:18080/migrations/$M_NAME/addPendingRegion?path=$M_PATH&actionPolicy=$M_POLICY"

printf "\e[0;36m\n===== [EOF] =======\n\e[0m\n\n"

#!/bin/sh

#
# VERIFY RULES HAVE NOT BEEN APPLIED BEFORE RUNNING!!!!!!!!!
# use - - - > ufw show added
# 

# Edit to add appropriate private network IPs
# On each server COMMENT OUT the local server before executing

ufw allow proto tcp from any to any port 8083,8443 comment 'WANdisco Fusion UI'

# Central - s00188vmedap08181 (10.194.0.4)
# ufw allow proto tcp from 10.194.0.4 to any port 6444,8082,8084,8023,8024,7000,7001,8001,9000,9001 comment 'WANdisco Fusion'

# Central - s00188vmedap08261 (10.194.0.5)
ufw allow proto tcp from 10.194.0.5 to any port 6444,8082,8084,8023,8024,7000,7001,8001,9000,9001 comment 'WANdisco Fusion'

# East US2 - s00188vmedap05501 (10.184.0.4)
ufw allow proto tcp from 10.184.0.4 to any port 6444,8082,8084,8023,8024,7000,7001,8001,9000,9001 comment 'WANdisco Fusion'

# East US2 - s00188vmedap06071 (10.184.0.5)
ufw allow proto tcp from 10.184.0.5 to any port 6444,8082,8084,8023,8024,7000,7001,8001,9000,9001 comment 'WANdisco Fusion'

enable ufw

printf '\n====\n[EOL]\n'
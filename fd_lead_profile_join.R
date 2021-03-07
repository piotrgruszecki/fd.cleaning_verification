# Sun Mar  7 11:26:24 2021 ------------------------------
# leads + profiles join verification

library(fd.cleaning)

#-- 1. read config file
if (!exists("config")) config <- config::get(file = "../fd.cleaning/config.yml", use_parent = TRUE)

#-- 2.
fd.cleaning::join_leads_profiles_aws()


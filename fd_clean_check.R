devtools::install_git(url = "https://github.com/piotrgruszecki/fd.cleaning.git", credentials = git2r::cred_token())

library(fd.cleaning)

if (!exists("config")) config <- config::get(file = "../fd.cleaning/config.yml", use_parent = TRUE)

# make sure there is 00_data/ directory, as it is where temporary Rds files will be stored
fd.cleaning::clean_leads()

fd.cleaning::clean_profiles()

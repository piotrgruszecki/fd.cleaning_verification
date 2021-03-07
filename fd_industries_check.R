# Tue Mar  2 12:23:51 2021 ------------------------------
#-- checking functions for Industries, Categories

#-- 0. install library
devtools::install_git(url = "https://github.com/piotrgruszecki/fd.cleaning.git", credentials = git2r::cred_token())
library(fd.cleaning)

#-- 1. read config file
if (!exists("config")) config <- config::get(file = "../fd.cleaning/config.yml", use_parent = TRUE)

#-- 2. read csv, store in amazon
fd.cleaning::read_csv_store_aws()

#-- 3. read from aws
dt <- fd.cleaning::read_table_from_aws(table_name = config$table_ind_cat_raw)
cols.character <- dt[ , .SD, .SDcols = is.character] %>% colnames()
dt[, (cols.character) := lapply(.SD, `Encoding<-`, "latin1"), .SDcols = cols.character]

dt %>% typeof()
dt %>% is.data.table()
dt %>% tibble::glimpse()

#-- 4. decode primary industry
primary_industry_dt <- decode_primary_industry(dt)
primary_industry_dt %>% tibble::glimpse()

#-- 5. decode industries (a list of)
industries_dt <- decode_industries(dt)
industries_dt %>% tibble::glimpse()
industries_dt[, .N, .(n)][order(n)]

#-- 6. decode categories
categories_dt <- decode_categories(dt)
categories_dt %>% tibble::glimpse()

fd.cleaning::write_table_to_aws(dt = primary_industry_dt,  table_name = config$table_prime_industry, overwrite = T, append = F)
fd.cleaning::write_table_to_aws(dt = industries_dt,        table_name = config$table_industries,     overwrite = T, append = F)
fd.cleaning::write_table_to_aws(dt = categories_dt,        table_name = config$table_categories,     overwrite = T, append = F)


#-- 7. complete sequence, as a function
lookup_dt <- decode_industries_full()
lookup_dt[, .N, .(Label, Product.Title, Client, country_iso2c)][N > 1][order(-N)]
Bebedeparis_n <- lookup_dt[Product.Title == "Bebedeparis" & Client == "BebeDeParis"][, n]
dt[n %in% Bebedeparis_n, ]

lookup_dt[Product.Title == "247staff" & Client == "247staff"]

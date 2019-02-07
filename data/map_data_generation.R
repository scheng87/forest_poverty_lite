##Preparing RDS file for map filtering app
library(dplyr)
library(tidyr)
library(stringr)
setwd("~/Documents/github/forest_poverty_lite/")
load("~/Documents/github/forest_poverty_lite/data/PROFOR_Evidence_Map_7_5_2018.RData")

#Isolate country data and add region column
country_data <- select(data.study,aid,Study_country)
country_data <- distinct(country_data)
reg <- read.csv("data/allcountries.csv",header=TRUE)
#create blank data matrix
rows <- c(1:nrow(country_data))
reg_data <- matrix(nrow=nrow(country_data),ncol=2)
rownames(reg_data) <- rows
colnames(reg_data) <- c("region","subregion")

#Assign regions
for (i in rows){
  country <- country_data$Study_country[i]
  sub <- filter(reg,Country == country)
  if (nrow(sub) != 0){
    reg_data[i,"region"] <- as.character(sub$Region)
    reg_data[i,"subregion"] <- as.character(sub$Subregion)
  } else {
    reg_data[i,"region"] <- as.character("NA")
    reg_data[i,"subregion"] <- as.character("NA")
  }
}

reg_data <- as.data.frame(reg_data)
country_data_final <- bind_cols(country_data,reg_data)

#Read in biomes
biome_data <- distinct(data.biomes)

#Attach final data frames
map_data_final <- left_join(data.biblio,data.interv,by="aid")
map_data_final <- distinct(map_data_final)
map_data_final <- select(map_data_final,-Assess_date,-Assessor_2)
map_data_final <- left_join(map_data_final,biome_data,by="aid")
map_data_final <- distinct(map_data_final)
map_data_final <- left_join(map_data_final,country_data_final,by="aid")
map_data_final <- distinct(map_data_final)
map_data_final <- left_join(map_data_final,data.outcome,by="aid")
map_data_final <- distinct(map_data_final)
map_data_final <- left_join(map_data_final,data.study,by="aid")
map_data_final <- distinct(map_data_final)
map_data_final <- left_join(map_data_final,data.pathways,by="aid")
map_data_final <- distinct(map_data_final)
map_data_final <- select(map_data_final,-Study_country.y)
map_data_final <- distinct(map_data_final)

saveRDS(map_data_final,file="data/map_data_final_7_5_18.rds")

int_type_def = as.data.frame(c("area_protect", "area_mgmt", "res_mgmt", "sp_control", "restoration", "sp_mgmt", "sp_recov", "sp_reint", "ex_situ", "form_ed", "training", "aware_comm", "legis", "pol_reg", "priv_codes", "compl_enfor", "liv_alt", "sub", "market", "non_mon", "inst_civ_dev", "part_dev", "cons_fin", "sus_use", "other"))

group_type_def = as.data.frame(c("area_protect", "res_mgmt", "land_wat_mgmt", "species_mgmt", "education", "law_policy", "liv_eco_inc", "ext_cap_build", "sus_use", "other"))

out_type_def = as.data.frame(c("env", "mat_liv_std", "eco_liv_std", "health", "education", "soc_rel", "sec_saf", "gov", "sub_well", "culture", "free_choice", "other"))

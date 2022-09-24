library(dplyr)
library(readr)
library(sf)
### Importing the dataset
nga <- readxl::read_xlsx("nigeria/data/nga_adminboundaries_tabulardata.xlsx")
head(nga)
nga %>% 
  group_by(admin1Pcode) %>% 
  select(admin1Name_en, admin1Pcode) %>% 
  collect() %>% 
  unique()

unique(nga$admin1Pcode)  

st_layers("nigeria/data/nga_admbnda_osgof_eha_itos.gdb.zip")
nga <- st_read("nigeria/data/nga_admbnda_osgof_eha_itos.gdb.zip", "nga_admbnda_adm1_osgof_20161215")
head(nga)
nga %>% 
  group_by(admin1Pcode) %>% 
  select(admin1Pcode, admin1Name_en, Shape) %>% 
  print(n = 37)

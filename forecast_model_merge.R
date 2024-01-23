forecast_model_merge <- function(folder, model_id, start, end){

  library("tidyverse")

  dir.create("forecast_files")
  setwd("forecast_files")
  
  for (i in as.numeric(start):as.numeric(end)){
    forecast_file <- paste0("aquatics","-",model_id,"-",i,".csv.gz")
    FaaSr::faasr_get_file(local_file=forecast_file, remote_folder=folder, remote_file=forecast_file)
    faasr_delete_file(remote_folder=folder, remote_file=forecast_file)
  }

  file_lists <- list.files()
  result <- map_dfr(file_lists, read_csv)
  
  file_date <- Sys.Date() #forecast$reference_datetime[1]
  forecast_file <- paste0("aquatics","-",file_date,"-",model_id,".csv.gz")
  
  write_csv(result, forecast_file)
  FaaSr::faasr_put_file(local_file=forecast_file, remote_folder=folder, remote_file=forecast_file)
  
}

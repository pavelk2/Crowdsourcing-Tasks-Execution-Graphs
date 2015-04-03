#####################################################################
# HCOMP 15 - Micro task time execution
#####################################################################

# download required libraries
# install.packages('downloader')
# install.packages('iterators')
# install.packages('lubridate')

library(downloader)
library(lubridate)
library(scales)

dumb_start_time <- as.POSIXct("03/19/2015 00:00:00", format='%m/%d/%Y %H:%M:%S')
collectResults <- function(crowdsourcing_platform,job_id, title, batch, download = F){
	# depending on the crowdsourcing platform the parsing of files is different
	if (crowdsourcing_platform == "CrowdFlower"){
		data <-collectResultsCrowdFlower(job_id, title, batch, download = F)
	}
	if (crowdsourcing_platform == "MTURK"){
		data <-collectResultsMTURK(job_id, title, batch, download = F)
	}
	# compliment the dataset with extra data
	data$job_id <- job_id
	data$task <- title
	data$batch <- batch
	data$duration <- data$execution_end-data$execution_start
	data$platform <- crowdsourcing_platform
	data$first_execution_start <- min(data$execution_start)
	# store unit indexes
	data$unit_number <- as.numeric(rownames(data))
	data$execution_relative_end <- dumb_start_time + (data$execution_end - data$first_execution_start)
	# in order to preserve the order
	data$unit_id <- factor(data$unit_id, levels = data$unit_id)

	data
}
collectResultsCrowdFlower <- function(job_id, title, batch, download = F){

	# (comment if is already downloaded)download the latest zip file with full results for the target job
	if (download){
		source("crowdflower_secret.R")
		download(paste("https://api.crowdflower.com/v1/jobs/",job_id,".csv?type=full&key=",CROWDFLOWER_SECRET_KEY, sep = ""), mode = "wb", destfile = paste("output/",job_id,".zip", sep=""))
	}
	# read the csv from the zip file
	data <- read.table(unz(paste("output/",job_id,".zip", sep=""), paste("f",job_id,".csv", sep="")), header=T, sep=",",quote = "\"",comment.char = "")
	# parse string/factor columns into date format
	data$execution_end <- mdy_hms(data$X_created_at)
	data$execution_start <- mdy_hms(data$X_started_at)
	data$unit_id <- as.character(data$X_unit_id)
	data$worker_id <- as.character(data$X_worker_id)
	
	data
}
collectResultsMTURK <- function(job_id, title, batch, download = F){
	# read the csv from the zip file
	data <- read.csv(paste("output/Batch_",job_id,"_batch_results.csv", sep=""), header=T, sep=",",quote = "\"",comment.char = "")
	data$execution_start <- sapply(data$AcceptTime, 
                       function(t){as.POSIXct(as.character(t), "%a %b %d %H:%M:%S PDT %Y", tz="UTC")}
                      )
	data$execution_end <- sapply(data$SubmitTime, 
                       function(t){as.POSIXct(as.character(t), "%a %b %d %H:%M:%S PDT %Y", tz="UTC")}
                      )
	data$worker_id<- as.character(data$WorkerId)
	data$unit_id<- as.character(data$AssignmentId)
	
	data
}
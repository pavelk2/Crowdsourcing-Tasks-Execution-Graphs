#####################################################################
# HCOMP 15 - Micro task time execution
#####################################################################

# download required libraries
# https://learnr.wordpress.com/2010/05/10/ggplot2-waterfall-charts/
library(ggplot2)

plotRectangles <- function(data, filename, width, height){
	
	hist_plot <- ggplot(data)
	hist_plot <- hist_plot + geom_rect(color = "black", aes(fill = worker_id, xmin = execution_relative_end - duration, xmax = execution_relative_end, y = unit_id, ymin = unit_number - 0.45  , ymax = unit_number + 0.45))
	hist_plot <- hist_plot+ geom_text(data=data, aes(x= execution_relative_end - (duration/2), y=unit_id, label=worker_id), size=3,color = "black")
	hist_plot <- hist_plot + scale_x_datetime(breaks = date_breaks("5 min"), minor_breaks = date_breaks("1 min"),labels = date_format("%H:%M"))
	hist_plot <- hist_plot + xlab("Time") + ylab("Task unit id")
	hist_plot <- hist_plot + ggtitle(paste("Execution of the task id=",data[1,"job_id"], " on ", data[1,"platform"], sep=""))
	hist_plot <- hist_plot + scale_fill_discrete(name="Worker ID")
	
	# save the plot into the file
	ggsave(hist_plot, file=filename, width=width, height=height)
}
drawRectangle <- function(row, graph){
	graph<- graph + geom_rect(data=row, mapping=aes(xmin=execution_relative_end - duration, xmax=execution_relative_end, ymin=unit_number-1, ymax=unit_number, fill=worker_id), color="black", alpha=0.5)
	graph
}
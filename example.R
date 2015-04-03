#####################################################################
# HCOMP 15 - Micro task time execution
#####################################################################

source("libs/crowdResultsCollect.R")
source("libs/crowdResultsPlot.R")

# collect results data
mturk <- collectResults("MTURK", 1884619,"Transcribe Receipts", "batch1", F)
crowdflower <- collectResults("CrowdFlower",710063,"Transcribe Receipts", "batch1", F)

# generate plots for the results and save them in files
plotRectangles(mturk,"plots/example_mturk.pdf", 20,15)
plotRectangles(crowdflower,"plots/example_crowdflower.pdf", 20,15)
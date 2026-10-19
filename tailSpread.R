library(shellpipes); manageConflicts()

library(ggplot2); theme_set(theme_bw(base_size=15))
startGraphics(height=5)

library(dplyr)
library(tidyr)

tails <- rdsRead()

spreadSum <- function(dat){
	return(dat
		|> summarize(
			m = mean(tailLength)
			, stdev = sd(tailLength)
			, n = n()
			, .by=sex
		)
		|> mutate(stderr=stdev/sqrt(n))
		|> pivot_longer(c(stdev, stderr), names_to="Measure", values_to="spread")
		|> rename(tailLength = m)
		|> mutate(Measure=factor(Measure, levels=c("stdev", "stderr")))
	)
}

spreadRange <- function(dat){
	s <- spreadSum(dat)
	return(range(c(s$tailLength-s$spread, s$tailLength+s$spread)))
}

spreadPlot <- function(dat, lims=NULL){
	return(
		ggplot(spreadSum(dat))
		+ aes(x=sex, y=tailLength, ymin=tailLength-spread, ymax=tailLength+spread)
		+ geom_errorbar()
		+ facet_wrap(~Measure)
		+ ylab("tail length (cm)")
		+ coord_cartesian(ylim=lims)
	)
}

## spreadPlot was for 708, didn't really annotate how I used it but meant to reinforce understanding of sd vs se. Using now for 3SA as well …
ele <- tails |> filter(species=="Elephant")
small <- ele |> filter(id<= 20)
lims <- range(spreadRange(small), spreadRange(ele))
spreadPlot(small, lims)
spreadPlot(ele, lims)

## Just playing now: how good is this histogram for illustrating lm residual thoughts?

print(ggplot(ele)
	+ aes(x=tailLength)
	+ geom_histogram()
)

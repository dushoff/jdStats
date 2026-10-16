library(shellpipes); manageConflicts()

library(ggplot2); theme_set(theme_bw(base_size=15))
startGraphics(height=5)

library(dplyr)
library(tidyr)

tails <- rdsRead()

spreadPlot <- function(dat){
	s <- (dat
		|> summarize(
			m = mean(tailLength)
			, stdev = sd(tailLength)
			, .by=sex
		)
		|> mutate(stderr=stdev/sqrt(nrow(dat)))
		|> pivot_longer(c(stdev, stderr), names_to="Measure", values_to="spread")
		|> rename(tailLength = m)
		|> mutate(Measure=factor(Measure, levels=c("stdev", "stderr")))
	)
	return(
		ggplot(s)
		+ aes(x=sex, y=tailLength, ymin=tailLength-spread, ymax=tailLength+spread)
		+ geom_errorbar()
		+ facet_wrap(~Measure)
		+ ylab("tail length (cm)")
	)
}

## spreadPlot was for 708, didn't really annotate how I used it but meant to reinforce understanding of sd vs se. Could be good for 3SA as well
ele <- tails |> filter(species=="Elephant")
spreadPlot(ele |> filter(id<= 20))
spreadPlot(ele)

## Just playing now: how good is this histogram for illustrating lm residual thoughts?

print(ggplot(ele)
	+ aes(x=tailLength)
	+ geom_histogram()
)

library(ggplot2)
theme_set(theme_bw())

library(shellpipes)
loadEnvironments()
startGraphics()

set.seed(411)

vitamins <- data.frame(treatment=treat, growth=growth)
summary(lm(growth~treatment, data=vitamins))

samPlot <- function(scramble=FALSE){
	vitamins$group <- vitamins$treatment
	if(scramble){
		vitamins$group <- sample(treat)
	} 
	est <- with(vitamins, 
		mean(growth[group=="A"]) - mean(growth[group=="B"])
	)
	print(ggplot(vitamins, aes(x=group, y=growth, colour=treatment))
		+ geom_point(size=3.8)
		+ theme(text = element_text(size=20))
		+ ylab("Effect")
		+ ggtitle(sprintf("%7.5f", est))
	)
}

samPlot()
samPlot(TRUE)
samPlot(TRUE)
samPlot(TRUE)
samPlot(TRUE)



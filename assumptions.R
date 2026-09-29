library(shellpipes)
library(DHARMa)
library(ggplot2)
library(ggforce)
library(tidyr)

startGraphics(height=4, width=9)

## Lognormal deviates for two groups; m0 and m1 are the actual group means
groupSim <- function(m0=1, m1, sdlog, n){
	meanlog <- log(c(m0, m1)) - sdlog^2/2
	dat <- data.frame(group = factor(rep(0:1, each=n))
		, x = rlnorm(2*n, meanlog=rep(meanlog, each=n), sdlog=sdlog)
	)
	return(dat)
}

## Fit lm(x~group) and simulate DHARMa residuals
groupRes <- function(dat){
	fit <- lm(x~group, data=dat)
	return(simulateResiduals(fittedModel=fit))
}

## Make the standard DHARMa residual plots
groupDharma <- function(dat){
	simRes <- groupRes(dat)
	plot(simRes)
	return(simRes)
}

## Simulate, fit lm(x~group), and return P values:
## the tests reported on the standard DHARMa plots
## (within: smallest Holm-adjusted within-group KS p, which is what DHARMa flags)
## and beta: one-sided lm P for the true difference m1-m0
## (<0.025 if truth is significantly below the estimate, >0.975 if above)
simP <- function(m0=1, m1, sdlog, n){
	dat <- groupSim(m0, m1, sdlog, n)
	simRes <- groupRes(dat)
	fit <- simRes$fittedModel
	est <- coef(summary(fit))["group1", ]
	## Levene and within-group tests as in testCategorical, which draws
	## titles even with plot=FALSE
	res <- simRes$scaledResiduals
	absDev <- abs(res - ave(res, dat$group, FUN=median))
	withinP <- sapply(split(res, dat$group)
		, function(r){return(suppressWarnings(ks.test(r, "punif"))$p.value)}
	)
	return(c(KS = testUniformity(simRes, plot=FALSE)$p.value
		, dispersion = testDispersion(simRes, plot=FALSE)$p.value
		, outlier = testOutliers(simRes, plot=FALSE)$p.value
		, levene = anova(lm(absDev~dat$group))[["Pr(>F)"]][[1]]
		, within = min(p.adjust(withinP))
		, beta = pt((m1-m0-est[["Estimate"]])/est[["Std. Error"]]
			, df=df.residual(fit)
		)
	))
}

## Run simP rep times; one row per replicate
## simP parameters are kept in attr(, "pars")
simRep <- function(rep, ...){
	pmat <- t(sapply(1:rep, function(i){return(simP(...))}))
	tab <- data.frame(rep=1:rep, pmat)
	attr(tab, "pars") <- list(...)
	return(tab)
}

## P-value histograms, one test per page, free scales
pHist <- function(tab, breaks=seq(0, 1, length.out=41)){
	long <- (tab
		|> pivot_longer(-rep, names_to="test", values_to="p")
		|> transform(test=factor(test, levels=setdiff(names(tab), "rep")))
	)
	base <- (ggplot(long, aes(p))
		+ geom_histogram(breaks=breaks, fill="grey60", color="grey20")
		+ theme_bw()
	)
	pages <- n_pages(base + facet_wrap_paginate(~test, nrow=1, ncol=1, scales="free"))
	for (i in 1:pages){
		print(base
			+ facet_wrap_paginate(~test, nrow=1, ncol=1, scales="free", page=i)
		)
	}
}

## Plot of KS and beta histograms side by side, titled with sdlog and n
ksBetaHist <- function(tab, breaks=seq(0, 1, length.out=41)){
	pars <- attr(tab, "pars")
	long <- (tab
		|> pivot_longer(c(KS, beta), names_to="test", values_to="p")
		|> transform(test=factor(test, levels=c("KS", "beta")))
	)
	return(ggplot(long, aes(p))
		+ geom_histogram(breaks=breaks, fill="grey60", color="grey20")
		+ facet_wrap(~test, nrow=1, scales="free_y")
		+ ggtitle(paste0("sdlog = ", pars$sdlog, ", n = ", pars$n))
		+ theme_bw()
	)
}

dat <- groupSim(m1=2, sdlog=0.8, n=1000)
## print(summary(dat))
## print(aggregate(x~group, data=dat, FUN=mean))

## simRes <- groupDharma(dat)
## print(simRes)

set.seed(101)

rep=2000
m1=2
sdlog=0.6
ss = c(20, 100)

for (n in ss){
	print(ksBetaHist(
		simRep(rep=rep, m1=m1, sdlog=sdlog, n=n)
	))
}

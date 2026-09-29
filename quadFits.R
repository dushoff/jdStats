library(shellpipes)
library(DHARMa)
library(ggplot2)
library(ggforce)
library(tidyr)

startGraphics(height=4, width=9)

## Curvilinear response y = x + q*x^2 with normal noise
## x is evenly spaced on [-1, 1], so x and x^2 are uncorrelated and
## the least-squares slope of the linear fit is exactly 1
quadSim <- function(q, sigma, n){
	x <- seq(-1, 1, length.out=n)
	dat <- data.frame(x=x, y=x + q*x^2 + rnorm(n, sd=sigma))
	return(dat)
}

## Fit lm(y~x) and simulate DHARMa residuals
quadRes <- function(dat){
	fit <- lm(y~x, data=dat)
	return(simulateResiduals(fittedModel=fit))
}

## Make the standard DHARMa residual plots
quadDharma <- function(dat){
	simRes <- quadRes(dat)
	plot(simRes)
	return(simRes)
}

## Simulate, fit lm(y~x), and return P values:
## the tests reported on the standard DHARMa plots
## (quantiles: the qgam test in the residual-vs-predicted panel)
## and beta: one-sided lm P for slope = beta
## (<0.025 if beta is significantly below the estimate, >0.975 if above)
quadP <- function(q, sigma, n, beta=1){
	dat <- quadSim(q, sigma, n)
	simRes <- quadRes(dat)
	fit <- simRes$fittedModel
	est <- coef(summary(fit))["x", ]
	return(c(KS = testUniformity(simRes, plot=FALSE)$p.value
		, dispersion = testDispersion(simRes, plot=FALSE)$p.value
		, outlier = testOutliers(simRes, plot=FALSE)$p.value
		, quantiles = testQuantiles(simRes, plot=FALSE)$p.value
		, beta = pt((beta-est[["Estimate"]])/est[["Std. Error"]]
			, df=df.residual(fit)
		)
	))
}

## Run pFun rep times; one row per replicate
## pFun parameters are kept in attr(, "pars")
simRep <- function(rep, pFun, ...){
	pmat <- t(sapply(1:rep, function(i){return(pFun(...))}))
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

set.seed(101)

dat <- quadSim(q=1, sigma=0.5, n=100)
simRes <- quadDharma(dat)

print(quadP(q=1, sigma=0.5, n=100))

pHist(simRep(rep=2000, pFun=quadP, q=1, sigma=0.5, n=100))

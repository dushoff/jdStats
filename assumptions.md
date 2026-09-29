
## Summary

Here is an attempt at the example you asked for.

It's a two-group model with a ratio of two in the mean. Deviates are lognormal, but we model the groups with lm. As the sample size increases, the piano plot gets nicer and Dharma gets more confident that the model is bad.

## Prompts

My R style is:
* tab indentation
* explicit print() and return()
* Continuation characters (|> and , particularly) at the beginning rather than end of lines (protected by parens), e.g.:

Please use the make pipeline: to show me something from assumptions.R, use `make assumptions.Rout` or `make assumptions.Rout.pdf`

dat <- (dat
	|> mutate(x=3*d
		, y=x^2
	)
	|> filter ...
)

Although in this instance I would put the mutate call on a single line, since everything is short.

In assumptions.R:

I want groupSim(m0=1, m1, sdlog, n) to create a data frame with group as a factor (0 or 1) and n lognormal deviates for each group, with m0 and m1 giving the actual group means (not meanlog or exp(meanlog)) and sdlog being the sdlog for each group). You can also write a test call. 

I want a function that will make the standard Dharma fits and plots for the data generated above under the model lm(x~group)

Is it easy to make a function that returns instead just the four P values corresponding to the four things that Dharma reports as sig or nonsig?

Let's try to make a single function that:
* does the simulation
* does the fit
* returns the five P values you already have, plus a one-sided P value for the hypothesis beta_group=m1-m0, based on the (not perfectly valid) lm above. I am looking for a P value that will be <0.025 if the “truth” is significantly lower than the estimate, and >0.975 if higher

Can we have a wrapper that runs simP “rep” times and produces a nice table? And then a function that takes that table and produces p-value histograms using facet_wrap_page? You can set height=4 in startGraphics(). 

I want one histogram per page, with "free" scales. Also, I meant that I want explicit returns when I'm returning something, meaning no implicit returns. We don't need the return from pHist.

Can we have fixed bins spanning 0:1, length.out=41? Don't worry about other changes I made, assume they're fine for now.

Please drop the Dharma plot (comment it out).

I would like a new function now that plots only KS and beta, using facet_wrap or facet_grid, whichever makes sense. Choose a sensible dimension so that each histogram is a bit wider than high and it looks nice on my laptop screen. Each page should have sdlog and n in the title.

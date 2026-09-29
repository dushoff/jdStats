
assumptions.R shows the model fit getting better (with larger sample size) while the standard diagnostic tests are getting more confident that it is bad.

Let's rename it as lnormFits.R (with git mv for it, and the .md file). You can clean up all the trash (and move the output file as well). And fix the Makefile. But don't commit anything yet.

quadFits will seek to do the same thing for a curvilinear response. x will go uniformly from -1 to 1. y will be modeled as x + qx^2. I'm pretty sure that corresponds to a true beta of 1?

Let's put ksBetaHist on hold. I guess we should be able to use exactly the same pHist function, and maybe something very similar to simP (maybe make it so that you can pass it an estimate for the beta calculation?).

Just code it up for now, don't run anything yet.


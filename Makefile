## This is jdStats

current: target
-include target.mk
Ignore = target.mk

vim_session:
	bash -ic "vmt README.md TODO.md"

## -include makestuff/perl.def

######################################################################

Sources += $(wildcard *.md)

######################################################################

autopipeR = defined
Sources += $(wildcard *.R)

######################################################################

## dharma stats evaluation

## lnormFits.Rout: lnormFits.R lnormFits.md ##
## quadFits.Rout: quadFits.R quadFits.md

######################################################################

## Old StatsPhil / clarity examples

flu.Rout: ciplots.rda 
masks.Rout: ciplots.rda 

## vitamins.Rout: vitamins.R ciplots.R
vitamins.Rout: ciplots.rda

vitamins_data.Rout: vitamins_data.R

vitamins_plot.Rout: vitamins_plot.R vitamins_data.rda

## vitamins_scramble.Rout: vitamins_scramble.R permcount.R
vitamins_scramble.Rout: permcount.rda vitamins_data.rda

test: vitamins_plot.Rout vitamins_scramble.Rout

######################################################################

## Cribbing (temp!)

.PRECIOUS: %.R
%.R:
	$(CP) ../statsTalks/$@ .
 
######################################################################

## Mammal tail example inspired by Ian Dworkin
tails.Rout: tails.R tails.md
tailPlot.Rout: tailPlot.R tails.rds
tailSpread.Rout: tailSpread.R tails.rds
tailModels.Rout: tailModels.R tails.rds

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

## ln -s ../makestuff . ## Do this first if you want a linked makestuff
Ignore += $(wildcard *.stamp)
Makefile: 00.stamp
%.stamp: | makestuff
	- $(RM) *.stamp
	cd makestuff && $(MAKE) pull
	touch $@
makestuff:
	git clone --depth 1 $(msrepo)/makestuff

-include makestuff/os.mk

-include makestuff/pipeR.mk
-include makestuff/pdfpages.mk

-include makestuff/git.mk
-include makestuff/visual.mk


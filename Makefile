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

## claude --resume c876bfaf-d364-46f6-8ad5-646044980410

## lnormFits.Rout: lnormFits.R lnormFits.md ##

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
	$(CP) ../sandbox/$@ .
.PRECIOUS: %.tsv
%.tsv:
	$(CP) ../sandbox/$@ .
 
######################################################################

## Make a clarStrength-like picture from a table (allow different language)
## Lakens language is still in notebook (not sure what's going on here with venue) 2025 Jun 18 (Wed)
Sources += $(wildcard *.clarpix.tsv)
## clarity.clarpix.Rout: clarpix.R clarity.clarpix.tsv
## newsig.clarpix.Rout: clarpix.R newsig.clarpix.tsv
## oldsig.clarpix.Rout: clarpix.R oldsig.clarpix.tsv
## different.clarpix.Rout: clarpix.R different.clarpix.tsv
%.clarpix.Rout: clarpix.R %.clarpix.tsv
	$(pipeR)

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


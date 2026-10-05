
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

## quadFits.Rout: quadFits.R quadFits.md

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

-include makestuff/git.mk
-include makestuff/visual.mk


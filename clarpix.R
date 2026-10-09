library(ggplot2); theme_set(theme_bw(base_size=14))
theme_update(panel.grid.major = element_blank()
	, panel.grid.minor = element_blank()
)

library(dplyr)

library(shellpipes)
startGraphics(height=5)
span = 2

vr <- tsvRead(na=".")

## (vr %>% mutate_if(is.character, as.factor) %>% summary)
## quit()

vf <- (vr
	%>% mutate(NULL
		, pic = factor(pic, levels=rev(pic))
		, atext = gsub('\\|', '\n', atext)
		, val = if_else(is.na(val), (upr+lwr)/2, val)
	)
)

## (vf %>% mutate_if(is.character, as.factor) %>% summary)
## quit()

print(ggplot(vf)
	+ aes(pic, val)
	+ geom_point()
	+ geom_errorbar(aes(ymin=lwr, ymax=upr), width=0.1)
	+ coord_flip()
	+ geom_hline(yintercept=0)
	+ geom_hline(yintercept=c(-1, 1), lty=2)
	+ scale_y_continuous(limits=c(-span, span)
		, breaks = -1:1
		, labels = c("cutoff", 0 , "cutoff")
	)
	+ scale_x_discrete(labels=rev(vf$atext)
	)
	+ xlab("")
	+ ylab("")
	## + theme(panel.grid.major = element_blank()
	## 	, panel.grid.minor = element_blank()
	## )
)


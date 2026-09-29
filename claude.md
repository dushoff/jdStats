
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


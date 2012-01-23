TARGET=mlabc07ex2
all: ${TARGET}.pdf
%.pdf: %.tex title/* files/*
		xelatex -shell-escape $<
spell:
		aspell -l el_gr --ignore-case=true -c ${TARGET}.tex

CC=xelatex
TARGET=mlabc07ex7
all: ${TARGET}.pdf
%.pdf: 	%.tex title/* files/* parts/*
		$(CC) -shell-escape $<
spell:
		aspell -l el_gr --ignore-case=true -c ${TARGET}.tex
clean:
		rm -f ${TARGET}.{pdf,log,aux,pyg}

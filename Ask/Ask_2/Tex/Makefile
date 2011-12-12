TARGET=mlabc07ex2
all: ${TARGET}.pdf
${TARGET}.pdf: ${TARGET}.tex title/* 
		xelatex -shell-escape ${TARGET}.tex
spell:
		aspell -l el_gr --ignore-case=true -c ${TARGET}.tex

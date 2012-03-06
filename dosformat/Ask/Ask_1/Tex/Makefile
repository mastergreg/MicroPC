all: mlabc07ex1.pdf
mlabc07ex1.pdf: mlabc07ex1.tex title/* 
		xelatex -shell-escape mlabc07ex1.tex
spell:
		aspell -l el_gr --ignore-case=true -c mlabc07ex1.tex

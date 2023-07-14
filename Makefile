all: letter

letter:
	xelatex *.tex
	xelatex *.tex

clean:
	rm -rf **/*.fls **/*.spl **/*.aux **/*.bbl **/*.blg **/*.log \
	       	**/*.out **/*.toc **/*.synctex.gz **/*.fdb_latexmk **/*.zip **/*.bib~ \
		**/*.*~ **/*.bak **/*.cut *.fls *.spl *.aux *.bbl *.blg \
		*.log *.out *.toc *.synctex.gz *.fdb_latexmk *.zip *.bib~ *.*~ *.bak *.cut


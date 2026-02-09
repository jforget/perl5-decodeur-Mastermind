-*- encoding: utf-8 -*-

visu: sector-centre.png
	display sector-centre.png

visu2: sector-side.png
	display sector-side.png

visu3: cloud.png
	display cloud.png

visu4: cloud-g.png
	display cloud-g.png

visu5: ring-centre.png
	display ring-centre.png

visu6: ring-side.png
	display ring-side.png


sector-centre.png: pic.pdf
	pdftoppm -png -f 1 -l 1 -x 220 -y 220 -W 500 -H 500 pic.pdf sector-centre
	mv sector-centre-1.png sector-centre.png

sector-side.png: pic.pdf
	pdftoppm -png -f 1 -l 1 -x 700 -y 220 -W 500 -H 500 pic.pdf sector-side
	mv sector-side-1.png sector-side.png

cloud.png: pic.pdf
	pdftoppm -png -f 1 -l 1 -x 350 -y 740 -W 250 -H 250 pic.pdf cloud
	mv cloud-1.png cloud.png

cloud-g.png: pic.pdf
	pdftoppm -png -f 1 -l 1 -x 780 -y 740 -W 250 -H 250 pic.pdf cloud-g
	mv cloud-g-1.png cloud-g.png

ring-centre.png: pic.pdf
	pdftoppm -png -f 1 -l 1 -x 220 -y 960 -W 500 -H 500 pic.pdf ring-centre
	mv ring-centre-1.png ring-centre.png

ring-side.png: pic.pdf
	pdftoppm -png -f 1 -l 1 -x 700 -y 960 -W 500 -H 500 pic.pdf ring-side
	mv ring-side-1.png ring-side.png

pic.pdf: pic.tex
	lualatex pic.tex

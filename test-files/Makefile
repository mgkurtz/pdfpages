FILES=fulltest fullpost mixed dvi-mode pst-pdf-example pst-pdf-example-pics slides addtotoc-1 addtotoc-2 addtotoc-3 addtolist-1 addtolist-2 addto-tocloft addto-jura addtotoc-jura  minimal crop-test
SUFFIX=log,aux,toc,lof,lot,out,lol,pdc,pfg,pdf,ps,dvi

.PHONY: clean makeclean

clean:
	$(foreach file, ${FILES}, rm -f ${file}.{${SUFFIX}};)

distclean: clean

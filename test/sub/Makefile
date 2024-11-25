all: link-test-files

.PHONY: link-test-files
link-test-files:
	ln -sf ../pdf/dummy.pdf subfiles-pic.pdf

.PHONY: unlink-test-files
unlink-test-files:
	rm -f subfiles-pic.pdf

.PHONY: clean
clean:

.PHONY: distclean
distclean: clean unlink-test-files

test:

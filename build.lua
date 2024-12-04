module = "pdfpages"

dynamicfiles = {"*.aux", "*.toc", "*.out"}

checkinit_hook = function(_)
	return runcmd("make all", "test") or 1
end

uploadconfig = {
	pkg = "pdfpages",
	version = "0.7",
	announcement = "",
	author = "Andreas Matthias",
	uploader = "Andreas Matthias",
	license = "lppl1.3c",
	summary = "Include PDF documents in LaTeX",
	ctanPath = "/macros/latex/contrib/pdfpages",
	repository = "https://github.com/AndreasMatthias/pdfpages",
	bugtracker = "github.com/AndreasMatthias/pdfpages/issues",
	description = "This package simplifies the inclusion of external multi-page PDF documents in LaTeX documents. Pages may be freely selected and similar to psnup it is possible to put several logical pages onto each sheet of paper. Furthermore a lot of hypertext features like hyperlinks and article threads are provided. The package supports pdfTeX (pdfLaTeX) and VTeX. With VTeX it is even possible to use this package to insert PostScript files, in addition to PDF files.",
	topic = {"pdf-feat", "graphics-incl"},
}

require("l3build-variables.lua") -- Load default settings

-- Regression tests exploiting the fact that pdftex and luatex print information about included graphics
-- Set \hbadness and \hfuzz to infinity to suppress underfull respectively overfull hboxes.

--preamble = [[\input{regression-test.tex}\AtBeginDocument{\hbadness=10000\hfuzz=\maxdimen\START}]]
preamble = [[\input{regression-test.tex}\AtBeginDocument{\hbadness=10000\hfuzz=\maxdimen\showoutput\START}]] -- very verbose

for _, value in ipairs(checkengines) do
	specialformats.latex[value] = specialformats.latex[value] or {}
	specialformats.latex[value].tokens = preamble
end

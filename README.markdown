pdftk
=====

Pdftk is a Ruby wrapper around the unix CLI tool [pdftk][]

[pdftk][] makes a number of different options easy to perform, *except* it's a pain to use it to:

 - query a PDF's fillable form fields
 - export a new PDF with filled out form fields

This gem is mainly geared towards querying and filling out PDF form fields but, because it wraps 
[pdftk][], we may wrap all of the available [pdftk][] commands.

[pdftk]: http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/

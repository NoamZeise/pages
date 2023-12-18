(TeX-add-style-hook
 "mat"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("standalone" "preview")))
   (TeX-run-style-hooks
    "latex2e"
    "standalone"
    "standalone10"
    "amsmath"))
 :latex)


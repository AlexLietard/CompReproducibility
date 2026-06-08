# Tutorial

After having creating your quarto environment, you need to create a virtual environment and install the dependencies to deal with the packages:

```R
# Install renv package and initialize the environment
install.packages("renv")
renv::init()

# Install the required packages
install.packages(c("ggplot2", "rmarkdown", "knitr"))

# When you want to share it, you can use the following command to snapshot the environment and create a lockfile
renv::snapshot()

# To restore the environment on another machine, you can use the following command to install the packages from the lockfile
renv::restore()
```

The goal of this repository is to make you try analyzing the data presents in data.csv and create a reproducible report with the results. An example of what you can do is in example.qmd, but you can do whatever you want with the data and the report, as long as you use the features of quarto and that you can share it with others.

## Features 

- \_ [text] \_ to put in italics
- \[@key\] for referencing a paper with brackets, or @key without brackets
- \`r [code]\` to insert inline code. Add ";" between the key.
- `r source("filename.R")` to execute a script.
- \<\!-- text --> to insert a comment. In Positron, the shortcut for a comment is Ctrl + :
- results="hide" in the code chunk to avoid having the textual output of the code chunk.
- @ref(fig-labelName) for figures and @ref(eq-eqName) for equations to reference them in the text.

## When finish

When you finish writing your document, you can use the following command to render it:

```cmd
quarto render .
```

The dot means the current directory, it allows thus to render your project (you can also put just your filename).

## References

- More information about Quarto [Quarto Documentation](https://quarto.org/)
- More information about computational reproducibility with Daniel Lakens https://lakens.github.io/statistical_inferences/14-computationalreproducibility.html
- For the citekey:
    - To have the key https://www.bibtex.org/
    - Change the citekey format 
        - Where to change it in Zotero https://forums.zotero.org/discussion/118879/change-default-citation-key-when-importing-files
        - The possible ways to change it https://retorque.re/zotero-better-bibtex/citing/. My way is "authEtal2(sep=_)+ "_" + year"
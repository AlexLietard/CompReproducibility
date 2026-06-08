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

## Features 

- \_ [text] \_ to put in italics
- \[@key\] for referencing a paper with brackets, or @key without brackets
- \`r [code]\` to insert inline code. Add ";" between the key.
- \`r source("filename.R")` to execute a script.
- \<\!-- text --> to insert a comment. In Positron, the shortcut for a comment is Ctrl + :
- results="hide" in the code chunk to avoid having the textual output of the code chunk.
- @ref(fig-labelName) for figures and @ref(eq-eqName) for equations to reference them in the text.

## When finish

When you finish writing your document, you can use the following command to render it:

```cmd
quarto render .
```

The dot means the current directory, it allows thus to render your project.
This package just provides a small [RStudio Addin](https://rstudio.github.io/rstudioaddins/) that allows to find and replace in multiple files.

Install the package directly from Github by running
```r
if (!require(devtools)) install.packages("devtools")
devtools::install_github("skranz/ReplaceInFiles")
```
You can then use the Addin in RStudio under the `Addins` menu. By default it searches in all files in your Project directory or in your working directory if no project is open. Instead of just changing the files in the background it opens all files that contain the search pattern in RStudio and replaces the values in RStudio without saving. This allows you the possibility to easily undo changes.

Probably a "Find and replace in files"" feature will be implemented at some point directly in RStudio. It is discussed in [this issue](https://github.com/rstudio/rstudio/issues/2066).  Until this point this RStudio Addin allows a workaround.


replaceInFilesAddin <- function() {
  library(ReplaceInFiles)
  dir = getActiveProject()
  if (is.null(dir))
    dir = getwd()
  width = "500px"
  ui <- miniPage(
    miniContentPanel(
      textInput("pattern", "Find:", width=width),
      checkboxInput("regexp","Regular expression",value = FALSE),
      textInput("replacement", "Replace by:", width=width),
      textInput("dir","Search in", value=dir, width=width),
      textInput("fileGlob","File patterns", value="*.R *.Rmd", width=width),
      actionButton("replaceBtn","Replace All"),
      actionButton("cancelBtn","Cancel")

    )

  )

  server <- function(input, output, session) {
    observeEvent(input$replaceBtn, {
      pattern = input$pattern
      replacement = input$replacement
      dir = input$dir
      fixed = !isTRUE(input$regexp)
      files.glob = strsplit(input$fileGlob," ", fixed=TRUE)[[1]]

      cat("Find", pattern)
      if (pattern=="") {
        cat("No search pattern entered.")
        return(invisible())
      }
      files = replace.in.documents(pattern=pattern,replacement = replacement,files.glob = files.glob,path = dir,fixed=fixed,recursive=TRUE, save=FALSE)
      if (length(files)>0) {
        cat("\nChanged files have been opened in RStudio, but not yet saved.")
        invisible(stopApp())
      }
    })
    observeEvent(input$cancelBtn, {
      invisible(stopApp())
    })
  }
  viewer <- dialogViewer("Replace in Files", width = 550, height = 600)
  runGadget(ui, server, viewer = viewer)
}

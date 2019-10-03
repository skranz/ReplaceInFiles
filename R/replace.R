examples.replace.in.documents = function() {
  files.glob = c("*.R","*.txt")
  replace.in.documents("Hallo","papa", file.types = c("txt"))
}

#'
replace.in.documents = function(pattern, replacement,path=getwd(),files.glob= if (!is.null(file.types)) paste0("*.",file.types), file.types = c("r"), fixed=TRUE,  encoding="unknown", recursive=TRUE, save=FALSE, timeout.sec=3) {
  #restore.point("replace.in.documents")

  if (!is.null(files.glob)) {
    rx = glob2rx(files.glob)
    files = NULL
    for (crx in rx) {
      files = c(files, list.files(path = path,crx, recursive = recursive , ignore.case=TRUE, full.names = TRUE))
    }
    files = unique(files)
  } else {
    files = list.files(path = path,recursive = recursive, ignore.case=TRUE)
  }

  n.checked = length(files)
  num.pattern = sapply(files, function(file) {
     txt = readLines(file,encoding=encoding,warn = FALSE)
     sum(grepl(pattern, txt,fixed=fixed))
  })
  files = files[num.pattern>0]
  num.pattern = num.pattern[num.pattern>0]
  if (length(files)==0) {
    cat("\nChecked",n.checked,"files but the pattern", pattern,"was not found.")
    return(invisible(files))
  }
  for (i in seq_along(files)) {
    file = files[i]
    ok = replace.in.document(pattern, replacement, file, fixed=fixed, save=save, timeout.sec=timeout.sec)
    if (ok) {
      cat("\nreplaced", num.pattern[i], "lines in", file)
    }
  }
  return(invisible(files))
}

replace.in.document = function(pattern, replacement,file,fixed=TRUE, save=TRUE, timeout.sec=3) {
  navigateToFile(file)
  doc = getActiveDocumentContext()
  start.time = Sys.time()
  while(as.double(Sys.time()-start.time) < timeout.sec) {
    if (!identical(tolower(basename(doc$path)), tolower(basename(file)))) {
      Sys.sleep(0.1)
      doc = getActiveDocumentContext()
    } else {
      break
    }
  }
  if (!identical(tolower(basename(doc$path)), tolower(basename(file)))) {
    Sys.sleep(1)
    doc = getActiveDocumentContext()
  }
  if (!identical(tolower(basename(doc$path)), tolower(basename(file)))) {
    cat("\nNavigating to file", basename(file)," did not work correctly. Skip replacement.")
    return(FALSE)
  }

  txt = doc$contents
  txt = gsub(pattern, replacement,txt, fixed=fixed)
  setDocumentContents(paste0(txt,collapse="\n"), id = doc$id)
  if (save) {
    documentSave(id=doc$id)
  }
  return(TRUE)
}

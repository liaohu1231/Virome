new.cbind <- function(...)
{
  input <- eval(substitute(list(...), env = parent.frame()))
  names.orig <- NULL
  nrows <- numeric()
  for (i in 1:length(input))
  {
    nrows[i] <- nrow(input[[i]])
    names.orig <- c(names.orig, colnames(input[[i]])) 
  }
  idx <- (1:length(input))[order(nrows, decreasing=T)]
  x <- NULL
  for (i in 1:length(input))
  {
    x <- c(x, rownames(input[[idx[i]]]))
  }
  r <- data.frame(row.names=unique(x))
  for (i in 1:length(input))
  {
    r <- cbind(r, data.frame(input[[i]][match(rownames(r), rownames(input[[i]])),]))
  }
  colnames(r) <- names.orig
  return(r)
}
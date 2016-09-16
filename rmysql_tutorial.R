\documentclass{article}

\begin{document}
\SweaveOpts{concordance=TRUE}

<<>>=
mydb = dbConnect(MySQL(), user = 'dangle', password = 'dongle', dbname = 'shop', host = '127.0.0.1')
@



\end{document}
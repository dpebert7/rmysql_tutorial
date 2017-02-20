RMySQL Tutorial
================

Here are the steps I used to combine R and MySQL together happily.

1.  Get MySQL and the R package RMySQL.

2.  Create a database in MySQL. Notice that while the syntax for is the same as Oracle, the data types are different. In particular, MySQL uses , , etc. for integers.

GitHub Documents
----------------

This is an R Markdown format used for publishing markdown documents to GitHub. When you click the **Knit** button all R code chunks are run and a markdown file (.md) suitable for publishing to GitHub is generated.

Including Code
--------------

You can include R code in the document as follows:

``` r
summary(cars)
```

    ##      speed           dist       
    ##  Min.   : 4.0   Min.   :  2.00  
    ##  1st Qu.:12.0   1st Qu.: 26.00  
    ##  Median :15.0   Median : 36.00  
    ##  Mean   :15.4   Mean   : 42.98  
    ##  3rd Qu.:19.0   3rd Qu.: 56.00  
    ##  Max.   :25.0   Max.   :120.00

Including Plots
---------------

You can also embed plots, for example:

![](rmysql_tutorial_files/figure-markdown_github/pressure-1.png)

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.

\begin{verbatim}
$ mysql -u root -p -h localhost

mysql> CREATE DATABASE shop;

mysql> CREATE TABLE inventory
        (id SMALLINT PRIMARY KEY, 
        name VARCHAR(50),
        quantity SMALLINT);

mysql> INSERT INTO inventory VALUES(1, 'Tomato', '10');
mysql> INSERT INTO inventory VALUES(2, 'Potato', '20');
mysql> INSERT INTO inventory VALUES(3, 'Rhubarb', '0');
mysql> INSERT INTO inventory VALUES(4, 'Eggplant', '2');
mysql> INSERT INTO inventory VALUES(5, 'Brussels Spouts', '15');
mysql> INSERT INTO inventory VALUES(6, 'Onion', '10');

mysql> SELECT * from inventory;

mysql> DESCRIBE inventory; -- This is a lot like the schema tab in Oracle SQL live
\end{verbatim}
\item 
Next, we need to create a user with permission to access the database. To do that, I created a new user in MySQL.

\begin{verbatim}
$ mysql -u root -p -h localhost

mysql> CREATE USER 'dangle'@'localhost' IDENTIFIED BY 'dongle'; 
mysql>   -- username is dangle. password is dongle.
mysql> GRANT ALL PRIVILEGES ON shop.* TO 'dangle'@'localhost';
mysql> quit;
\end{verbatim}
We can now access the database directly through R. But if you want to log in to MySQL as dangle, you would use the following command before entering the password:

\begin{verbatim}
$ mysql -u dangle -p -h localhost
\end{verbatim}
\item 
We're now ready to use R. First, we need to create a database connection, which we'll name :

\begin{Schunk}
\begin{Sinput}
> library(RMySQL)
> dbcon = dbConnect(MySQL(), user = 'dangle', 
+                  password = 'dongle', 
+                  dbname = 'shop', 
+                  host = '127.0.0.1')
\end{Sinput}
\end{Schunk}
\item 
Now we're ready. First, let's look at the tables in the database, and then the columns in the inventory.

\begin{Schunk}
\begin{Sinput}
> dbListTables(dbcon)
\end{Sinput}
\begin{Soutput}
[1] "employee"  "inventory"
\end{Soutput}
\begin{Sinput}
> dbListFields(dbcon, 'inventory')
\end{Sinput}
\begin{Soutput}
[1] "id"       "name"     "quantity"
\end{Soutput}
\end{Schunk}
\vspace{25 pt}
Next, let's bring the table data into R.

\begin{Schunk}
\begin{Sinput}
> inventory_table = dbReadTable(dbcon, "inventory")
> inventory_table
\end{Sinput}
\begin{Soutput}
  id            name quantity
1  1          Tomato       10
2  2          Potato       20
3  3         Rhubarb        0
4  4        Eggplant        2
5  5 Brussels Spouts       15
6  6           Onion       10
\end{Soutput}
\end{Schunk}
\vspace{25 pt}
We can go the other way, too. Let's create a new table in R, called and send that table to the database.

\begin{Schunk}
\begin{Sinput}
> fname = c("Alice", "Bob", "Charlie", "Dave")
> lname = c("Alvarez", "Brown", "Chaplin", "Dangle")
> employee = data.frame(lname, fname)
> employee
\end{Sinput}
\begin{Soutput}
    lname   fname
1 Alvarez   Alice
2   Brown     Bob
3 Chaplin Charlie
4  Dangle    Dave
\end{Soutput}
\begin{Sinput}
> dbWriteTable(dbcon, "employee", 
+              employee, 
+              overwrite = TRUE, 
+              append = FALSE)
\end{Sinput}
\begin{Soutput}
[1] TRUE
\end{Soutput}
\end{Schunk}
\vspace{25 pt}
Finally, let's send queries to the database from within R. First we send a query to SQL. Then the command imports the table into R.

\begin{Schunk}
\begin{Sinput}
> sql_query = dbSendQuery(dbcon, 
+                         'SELECT name, quantity 
+                         FROM inventory 
+                         WHERE quantity > 8')
> sql_query
\end{Sinput}
\begin{Soutput}
<MySQLResult:8,0,8>
\end{Soutput}
\begin{Sinput}
> inventory_table = fetch(sql_query, n=-1)
> inventory_table
\end{Sinput}
\begin{Soutput}
             name quantity
1          Tomato       10
2          Potato       20
3 Brussels Spouts       15
4           Onion       10
\end{Soutput}
\begin{Sinput}
> on.exit(dbDisconnect(dbcon))
\end{Sinput}
\end{Schunk}
\\end{enumerate}

\\end{document}

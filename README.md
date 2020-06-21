# iNat_lists

**FOR BEGINNING CODERS:**

First you will need to download a R code editor, I highly recommend RStudio Desktop (download at https://rstudio.com/products/rstudio/download/). 

Another option is to use a notebook like Kaggle.com, which is kind of nice as it does not require a download. However, these are a little more limited than an IDE like RStudio, and I am unsure if all the packages required in the code found here are avaliable in some notebooks.

I will only cover the basics for how to get started with RStudio below but if you would like to use a notebook there are many great resourses online.

Note: if you are experiencing any issues or if this seems too complicated and time consuming feel free to email me at whimbrelbirders (at) yahoo (dot) com with your iNaturalist username and what visualizations you would like and I will give you a link to them on RPubs.

------------

**GETTING STARTED WITH RSTUDIO:**

After you suscessfully complete the download, you will see a window for writing the script in the top left, type and execute (ctrl+enter) the following commands:

*library(devtools)*

*install.packages("reactable")*

*install_github("hrbrmstr/streamgraph", type = "binary")*

Next, click the green plus (with a document in the backgrond) button right under file in the top left corner. 
Now select, *"R Script"*, it sould now bring up a new script. You are now ready to copy and paste any of the code in this repository.

------------

**EXAMPLES ON RPUBS**

Treemap - https://rpubs.com/whimbrelbirder/treemap

**FUTURE GOALS**

1 - Use API to create easy access to data

2 - Target lists based on location

3 - Make a Shiny App dashboard to streamline the process and make it so anyone can use these features, not just those who know how to code.

4 - And many many more cool graphs for your data!

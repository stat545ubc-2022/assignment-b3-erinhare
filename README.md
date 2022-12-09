
This is the link to my updated BC Liquor Store Data app: https://stat545b-erinhare-assignmentb3.shinyapps.io/updatedBCliquor/

The BC Liquor Store Data used in this app can be found here: https://github.com/daattali/shiny-server/tree/master/bcl

Previously the app allowed the user can select one or more countries using the select box in the side bar to filter the data by which would modify the histogram and table. The DT package was used to make the table interactive. The user could search using the top right search bar and see a select number of products per page. The text above the histogram was added to show the number of results based on the selections the user made in the side bar.

Now more features have been added including the ability to change the colour of the histogram bars using the select box, the ability to select more than one beverage type at a time using the check boxes, and download the results in the table as a csv file. An image displaying the interior of a BC Liquor Store has also been added.

This repository contains an **app.R** file which contains the code that was used to create this app and the **Stat 545 Shiny App Demo.Rproj** file which can both be opened using R. R version 4.2.1 (2022-06-23) and RStudio 2022.07.1 were used.

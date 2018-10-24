

# Getting started

These files are used to transform data from the national HMIS to the Stop Palu database.
To run the Paludisme dataset importer you will need login credentials for both the Système National d'Information Sanitaire and the Stop Palu database. There are three steps to this process:

1. Export the Paludisme dataset.
2. Transform the data set to an import file that is compatible with the Stop Palu database, by a) replacing the facility organisation units with their equivalents in the Stop Palu database and b) replacing the data elements and their disaggregations ( aka category option combonations) with their equivilants in the Stop Palu database. 
3. Import the resulting file from step 2 into the Stop Palu database.


The mapping files for step two are right here`orgUnits.xml` and `dataElements.xml`. So, if a new health facility is to be added to the process, the orgUnits.xml file will need to be updated. Simliarly if any new data elements are to be added, the dataElements.xml will need to be updated. As with any data entry into DHIS2, the analytics table will need to be updated before the new data can be viewed in the Pivot Table app.


## Run this as a windows batch file

To run this on Windows you will need to install msxsl, which can be downloaded [here](https://www.microsoft.com/en-us/download/details.aspx?id=21714). Once this is installed run the batch file from a windows command line.


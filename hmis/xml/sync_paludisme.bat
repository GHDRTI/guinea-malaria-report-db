@echo off
set /p moh_user="Please enter your Système National d'Information Sanitaire username: "
set /p moh_pass="Please enter your Système National d'Information Sanitaire password: "

set /p sync_period="Please enter the period (enter 201809 for September 2018): "



curl -k -u %moh_user%:%moh_pass% "https://dhis2.sante.gov.gn/dhis/api/26/dataValueSets.xml?dataSet=TL7xWT7zMNN&period=201809&orgUnitGroup=UF9kVV05HJ0" > paludisme-moh-%sync_period%.xml


msxsl paludisme-moh-%sync_period%.xml hmis_transform.xsl > paludisme-stoppalu-%sync_period%.xml

set /p stoppalu_user="Please enter your Stop Palu username: "
set /p stoppalu_pass="Please enter your Stop Palu password: "


curl -k -u %stoppalu_user%:%stoppalu_pass% -H "Content-Type: application/xml"  "https://stoppaludhis2.rti-ghd.org/api/26/dataValueSets" --data @paludisme-stoppalu-%sync_period%.xml



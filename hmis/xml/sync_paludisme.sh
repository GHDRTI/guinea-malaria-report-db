#!/bin/bash

echo ""
echo ""
echo "This script will download malaria data from the national HMIS and transform it, then upload it to the stop Palu database."
echo ""

echo "Enter the National HMIS username:"

read moh_user

echo "Enter the National HMIS password:"

read moh_pass

echo "Enter the period (i.e. 201805 for May 2018)"

read period

# qhAGuWjFjFG is the MOH population dataset
curl -u $moh_user:$moh_pass "https://dhis2.sante.gov.gn/dhis/api/26/dataValueSets.xml?dataSet=qhAGuWjFjFG&period="$period"&orgUnitGroup=UF9kVV05HJ0" > paludisme-moh-$period.xml

xsltproc paludisme_transform.xml paludisme-moh-$period.xml > paludisme-stoppalu-$period.xml


echo "Enter your Stop Palu username:"

read stoppalu_user

echo "Enter your Stop Palu password:"

read stoppalu_pass


curl -u $stoppalu_user:$stoppalu_pass -H "Content-Type: application/xml"  "https://stoppaludhis2.rti-ghd.org/api/26/dataValueSets?importStrategy=CREATE" --data @paludisme-stoppalu-$period.xml

echo ""
echo ""
echo ""

echo "Ok, you're done. Regenerate the analytic tables and you should be good (unless of course you have errors."



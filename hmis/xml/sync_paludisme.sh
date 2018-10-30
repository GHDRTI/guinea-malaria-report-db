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

# get moh data
curl -u $moh_user:$moh_pass "https://dhis2.sante.gov.gn/dhis/api/26/dataValueSets.xml?dataSet=TL7xWT7zMNN&period="${period}"&orgUnitGroup=UF9kVV05HJ0" > paludisme_moh_${period}.xml


# you can get this by doing this on a mac 'brew install saxon'
saxon -xsl:paludisme_transform.xsl -s:paludisme_moh_${period}.xml -o:paludisme_stoppalu_${period}.xml


echo "Enter your Stop Palu username:"

read stoppalu_user

echo "Enter your Stop Palu password:"

read stoppalu_pass


curl -u $stoppalu_user:$stoppalu_pass -H "Content-Type: application/xml"  "https://stoppaludhis2.rti-ghd.org/api/26/dataValueSets?importStrategy=CREATE" --data @paludisme_stoppalu_${period}.xml


saxon -xsl:paludisme_complete_registrations.xsl -s:paludisme_moh_${period}.xml -o:paludisme_stoppalu_${period}_completes.xml

echo ""
echo "Completing Datasets."
echo ""

curl -u $stoppalu_user:$stoppalu_pass -H "Content-Type: application/xml"  "https://stoppaludhis2.rti-ghd.org/api/26/completeDataSetRegistrations.xml" --data @paludisme_stoppalu_${period}_completes.xml


echo ""
echo ""
echo ""

echo "Ok, you're done. Regenerate the analytic tables and you should be good (unless of course you have errors."


echo ""
echo ""

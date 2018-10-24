

# Demo
![Malari Workbook Import Tool](public/parrot.svg)

# Getting Started

Set local environment variables

```
export MAGIC_LINK_HOST="localhost:3000"
export EMAILER_FROM="ict@rti.org"
export AWS_ACCESS_KEY_ID=YOUR_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_ACCESS_KEY
export S3_WORKBOOK_FILE_PATH=
export S3_BUCKET=
export EMAILER_HOST=
export EMAILER_PORT=
export EMAILER_USERNAME=
export EMAILER_PASSWORD=
```

then

```
rake db:create
rake db:migrate
rake db:seed

```



## Here are some helpful examples

**Import an individual workbook file**
> bundle exec rake import:workbook_file["/Users/apreston/OneDrive - RTI International/Projects/StopPalu/Workbooks/RAPPORT PALU 2018/FEVRIER/Fichier Excel_Rapport Mensuel  Palu Fevrier-18.xls",1]

**Import a workbook directory (to the local database)**
> bundle exec rake import:workbook_file_dir[/Users/apreston/Downloads/Reports/AOUT2017,1]

**Export data from a given reporting period**
> bundle exec rake export:reporting_period[6,2017]

**Export data from a given reporting period**
> bundle exec rake export:reporting_period[6,2017]

**Import file into the Stop Palu database**
> curl -u USERNAME:PASSWORD -H "Content-Type: application/json"  "https://stoppaludhis2.rti-ghd.org/api/26/dataValueSets" --data @/Users/apreston/Desktop/Stop Palu/july2018.json





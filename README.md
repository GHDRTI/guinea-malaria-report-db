# Workbook Upload Use Cases 

## User adds a new valid workbook file

> A registered user with permissions to add a workbook to the targeted month/year/district/country uploads a new valid workbook to be part of the active data.

**Preconditions** The country and district are present in the database configuration.  A workbook has not been uploaded for the month & year.  The workbook to be uploaded is valid.

**Postconditions** The aggregate data from the workbook for the month & year is included in the database as the active data.  It is reflected in all reporting from the system.  A line item for the workbook is available in the list of uploaded workbooks.

  1. The logged in user navigates to the workbook upload page.
  2. The user interacts with the page to upload the workbook and the workbook is stored in the system.
  3. The user is given feedback about the target month/year/district/country and asked to verify.
  4. If the user approves the target information, the user indicates so and the workbook data is added into the system and the data is interpreted as the active data for the month/year/district/country.


## User replaces a workbook file

> A registered user with permissions to add a workbook to the targeted month/year/district/country uploads a new valid workbook that replaces a previously uploaded version into the active data.

**Preconditions** The country and district are present in the database configuration.  There is at least one imported workbook for that same month & year.  The workbook to be uploaded is valid.

**Postconditions**  The aggregate data from the workbook for the month & year is included in the database as the active data.  It is reflected in all reporting from the system.  All of the data from the previous version of the workbook is omitted from the active data.  The newly uploaded workbook version is added to the list of uploaded files for the month/year/district/country workbook.  

  1. The logged in user navigates to the workbook upload page.
  2. The user interacts with the page to upload the workbook and the workbook is stored in the system.
  3. The user is given feedback about the target month/year/district/country and asked to verify that they wish to replace the previous workbook's data.
  4. If the user approves the target information, the user indicates so and the workbook data is added into the system and the data is interpreted as the active data for the month/year/district/country.


## User uploads an invalid workbook file

> A registered user with permissions to add a workbook to the targeted month/year/district/country uploads a new invalid workbook and is given a list of the validation errors to resolve.  No data is added to the system from the invalid workbook.

**Preconditions** Only that the user is a registered user.

**Postconditions** Validation errors are presented to the user.  No data is changed.

  1. The logged in user navigates to the workbook upload page.
  2. The user interacts with the page to upload the workbook and the workbook is validated.
  3. The validation errors are presented back to the user to resolve.  No data is uploaded into the system and the workbook file is marked in the system as invalid.

Note: This is the end of this case.  To resolve the issues of the workbook, a new one using the story "User adds a new valid workbook" must be invoked.

## User archives a workbook fiile

> A registered user with permissions to remove a workbook from the targeted month/year/district/country selects a workbookfile and removes it from the pool of active data.  A previous imported valid workbook is then considered the active data, if there is one.

**Preconditions** A workbook (current and active or not) exists.

**Postconditions** The workbook is marked as inactive and its data is no longer part of the active data.  Previous valid, non-archived data is considered the new active data.

  1. The logged in user navigates to the list of workbook and to the workbook file they want to archive.
  2. The interacts with the workbook file view page to mark the workbook as archived.
  3. The application informs the user of the net effects of marking the file as archived. The user confirms.
  4. The workbook file is marked as archived. 



# Reporting 

## Types of reports

### Quarterly report

#### Section 1 District Report

**y-axis** Districts (sort by name)

**x-axis** Columns

  - Patients consulted all causes
  - Persons suspected
  - Persons tested
  - Persons tested positive
  - Persons tested negative
  - Persons treated
  - Pregnant women - ANC test 
  - Pregnant women - 1st dose SP
  - Pregnant women - 3 doses SP
  - Health facilities that have filed
  - Distributed


#### Section 2 Cases Report

**y-axis** Districts

**x-axis** Months of year, total

## Live data view

#### Cases by Health Center
  
  - from `start_date` to `end_date`
  - filter health center by text search
  - group by `month` or `year`

#### Cases by District

  - from `start_date` to `end_date`
  - filter district by text search
  - group by `month` or `year`



# Monthly Malaria Workbook Import

### Reporting Data Model

Structural Tables, these tables are managed on the administration side.  They will include a `possible_spellings` field to match to importing workbooks.

  - **District**
  - **HealthFacility**

Reporting views, these tables are views derived from current reporting information.

  - **HealthFacilityMonthlyReport**
  - **HealthFacilityMalariaGroupReport**
  - **HealthFacilityInventoryReport**
  - **DistrictMonthlyReport**
  - **DistrictMalariaGroupReport**
  - **DistrictInventoryReport**

### Workbook Data Model

  - **Workbook**
  - **WorkbookFile**
  - **WorkbookMonthlyReport** 
    - Structure of *HealthFacilityMonthlyReport*
  - **WorkbookMalariaGroupReport** 
    - Structure of *HealthFacilityMalariaGroupReport* 
  - **WorkbookInventoryReport**
    - Structure of *HealthFacilityInventoryReport*


### Import Process

  1. WorkbookFile is uploaded (WorkbookFile.status:`uploading`)
    1. WorbookFile is created, file is uploaded to S3.
  2. WorkbookFile is validated (WorkbookFile.status:`verifying`), checked for:
    1. Structural correctness
    2. Month/Year/District correctness
  3. If WorkbookFile is not valid, present errors and STOP (WorkbookFile.status:`invalid`).  Workbook may or may not exist.
  4. If WorkbookFile is valid, confirm month/year/district for import (WorkbookFile.status:`verified`).  If actual Workbook does not exist, create it.
  5. If User confirms, start import (WorkbookFile.status:`importing`)
  6. If import fails, display error to user (WorkbookFile.status:`error`)
  7. If import succeeds, display success to user (WorkbookFile.status:`imported`)
  8. If user decides to not use the WorkbookFile anymore, set as archived (WorkbookFile.status:`archived`)
    1. WorkbookFile's data tables should no longer be included in view's calculations
    2. If no previous non-archived data will be included in the view's calculations, the user should be informed.


# Monthly Malaria Report Types

Report types:

District Report 
  - all years, particular year
  - year/month

Facility Report
  - all districts, district

## Monthly Case Report
  
Total Patients: 
sum(`fmgr`.`total_patients_all_causes`)


Suspected Cases:
sum(`fmgr`.`suspect_simple_male`) + sum(`fmgr`.`suspect_simple_female`) + sum(`fmgr`.`suspect_severe_male`) + sum(`fmgr`.`suspect_severe_female`)

Total Tested:
sum(`fmgr`.`tested_microscope`) + sum(`fmgr`.`tested_rdt`)

Total Tested Positive:
sum(`fmgr`.`confirmed_microscope`) + sum(`fmgr`.`confirmed_rdt`)

Total Tested Negative:
(sum(`fmgr`.`tested_microscope`) - sum(`fmgr`.`confirmed_microscope`)) + (sum(`fmgr`.`tested_rdt`) - sum(`fmgr`.`confirmed_rdt`))

Total Treated:
sum(`fmgr`.`treated_act_male`) + sum(`fmgr`.`treated_act_female`) + sum(`fmgr`.`treated_severe_male`) + sum(`fmgr`.`treated_severe_female`)

Total Pregnant Women ANC Tested:
`fmr`.`num_pregnant_anc_tested`

Total Pregnant Women First Dose SP:
`fmr`.`num_pregnant_first_dose_sp`

Total Pregnant Women 3 Doses SP:
`fmr`.`num_pregnant_three_doses_sp`

Date Submitted:
`fmr`.`approved_by_date`

Number MILDA Distributed
where(`product` = 'milda'): (`stock_month_start` + `stock_month_received`) - (`num_delivered_to_ac` + `num_delivered_to_ps` + `num_used` + `num_lost`)




### Facility Monthly Case Report

### District Monthly Case



# Models

    $ rails generate model user name:text email:text login_key:string login_key_expires:datetime last_login_time:datetime last_login_ip:string

    $ rails generate model district name:text

    $ rails generate model health_facility name:text district:references location:text

    $ rails generate model workbook reporting_month:integer reporting_year:integer district:references

    $ rails generate model workbook_file workbook:references user:references url:text status:string uploaded_at:datetime validation_errors:json errors:json 

    $ rails generate model workbook_facility_monthy_report workbook:references population_total:integer population_covered:integer num_services:integer num_reports_compiled:integer num_pregnant_anc_tested:integer num_pregnant_first_dose_sp:integer num_pregnant_three_doses_sp:integer num_structures:integer num_agents:integer num_local_ngos_cbos:integer compiled_by_name:string compiled_by_org:string compiled_by_phone:string compiled_by_date:date approved_by_name:string approved_by_org:string approved_by_phone:string approved_by_date:date

    $ rails generate model workbook_facility_malaria_group_report group:string registration_method:string total_patients_all_causes:integer total_deaths:integer suspect_severe_deaths_male:integer suspect_severe_deaths_female:integer suspect_simple_male:integer suspect_simple_female:integer suspect_severe_male:integer suspect_severe_female:integer tested_microscope:integer tested_rdt:integer confirmed_micoscope:integer confirmed_rdt:integer treated_act_male:integer treated_act_female:integer treated_severe_male:integer treated_severe_female:integer total_referrals:integer

    $ rails generate model workbook_facility_inventory_report product:string stock_month_start:integer stock_month_received:integer stock_month_end:integer num_delivered_to_ac:integer num_delivered_to_ps:integer num_used:integer num_lost:integer num_close_to_expire:integer num_days_out_of_stock:integer










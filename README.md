this is a work-in-progress ruby script to easily import individual subjects from the Census American Community Survey 2010 5-year summaryinto a postgres database.

dependencies:
ruby
wget
unzip

current steps:
	1. make an 'all_data' directory
	1. download all the geo data with:
		wget -r -nd -nc 'ftp://ftp.census.gov/acs2010_5yr/summaryfile/2006-2010_ACSSF_By_State_By_Sequence_Table_Subset' -A 'g*.txt' -P all_data
	1. for desired subject, consult http://www2.census.gov/acs2010_5yr/summaryfile/Sequence_Number_and_Table_Number_Lookup.txt for the sequence number, start position, and total number of cells.
	1. if the appropriate sequence table has not been downloaded, run 'prepare_acs_subject_file
	1. run 'create_acs_table'
	1. run the created SQL commad
	

TODO:
* general cleanup of code
* check for subject file before downloading
* creation of turnkey downloading of subject file

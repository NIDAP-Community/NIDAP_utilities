# NIDAP_utilities
Utilities to handle NIDAP tasks

## Upload script: Upload_to_NIDAP_Folder.sh
  Takes in five arguements in order: <br />
    1. NIDAP user token <br />
    2. Target folder path on NIDAP file system, please make sure you have correct permission to write to the folder. <br />
    3. Name of dataset user wants to create. <br />
    4. List of file paths wanted to upload as a single arguement, or a single file path. <br />
    5. List of full file name (includes extension, plead aviod space and symbols) stored in NIDAP dataset. Althouhg user can change the uploaded name, it is recommended to keep the name of source file and target file the same to avoid confusion. <br />

  Error message from the the API call will be displayed for troubleshooting. 
  
  Example:
  To upload sinlge file to the dataset created:
     
    source <PATH TO SCRIPT>/Upload_to_NIDAP_Folder.sh $NIDAP_TOEKN \
                                                      "<FOLDER PATH ON NIDAP>" \
                                                      "<NAME OF DATASET TO CREATE>" \
                                                      "<PATH TO FILE/FILE.extension>" \
                                                      "<NAME OF FILE.extension>"
    
  To upload multiple files to the dataset created:
    
    source <PATH TO SCRIPT>/Upload_to_NIDAP_Folder.sh $NIDAP_TOEKN \
                                                    "<FOLDER PATH ON NIDAP>" \
                                                    "<NAME OF DATASET TO CREATE>" \
                                                    ""<PATH TO FILE1/FILE1.extension>" "<PATH TO FILE2/FILE2.extension>" ... "<PATH TO FILEn/FILEn.extension>"" \
                                                    ""<NAME OF FILE1.extension>" "<NAME OF FILE2.extension>" ... "<NAME OF FILEn.extension>""
    

## Download script user interface: Downloader_UI.sh
  User interface for Download script. Consider downloading into local directory may require higher level of complexity, this allows user to specify where the file to be stored and under customed filename. This also allows downloading multiple files in one script run by providing a list of file wanted to be downloaded in the same trasaction rid as a single arguement.


## Download script: Download_from_NIDAP.sh
  Takes in five arguements in order: <br />
    1. NIDAP user token. <br />
    2. Source dataset rid, please make sure you have correct permission to access the dataset. <br />
    3. Trasaction rid of the targeted file. <br />
    4. Full name (includes extension) of the targeted file. <br />
    5. Full name (includes extension) of the targeted file to be stored locally. <br />

  Error message from the the API call will be displayed for troubleshooting. 
## nd_pd: Palantir download; copies file from Palantir to local system;

NOTE: options and associated input, if any, may be passed
         in any order;

Usage:
sh nd_pd.sh -tf (-to_file) "to_local_file_name.extension"
            -fr (-from_rid) "from_palantir_object_rid"
            -fp (-from_path) "from_palantir_object_path"
            -u (-user_token) "user_token"
            -d (-domain) "domain_url"
               [default:https://nidap.nih.gov]
............downloads Palantir from_path as local to_file;

sh nd_pd.sh -h (-help)
............displays function help;

sh nd_pd.sh -t (-test)
............test function;

Returns:
string: SUCCESS or FAILURE


## nd_pd: Palantir upload; copies file from local to Palantir system;

NOTE: options and associated input, if any, may be passed
         in any order;

Usage:
sh nd_pu.sh -ff (-from_file) "from_local_file_name.extension"
            -tr (-to_rid) "to_palantir_object_rid"
            -tp (-to_path) "to_palantir_object_path"
            -u (-user_token) "user_token"
            -d (-domain) "domain_url"
               [default:https://nidap.nih.gov]
............uploads local from_file as Palantir to_path;

sh nd_pu.sh -h (-help)
............displays function help;

sh nd_pu.sh -t (-test)
............test function;

Returns:
string: SUCCESS or FAILURE


## nd_ls: implements the BASH ls command with options for local and/or Palantir target system;

NOTE: requires curl, jq;

NOTE: options and associated input, if any, may be passed
         in any order;

Usage:
sh nd_ls.sh -f (-folder) "folder_path_name_to_list"
............displays contents of local folder(s);

sh nd_ls.sh -r (-rid) "palantir_object_rid"
            -u (-user_token) "user_token"
            -d (-domain) "domain_url"
               [default:https://nidap.nih.gov]
............displays contents of Palantir folder/dataset(s);

sh nd_ls.sh -h (-help)
............displays function help;

sh nd_ls.sh -t (-test)
............test function;

Returns:
SUCCESS or FAILURE; Contents of requested folder/dataset(s);


## nd_rm: implements the BASH rm command with options for local or Palantir target system;

NOTE: requires curl, jq;

NOTE: options and associated input, if any, may be passed
         in any order;

Usage:
sh nd_rm.sh -f (-file) "local_file_path_name.extension"
............deletes requested file(s) from local system;

sh nd_rm.sh -r (-rid) "palantir_dataset_rid"
            -p (-path) "palantir_file_path_name.extension"
            -u (-user_token) "user_token"
            -d (-domain) "domain_url"
               [default:https://nidap.nih.gov]
............deletes requested file(s) from Palantir system;

sh nd_rm.sh -h (-help)
............displays function help;

sh nd_rm.sh -t (-test)
............tests functionality (ignores file pathname provided;
            deletes temporary test file);

Returns:
string: SUCCESS or FAILURE


## nd_mv: implements the BASH mv command with options for local and/or Palantir target system;

NOTE: requires curl, jq;

NOTE: options and associated input, if any, may be passed
         in any order;

Usage:
sh nd_mv.sh -ff (-from_file) "from_local_file_name.extension"
            -tf (-to_file) "to_local_file_name.extension"
            -fr (-from_rid) "from_palantir_object_rid"
            -fp (-from_path) "from_palantir_object_path"
            -tr (-to_rid) "to_palantir_object_rid"
            -tp (-to_path) "to_palantir_object_path"
            -u (-user_token) "user_token"
            -d (-domain) "domain_url"
               [default:https://nidap.nih.gov]
............moves from_file/_path as to_file/_path; direction
            determined by input; e.g., providing -ff and -tf
            results in local move, providing -fr,-fp, -tr, -tp,
            and -u results in Palantir move, providing combin-
            ations produce intuitive results; i.e., providing
            -tf with -fr, -fp and -u moves from Palantir to
            local system, while -ff with -tr, -tp and -u moves
            from local system to Palantir;

sh nd_mv.sh -h (-help)
............displays function help;

sh nd_mv.sh -t (-test)
............test function;

Returns:
SUCCESS or FAILURE


## nd_cp: implements the BA/bin/bash cp command with options for local and/or Palantir target system;

NOTE: requires curl, jq;

NOTE: options and associated input, if any, may be passed
         in any order;

Usage:
/bin/bash nd_cp./bin/bash -ff (-from_file) "from_local_file_name.extension"
            -tf (-to_file) "to_local_file_name.extension"
            -fr (-from_rid) "from_palantir_object_rid"
            -fp (-from_path) "from_palantir_object_path"
            -tr (-to_rid) "to_palantir_object_rid"
            -tp (-to_path) "to_palantir_object_path"
            -bp (-base_path)
            -u (-user_token) "user_token"
            -d (-domain) "domain_url"
               [default:https://nidap.nih.gov]
............copies from_file/_path as to_file/_path; direction
            determined by input; e.g., providing -ff and -tf
            results in local copy, providing -fr,-fp, -tr, -tp,
            and -u results in Palantir copy, providing combin-
            ations produce intuitive results; i.e., providing
            -tf with -fr, -fp and -u copies from Palantir to
            local system, while -ff with -tr, -tp and -u copies
            from local system to Palantir;

/bin/bash nd_cp./bin/bash -h (-help)
............displays function help;

/bin/bash nd_cp./bin/bash -t (-test)
............test function;

Returns:
string: SUCCESS or FAILURE

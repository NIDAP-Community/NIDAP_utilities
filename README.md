# NIDAP_utilities
Utilities to handle NIDAP tasks

## Upload script: Upload_to_NIDAP_Helix.sh
  Takes in five arguements in order: <br />
    1. NIDAP user token <br />
    2. Target folder path on NIDAP file system, please make sure you have correct permission to write to the folder. <br />
    3. Name of dataset user wants to create. <br />
    4. List of files wanted to upload. <br />
    5. List of full file name (includes extension, plead aviod space and symbols) stored in NIDAP dataset. Althouhg user can change the uploaded name, it is recommended to keep the name of source file and target file the same to avoid confusion. <br />

  Error message from the the API call will be displayed for troubleshooting. 


## Download script: Download_from_NIDAP.sh
  Takes in five arguements in order: <br />
    1. NIDAP user token. <br />
    2. Source dataset rid, please make sure you have correct permission to access the dataset. <br />
    3. Trasaction rid of the targeted file. <br />
    4. Full name (includes extension) of the targeted file. <br />
    5. Full name (includes extension) of the targeted file to be stored locally. <br />

  Error message from the the API call will be displayed for troubleshooting. 

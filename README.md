# NIDAP_utilities
Utilities to handle NIDAP tasks

## Upload script: Upload_to_NIDAP_Helix.sh
  Takes in five arguements in order:
    1. NIDAP user token
    2. Target folder path on NIDAP file system, please make sure you have correct permission to write to the folder.
    3. Name of dataset user wants to create
    4. List of files wanted to upload
    5. List of full file name (includes extension, plead aviod space and symbols) stored in NIDAP dataset. Althouhg user can change the uploaded name, it is recommended to keep the name of source file and target file the same to avoid confusion.

  Error message from the the API call will be displayed for troubleshooting. 


## Download script: Download_from_NIDAP.sh
  Takes in five arguements in order:
    1. NIDAP user token
    2. Source dataset rid, please make sure you have correct permission to access the dataset.
    3. Trasaction rid of the targeted file.
    4. Full name (includes extension) of the targeted file.
    5. Full name (includes extension) of the targeted file to be stored locally. 

  Error message from the the API call will be displayed for troubleshooting. 

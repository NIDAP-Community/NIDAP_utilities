# NIDAP_utilities
Utilities to handle NIDAP tasks

This is an edit - remove.


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

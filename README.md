# JHS-Training-Acft-Study
This is a central repository for all code associated with a study on training aircraft failures utilizing the FAA Aircraft Registry and NTSB Accident Database

In order to run the Matlab script, have the following databases accesible in the same file location as your code:
1. A folder called "FAA Registry" that conatains:

    a. MASTER.txt
    
    b. DEREG.txt
    
    c. ENGINE.txt
    
    d. ACFTREF.txt
    
2. An excel sheet from the NTSB Microsoft Access database called "aircraft_NewNTSB.xlsx"
3. A text file from the NTSB downloadable databased called "AviationData.txt"

The script works from beginning to end, uncomment the entire file to run everything, or leave commented sections that you don't need to re-run (for example, if you have already imported the databases into the Matlab workspace, you can leave the first section commented out).

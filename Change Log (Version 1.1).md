# CreateUserAccount
A user account creation and management project

> Change Log for Version 1.1 (Previous Version 1.0)

### Updates / Improvements
- **Usage Section**
    - Updated to reflect all changes made and features added
    - Added additional details to each item/option
- **Admin / root Check**
    - Improved the validation to now require the script to be ran with sudo
- **User Selection (Account Management)**
    - Created a function that lists the user accounts on the computer, replacing the need for it to be typed. This resolves the issue where the script will return an error if the username isn't found due to misspelling.
    - The Standard and Admin user lists are separate functions to increase security and performance
- **Reset Password (Account Management)**
    - Added a section that give you the option to verify the password change for the users. If the option to verify is selected, you are prompted to enter the new password. The change is verified by running the 'whoami' command as the user you selected (Eg: su username -c 'whoami')
- **Enable User (Account Management)**
    - Changed the lines that enable the account to now just delete the entry that the Disable User option adds. This resolves the issue of the entire Authentication key getting deleted which may cause Kerberos and other authentication issues in the future.
- **Disable User (Account Management)**
    - Removed the quotes for the entry that gets added to disable the user's account. This resolves the issues where the disable/enable validation check kept failing and also allows for the line to be removed when the Enable User option is selected.
- **Main Menu / Account Management Menu**
    - Changed the menus to use the select command. Previously the menus used the case command. This change will allow future updates and new features to be added easier and makes the script more portable.

### New Features
- **Getopts Option**
    - Created a getopts option that allows for different options to be selected when first running the script. The following options are available:
        - -a : Enables Administrator Mode (This option adds the ability to perform management tasks on admin accounts. An additional header will appear when this option is used.)
        - -h : Shows the Usage/Help Section
        - -c : Shows the Licensing Section  
- **Create Package (Create User Sections)**
    - Before the user account is created, you will now have the option to export the user creation script as a package for use later.
    - The Package is created with the no payload option and uses a postinstall script to create the user account. The package is also not signed due to my developer cert not being included in the script (If the option to include it in a secure way exists, it will be added in the future)
    - If the option to create a package is selected, you will also have the option of adding a password to it. When this option is selected you will be asked to enter a password then the package will be converted to a zip which will be encrypted with that password. Once complete, you will find the zip on your Desktop.
    - If this option is selected, you will also be given the option to exit the script after the package is created. If you choose to exit the script, the user account will not be created on that computer.
- **Reset Password (FileVault User Check)**
    - Added a section that will now check to see if FileVault is turned on and if so will check if that user is on the list of FileVault users. 
    - If the user is on the list of FileVault users, a message will appear informing you that the user is on the FileVault list and will need to be removed from it before changing the password. It also states that an attempt to add the user's account back to the FileVault list will be made and gives you the option to quit or continue. If it fails, the user's account will have to be manually added back to the list. This will resolve the issue of the password change not being synced with their FileVault password. 
        - Note: If the user is on the FileVault list, you will be prompted to enter the username of a current FileVault user along with the password for that user. This must be correct in order for the user to be added back onto the list.

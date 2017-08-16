# CreateUserAccount
A user account creation and management project

> README updated on August 16th 2017
> Current Version: 1.2

## Usage
```
sudo sh CreateUserAccount.sh [-a | -c | -h]
```

## Overview
This script will allow you to perform various user management tasks. It was originally created to allow the customization I needed that the [CreateUserPKG](https://github.com/MagerValp/CreateUserPkg) did not have. Since the CreateUserPKG is now no longer being maintained, I decided to add to the script I had created and hope that it helps others as much as it has helped me.

------------------------------------------------------------------------------------------------------------------------------

**For a detailed outline of all the changes and feature additions, please read the Change Log for Version 1.1**

### In it's current state (as of August 11th 2017 - version 1.1), this script will do the following tasks:

**Options**
  - -a - Administrator Management Mode
  - -c - Show Copyright/Licensing Section
  - -h - Usage/Help Section

**Main Menu**
   - Create a Standard User Account
     - Located in the /Users directory with a UID above 500
   - Create a Sharing Only Account
   - Create a Admin User Account
     - Non Hidden Account
      - Located in the /Users directory with a UID above 500
    - Hidden Account
      - Located in the /var directory with a UID below 500 to allow for the account to be hidden from the User & Groups pane and the /Users directory.
  
     
**Account Management**
   - Disable Standard Account
   - Enable Standard Account
   - Reset Standard Account Password
   - Delete Standard Account
   - Delete Sharing Only Account
   - Disable Admin Account *[-a option required]*
   - Enable Admin Account *[-a option required]*
   - Reset Admin Account Password *[-a option required]*
   - Delete Admin Account *[-a option required]*
------------------------------------------------------------------------------------------------------------------------------

#### User Creation Fields:
  - Username
  - First / Last Name (Used to create the Real Name)
  - Password
    - Option of entering hidden / visible passwords
  - User Icon
    - Provides the following options:
      1. Have an icon randomly selected from the default user template
      2. Select a custom icon that you have on your computer (PNG format only)
  - Create User Package
    - Creates a package that allows you to create the user account on multiple computers
    - Option provided to allow you to password protect the package for additional security
      - This option will create a encrypted zip file on your Desktop and delete the package that was first created
      
#### Current Field Validations:
  - Username
    - Checks for spaces and special characters
  - First / Last Name
    - Checks the number of words being entered for each field
  - Password
    - Verifies the password being entered matches by prompting for you to enter it twice
    - Allows you to select the option if you want the password to be visible while you type it or not

#### Current Script Validations:
  - Error Limit
    - Once the script finds three errors, it will quit the script and inform the user that the maximum number of errors has been reached
  - Admin Check
    - Checks to see if the user running the script is a memember of the admin group
  - Root Check
    - Checks to see if the user is running the script as root. Will exit the script if not.
   
**This script requires various commands to be ran as root.**

The following items will be added / completed in the near future and this will be updated to reflect those changes
  - [x] A more detailed usage/help section *[added 8/11]*
  - Account Management
    - [x] User Password Reset *[added 7/25]*
    - [x] Enable User Account *[added 7/25]*
    - [x] Disable User Account *[added 7/25]*
    - [x] Delete User Account *[added 8/11]*

### Future Plans
  - [ ] Create a GUI for the script to allow for easier useage
  - [x] Create the option to allow the user to export to a package to allow for duplication *[added 8/11]*
  - [ ] Create the option to add items to the user's home directory to further customize the account
  - [x] Sharing Only / Shell Account Option *[added 8/16]*
  - [ ] Multiple Account Creation Option
  
If you would like to help with an area of the script or any of the future plans, send me an email (josh[at]macjeezy.com) or submit a request on this repo! Also, if you have any feedback or comments about this project, I would love to hear them!

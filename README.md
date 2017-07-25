# CreateUserAccount
A user account creation and management project

> README updated on July 24th 2017

## Usage
sudo sh CreateUserAccount.sh

## Overview
This script will allow you to perform various user management tasks. It was originally created to allow the customization I needed that the [CreateUserPKG](https://github.com/MagerValp/CreateUserPkg) did not have. Since the CreateUserPKG is now no longer being maintained, I decided to add to the script I had created and hope that it helps others as much as it has helped me.

In it's current state (as of July 24th 2017), this script will do the following tasks:
  - Create a Standard User Account
    - Located in the /Users directory with a UID above 500
  - Create a Admin User Account (Not Hidden)
    - Located in the /Users directory with a UID above 500
  - Create a Admin User Account (Hidden)
    - Located in the /var directory with a UID below 500 to allow for the account to be hidden from the User & Groups pane and the /Users directory.

User Creation Fields:
  - Username
  - First / Last Name (Used to create the Real Name)
  - Password
  - User Icon
    - Provides the following options:
      1. Have an icon randomly selected from the default user template
      2. Select a custom icon that you have on your computer (PNG format only currently)
  
Current Field Validations:
  - Username
    - Checks for spaces and special characters
  - First / Last Name
    - Checks the number of words being entered for each field
  - Password
    - Verifies the password being entered matches by prompting for you to enter it twice
    - Allows you to select the option if you want the password to be visible while you type it or not

Current Script Validations:
  - Error Limit
    - Once the script finds three errors, it will quit the script and inform the user that the maximum number of errors has been reached
  - Admin Check
    - Checks to see if the user running the script is a memember of the admin group
  - Root Check
    - Checks to see if the user is running the script as root

**This script requires various commands to be ran as root.**

The following items will be added / completed in the near future and this will be updated to reflect those changes
  - [ ] A more detailed useage section (Function inside of the script)
  - [ ] FileVault User Placeholder (aka User Shell - no login)
  - Account Management
    - [ ] User Password Reset
    - [ ] Enable / Disable User Account (Standard Accounts Only)
    - [ ] Remove User Account (Standard Accounts Only)

### Future Plans
  - [ ] Create a GUI for the script to allow for easier useage
  - [ ] Create the option to allow the user to export to a package to allow for easier duplication
  - [ ] Create the option to add items to the user's home directory to further customize the account
  
If you would like to help with an area of the script or any of the future plans, send me an email (josh[at]macjeezy.com) or submit a request on this repo! Also, if you have any feedback or comments about this project, I would love to hear them!

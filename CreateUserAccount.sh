#!/bin/bash

##########################################
# Create User Account Script				 
# Josh Harvey | josh[at]macjeezy.com 				 	 
# GitHub - github.com/therealmacjeezy    
# JAMFnation - therealmacjeezy
# Created: July 6 2017
# Updated: August 16 2017			 
##########################################

############################# Licensing ###############################
# Copyright 2017, Joshua Harvey
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License at <http://www.gnu.org/licenses/> for
# more details.
############################### Usage #################################
# sudo createuser.sh [-a | -h | -c]
########################## Revision History ###########################
# 08-16-2017	Added an option to create and delete a Sharing Only
#				account (Version 1.2)
# 08-11-2017	Custom pictures can now be used when the package option
#				is selected. Added an option to exit the script after
#				the package is created, instead of automatically 
#				creating the account (Version 1.1).
# 08-06-2017	Added option to export a user to a package and the 
#				option to password protect that package as a zip
# 08-05-2017	Added section for FileVault (Reset Password Section),
#				Created user lists that appear when you need to select
#				a user, fixed issues in the disable/enable user section
# 07-19-2017	Added Getopts section
# 07-06-2017	Created
#######################################################################

########################### Text Formatting ###########################
addStyle() {
	esc="\033"

	# Text Colors
	TXTblack="${esc}[30m"; TXTred="${esc}[31m"; TXTgreen="${esc}[32m";	
	TXTyellow="${esc}[33m"; TXTblue="${esc}[34m"; TXTpurple="${esc}[35m";	
	TXTcyan="${esc}[36m"; TXTwhite="${esc}[37m"; TXTlightgreen="${esc}[92m"; 
	TXTpink="${esc}[95m";

	# Background Colors
	BGblack="${esc}[40m"; BGred="${esc}[41m"; BGgreen="${esc}[42m";	
	BGyellow="${esc}[43m"; BGblue="${esc}[44m"; BGpurple="${esc}[45m";	
	BGcyan="${esc}[46m"; BGwhite="${esc}[47m"; BGgray="${esc}[100m"; 
	BGlightgreen="${esc}[102m";

	# Additional Styles
	boldon="${esc}[1m";	boldoff="${esc}[22m";
	italicon="${esc}[3m";	italicoff="${esc}[23m";
	underlineon="${esc}[4m";	underlineoff="${esc}[24m";
	inverton="${esc}[7m";	invertoff="${esc}[27m";
	blinkon="${esc}[5m";	blinkoff="${esc}[25m";
	hideon="${esc}[8m";	hideoff="${esc}[28m";

	# Reset Style
	reset="${esc}[0m"
}

addStyle
#######################################################################

#### Generate UID
# Creates a UID in the 503 to 550 range that will appear in the Account Preferences pane
makeUID500=`awk -v min=503 -v max=550 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'`

# Creates a UID in the 480 to 499 range that will NOT appear in the Account Preferences pane
makeUID400=`awk -v min=480 -v max=499 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'`

scriptTitle() {
printf "${boldon}${BGlightgreen}############################################################\n"
printf " Create User Account Script | Copyright: Josh Harvey [2017] \n"
printf "############################################################${reset}\n"
printf "\n"	
}


showCopyright() {
scriptTitle
echo "
${boldon}Copyright 2017, Joshua Harvey${boldoff}
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License at <http://www.gnu.org/licenses/> for
more details.

================================================================
${boldon}Contact${boldoff}
> ${boldon}E-Mail: ${boldoff}josh[at]macjeezy.com 				 	 
> ${boldon}GitHub: ${boldoff}github.com/therealmacjeezy    
> ${boldon}JAMFnation: ${boldoff}therealmacjeezy	
================================================================
"
}

scriptHelp() {
clear
scriptTitle
echo "${boldon}Create User Account Script${boldoff} - ${boldon} Version: ${boldoff}1.1${reset}

${boldon}Summary${reset}
This script will allow a user to create various account types along with perform select account management tasks.

${boldon}Useage${reset}
${boldon}CreateUserAccount.sh ${boldoff} [ -a | -c | -h ]
	${boldon}-a${boldoff} - Administrator Management Mode 
	${boldon}-c${boldoff} - Show Copyright Section
	${boldon}-h${boldoff} - Usage / Help (This Page)

${boldon}Main Menu Options: ${boldoff}
	- Create Standard Account
	- Create Admin Account
		- ${italicon}${boldon}Account Options:${italicoff}${boldoff}
		   - Hidden Account 
		     (${boldon}Location:${boldoff} /var/username/ | ${boldon}UID:${boldoff} below 500)
		   - Non Hidden Account
		     (${boldon}Location:${boldoff} /Users/username/ | ${boldon}UID:${boldoff} above 500)
	- Create Sharing Only Account [new]
	- Account Management 

${boldon}Account Management Options: ${boldoff}
	- Disable Standard User Account
	- Enable Standard User Account
	- Reset Standard User Password
	- Delete Standard User Account
	- Delete Sharing Only Account [new]
	- Admin: Disable Account ${italicon}${TXTblue}(-a Required)${reset}
	- Admin: Enable Account ${italicon}${TXTblue}(-a Required)${reset}
	- Admin: Reset Password ${italicon}${TXTblue}(-a Required)${reset}
	- Admin: Delete Account ${italicon}${TXTblue}(-a Required)${reset}
"
}

#### Package Creation Section ####
# Gets the current logged in user and sets it as a variable
theUser=$(who | grep "console" | cut -d" " -f1)

# Function to create the package and postscripts for the user account
pkgOptions() {
	mkPkg() {
		# Creates the directory for the postinstall script
		mkdir -p /Users/"$theUser"/Desktop/scripts/
		# Allows the directory to be read/write/executed by all users
		chmod ugo+rwx /Users/"$theUser"/Desktop/scripts/
		# Takes the user creation lines and exports them into a postinstall script
		printf "#!/bin/bash\n" > /Users/"$theUser"/Desktop/scripts/postinstall
		printf "sudo dscl . -create /Users/"$userName"\n" >> /Users/"$theUser"/Desktop/scripts/postinstall
		printf "sudo dscl . -create /Users/"$userName" UserShell "$userShell"\n" >> /Users/"$theUser"/Desktop/scripts/postinstall
		printf 'sudo dscl . -create /Users/'"$userName"' RealName '"\"$userRealName\""'\n' >> /Users/"$theUser"/Desktop/scripts/postinstall
		printf "sudo dscl . -create /Users/"$userName" UniqueID "$makeUID"\n" >> /Users/"$theUser"/Desktop/scripts/postinstall
		printf "sudo dscl . -create /Users/"$userName" PrimaryGroupID "$getID"\n" >> /Users/"$theUser"/Desktop/scripts/postinstall
		printf "sudo dscl . -create /Users/"$userName" NFSHomeDirectory "$homeDir"\n" >> /Users/"$theUser"/Desktop/scripts/postinstall
		printf "sudo dscl . passwd /Users/"$userName" "$userPass"\n" >> /Users/"$theUser"/Desktop/scripts/postinstall
		printf "sudo mkdir -p "$homeDir"\n" >> /Users/"$theUser"/Desktop/scripts/postinstall
			if [[ "$customPictureOption" == "true" ]];
				then
					cp -R "$userIcon" /Users/"$theUser"/Desktop/scripts/img01.png
					sudo mkdir /Library/User\ Pictures/Custom
					printf "sudo cp -R img01.png /Library/User\ Pictures/Custom/img01.png\n" >> /Users/"$theUser"/Desktop/scripts/postinstall
					printf "sudo dscl . -create /Users/"$userName" Picture /Library/User\ Pictures/Custom/img01.png\n" >> /Users/"$theUser"/Desktop/scripts/postinstall
			else
					printf 'sudo dscl . -create /Users/'"$userName"' Picture '\""$userIcon"\"'\n' >> /Users/"$theUser"/Desktop/scripts/postinstall
			fi
		#printf 'sudo dscl . -create /Users/'"$userName"' Picture '\""$userIcon"\"'\n' >> /Users/"$theUser"/Desktop/scripts/postinstall
		# Makes the postinstall script executable
		chmod a+x /Users/"$theUser"/Desktop/scripts/postinstall
		# Builds the package without a payload and just the postscript
		sudo pkgbuild --identifier com.therealmacjeezy.createuseraccount --nopayload --scripts "/Users/"$theUser"/Desktop/scripts" "/Users/"$theUser"/Desktop/CreateUserAccount.pkg"
		# Removes the directory that stored the postinstall script
		sudo rm -rf /Users/"$theUser"/Desktop/scripts/
	}

makeUser() {
	# Prompt that will ask the user if they still want to create the user account or exit the script. This option will be provided if they choose to create a package of the user account
	clear
	scriptTitle
	printf "${boldon}Do you still want to create the user account on this computer? (Y/N): ${boldoff}"
	read continueScript

	tput cuu1; tput cr; tput el;
	case $continueScript in
		Y|y)
			echo "Beginning User Creation.."
			;;
		N|n)
			printf "${boldon}Exiting Script.. ${boldoff}\n"
			sleep 1
			clear
			exit 0
			;;
	esac
}

# Prompt that gives you the option to convert the package into a password protected zip for additonal security
printf "${boldon}Would you like to password protect the package? ${boldoff}\n"
printf "${italicon}${TXTyellow}${boldon}Note: This will convert the package to a password protected zip${reset}\n"
printf "${boldon}Add Password? (Y/N): ${boldoff}"
read addPass

tput cuu1; tput cr; tput el;
case $addPass in
	Y|y)
		# Until loop that will ensure the passwords match
		until [[ "$passVerified" == "yes" ]]; do
		printf "${boldon}Enter a password to use:${boldoff}\n"
		read -s pkgPass
		tput cuu1; tput cr; tput el;
				printf "Please Re-Enter The Password:\n"
				read -s pkgPassVerify
				tput cuu1; tput cr; tput el;
					if [[ "$pkgPass" == "$pkgPassVerify" ]];
						then
							passVerified="yes"
						else
							printf "${TXTred}The Passwords you entered do not match.${reset}\n"
							printf "${boldon}Please Re-Enter the password..${boldoff}\n"
							sleep 1
							tput cuu1; tput cr; tput el;
							tput cuu1; tput cr; tput el;
					fi
			done
		# Runs the function to create the package
		mkPkg
		# Changes the directory to the user's desktop so the zip gets created onto their Desktop
		cd /Users/"$theUser"/Desktop
		# Creates the zip file using the password the user entered above
		zip -e CreateUserAccount.pkg.zip CreateUserAccount.pkg --password "$pkgPass"
		# Removes the package from the Desktop so only the zip file is there
		rm -rf /Users/"$theUser"/Desktop/CreateUserAccount.pkg
		;;
	N|n)
		# Runs the function to create the package
		mkPkg
		;;
esac
}

createPKG() {
	printf "Would you like to export this user to a package for later use? (Y/N):\n"
	read pkgToo
	tput cuu1; tput cr; tput el;
		case $pkgToo in
			Y|y)
				pkgOptions
				makeUser
				;;
			N|n)
				#break
				;;
		esac
}
## End Package Option
getSharing() {
# Get list of all user accounts with the system accounts filtered out	
listUsers=$(dscl . -list /Users | grep -v "^_.*" | awk '{print $1}')

# Count the number of user accounts
countUsers=$(echo "$listUsers" | wc -l)

# Create starting count for the user array
lineNumber="1"

# Creates an item in the array for every user. 
for i in $(seq 1 "$countUsers"); do
	# Uses the numbering variable set above with the head command to print each user line by line
	listUsers=$(dscl . -list /Users | grep -v "^_.*" | awk '{print $1}' | head -"$lineNumber" | tail -1)
	# Checks to see if the account is able to login or if their shell is set to /usr/bin/false
	userShell=$(dscl . -read /Users/"$listUsers" NFSHomeDirectory | grep -w "/dev/null")
		# If the account has the default shell to allow logins, the user is added to the array
		if [[ ! -z  "$userShell" ]];
			then
				userList+=("$listUsers")
		fi
	# Increases the numbering variable
	let "lineNumber++"
done

# A for loop that will check to see if the users in the array created above are part of the admin group. If they aren't an admin, they will get added to the standard users array.
for i in "${userList[@]}"; do
	# Variable to check to see if the user is a member of the admin group
	adminCheck=$(dsmemberutil checkmembership -U "$i" -G admin | grep "is a member")
		# If the variable above is empty, that means the user is not a memeber of the admin group and gets added to the standard users array
		if [[ -z "$adminCheck" ]];
			then
				sharingUser+=("$i")
		fi
done

# Adds an option to quit to the end of the standard users array
sharingUser+=("QUIT")

# Creates a starting count for error checking
errorCount="0"

pickUser() {
		# Function to allow the user to verify the user they have selected and allows them to pick another one if it's not correct
		verifyUser() {
			clear
			scriptTitle
			printf "You have selected the user ${boldon}$usr ${boldoff}..\nIs this correct (y/n)? "
			read useOption
				case $useOption in
					Y|y)
						# Sets the variable that is used to verify the user has been verifed and set to be used in the next part of the script
						selectionComplete="true"
						# Sets the variable that is used in the until loop to skip the user selection menu
						userPicked="yes"
						clear
						break
						;;
					N|n)
						clear
						scriptTitle
						# Sets the variable that will bring the user back to the user selection menu to pick a different user
						userPicked="no"
							# Increases the variable for error checking
							let "errorCount++"
								# Exits the script if the max number of errors has been reached
								if [[ "$errorCount" == "3" ]];
									then
										echo "Max number of attempts reached. Exiting"
										sleep .5
										exit 1
								fi
						break
						;;
					*)
						echo "Error Found: Invalid Entry"
						sleep .5
						tput cuu1; tput cr; tput el;
						# Increases the variable for error checking
						let "errorCount++"
							# Exits the script if the max number of errors has been reached
							if [[ "$errorCount" == "3" ]];
								then
									echo "Max number of errors reached. Exiting"
									sleep .5
									exit 1
							fi
						;;
				esac
			}

	PS3="Please select a user: "
	until [[ "$userPicked" == "yes" ]]; do
		select usr in "${sharingUser[@]}"; do
		tput cuu1; tput cr; tput el;
			if [[ -z "$usr" ]];
				then
					echo "Error Found: Invalid Entry"
					sleep .5
					tput cuu1; tput cr; tput el;
					# Increases the variable for error checking
					let "errorCount++"
						# Exits the script if the max number of errors has been reached
						if [[ "$errorCount" == "3" ]];
							then
								echo "Max number of errors reached. Exiting"
								sleep .5
								exit 1
						fi
			elif [[ "$usr" == "QUIT" ]];
				then
					echo "Exiting.."
					sleep .5
					clear
					exit 0
			else
					# Sets the variable that is used in the until loop to skip the user selection menu
					userPicked="yes"
					tput cuu1; tput cr; tput el;
					# Calls the function to verify the user that has been selected
					verifyUser
			fi
		done
	done
}

# A while loop that will call the pickUser function if it sees the variable for selectionComplete isn't set to true
while [[ "$selectionComplete" != "true" ]]; do
		pickUser
done

# If statement that sets the setUser variable with the user that has been selected above
if [[ "$selectionComplete" == true ]];
	then
		setUser="$usr"
fi
}


getStandard() {
# Get list of all user accounts with the system accounts filtered out	
listUsers=$(dscl . -list /Users | grep -v "^_.*" | awk '{print $1}')

# Count the number of user accounts
countUsers=$(echo "$listUsers" | wc -l)

# Create starting count for the user array
lineNumber="1"

# Creates an item in the array for every user. 
for i in $(seq 1 "$countUsers"); do
	# Uses the numbering variable set above with the head command to print each user line by line
	listUsers=$(dscl . -list /Users | grep -v "^_.*" | awk '{print $1}' | head -"$lineNumber" | tail -1)
	# Checks to see if the account is able to login or if their shell is set to /usr/bin/false
	userShell=$(dscl . -read /Users/"$listUsers" UserShell | grep -w "/bin/bash")
		# If the account has the default shell to allow logins, the user is added to the array
		if [[ ! -z  "$userShell" ]];
			then
				userList+=("$listUsers")
		fi
	# Increases the numbering variable
	let "lineNumber++"
done

# A for loop that will check to see if the users in the array created above are part of the admin group. If they aren't an admin, they will get added to the standard users array.
for i in "${userList[@]}"; do
	# Variable to check to see if the user is a member of the admin group
	adminCheck=$(dsmemberutil checkmembership -U "$i" -G admin | grep "is a member")
		# If the variable above is empty, that means the user is not a memeber of the admin group and gets added to the standard users array
		if [[ -z "$adminCheck" ]];
			then
				standardUser+=("$i")
		fi
done

# Adds an option to quit to the end of the standard users array
standardUser+=("QUIT")

# Creates a starting count for error checking
errorCount="0"

pickUser() {
		# Function to allow the user to verify the user they have selected and allows them to pick another one if it's not correct
		verifyUser() {
			clear
			scriptTitle
			printf "You have selected the user ${boldon}$usr ${boldoff}..\nIs this correct (y/n)? "
			read useOption
				case $useOption in
					Y|y)
						# Sets the variable that is used to verify the user has been verifed and set to be used in the next part of the script
						selectionComplete="true"
						# Sets the variable that is used in the until loop to skip the user selection menu
						userPicked="yes"
						clear
						break
						;;
					N|n)
						clear
						scriptTitle
						# Sets the variable that will bring the user back to the user selection menu to pick a different user
						userPicked="no"
							# Increases the variable for error checking
							let "errorCount++"
								# Exits the script if the max number of errors has been reached
								if [[ "$errorCount" == "3" ]];
									then
										echo "Max number of attempts reached. Exiting"
										sleep .5
										exit 1
								fi
						break
						;;
					*)
						echo "Error Found: Invalid Entry"
						sleep .5
						tput cuu1; tput cr; tput el;
						# Increases the variable for error checking
						let "errorCount++"
							# Exits the script if the max number of errors has been reached
							if [[ "$errorCount" == "3" ]];
								then
									echo "Max number of errors reached. Exiting"
									sleep .5
									exit 1
							fi
						;;
				esac
			}

	PS3="Please select a user: "
	until [[ "$userPicked" == "yes" ]]; do
		select usr in "${standardUser[@]}"; do
		tput cuu1; tput cr; tput el;
			if [[ -z "$usr" ]];
				then
					echo "Error Found: Invalid Entry"
					sleep .5
					tput cuu1; tput cr; tput el;
					# Increases the variable for error checking
					let "errorCount++"
						# Exits the script if the max number of errors has been reached
						if [[ "$errorCount" == "3" ]];
							then
								echo "Max number of errors reached. Exiting"
								sleep .5
								exit 1
						fi
			elif [[ "$usr" == "QUIT" ]];
				then
					echo "Exiting.."
					sleep .5
					clear
					exit 0
			else
					# Sets the variable that is used in the until loop to skip the user selection menu
					userPicked="yes"
					tput cuu1; tput cr; tput el;
					# Calls the function to verify the user that has been selected
					verifyUser
			fi
		done
	done
}

# A while loop that will call the pickUser function if it sees the variable for selectionComplete isn't set to true
while [[ "$selectionComplete" != "true" ]]; do
		pickUser
done

# If statement that sets the setUser variable with the user that has been selected above
if [[ "$selectionComplete" == true ]];
	then
		setUser="$usr"
fi
}

getAdmin() {
# Get list of all user accounts with the system accounts filtered out	
listUsers=$(dscl . -list /Users | grep -v "^_.*" | awk '{print $1}')

# Count the number of user accounts
countUsers=$(echo "$listUsers" | wc -l)

# Create starting count for the user array
lineNumber="1"

# Creates an item in the array for every user. 
for i in $(seq 1 "$countUsers"); do
	# Uses the numbering variable set above with the head command to print each user line by line
	listUsers=$(dscl . -list /Users | grep -v "^_.*" | awk '{print $1}' | head -"$lineNumber" | tail -1)
	# Checks to see if the account is able to login or if their shell is set to /usr/bin/false
	userShell=$(dscl . -read /Users/"$listUsers" UserShell | grep -w "/bin/bash")
		# If the account has the default shell to allow logins, the user is added to the array
		if [[ ! -z  "$userShell" ]];
			then
				userList+=("$listUsers")
		fi
	# Increases the numbering variable
	let "lineNumber++"
done

# A for loop that will check to see if the users in the array created above are part of the admin group. If they are an admin, they will get added to the admin users array.
for i in "${userList[@]}"; do
	# Variable to check to see if the user is a member of the admin group
	adminCheck=$(dsmemberutil checkmembership -U "$i" -G admin | grep "is a member")
		# If the variable above is not empty, that means the user is a memeber of the admin group and gets added to the admin users array
		if [[ ! -z "$adminCheck" ]];
			then
				adminUser+=("$i")
		fi
done

# Adds an option to quit to the end of the admin users array
adminUser+=("QUIT")

# Creates a starting count for error checking
errorCount="0"

pickUser() {
		# Function to allow the user to verify the user they have selected and allows them to pick another one if it's not correct
		verifyUser() {
			clear
			scriptTitle
			printf "You have selected the user ${boldon}$usr ${boldoff}..\nIs this correct (y/n)?: "
			read useOption
				case $useOption in
					Y|y)
						# Sets the variable that is used to verify the user has been verifed and set to be used in the next part of the script
						selectionComplete="true"
						# Sets the variable that is used in the until loop to skip the user selection menu
						userPicked="yes"
						clear
						break
						;;
					N|n)
						clear
						scriptTitle
						# Sets the variable that will bring the user back to the user selection menu to pick a different user
						userPicked="no"
							# Increases the variable for error checking
							let "errorCount++"
								# Exits the script if the max number of errors has been reached
								if [[ "$errorCount" == "3" ]];
									then
										echo "Max number of attempts reached. Exiting"
										sleep .5
										exit 1
								fi
						break
						;;
					*)
						echo "Error Found: Invalid Entry"
						sleep .5
						tput cuu1; tput cr; tput el;
						# Increases the variable for error checking
						let "errorCount++"
							# Exits the script if the max number of errors has been reached
							if [[ "$errorCount" == "3" ]];
								then
									echo "Max number of errors reached. Exiting"
									sleep .5
									exit 1
							fi
						;;
				esac
			}

	PS3="Please select a user: "
	until [[ "$userPicked" == "yes" ]]; do
		#printf "User List\n"
		select usr in ${adminUser[@]}; do
		tput cuu1; tput cr; tput el;
			if [[ -z "$usr" ]];
				then
					echo "Error Found: Invalid Entry"
					sleep .5
					tput cuu1; tput cr; tput el;
					# Increases the variable for error checking
					let "errorCount++"
						# Exits the script if the max number of errors has been reached
						if [[ "$errorCount" == "3" ]];
							then
								echo "Max number of errors reached. Exiting"
								sleep .5
								exit 1
						fi
			elif [[ "$usr" == "QUIT" ]];
				then
					echo "Exiting.."
					sleep .5
					clear
					exit 0
			else
					# Sets the variable that is used in the until loop to skip the user selection menu
					userPicked="yes"
					tput cuu1; tput cr; tput el;
					# Calls the function to verify the user that has been selected
					verifyUser
			fi
		done
	done
}

# A while loop that will call the pickUser function if it sees the variable for selectionComplete isn't set to true
while [[ "$selectionComplete" != "true" ]]; do
		pickUser
done

# If statement that sets the setUser variable with the user that has been selected above
if [[ "$selectionComplete" == true ]];
	then
		setUser="$usr"
fi
}

# Gets the list of FileVault users
getFVUserList() {
# Get list of all user accounts with the system accounts filtered out	
listFVUsers=$(sudo fdesetup list | sed 's/[,].*//')

# Count the number of user accounts
countFVUsers=$(echo "$listFVUsers" | wc -l)

# Create starting count for the user array
lineNumberFV="1"

# Creates an item in the array for every user. 
for i in $(seq 1 "$countFVUsers"); do
	# Uses the numbering variable set above with the head command to print each user line by line
	listFVUsers=$(sudo fdesetup list | sed 's/[,].*//' | head -"$lineNumberFV" | tail -1)
	# Adds the FileVault user to the array
	FVUserList+=("$listFVUsers")
	# Increases the numbering variable
	let "lineNumberFV++"
done

# Adds an option to quit to the end of the admin users array
FVUserList+=("QUIT")

# Creates a starting count for error checking
errorCount="0"

pickFVUser() {
		# Function to allow the user to verify the user they have selected and allows them to pick another one if it's not correct
		verifyFVUser() {
			clear
			scriptTitle
			printf "You have selected the user ${boldon}$FVusr ${boldoff}..\nIs this correct (y/n)?: "
			read useOption
				case $useOption in
					Y|y)
						# Sets the variable that is used to verify the user has been verifed and set to be used in the next part of the script
						FVselectionComplete="true"
						# Sets the variable that is used in the until loop to skip the user selection menu
						FVuserPicked="yes"
						clear
						break
						;;
					N|n)
						clear
						scriptTitle
						# Sets the variable that will bring the user back to the user selection menu to pick a different user
						FVuserPicked="no"
							# Increases the variable for error checking
							let "errorCount++"
								# Exits the script if the max number of errors has been reached
								if [[ "$errorCount" == "3" ]];
									then
										echo "Max number of attempts reached. Exiting"
										sleep .5
										exit 1
								fi
						break
						;;
					*)
						echo "Error Found: Invalid Entry"
						sleep .5
						tput cuu1; tput cr; tput el;
						# Increases the variable for error checking
						let "errorCount++"
							# Exits the script if the max number of errors has been reached
							if [[ "$errorCount" == "3" ]];
								then
									echo "Max number of errors reached. Exiting"
									sleep .5
									exit 1
							fi
						;;
				esac
			}
	printf "FileVault Users\n"
	PS3="Please select a user: "
	until [[ "$FVuserPicked" == "yes" ]]; do
		#printf "User List\n"
		select FVusr in ${FVUserList[@]}; do
		tput cuu1; tput cr; tput el;
			if [[ -z "$FVusr" ]];
				then
					echo "Error Found: Invalid Entry"
					sleep .5
					tput cuu1; tput cr; tput el;
					# Increases the variable for error checking
					let "errorCount++"
						# Exits the script if the max number of errors has been reached
						if [[ "$errorCount" == "3" ]];
							then
								echo "Max number of errors reached. Exiting"
								sleep .5
								exit 1
						fi
			elif [[ "$FVusr" == "QUIT" ]];
				then
					echo "Exiting.."
					sleep .5
					clear
					exit 0
			else
					# Sets the variable that is used in the until loop to skip the user selection menu
					FVuserPicked="yes"
					tput cuu1; tput cr; tput el;
					# Calls the function to verify the user that has been selected
					verifyFVUser
			fi
		done
	done
}

# A while loop that will call the pickUser function if it sees the variable for selectionComplete isn't set to true
while [[ "$FVselectionComplete" != "true" ]]; do
		pickFVUser
done

# If statement that sets the setUser variable with the user that has been selected above
if [[ "$FVselectionComplete" == true ]];
	then
		fvUserOld="$FVusr"
fi
}


adminCheck() {
	if groups $setUser | grep -q -w admin;
		then
			echo "Error Found: Access Denied"
			exit 1
			adminUser=true
	else
			adminUser=false
	fi
}

# Function to disable a user account
disableUser() {
# Verify the username variable isn't empty before continuing
if [[ -z "$setUser" ]];
	then
		echo "Required Field Missing: Username not chosen."
		echo "Exiting.."
		sleep 1
		clear
		exit
fi

# Check to see if the user account is already disabled
disableCheck=$(dscl . -read /Users/$setUser AuthenticationAuthority | grep -w ';DisabledUser;')

if [[ -z "$disableCheck" ]];
	then
		echo "$setUser is not already disabled. Continuing.."
		sudo dscl . -append /Users/$setUser AuthenticationAuthority \;DisabledUser\;
else
		echo "$setUser is already disabled. Exiting.."
		sleep .5
		exit 1
fi

verifyOption=$(dscl . -read /Users/$setUser AuthenticationAuthority | grep -w ';DisabledUser;')

if [[ ! -z "$verifyOption" ]];
	then
		echo "${boldon}${blinkon}$setUser has been disabled.${reset}"
		sleep 1
		clear
		exit 0
else
		echo "Unable to disable the account for $setUser."
		sleep 1
		exit 1
fi
}

# Function to delete a user account
deleteUser() {
# Verify the username variable isn't empty before continuing
if [[ -z "$setUser" ]];
	then
		echo "Required Field Missing: Username not chosen."
		echo "Exiting.."
		sleep 1
		clear
		exit
fi

# Creates the variable to set the error number count
errorsFound="0"

# Verifies the user exists once more before deleting the account to add another layer of validation
userCheck=$(dscl . -list /Users | grep -w "$setUser")

# If statement to verify and validate the user account does exist and will confirm with the user once more if they want to delete the account
if [[ ! -z "$userCheck" ]];
	then
		scriptTitle
		echo "Found account for $setUser .."
		# Asks the user once more if they want to delete the account for the selected user
		printf "${boldon}Are you sure you want to delete the account for $setUser?\n${TXTred}${blinkon}This action cannot be undone.${reset}\n"
		sleep 1
		printf "${boldon}Confirm Deletion?${boldoff} (y/n): "
		read verifyDelete
			tput cuu1; tput cr; tput el;
			case $verifyDelete in
				Y|y)
					echo "Deleting account for $setUser .."
					# Deletes the user from dscl
					sudo dscl . -delete /Users/"$setUser"
					# Deletes the user's home directory
					if [[ -z "$sharingAccount" ]];
						then
							sudo rm -rf /Users/"$setUser"/
					fi
					# Sets the variable to verify the actions performed above to true
					verifyAction=true
					;;
				N|n)
					echo "Deletion for ${setUser}'s account halted.."
					echo "Exiting.."
					sleep .5
					exit 0
					;;
				*)
					echo "Error Found: Invalid Entry"
					# Increases the number of errors found
					let "errorsFound++"
						# If statement to exit the script if the max number of errors has been reached (2)
						if [[ "$errorsFound" == "2" ]];
							then
								echo "Max Number of Errors Reached. Exiting.."
								sleep .5
								clear
								exit 1
						fi
					;;
			esac
fi

# If statement to verify the account was able to be deleted
if [[ "$verifyAction" == "true" ]];
	then
		# Searches for the user's account
		userSearch=`dscl . -list /Users | grep -w "$setUser"`
			if [[ -z "$userSearch" ]];
				then
					echo "The account for $setUser has been successfully deleted."
					sleep 1
					clear
					exit 0
			else
					echo "The account for $setUser was unable to be deleted."
					sleep 1
					clear
					exit 1
			fi
fi	
}

# Function to enable a user account
enableUser() {
# Verify the username variable isn't empty before continuing
if [[ -z "$setUser" ]];
	then
		echo "Required Field Missing: Username not chosen."
		echo "Exiting.."
		sleep 1
		clear
		exit
fi

# Check to see if the user account is already disabled
disableCheck=$(dscl . -read /Users/$setUser AuthenticationAuthority | grep -w ';DisabledUser;')

if [[ -z "$disableCheck" ]];
	then
		echo "$setUser is not disabled. Exiting.."
		sleep 1
		exit 0
else
		echo "$setUser is currently disabled. Continuing.."
		sudo dscl . -delete /Users/$setUser AuthenticationAuthority \;DisabledUser\;
fi

verifyOption=$(dscl . -read /Users/$setUser AuthenticationAuthority | grep -w ';DisabledUser;')

if [[ -z "$verifyOption" ]];
	then
		echo "${boldon}${blinkon}$setUser has been enabled.${reset}"
		sleep 1
		clear
		exit 0
else
		echo "Unable to enable the account for $setUser."
		sleep 1
		exit 1
fi
}

# Function to reset a user's password
resetPassword() {
# Verify the username variable isn't empty before continuing
if [[ -z "$setUser" ]];
	then
		echo "Required Field Missing: Username not chosen."
		echo "Exiting.."
		sleep 1
		clear
		exit
fi
	# Function to change the user's password
	getPW() {
		scriptTitle
		# Creates variable based on if the user wants the password to be visible while they enter it
		printf "Do you want the password to be visible while being entered? (Y/N): "
		read visiblePW
		tput cuu1; tput cr; tput el;
		case $visiblePW in
			y|yes|Y|Yes)
					readoption="read"
					;;
			n|no|N|No)
					readoption="read -s"
					;;
				*)
					printf "Using nonvisible option due to invalid input\n"
					readoption="read -s"
					;;
		esac
					

		# Creates variable to end the while loop if the password is found and matches
		passwordFound=false
		# Creates variable to exit the script if the max number of errors are reached (3)
		errorCount="0"

		while [[ "$passwordFound" == "false" ]]; do 
			printf "${boldon}Enter a password for $setUser:${boldoff}\n"
			$readoption userPW
			tput cuu1; tput cr; tput el;
				if [[ -z "$userPW" ]];
					then
						printf "Missing password for $setUser..\n"
						let "errorCount++"
						sleep 1
						tput cuu1; tput cr; tput el;
						tput cuu1; tput cr; tput el;
				else
					checkPassword=true
				fi

				if [[ "$checkPassword" == "true" ]];
					then
						printf "${boldon}Verify the password entered for $setUser:${boldoff}\n"
						$readoption verifyPW
						tput cuu1; tput cr; tput el;
							#while [[ "$passwordMatch" == "false" ]]; do
							if [[ "$userPW" == "$verifyPW" ]];
								then
									passwordFound=true
									tput cuu1; tput cr; tput el;
									tput cuu1; tput cr; tput el;
									#tput cuu1; tput cr; tput el;
									userPass="$userPW"
							else
									printf "Please enter matching passwords..\n"
									passwordFound=false
									sleep 1
									let "errorCount++"
									tput cuu1; tput cr; tput el;
									tput cuu1; tput cr; tput el;
							fi
							#done
				fi

			if [[ "$errorCount" == "3" ]];
				then
					printf "Max Amount of errors allowed. Exiting..\n"
					exit 1
			fi
		done
	}

addFVUser() {
scriptTitle

# Gets the username of a user that is currently enabled for FileVault
getFVUserList

scriptTitle

# Gets the password for the user that is entered above
printf "${boldon}Please enter the current FileVault Password for $fvUserOld${boldoff}: \n"
read -s fvUserOldPW

# Function to create the plist from the information entered above
makePlist() {
echo '
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>Username</key>
<string>'"$fvUserOld"'</string>
<key>Password</key>
<string>'"$fvUserOldPW"'</string>
<key>AdditionalUsers</key>
<array>
    <dict>
        <key>Username</key>
        <string>'"$setUser"'</string>
        <key>Password</key>
        <string>'"$userPass"'</string>
    </dict>
</array>
</dict>
</plist>'
}

# Creates a hidden plist in the /tmp directory that will readd the user to FileVault
makePlist > /tmp/fvlist.plist

# Adds the user back to FileVault
sudo fdesetup add -i < /tmp/fvlist.plist

# Deletes the plist that was used to add the user to FileVault
sudo rm -rf /tmp/.fvlist.plist
}

# FileVault Check (If FileVault is turned on, the user will have to be removed from the list of FileVault users before the password is changed, then added back to the list after the password change is complete. If this is not done, the user's FileVault password will not be updated with the new password.)
fvCheck=$(fdesetup status | grep "On")

if [[ ! -z "$fvCheck" ]];
	then
		fvStatus="on"
		fvUserCheck=$(sudo fdesetup list | grep "$setUser")
fi

if [[ -z "$fvStatus" ]];
	then
		getPW
		sudo dscl . passwd /Users/$setUser "$userPass"
		printf "The password for $setUser has been changed.\nWould you like to verify the change? (y/n): "
		read verifyAction
			case $verifyAction in 
				Y|y)
					echo "Verifying the password change. You will now be prompted to enter the password for $setUser"
					su "$setUser" -c 'echo "Password Changed Successfully"'
					sleep 1
					exit
					;;
				N|n)
					exit 0
					;;
				*)
					echo "Error Found: Invalid Entry.. Exiting"
					exit 1
					;;
			esac
elif [[ ! -z "$fvStatus" && -z "$fvUserCheck" ]];
	then
		getPW
		sudo dscl . passwd /Users/$setUser "$userPass"
		printf "The password for $setUser has been changed.\nWould you like to verify the change? (y/n): "
		read verifyAction
			case $verifyAction in 
				Y|y)
					echo "Verifying the password change. You will now be prompted to enter the password for $setUser"
					su "$setUser" -c 'echo "Password Changed Successfully"'
					sleep 1
					exit
					;;
				N|n)
					exit 0
					;;
				*)
					echo "Error Found: Invalid Entry.. Exiting"
					exit 1
					;;
			esac
elif [[ ! -z "$fvStatus" && ! -z "$fvUserCheck" ]];
	then
		scriptTitle
		printf "${boldon}$setUser is enabled for FileVault${boldoff}\n"
		printf "$setUser will be removed from the list of FileVault users before the password is changed in order for the new password to sync with FileVault. Once the password change is finished, $setUser will be re-added to the list of FileVault users.\n${TXTred}Note: If the user is unable to be re-added to the list of FileVault users, they will have to be manually added using the new password that was just set.${reset}\n"
		printf "Would you like to continue? (y/n): "
		read fvAnswer
			case $fvAnswer in
				Y|y)
					echo "Removing $setUser from FileVault.."
					sudo fdesetup remove -user $setUser
					verifyRemoval=$(sudo fdesetup list | grep "$setUser")
						# If statement to check if the user has been successfully removed from the list of FileVault users
						if [[ -z "$verifyRemoval" ]];
							then
								clear
								getPW
								sudo dscl . passwd /Users/$setUser "$userPass"
								printf "The password for $setUser has been changed. Would you like to verify the change? (y/n):\n"
								read verifyAction
									case $verifyAction in 
										Y|y)
											echo "Verifying the password change. You will now be prompted to enter the password for $setUser"
											su "$setUser" -c 'echo "Password Changed Successfully"'
											sleep 1
											clear
											addFVUser
											verifyAdd=$(sudo fdesetup list | grep "$setUser")
												if [[ -z "$verifyAdd" ]];
													then
														echo "$setUser was unable to be added back to the list of FileVault users. Please manually add $setUser back to FileVault."
														sleep 1
														exit
												else
														echo "$setUser has successfully been re-added back to the list of FileVault Users."
														sleep 1
														clear
												fi
											exit
											;;
										N|n)
											clear
											exit 0
											;;
										*)
											echo "Error Found: Invalid Entry.. Exiting"
											clear
											exit 1
											;;
									esac
						else
								echo "Unable to remove $setUser from FileVault. Please manually remove the user then run this again."
								sleep 1
								clear
								exit 1
						fi
						;;
				N|n)
					echo "Please remove the $setUser from the list of FileVault users then run this again."
					sleep 1
					clear
					exit 0
					;;
			esac
fi
}

#### Username ####
getUsername() {
	# Variable to exit the while loop after it validates the input for the username
	usernameFound=false
	# Variable to count the number of errors and exit when it reaches the max (3)
	errorCount="0"

	while [[ "$usernameFound" == "false" ]]; do
		printf "${boldon}Enter a username: ${boldoff}"
		read userName
			if [[ -z "$userName" ]];
				then
					printf "Missing Username..\n"
					let "errorCount++"
			else
					spacesFound=$(echo "$userName" | grep \  | wc -l | sed 's/^[[:space:]]*//')
						if [[ "$spacesFound" == "0" ]];
							then
								nospacesFound=true
								#homeDir="/Users/$userName"
						else
								tput cuu1; tput cr; tput el;
								printf "Error: Enter a username without spaces..\n"
								let "errorCount++"
								sleep 1
								#tput cuu1; tput cr; tput el;
								tput cuu1; tput cr; tput el;
						fi
					characterCheck=$(echo "$userName" | sed 's/[[:alnum:]]//g')
						if [[ "$nospacesFound" == "true" ]];
							then
								if [[ -z "$characterCheck" ]];
									then
										usernameFound=true
									else
										tput cuu1; tput cr; tput el;
										printf "Error: Enter a username with alphanumeric characters only..\n"
										let "errorCount++"
										sleep 1
										tput cuu1; tput cr; tput el;
								fi
						fi
			fi

			if [[ "$errorCount" == "3" ]];
				then
					printf "Max Amount of errors allowed. Exiting..\n"
					sleep 1
					clear
					exit 1
			fi
	done
}

#### First / Last Name Functions ####
fName() {
	# Variable that will stop the while loop once the first name has been entered
	firstnameFound=false

	# Variable to count the number of errors (Max Number is 3)
	errorCount="0"

	while [[ "$firstnameFound" == "false" ]]; do

		printf "${boldon}Enter the Full Name for${boldoff} $userName..\n"
		printf "${boldon}> First Name: ${boldoff}" 
		read firstName
			if [[ -z "$firstName" ]];
				then
					printf "Missing First Name for $userName..\n"
					let "errorCount++"
					sleep 1
					nameFound=false
					tput cuu1; tput cr; tput el;
					tput cuu1; tput cr; tput el;
					tput cuu1; tput cr; tput el;
			else
					nameFound=true
			fi

			if [[ "$nameFound" == "true" ]];
				then
					wordCount=$(echo "$firstName" | wc -w | sed 's/^[[:space:]]*//')
						if [[ "$wordCount" == "1" ]];
							then
								firstnameFound=true
						else
								printf "Please only enter the first name for $userName.\n"
								let "errorCount++"
								sleep 1
								tput cuu1; tput cr; tput el;
								tput cuu1; tput cr; tput el;
								tput cuu1; tput cr; tput el;
						fi
			fi


		if [[ "$errorCount" == "3" ]];
				then
					printf "Max Amount of errors allowed. Exiting..\n"
					exit 1
		fi
	done
}

lName() {
	# Variable that will stop the while loop once the last name has been entered
	lastnameFound=false

	# Variable to count the number of errors (Max Number is 3)
	errorCount="0"

	while [[ "$lastnameFound" == "false" ]]; do

		#printf "${boldon}Enter the Full Name for${boldoff} $userName..\n"
		printf "${boldon}> Last Name: ${boldoff}" 
		read lastName
			if [[ -z "$lastName" ]];
				then
					printf "Missing Last Name for $userName..\n"
					let "errorCount++"
					sleep 1
					nameFound=false
					tput cuu1; tput cr; tput el;
					tput cuu1; tput cr; tput el;
					#tput cuu1; tput cr; tput el;
			else
					nameFound=true
			fi

			if [[ "$nameFound" == "true" ]];
				then
					wordCount=$(echo "$lastName" | wc -w | sed 's/^[[:space:]]*//')
						if [[ "$wordCount" == "1" ]];
							then
								lastnameFound=true
						else
								printf "Please only enter the last name for $userName.\n"
								let "errorCount++"
								sleep 1
								tput cuu1; tput cr; tput el;
								tput cuu1; tput cr; tput el;
						fi
			fi


		if [[ "$errorCount" == "3" ]];
				then
					printf "Max Amount of errors allowed. Exiting..\n"
					exit 1
		fi
	done
}

# Function to create the user's password
getPW() {
	# Creates variable based on if the user wants the password to be visible while they enter it
	printf "Do you want the password to be visible while being entered? (Y/N): "
	read visiblePW
	tput cuu1; tput cr; tput el;
	case $visiblePW in
		y|yes|Y|Yes)
				readoption="read"
				;;
		n|no|N|No)
				readoption="read -s"
				;;
			*)
				printf "Using nonvisible option due to invalid input\n"
				readoption="read -s"
				;;
	esac
				

	# Creates variable to end the while loop if the password is found and matches
	passwordFound=false
	# Creates variable to exit the script if the max number of errors are reached (3)
	errorCount="0"

	while [[ "$passwordFound" == "false" ]]; do 
		printf "${boldon}Enter a password for $userName:${boldoff}\n"
		$readoption userPW
		tput cuu1; tput cr; tput el;
			if [[ -z "$userPW" ]];
				then
					printf "Missing password for $userName..\n"
					let "errorCount++"
					sleep 1
					tput cuu1; tput cr; tput el;
					tput cuu1; tput cr; tput el;
			else
				checkPassword=true
			fi

			if [[ "$checkPassword" == "true" ]];
				then
					printf "${boldon}Verify the password entered for $userName:${boldoff}\n"
					$readoption verifyPW
					tput cuu1; tput cr; tput el;
						#while [[ "$passwordMatch" == "false" ]]; do
						if [[ "$userPW" == "$verifyPW" ]];
							then
								passwordFound=true
								tput cuu1; tput cr; tput el;
								tput cuu1; tput cr; tput el;
								#tput cuu1; tput cr; tput el;
								userPass="$userPW"
						else
								printf "Please enter matching passwords..\n"
								passwordFound=false
								sleep 1
								let "errorCount++"
								tput cuu1; tput cr; tput el;
								tput cuu1; tput cr; tput el;
						fi
						#done
			fi

		if [[ "$errorCount" == "3" ]];
			then
				printf "Max Amount of errors allowed. Exiting..\n"
				exit 1
		fi
	done
}

# Function to select a user icon
selectUserPicture() {
pictureFound=false
# Creates variable to exit the script if the max number of errors are reached (3)
errorCount="0"

randomizeIcon() {
	iconLocation=(/Library/User\ Pictures/*)
	selectCatagory=`printf "%s\n" "${iconLocation[RANDOM % ${#iconLocation[@]}]}"`

	randomCatagory=`echo "$selectCatagory" | sed 's/[/Library/User\ Pictures/]*//'`

	catagoryLocation=(/Library/User\ Pictures/$randomCatagory/*)
	selectIcon=`printf "%s\n" "${catagoryLocation[RANDOM % ${#catagoryLocation[@]}]}"`
	getIcon=`echo "$selectIcon" | sed 's/[/Library/User\ Pictures/]*//'`
	confirmIcon=`echo "$getIcon" | sed 's/.*[/]//'`
}

customPictureFunction() {
selectedIcon=$(/usr/bin/osascript <<'APPLESCRIPT'
try
	set theUser to do shell script "who | grep \"console\" | cut -d\" \" -f1"
	set picturesHome to "/Users/" & theUser & "/Pictures"
	
	choose file with prompt "Select A User Image" of type {"png"} default location picturesHome
	
	set customUserPicture to the POSIX path of the result
	
	
on error errStr number errorNumber
	if the errorNumber is equal to -128 then
		set customUserPicture to "ErrorFound"
	end if
end try

customUserPicture

APPLESCRIPT
)

randomIcon() {
	iconLocation=(/Library/User\ Pictures/*)
	selectCatagory=`printf "%s\n" "${iconLocation[RANDOM % ${#iconLocation[@]}]}"`

	randomCatagory=`echo "$selectCatagory" | sed 's/[/Library/User\ Pictures/]*//'`

	catagoryLocation=(/Library/User\ Pictures/$randomCatagory/*)
	selectIcon=`printf "%s\n" "${catagoryLocation[RANDOM % ${#catagoryLocation[@]}]}"`
	getIcon=`echo "$selectIcon" | sed 's/[/Library/User\ Pictures/]*//'`
	confirmIcon=`echo "$getIcon" | sed 's/.*[/]//'`

while [[ "$approvedIcon" == "false" ]]; do
printf "${boldon}Use \"$confirmIcon\" ?${boldoff} ${italicon}(Yes/No)${italicoff}\n"
read iconAnswer
tput cuu1; tput cr; tput el;
	case $iconAnswer in
		yes | Yes | y | Y)
							tput cuu1; tput cr; tput el;
							printf "Using $confirmIcon\n"
							sleep 1
							tput cuu1; tput cr; tput el;
							approvedIcon=true
							pictureFound=true
							customFail=false
							validPicture=true
							userIcon="$selectIcon"
							iconPath="$selectIcon"
							;;
		no | No | n | N)
							tput cuu1; tput cr; tput el;
							printf "Generating a new icon\n"
							tput cuu1; tput cr; tput el;
							customFail=true
							randomIcon
							;;
	esac
done
}

if [[ "$selectedIcon" == "ErrorFound" ]];
	then
		printf "User Canceled. Would you like to have a random icon selected instead (Y/N)? "
		read tryAgain
			tput cuu1; tput cr; tput el;
			case $tryAgain in
				Y|y|Yes|yes)
							printf "Using a default user icon\n"
							sleep 1
							validPicture=true
							randomIcon
							printf "${boldon}Using \"$confirmIcon\"${boldoff}\n"
							iconPath="$selectIcon"
							;;
				N|n|No|no)
							customPictureFunction
							;;
			esac
else
		iconPath="$selectedIcon"
fi

}

while [[ "$pictureFound" == "false" ]]; do
	printf "${boldon}Select a picture for $userName${boldoff}\n"
	echo "${boldon}1)${boldoff} Default ${italicon}(Selects a picture from the system defaults at random)${italicoff}
${boldon}2)${boldoff} Custom Image ${italicon}(png format only)${italicoff}"
	read pictureType
	echo "$(tput cuu1)$(tput dl1)"
		case $pictureType in
			1)
				randomizeIcon
				approvedIcon=false
				while [[ "$approvedIcon" == "false" ]]; do
					printf "${boldon}Use \"$confirmIcon\" ?${boldoff} ${italicon}(Yes/No)${italicoff}\n"
					read iconAnswer
					tput cuu1; tput cr; tput el;
						case $iconAnswer in
							yes | Yes | y | Y)
												tput cuu1; tput cr; tput el;
												printf "Using $confirmIcon\n"
												sleep 1
												tput cuu1; tput cr; tput el;
												approvedIcon=true
												pictureFound=true
												userIcon="$selectIcon"
												;;
							no | No | n | N)
												tput cuu1; tput cr; tput el;
												printf "Generating a new icon\n"
												tput cuu1; tput cr; tput el;
												randomizeIcon
												;;
						esac
				done
				;;
			2)
				tput cuu1; tput cr; tput el;
				customPictureOption=true
				customPictureFunction
					validPicture=false
					errorCount="0"
					while [[ "$validPicture" == "false" ]]; do
						if [[ -z "$iconPath" ]];
							then
								tput cuu1; tput cr; tput el;
								printf "No Picture Selected.. Try again\n"
								sleep 2
								tput cuu1; tput cr; tput el;
								let "errorCount++"
								customPictureFunction
						else
							validPicture=true
						fi

						if [[ "$errorCount" == "3" ]];
							then
								printf "Max Amount of errors allowed. Exiting..\n"
								exit 1
						fi

					done
				userIcon="$iconPath"
				pictureFound=true
				;;
			*)
				printf "Invalid Entry.. please select again"
				let "errorCount++"
		esac
	if [[ "$errorCount" == "3" ]];
		then
			printf "Max Amount of errors allowed. Exiting..\n"
			exit 1
	fi
done	
}

# Function to create a user account from the variables created in the script
createUser () {
	# Runs the function to create the package
	createPKG

	sudo dscl . -create /Users/"$userName"
	sudo dscl . -create /Users/"$userName" UserShell "$userShell"
	sudo dscl . -create /Users/"$userName" RealName "$userRealName"
	sudo dscl . -create /Users/"$userName" UniqueID "$makeUID"
	sudo dscl . -create /Users/"$userName" PrimaryGroupID "$getID"
	sudo dscl . -create /Users/"$userName" NFSHomeDirectory "$homeDir"
	sudo dscl . passwd /Users/"$userName" "$userPass"
	sudo mkdir -p "$homeDir"
	sudo dscl . -create /Users/"$userName" Picture "$userIcon"

	printf "Account has been successfully created for $userName\n"
}

previewDSCLUser() {
clear
scriptTitle
printf "${boldon}Verify Account Information${boldoff}\n"
echo "
${boldon}Admin Account:${boldoff} $adminUser
${boldon}Username:${boldoff} $userName ${italicon}($makeUID)${italicoff}
${boldon}First Name:${boldoff} $firstName
${boldon}Last Name:${boldoff} $lastName
${boldon}Full Name:${boldoff} $userRealName
${boldon}User Icon:${boldoff} $userIcon
"

checkUser=("Username" "Real Name" "Password" "User Icon" "Other" "QUIT")

verifiedUser=false
while [[ "$verifiedUser" == "false" ]]; do
	printf "${boldon}Is the above information correct?${boldoff} (Y/N): "
	read correctInfo
	tput cuu1; tput cr; tput el;
			case $correctInfo in
				Y | y | yes | Yes)
							printf "Starting User Account Creation\n"
							sleep 1
							# Function that will create the user account based on the input from the user
							createUser
							### Add account creation verification here ###
							exit 0
							;;
				N | n | no | No)
							PS3="What field would you like to change?: "
							select userAnswer in "${checkUser[@]}"
							do
							#tput cuu1; tput cr; tput el;
								case $userAnswer in
									Username)
											clear
											scriptTitle
											printf "${boldon}Edit Username\n${boldoff}"	
											getUsername
												if [[ "$isHidden" == "true" ]];
													then
														homeDir="/private/var/$userName"
												else
														homeDir="/Users/$userName"
												fi
											verifiedUser=true
											previewDSCLUser
											break
											;;
								"Real Name")
											clear
											scriptTitle
											printf "${boldon}Edit First/Last Name\n${boldoff}"	
											fName
											lName
											userRealName="$firstName $lastName"
											verifiedUser=true
											previewDSCLUser
											break
											;;
									Password)
											clear
											scriptTitle
											printf "${boldon}Edit Password\n${boldoff}"	
											getPW
											verifiedUser=true
											previewDSCLUser
											break
											;;
								"User Icon")
											clear
											scriptTitle	
											printf "${boldon}Edit User Icon\n${boldoff}"
											selectUserPicture
											verifiedUser=true
											previewDSCLUser
											break
											;;
									Other)
											printf "To change additional information, please run this script again\n"
											printf "Good Bye..\n"
											sleep 1
											exit 0
											;;
									QUIT)
											exit 0
											;;
								esac
							done
							;;

				*)
							printf "Invalid Entry. Please try again"
							let "errorCount++"
							sleep 1
							#tput cuu1; tput cr; tput el;
							tput cuu1; tput cr; tput el;
							;;
			esac
		if [[ "$errorCount" == "3" ]];
			then
				printf "Max Amount of errors allowed. Exiting..\n"
				exit 1
		fi
done
}

accountManagement() {
errorCount="0"
validOption=false
clear
scriptTitle
adminHeader
printf "${boldon}Account Management${reset}\n"
PS3="Select a management option: "
while [[ "$validOption" == "false" ]]; do
	select managementOption in "${managementMenu[@]}"
	do
		case $managementOption in
			"Disable Standard User Account")
					clear
					scriptTitle
					printf "${boldon}Disable Standard User Account${boldoff}\n"
					getStandard
					disableUser
					echo "$setUser has been disabled."
					sleep 2
					validOption=true
					break
					;;
			"Admin: Disable Account")
					clear
					scriptTitle
					printf "${boldon}Disable Admin User Account${boldoff}\n"
					getAdmin
					disableUser
					echo "$setUser has been disabled."
					sleep 2
					validOption=true
					break
					gracefulExit=true
					;;
			"Enable Standard User Account") 
					clear
					scriptTitle
					printf "${boldon}Enable Standard User Account${boldoff}\n"
					getStandard
					enableUser
					echo "$setUser has been enabled"
					validOption=true
					break
					gracefulExit=true
					;;
			"Admin: Enable Account") 
					clear
					scriptTitle
					printf "${boldon}Enable Admin User Account${boldoff}\n"
					getAdmin
					enableUser
					echo "$setUser has been enabled"
					validOption=true
					break
					gracefulExit=true
					;;
			"Reset Standard User Password") 
					clear
					scriptTitle
					printf "${boldon}Reset Standard User Password${boldoff}\n"
					getStandard
					resetPassword
					#echo "The password for $setUser has been reset"
					validOption=true
					break
					gracefulExit=true
					;;
			"Admin: Reset Password") 
					clear
					scriptTitle
					printf "${boldon}Reset Admin User Password${boldoff}\n"
					getAdmin
					resetPassword
					echo "The password for $setUser has been reset"
					validOption=true
					break
					gracefulExit=true
					;;
			"Delete Standard User Account") 
					clear
					scriptTitle
					printf "${boldon}Delete Standard User Account${boldoff}\n"
					getStandard
					deleteUser
					echo "The account for $setUser has been deleted"
					validOption=true
					break
					gracefulExit=true
					;;
			"Delete Sharing Only Account") 
					clear
					scriptTitle
					printf "${boldon}Delete Sharing Only Account${boldoff}\n"
					getSharing
					sharingAccount=true
					deleteUser
					echo "The sharing only account $setUser has been deleted"
					validOption=true
					break
					gracefulExit=true
					;;
			"Admin: Delete Account") 
					clear
					scriptTitle
					printf "${boldon}Delete Admin User Account${boldoff}\n"
					getAdmin
					deleteUser
					echo "The account for $setUser has been deleted"
					validOption=true
					break
					gracefulExit=true
					;;
			"Go Back")
					clear
					mainOptions
					;;
			QUIT)
					clear
					exit 0
					;;

				*)
					printf "Invalid Entry.. please select again\n"
					sleep .5
					tput cuu1; tput cr; tput el;
					let "errorCount++"
					tput cuu1; tput cr; tput el;
						if [[ "$errorCount" == "3" ]];
							then
								printf "Max Amount of errors allowed. Exiting..\n"
								sleep 1
								clear
								exit 1
						fi
					;;	
			esac
	done
		
		if [[ "$errorCount" == "3" ]];
			then
				printf "Max Amount of errors allowed. Exiting..\n"
				exit 1
		fi
done				
}

standardUser() {
	clear
	scriptTitle
	# Set Standard Shell
	userShell="/bin/bash"

	# Get Standard UID
	makeUID="$makeUID500"

	# Get Standard GroupID
	getID="20"

	# Sets variable to reflect standard user
	adminUser=`printf "No (Standard Account)\n"`

	printf "${boldon}Standard Account Setup${reset}\n"
	printf "\n"

	# Username
	getUsername

	homeDir="/Users/$userName"

	# First Name
	fName

	# Last Name
	lName

	# Creates Real Name for user
	userRealName="$firstName $lastName"

	# Password
	getPW

	# User Icon
	selectUserPicture

	# Verify User Info
	previewDSCLUser

}

sharingUser() {
	clear
	scriptTitle
	# Set Standard Shell
	userShell="/usr/bin/false"

	# Get Standard UID
	makeUID="$makeUID500"

	# Get Standard GroupID
	getID="20"

	# Sets variable to reflect standard user
	adminUser=`printf "No (Sharing Only Account)\n"`

	printf "${boldon}Sharing Only Account Setup${reset}\n"
	printf "\n"

	# Username
	getUsername

	homeDir="/dev/null"

	# First Name
	fName

	# Last Name
	lName

	# Creates Real Name for user
	userRealName="$firstName $lastName"

	# Password
	getPW

	# User Icon
	selectUserPicture

	# Verify User Info
	previewDSCLUser

}

# Admin Account (Not Hidden)
adminUserVisible() {
	clear
	scriptTitle
	# Set Standard Shell
	userShell="/bin/bash"

	# Get Standard UID
	makeUID="$makeUID500"

	# Get Standard GroupID
	getID="80"


	adminUser=`printf "Yes\n${boldon}Hidden Account:${boldoff} No\n"`

	printf "${boldon}Admin Account${boldoff}${italicon}(Not Hidden)${reset}\n"
	printf "\n"

	homeDir="/Users/$userName"

	# Username
	getUsername
	homeDir="/Users/$userName"

	# First Name
	fName

	# Last Name
	lName

	# Creates Real Name for user
	userRealName="$firstName $lastName"

	# Password
	getPW

	# User Icon
	selectUserPicture

	# Verify User Info
	previewDSCLUser

}

# Admin Account (Hidden)
adminUserHidden() {
	clear
	scriptTitle

	isHidden=true

	# Set Standard Shell
	userShell="/bin/bash"

	# Get Standard UID
	makeUID="$makeUID400"

	# Get Standard GroupID
	getID="80"

	adminUser=`printf "Yes\n${boldon}Hidden Account:${boldoff} Yes\n"`

	homeDir="/private/var/$userName"

	printf "${boldon}Admin Account${boldoff}${italicon}(Hidden)${reset}\n"
	printf "\n"

	# Username
	getUsername

	# First Name
	fName

	# Last Name
	lName

	# Creates Real Name for user
	userRealName="$firstName $lastName (Hidden)"

	# Password
	getPW
	
	# User Icon
	selectUserPicture

	# Verify User Info
	previewDSCLUser

}

######
clear
gracefulExit=false

adminUser() {
currentUser=`who | grep "console" | cut -d" " -f1`

# Checks to see if the current user is a member of the admin group
if groups $currentUser | grep -q -w admin; 
    then 
    	echo "Admin Logged In"
        adminLoggedIn=true 
    else 
    	clear
    	scriptTitle
    	printf "${boldon}This script requires administrator credentials to continue.${boldoff}\n"
    	printf "\n"
    	printf "Please run this script with administrator credentials in order to continue.\n"
    	printf "Exiting.."
    	sleep 1
    	exit 1
fi
}

checkRoot() {
loginAttempted=false
if [[ "$EUID" -ne 0 ]];
  then 
  	printf "${boldon}This script requires commands to be run as root.${boldoff}\n"
  	printf "${italicon}Example: sudo sh CreateUserAccount.sh ${italicoff}\n"
  	sleep 1
  	clear
  	exit 1
fi
}

while getopts :ahc adminMenu
do
	case "$adminMenu" in
		a)
			adminUser
			if [[ "$adminLoggedIn" == "true" ]];
				then
					mainMenu=("Create Standard Account" "Create Admin Account" "Create Sharing Only Account" "Account Management" "QUIT")
					managementMenu=("Disable Standard User Account" "Enable Standard User Account" "Reset Standard User Password" "Delete Standard User Account" "Delete Sharing Only Account" "Admin: Disable Account" "Admin: Enable Account" "Admin: Reset Password" "Admin: Delete Account" "Go Back" "QUIT")
					elevatedSession="${TXTblue}${boldon}Administrator Mode ${reset}"
					adminOption=true
					clear
					scriptTitle
					checkRoot
			fi
			break
			;;
		h)
			needAdmin=false
			scriptHelp
			exit 0
			;;
		c)	needAdmin=false
			showCopyright
			exit 0
			;;
		*) 
			echo "invalid command"
			let "errorFound++"
				if [[ "$errorCount" == "3" ]];
					then
						printf "Max Amount of errors allowed. Exiting..\n"
						sleep 1
						clear
						exit 1
				fi
			;;
	esac
done

if [[ -z "$1" ]];
	then
		# Setting PS3 Prompt
		mainMenu=("Create Standard Account" "Create Admin Account" "Create Sharing Only Account" "Account Management" "QUIT")
		managementMenu=("Disable Standard User Account" "Enable Standard User Account" "Reset Standard User Password" "Delete Standard User Account" "Delete Sharing Only Account" "Go Back" "QUIT")
		adminOption=false
		needAdmin=true
		clear
		scriptTitle
		checkRoot
fi

adminHeader() {
	if [[ ! -z "$elevatedSession" ]];
		then
			echo "$elevatedSession"
	fi
}

mainOptions() {
	scriptTitle
	adminHeader
	COLUMNS="12"
	PS3="Enter an option: "
	select menuOption in "${mainMenu[@]}"
	do
	case $menuOption in
		"Create Standard Account")
			echo "${boldon}Create Standard Account ${boldoff}"
			standardUser
			createPKG
			gracefulExit=true
			break
			;;
		"Create Admin Account")
			clear
			scriptTitle
			echo "${boldon}Create Admin Account ${boldoff}"
				PS3="Select Account Type: "
				select hiddenUser in "Create Hidden Account" "Create Visible Account" "Go Back" "Quit"
				do
					case $hiddenUser in 
						"Create Hidden Account")
								adminUserHidden
								createPKG
								gracefulExit=true
								break
								;;
						"Create Visible Account")
								adminUserVisible
								gracefulExit=true
								createPKG
								break
								;;
						"Go Back")
								break
								;;
						QUIT)
								clear
								exit 0
								;;
							*)
								let "errorFound++"
								printf "Invalid Entry\n"
								break
								;;
					esac
				done
			break
			;;
		"Create Sharing Only Account")
			clear
			scriptTitle
			echo "${boldon}Create Sharing Only Account${boldoff}"
			sharingUser
			createPKG
			gracefulExit=true
			break
			;;
		"Account Management")
			echo "${boldon}Account Management ${boldoff}"
			accountManagement
			gracefulExit=true
			break
			;;	
		QUIT)
			echo "$(tput cuu1)$(tput dl1)Good Bye.."
			sleep 2
			clear
			exit 0
			;;

		*)
			echo "Error: Unknown Answer. Try again"
			sleep 2
			clear
			;;
	esac
done
}

while [[ "$gracefulExit" == "false" ]]; do
	clear
	mainOptions
done

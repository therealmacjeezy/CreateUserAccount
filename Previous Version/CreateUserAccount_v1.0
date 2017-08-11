#!/bin/sh

##########################################
# Create User Account Script				 
# Josh Harvey | josh[at]macjeezy.com 				 	 
# GitHub - github.com/therealmacjeezy    
# JAMFnation - therealmacjeezy			 
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
# sudo sh CreateUserAccount.sh
########################## Revision History ###########################
# 07-24-2017	Added Disable / Enable and Password Change functions 
# 		to the Account Management section.
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

userList() {
scriptTitle
printf "${boldon}Select a user type to create${reset}\n"
echo "
${boldon}1)${boldoff} Standard User
${boldon}2)${boldoff} Admin User ${italicon}(Not Hidden)${italicoff}
${boldon}3)${boldoff} Admin User ${italicon}(Hidden)${italicoff}
${boldon}4)${boldoff} FileVault User Placeholder
${boldon}5)${boldoff} Account Management

------ Other ------
${boldon}c)${boldoff} Copyright / Contact
${boldon}h)${boldoff} Help / Useage
${boldon}q)${boldoff} Exit
"
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
echo "${boldon}Create User Account Script${boldoff} - ${boldon} Version: ${boldoff}1.0${reset}

${boldon}Summary${reset}
	> This script will create a local user account on the computer.

${boldon}Useage${reset}
	${blinkon} > Coming Soon...${reset}"	
}

resetPassword() {
	printf "Enter the user you want to change the password for: "
	read setUser

	if [[ ! -z "$setUser" ]];
		then
			findUsers=`ls /Users | grep -w "$setUser"`
	else
			echo "Enter a username"
	fi

	if [[ -z "$findUsers" ]];
		then
			echo "Unable to find the username $setUser"
	else
			echo "$setUser is a valid account"
			foundUser=true
	fi

	adminCheck() {
		if groups $setUser | grep -q -w admin;
			then
				echo "Error Found.."
				exit 1
				adminUser=true
		else
				adminUser=false
		fi
	} 

	if [[ "$foundUser" == "true" ]];
		then
			adminCheck
	fi

	if [[ "$adminUser" == "false" ]];
		then
			getPW
			sudo dscl . passwd /Users/$setUser "$userPass"
	fi
}

disableUser() {
	printf "Enter the user you want to disable: "
read setUser

if [[ ! -z "$setUser" ]];
	then
		findUsers=`ls /Users | grep -w "$setUser"`
else
		echo "Enter a username"
fi

if [[ -z "$findUsers" ]];
	then
		echo "Unable to find the username $setUser"
else
		#echo "$setUser is a valid account"
		foundUser=true
fi

	adminCheck() {
		if groups $setUser | grep -q -w admin;
			then
				echo "Error Found.."
				exit 1
				adminUser=true
		else
				adminUser=false
		fi
	} 

if [[ "$foundUser" == "true" ]];
	then
		adminCheck
fi

if [[ "$adminUser" == "false" ]];
	then
		#sudo dscl . -delete /Users/"$setUser" AuthenticationAuthority
		sudo dscl . -append /Users/"$setUser" AuthenticationAuthority ";DisabledUser;"
		disableUser="done"
		checkUser=`dscl . read /Users/"$setUser" AuthenticationAuthority | grep "DisabledUser"`
fi

if [[ "$disableUser" == "done" ]];
	then
		if [[ -z "$checkUser" ]];
			then
				sleep 2
				echo "Error Found: User $setUser not disabled."
		else
				#echo "$setUser has been disabled"
				sleep 2
		fi
fi
}

enableUser() {
	printf "Enter the user you want to enable: "
read setUser

if [[ ! -z "$setUser" ]];
	then
		findUsers=`ls /Users | grep -w "$setUser"`
else
		echo "Enter a username"
fi

if [[ -z "$findUsers" ]];
	then
		echo "Unable to find the username $setUser"
else
		#echo "$setUser is a valid account"
		foundUser=true
fi

	adminCheck() {
		if groups $setUser | grep -q -w admin;
			then
				echo "Error Found.."
				exit 1
				adminUser=true
		else
				adminUser=false
		fi
	} 

if [[ "$foundUser" == "true" ]];
	then
		adminCheck
fi

if [[ "$adminUser" == "false" ]];
	then
		#sudo dscl . -delete /Users/"$setUser" AuthenticationAuthority
		sudo dscl . -create /Users/"$setUser" AuthenticationAuthority
		#echo "$setUser has been enabled."
		sleep 1
		#checkUser=`sudo dscl . read /Users/"$setUser" AuthenticationAuthority | grep "DisabledUser"`
fi

sleep 2
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
					spacesFound=`echo "$userName" | grep \  | wc -l | sed 's/^[[:space:]]*//'`
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
					characterCheck=`echo "$userName" | sed 's/[[:alnum:]]//g'`
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
					wordCount=`echo "$firstName" | wc -w | sed 's/^[[:space:]]*//'`
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
					wordCount=`echo "$lastName" | wc -w | sed 's/^[[:space:]]*//'`
						if [[ "$wordCount" == "1" ]];
							then
								lastnameFound=true
						else
								printf "Please only enter the last name for $userName.\n"
								let "errorCount++"
								sleep 1
								tput cuu1; tput cr; tput el;
								tput cuu1; tput cr; tput el;
								#tput cuu1; tput cr; tput el;
						fi
			fi


		if [[ "$errorCount" == "3" ]];
				then
					printf "Max Amount of errors allowed. Exiting..\n"
					exit 1
		fi
	done
}

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

selectUserPicture() {
# User Picture
pictureFound=false
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
	set picturesHome to (path to pictures folder)
	
	choose file with prompt "Select A User Image" of type {"png"} default location picturesHome
	
	set customUserPicture to the POSIX path of the result
	
	
on error errStr number errorNumber
	if the errorNumber is equal to -128 then
		set customUserPicture to "ErrorFound"
	end if
end try

customUserPicture

APPLESCRIPT)

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
		printf "User Canceled. Would you like to select a random icon instead (Y/N)? "
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

verifiedUser=false
while [[ "$verifiedUser" == "false" ]]; do
	printf "${boldon}Is the above information correct?${boldoff} (Y/N): "
	read correctInfo
	tput cuu1; tput cr; tput el;
			case $correctInfo in
				Y | y | yes | Yes)
							printf "Starting User Account Creation\n"
							sleep 1
							# Creating User function here
							#echo "beep boop beep.. making things.."
							createUser
							# Add account creation verification here
							exit 0
							;;
				N | n | no | No)
							printf "What field would you like to change? \n"
							printf "1) Username\n2) First/Last Name\n3) Password\n4) User Icon\n5) Other\n"
							read userAnswer
							tput cuu1; tput cr; tput el;
								case $userAnswer in
									1|username|Username)
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
											;;
									2|name|firstname|lastname)
											clear
											scriptTitle
											printf "${boldon}Edit First/Last Name\n${boldoff}"	
											fName
											lName
											userRealName="$firstName $lastName"
											verifiedUser=true
											previewDSCLUser
											;;
									3|password|Password)
											clear
											scriptTitle
											printf "${boldon}Edit Password\n${boldoff}"	
											getPW
											verifiedUser=true
											previewDSCLUser
											;;
									4|icon|picture|usericon)
											clear
											scriptTitle	
											printf "${boldon}Edit User Icon\n${boldoff}"
											selectUserPicture
											verifiedUser=true
											previewDSCLUser
											;;
									5|other)
											printf "To change additional information, please run this script again\n"
											printf "Good Bye..\n"
											sleep 1
											exit 0
											;;
								esac
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
printf "${boldon}Account Management${reset}\n"
	printf "${boldon}Select an option..${boldoff}\n"
	echo "
${boldon}1)${boldoff} Disable User
${boldon}2)${boldoff} Enable User
${boldon}3)${boldoff} Change User Password
${boldon}b)${boldoff} Go Back
${boldon}q)${boldoff} Quit
"

while [[ "$validOption" == "false" ]]; do
	printf "${boldon}Selection${blinkon}: ${reset}"
	read managementOption
	tput cuu1; tput cr; tput el;
		case $managementOption in
			1)
				clear
				scriptTitle
				printf "${boldon}Disable User Account${boldoff}\n"
				disableUser
				echo "$setUser has been disabled."
				sleep 2
				validOption=true
				;;
			2)
				clear
				scriptTitle
				printf "${boldon}Enable User Account${boldoff}\n"
				enableUser
				echo "$setUser has been enabled."
				sleep 2
				validOption=true
				;;
			3) 
				clear
				scriptTitle
				printf "${boldon}Change User Password${boldoff}\n"
				resetPassword
				echo "The password for $setUser has been reset"
				validOption=true
				;;
			b | B)
				clear
				validOption=true
				;;

			q | Q)
				exit 0
				;;

			*)
				printf "Invalid Entry.. please select again\n"
				sleep 2
				tput cuu1; tput cr; tput el;
				let "errorCount++"
				;;	
		esac
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
    	printf "This script requires administrator credentials to continue.\n"
    	printf "Please run this script with administrator credentials in order to continue.\n"
    	printf "Exiting.."
    	sleep 1
    	exit 1
fi
}

checkRoot() {
if [[ "$EUID" -ne 0 ]];
  then 
  	printf "This script requires commands to be run as root.\n"
  	sleep 1
  		printf "${boldon}Note:${boldoff} If a process has previously ran under the same terminal session in the last 15 minutes, you will ${underlineon}NOT${underlineoff} be prompted for a password.\n"
  		printf "Would you like to enter credentials to run this as root (Y/N)? "
  		read tryRoot
  			tput cuu1; tput cr; tput el;
  			case $tryRoot in
  				Y|y|Yes|yes)
						sudo echo
						loginAttempted=true
						;;
				N|n|No|no)
						printf "Please run this script as root.\n"
						printf "${italicon}Example: sudo sh CreateUserAccount.sh ${italicoff}\n"
						printf "Exiting..\n"
						sleep 1
						exit 0
						;;
			esac
fi
}

adminUser

if [[ "$adminLoggedIn" == "true" ]];
	then
		clear
		scriptTitle
		checkRoot
fi


while [[ "$gracefulExit" == "false" ]]; do
	clear
	userList
	printf "${boldon}Selection${blinkon}: ${reset}"
	read userType

	case $userType in
		1)
			echo "$(tput cuu1)$(tput dl1)Create Standard User"
			standardUser
			gracefulExit=true
			showCopyright
			;;
		2)
			echo "$(tput cuu1)$(tput dl1)Create Admin User ${italicon}(Not Hidden)${italicoff}"
			adminUserVisible
			gracefulExit=true
			showCopyright
			;;
		3)
			echo "$(tput cuu1)$(tput dl1)Create Admin User ${italicon}(Hidden)${italicoff}"
			adminUserHidden
			gracefulExit=true
			showCopyright
			;;
		4)
			echo "$(tput cuu1)$(tput dl1)Create FileVault User Placehold"
			printf "${blinkon}Coming Soon..${blinkoff}\n"
			sleep 2
			clear
			;;
		5)
			echo "$(tput cuu1)$(tput dl1)Account Management"
			accountManagement
			;;
		q|Q)
			echo "$(tput cuu1)$(tput dl1)Good Bye.."
			sleep 2
			clear
			exit 0
			;;
		h|H)
			echo "$(tput cuu1)$(tput dl1)"
			scriptHelp
			sleep 5
			clear
			;;
		c|C)
			echo "$(tput cuu1)$(tput dl1)"
			clear
			showCopyright
			gracefulExit=true
			;;
		*)
			echo "Error: Unknown Answer. Try again"
			sleep 2
			clear
			;;
	esac
done


workSpace() {
	
### Get GroupID
if [[ "$adminUser" = "true" ]];
	then
		groupID="80"
else
		groupID="20"
fi

### Get Home Directory
if [[ "$hideUser" == "true" ]];
	then
		homeDir="/private/var/$userName"
else
		homeDir="/Users/$userName"
fi


## Get Login Permissions
if [[ "$allowLogin" == "true" ]];
	then
		userShell="/bin/bash"
else
		userShell="/usr/bin/false"
fi
}



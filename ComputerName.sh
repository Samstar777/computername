#!/bin/sh

# Created By: Salim Ukani
# Date: Sep 21, 2022.
# Description: Script to set ComputerName with User Initials and Mac Model Name.

# Get current logged in user
getUser=$(ls -l /dev/console | awk '{ print $3 }')

# Get User's name | This field optional if you require, else hash it out
firstInitial=$(finger -s $getUser | head -2 | tail -n 1 | awk '{print toupper($2)}' | cut -c 1)
lastName=$(finger -s $getUser | head -2 | tail -n 1 | awk '{print toupper($3)}')

# Get Model Information
modelName=`system_profiler SPHardwareDataType | grep "Model Name" | awk '{print $3 $4}'`

if [[ "$modelName" == "MacBookPro" ]];
then
    modelabbr="MBP"
    echo "MacbookPro"
elif [[ "$modelName" == "MacBookAir" ]];
then
    modelabbr="MBA"
    echo "MacBookAir"
else 
    modelabbr="UN"
    echo "Unknown Model"
fi

computerName=$firstInitial$lastName"-"$modelabbr

# Set all the names in all the places
scutil --set ComputerName "$computerName"
scutil --set LocalHostName "$computerName"
scutil --set HostName "$computerName"

# Display new name and update JAMF
echo "New Computer Name: $computerName"
/usr/local/jamf/bin/jamf recon
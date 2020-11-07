#!/bin/bash

FILEPATH="./users.db"
BACKUPFOLDER="./backup"

function validateInput()
{
    validationResult=$(expr "$1" : "[A-Za-z]*$")

    if [ "$validationResult" -eq "0" ]; then
        echo "Invalid user $2! Only letters are allowed!"
        exit
    fi
}

function addUserToDb()
{
    echo "Please, enter user name:"
    read userName

    validateInput $userName "name"

    echo "Please, enter user role:"
    read userRole

    validateInput $userRole "role"

    echo "$userName, $userRole" >> $FILEPATH
}

function findUser()
{
    echo "Enter user name:"
    read userName

    res=$(grep $userName, $FILEPATH)

    if [ "$res" ]; then
        echo "$res"
    else
        echo "User not found"
    fi
}

function printFile()
{
    lineN=0
    while read -r line; do
        lineN=$((lineN+1))
        echo "$lineN. $line"
    done < $FILEPATH
}

function backup()
{
    fileName=$(date +"%m_%d_%Y"-users.db.backup)
    [ ! -d $BACKUPFOLDER ] && mkdir -p $BACKUPFOLDER
    touch $BACKUPFOLDER/$fileName

    cat $FILEPATH > $BACKUPFOLDER/$fileName
}

function restore()
{
    backupFileName=$(ls -t $BACKUPFOLDER | head -1)

    if [ ! $backupFileName ]; then
        echo "No backup file found"
        exit
    fi

    cat "$BACKUPFOLDER/$backupFileName" > "$FILEPATH"
}

function printHelp()
{
    echo -e "\n\nadd\n\tAdd new entity to db\nbackup\n\tCreate new backup file based on users.db file\nrestore\n\tRestore data from latest created backup file\nfind\n\tFind information in db by user name\nlist\n\tPrint content of users.db file to screen\nhelp\n\tPrint instruction how to user this script :)\n\n"
}


case $1 in
    add)
        addUserToDb
        ;;
    backup)
        backup
        ;;
    restore)
        restore
        ;;
    find)
        findUser
        ;;
    list)
        printFile
        ;;
    help | "")
        printHelp
        ;;
    *)
        echo "Command not found"
        ;;
esac

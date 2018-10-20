installpath=$1

# checking if the folder at the install path exists. 
# if it does, blow it away
if [[ -d ${installpath} ]]; then
    echo are you sure you want to delete the current installation? [y/N]
    read deleteAns
    if [[ $deleteAns == 'y' ]]; then
        echo deleting current installation and starting over
        rm -r ${installpath}
    else
        echo exiting... 
        exit
    fi
fi

echo making folder for ASAS in nobackup
mkdir ${installpath}

filterFile=modules/appSearch/DescriptionFilter.list

if [ ! -f $filterFile ]; then
    log "Creating DescriptionFilter"
    touch $filterFile
    log "Please input a string to search by:" "prompt"
    read answer
    printf "$answer\n" >> $filterFile
else
    log "Loaded the fowllowing strings from the filter:"
    while read line; do
        log "   $line\n" "raw"
    done < $filterFile

    yesNo "would you like to keep the current search strings"

    if [ "$?" = "1" ]; then
        rm $filterFile
        log "Please input a string to search by:" "prompt"
        read answer
        printf "$answer\n" >> $filterFile
    fi
fi

yesNo "Would you like to add a string?"
if [ "$?" = "0" ]; then
    while true; do
        log "Please input a string to search by:" "prompt"
        read answer
        printf "$answer\n" >> $filterFile

        yesNo "Would you like to add a string?"
        if [ "$?" = "1" ]; then
            break
        fi
    done
fi

filterStrings=""
while read line; do
    if [ "$filterStrings" = "" ]; then
        filterStrings="$line"
    else
        filterStrings="$filterStrings\\|$line"
    fi
done < <(cat $filterFile)

echo "$filterStrings"

log "Generating description list " "nobreak"
i=0
sp="/-\|"
for app in $(dpkg-query --show | awk '{print $1}')
do
    printf "\b${sp:i++%${#sp}:1}"
    while read description; do
        printf "$app:\n$description\n\n" >> modules/appSearch/installedPackagesDescriptions.list
    done < <(apt-cache show $app | grep Description-en:)
done
printf "\n\n"

cat modules/appSearch/installedPackagesDescriptions.list | grep --before-context=1 \'$filterStrings\'
rm modules/appSearch/installedPackagesDescriptions.list

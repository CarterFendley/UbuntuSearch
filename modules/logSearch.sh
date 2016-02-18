filterFile=modules/LogFilter.list

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

function recursiveGrep() {
    for file in $1/*; do
        if [ -d "$file" ]; then
            recursiveGrep $file $2
        fi

        if [ -s "$files"]; then
            #echo " found none zero size file"
            if [ ! "${filename##*.}" = "gz" ]; then
                while read lineNumber; do
                    log "pattern found in file \"$file\" at line: $lineNumber"
                    lineContents=$(sed "${lineNumber}q;d" $file)
                    log "   $lineContents\n" "raw"
                done < <(grep -n \'$2\' $file | cut -d : -f 1)
            fi
        fi
    done
}

recursiveGrep "/var/log" "$filterStrings"

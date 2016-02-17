log "Generating description list " "nobreak"
i=0
sp="/-\|"
for app in $(dpkg-query --show | awk '{print $1}')
do
    printf "\b${sp:i++%${#sp}:1}"
    while read description; do
        printf "$app: $description\n\n" >> modules/appSearch/installedPackagesDescriptions.list
    done < <(apt-cache show $app | grep Description-en:)
done
printf "\n"

cat modules/appSearch/installedPackagesDescriptions.list | more
rm modules/appSearch/installedPackagesDescriptions.list

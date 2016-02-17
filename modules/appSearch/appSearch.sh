function getSearchType() {
    log "Please select one of the operations below"
    log "   [1] List applications with descriptions\n" "raw"
    log "   [2] Search application by descriptons\n" "raw"
    log "   [3] Exit/Return\n" "raw"
    log "Please input the number of the operation to be preformed:" "prompt"

    read answer
    return $answer
}

while true
do
    printf "\n"
    getSearchType
    op=$?

    case $op in
        1)
            ./modules/appSearch/listDescriptions.sh
            ;;
        2)
            ./modules/appSearch/filterByDescription.sh
            ;;
        3)
            log "Quiting UbuntuSearch" "success"
            exit 0
            ;;
        *)
            log "error in running requested task" "error"
            ;;
    esac
done

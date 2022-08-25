#!/bin/bash 
# Trying to write a todo bash script to master by Bash skills
# todo add, edit,done, remove, implement sed


todoaddfunc () {
    LIST="$(echo -e "$@" | cut -f2 -d" ")"
    if [ -z "$LIST" ]; then
        helpfunc
        exit 1
    fi
    TODO_ITEM="$(echo -e "$@" | cut -f3- -d" ")"
    if [ -z "$TODO_ITEM" ]; then
        echo -e "Item input required!"
        echo
        helpfunc
        exit 1
    fi
    if [ -d "$TODO_DIR"/"$LIST" ]; then
        FILE_NAME="$(($(dir "$TODO_DIR"/"$LIST" | wc -w)+1))"
    else
        mkdir "$TODO_DIR"/"$LIST"
        FILE_NAME="1"
    fi
    if echo -e "$@" | cut -f3 -d" " | grep -q '='; then
        IMPORTANT_LEVEL="$(echo -e "$@" | cut -f2 -d"=" | cut -f1 -d" ")"
        TODO_ITEM="$(echo -e "$@" | cut -f4- -d" ")"
        case $IMPORTANT_LEVEL in
            4)
                echo -e "- \e[31m$TODO_ITEM\e[39m" > "$TODO_DIR"/"$LIST"/"$FILE_NAME"
                echo -e "Item \"\e[31m$TODO_ITEM\e[39m\" added to $LIST list!"
                ;;
            3)
                echo -e "- \e[33m$TODO_ITEM\e[39m" > "$TODO_DIR"/"$LIST"/"$FILE_NAME"
                echo -e "Item \"\e[33m$TODO_ITEM\e[39m\" added to $LIST list!"
                ;;
            2)
                echo -e "- \e[32m$TODO_ITEM\e[39m" > "$TODO_DIR"/"$LIST"/"$FILE_NAME"
                echo -e "Item \"\e[32m$TODO_ITEM\e[39m\" added to $LIST list!"
                ;;
            0)
                echo -e "- \e[90m$TODO_ITEM\e[39m" > "$TODO_DIR"/"$LIST"/"$FILE_NAME"
                echo -e "Item \"\e[90m$TODO_ITEM\e[39m\" added to $LIST list!"
                ;;
            *)
                echo -e "- \e[39m$TODO_ITEM\e[39m" > "$TODO_DIR"/"$LIST"/"$FILE_NAME"
                echo -e "Item \"\e[39m$TODO_ITEM\e[39m\" added to $LIST list!"
                ;;
        esac
    else
        echo -e "- \e[39m$TODO_ITEM\e[39m" > "$TODO_DIR"/"$LIST"/"$FILE_NAME"
        echo -e "Item \"$TODO_ITEM\" added to $LIST list!"
    fi
}

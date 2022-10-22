#!/bin/bash 
# Trying to write a todo bash script to master by Bash skills
# todo add, edit,done, remove, implement sed

#Add ele func
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

#Remove ele func

todormfunc () {
    LIST="$(echo -e "$@" | cut -f2 -d" ")"
    if [ -z "$LIST" ]; then
        helpfunc
        exit 1
    fi
    ITEM_CHECK="$(echo -e "$@" | cut -f3 -d" ")"
    if [ -z "$ITEM_CHECK" ]; then
        echo -e "Item input required!"
        echo
        helpfunc
        exit 1
    fi
    case $ITEM_CHECK in
        all)
            read -p "Remove all items in $LIST? Y/N " RMANSWER
            echo
            case $RMANSWER in
                y*|Y*)
                    rm -rf "$TODO_DIR"/"$LIST"
                    echo -e "All items in $LIST have been removed!"
                    ;;
                *)
                    echo -e "Items in $LIST were not removed."
                    ;;
            esac
            ;;
        *)
            TODO_ITEM="$(echo -e "$@" | cut -f3 -d" ")"
            if [ -z "$TODO_ITEM" ]; then
                echo -e "Item input required!"
                helpfunc
                exit 1
            fi
            if [ -f "$TODO_DIR"/"$LIST"/"$TODO_ITEM" ]; then
                echo -e "Item $TODO_ITEM removed from $LIST!"
                cat "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                rm "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                if [ "$(dir "$TODO_DIR"/"$LIST" | wc -w)" = "0" ]; then
                    rm -r "$TODO_DIR"/"$LIST"
                else
                    for file in $(dir -C -w 1 "$TODO_DIR"/"$LIST" | sort -n); do
                        if [ "$file" -gt "$TODO_ITEM" ]; then
                            FILE_NAME="$(($file-1))"
                            mv "$TODO_DIR"/"$LIST"/"$file" "$TODO_DIR"/"$LIST"/"$FILE_NAME"
                        fi
                    done
                fi
            else
                echo -e "Item $TODO_ITEM not found in $LIST!"
                exit 1
            fi
            ;;
    esac
}

#Edit ele func
todoeditfunc () {
    LIST="$(echo -e "$@" | cut -f2 -d" ")"
    if [ -z "$LIST" ]; then
        helpfunc
        exit 1
    fi
    if echo -e "$@" | cut -f4 -d" " | grep -q '='; then
        IMPORTANT_LEVEL="$(echo -e "$@" | cut -f2 -d"=" | cut -f1 -d" ")"
        TODO_ITEM="$(echo -e "$@" | cut -f3 -d" ")"
        if [ -f "$TODO_DIR"/"$LIST"/"$TODO_ITEM" ]; then
            case $IMPORTANT_LEVEL in
                4)
                    sed -i 's%- \x1b\[[0-9;]*m%- \x1b\[31m%g' "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                    sed -i 's%✘ \x1b\[[0-9;]*m%✘ \x1b\[31m%g' "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                    echo -e "Item \"$TODO_ITEM\" in $LIST changed to importance level 4!"
                    ;;
                3)
                    sed -i 's%- \x1b\[[0-9;]*m%- \x1b\[33m%g' "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                    sed -i 's%✘ \x1b\[[0-9;]*m%✘ \x1b\[33m%g' "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                    echo -e "Item \"$TODO_ITEM\" in $LIST changed to importance level 3!"
                    ;;
                2)
                    sed -i 's%- \x1b\[[0-9;]*m%- \x1b\[32m%g' "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                    sed -i 's%✘ \x1b\[[0-9;]*m%✘ \x1b\[32m%g' "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                    echo -e "Item \"$TODO_ITEM\" in $LIST changed to importance level 2!"
                    ;;
                0)
                    sed -i 's%- \x1b\[[0-9;]*m%- \x1b\[90m%g' "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                    sed -i 's%✘ \x1b\[[0-9;]*m%✘ \x1b\[90m%g' "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                    echo -e "Item \"$TODO_ITEM\" in $LIST changed to importance level 0!"
                    ;;
                *)
                    sed -i 's%- \x1b\[[0-9;]*m%- \x1b\[39m%g' "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                    sed -i 's%✘ \x1b\[[0-9;]*m%✘ \x1b\[39m%g' "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                    echo -e "Item \"$TODO_ITEM\" in $LIST changed to importance level 1!"
                    ;;
            esac
        else
            echo -e "Item $TODO_ITEM not found in $LIST!"
            exit 1
        fi
    else
        TODO_ITEM="$(echo -e "$@" | cut -f3 -d" ")"
        if [ -f "$TODO_DIR"/"$LIST"/"$TODO_ITEM" ]; then
            $EDITOR "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
        else
            echo -e "Item $TODO_ITEM not found in $LIST!"
            exit 1
        fi
    fi
}

#Wr done func
tododonefunc () {
    LIST="$(echo -e "$@" | cut -f2 -d" ")"
    if [ -z "$LIST" ]; then
        helpfunc
        exit 1
    fi
    TODO_ITEM="$(echo -e "$@" | cut -f3 -d" ")"
    case $TODO_ITEM in
        all)
            echo "Marking all items in $LIST as done..."
            for TODO_ITEM in $(dir -C -w 1 "$TODO_DIR"/"$LIST" | sort -n); do
                if [ -f "$TODO_DIR"/"$LIST"/"$TODO_ITEM" ]; then
                    sed -i 's%- %✘ %g' "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                    cat "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                else
                    echo -e "Item $TODO_ITEM not found in $LIST!"
                    exit 1
                fi
            done
            ;;
        *)
            if [ -f "$TODO_DIR"/"$LIST"/"$TODO_ITEM" ]; then
                sed -i 's%- %✘ %g' "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                echo -e "Item $TODO_ITEM marked as done in $LIST!"
                cat "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
            else
                echo -e "Item $TODO_ITEM not found in $LIST!"
                exit 1
            fi
            ;;
    esac
}

#Undo func
todoundofunc () {
    LIST="$(echo -e "$@" | cut -f2 -d" ")"
    if [ -z "$LIST" ]; then
        helpfunc
        exit 1
    fi
    TODO_ITEM="$(echo -e "$@" | cut -f3 -d" ")"
    case $TODO_ITEM in
        all)
            echo "Marking all items in $LIST as not done..."
            for TODO_ITEM in $(dir -C -w 1 "$TODO_DIR"/"$LIST" | sort -n); do
                if [ -f "$TODO_DIR"/"$LIST"/"$TODO_ITEM" ]; then
                    sed -i 's%✘ %- %g' "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                    cat "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                else
                    echo -e "Item $TODO_ITEM not found in $LIST!"
                    exit 1
                fi
            done
            ;;
        *)
            if [ -f "$TODO_DIR"/"$LIST"/"$TODO_ITEM" ]; then
                sed -i 's%✘ %- %g' "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
                echo -e "Item $TODO_ITEM marked as not done in $LIST!"
                cat "$TODO_DIR"/"$LIST"/"$TODO_ITEM"
            else
                echo -e "Item $TODO_ITEM not found in $LIST!"
                exit 1
            fi
            ;;
    esac
}



# move within list
todomvwithinlistfunc () {
    if [ ! -f "$TODO_DIR"/"$LIST"/"$TODO_ITEM_1" ] || [ ! -f "$TODO_DIR"/"$LIST"/"$TODO_ITEM_2" ]; then
        echo "Items $TODO_ITEM_1 and/or $TODO_ITEM_2 not found in $LIST!"
        exit 1
    fi
    mv "$TODO_DIR"/"$LIST"/"$TODO_ITEM_1" "$TODO_DIR"/"$LIST"/"$TODO_ITEM_1"-save
    if [ "$TODO_ITEM_1" -gt "$TODO_ITEM_2" ]; then
        for file in $(dir -C -w 1 "$TODO_DIR"/"$LIST" | grep -v '.*-save' | sort -n); do
            if [ "$file" -le "$TODO_ITEM_1" ] && [ "$file" -ge "$TODO_ITEM_2" ]; then
                mv "$TODO_DIR"/"$LIST"/"$file" "$TODO_DIR"/"$LIST"/"$file"-temp
            fi
        done
        for file in $(dir -C -w 1 "$TODO_DIR"/"$LIST" | grep '.*-temp' | sort -n); do
            FILE_NAME="$(echo "$file" | cut -f1 -d"-")"
            if [ "$FILE_NAME" -le "$TODO_ITEM_1" ]; then
                FILE_NAME="$(($FILE_NAME+1))"
                mv "$TODO_DIR"/"$LIST"/"$file" "$TODO_DIR"/"$LIST"/"$FILE_NAME"
            fi
        done
    else
        for file in $(dir -C -w 1 "$TODO_DIR"/"$LIST" | grep -v '.*-save' | sort -n); do
            if [ "$file" -le "$TODO_ITEM_2" ] && [ "$file" -ge "$TODO_ITEM_1" ]; then
                mv "$TODO_DIR"/"$LIST"/"$file" "$TODO_DIR"/"$LIST"/"$file"-temp
            fi
        done
        for file in $(dir -C -w 1 "$TODO_DIR"/"$LIST" | grep '.*-temp' | sort -n); do
            FILE_NAME="$(echo "$file" | cut -f1 -d"-")"
            if [ "$FILE_NAME" -le "$TODO_ITEM_2" ]; then
                FILE_NAME="$(($FILE_NAME-1))"
                mv "$TODO_DIR"/"$LIST"/"$file" "$TODO_DIR"/"$LIST"/"$FILE_NAME"
            fi
        done
    fi
    mv "$TODO_DIR"/"$LIST"/"$TODO_ITEM_1"-save "$TODO_DIR"/"$LIST"/"$TODO_ITEM_2"
    echo "Item $TODO_ITEM_1 moved to position $TODO_ITEM_2 in $LIST!"
}


#move items in the list
todomvitemlistfunc () {
    LIST_2="$TODO_ITEM_2"
    if [ ! -f "$TODO_DIR"/"$LIST"/"$TODO_ITEM_1" ]; then
        echo "Item $TODO_ITEM_1 not found in $LIST!"
        exit 1
    fi
    if [ ! -d "$TODO_DIR"/"$LIST_2" ]; then
        mkdir "$TODO_DIR"/"$LIST_2"
    fi
    FILE_NAME="$(($(dir "$TODO_DIR"/"$LIST_2" | wc -w)+1))"
    mv "$TODO_DIR"/"$LIST"/"$TODO_ITEM_1" "$TODO_DIR"/"$LIST_2"/"$FILE_NAME"
    echo "Item $TODO_ITEM_1 has been moved from $LIST to $LIST_2!"
    if [ "$(dir "$TODO_DIR"/"$LIST" | wc -w)" = "0" ]; then
        rm -r "$TODO_DIR"/"$LIST"
    else
        for file in $(dir -C -w 1 "$TODO_DIR"/"$LIST" | sort -n); do
            if [ "$file" -gt "$TODO_ITEM_1" ]; then
                FILE_NAME="$(($file-1))"
                mv "$TODO_DIR"/"$LIST"/"$file" "$TODO_DIR"/"$LIST"/"$FILE_NAME"
            fi
        done
    fi
}

#mv listing
todomvlistlistfunc () {
    LIST_2="$TODO_ITEM_1"
    if [ ! -d "$TODO_DIR"/"$LIST_2" ]; then
        mkdir "$TODO_DIR"/"$LIST_2"
    fi
    for item in $(dir -C -w 1 "$TODO_DIR"/"$LIST" | sort -n); do
        FILE_NAME="$(($(dir "$TODO_DIR"/"$LIST_2" | wc -w)+1))"
        mv "$TODO_DIR"/"$LIST"/"$item" "$TODO_DIR"/"$LIST_2"/"$FILE_NAME"
    done
    echo "All items in $LIST moved to $LIST_2!"
    rm -r "$TODO_DIR"/"$LIST"
}

#mv func
todomvfunc () {
    LIST="$(echo -e "$@" | cut -f2 -d" ")"
    if [ -z "$LIST" ]; then
        helpfunc
        exit 1
    elif [ ! -d "$TODO_DIR"/"$LIST" ]; then
        echo "$LIST does not exist!"
        exit 1
    fi
    TODO_ITEM_1="$(echo -e "$@" | cut -f3 -d" ")"
    TODO_ITEM_2="$(echo -e "$@" | cut -f4 -d" ")"
    if [ "$TODO_ITEM_1" = "$TODO_ITEM_2" ]; then
        echo "$TODO_ITEM_1 and $TODO_ITEM_2 are the same!"
        exit 1
    elif [ "$TODO_ITEM_1" = "$LIST" ]; then
        echo "$TODO_ITEM_1 and $LIST are the same!"
        exit 1
    fi
    case $TODO_ITEM_1 in
        1*|2*|3*|4*|5*|6*|7*|8*|9*)
            case $TODO_ITEM_2 in
                1*|2*|3*|4*|5*|6*|7*|8*|9*)
                    todomvwithinlistfunc
                    ;;
                *)
                    todomvitemlistfunc
                    ;;
            esac
            ;;
        *)
            todomvlistlistfunc
            ;;
    esac
}


#List func
todolistfunc () {
    LIST="$(echo -e "$@" | cut -f2 -d" ")"
    if [ "$(dir "$TODO_DIR" | wc -w)" = "0" ]; then
        echo -e "No lists made yet!"
        echo
        helpfunc
        exit 1
    fi
    if [ -z "$LIST" ]; then
        echo
        echo -e "$(tput bold)All todo lists$(tput sgr0):"
        echo
        for dir in $(dir "$TODO_DIR"); do
            echo -e "$(tput bold)$dir$(tput sgr0):"
            for file in $(dir -C -w 1 "$TODO_DIR"/"$dir" | sort -n); do
                if [ "$file" -lt "10" ]; then
                    echo -e " $file $(cat "$TODO_DIR"/"$dir"/"$file")"
                else
                    echo -e "$file $(cat "$TODO_DIR"/"$dir"/"$file")"
                fi
            done
            echo
        done
    else
        if [ -d "$TODO_DIR"/"$LIST" ]; then
                echo
                echo -e "$(tput bold)$LIST$(tput sgr0):"
                for file in $(dir -C -w 1 "$TODO_DIR"/"$LIST" | sort -n); do
                    if [ "$file" -lt "10" ]; then
                        echo -e " $file $(cat "$TODO_DIR"/"$LIST"/"$file")"
                    else
                        echo -e "$file $(cat "$TODO_DIR"/"$LIST"/"$file")"
                    fi
                done
                echo
        else
            echo -e "$LIST not found!"
            exit 1
        fi
    fi
}


if [ -z "$TODO_DIR" ]; then
    TODO_DIR="$HOME/.todo"
fi
if [ ! -d "$TODO_DIR" ]; then
    mkdir "$TODO_DIR"
fi

#!/bin/bash

# output usage info
function help {
    echo -e "\nHelp on $0 <password_length> <option>\n"
    echo "Generates random passwords for users list"
    echo "---"
    echo "Input:"
    echo "    The list of users should be provided with .txt file"
    echo "    Each line of .txt file should contains single user login"
    echo "---"
    echo "Output:"
    echo "    Generated passwords will be written to result.csv file"
    echo "    Format of output: <login> <password>"
    echo "---"
    echo "Options:"
    echo -e "    -p   :   print .csv file to console after successful generation of passwords\n"
}

# processing possible errors
function check_errors {
    # check 1st param to be a number -> if not print error message, pring help and exit with code 1
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
	echo "Error. Not a number given as <password_length> param."
	help   # call help pring function
	exit 1
    fi

    # check given file path -> if file is not suitable print error message, print help and exit with code 1
    if [ ! -f $INPUT_PATH ] || [ ! -r $INPUT_PATH ]; then
	echo "Error. $INPUT_PATH is not readable .txt file."
	help   # call help pring function
	exit 1
    fi

    # check pwgen existance -> if not installed print error message, print help and exit with code 1
    if ! command -v pwgen &> /dev/null; then
	echo "Error. pwgen is not installed."
	help   # call help print function
	exit 1
    fi
}

# generating passwords
function gen_passwords {
    # varaible of input file path
    local INPUT_PATH

    # get users login .txt file path from std input
    read -p "Input users .txt file path: " INPUT_PATH

    # call to check some possible errors
    check_errors $*

    # creating output .csv file and head columns in it
    echo "login,password" > results.csv

    # read line from input file, generate password, output generated password to .csv file
    while read login; do
	local password=$(pwgen -1 -s $1)        # use pwgen to generate password with given length
	echo "$login,$password" >> results.csv  # output login and generated password to .csv file
    done < $INPUT_PATH

    # output info about successful completition of password generation
    echo "Success. Passwords was generated!"

    # if second parameter == -p -> print .csv file
    if [ "$2" == "-p" ]; then
    	cat results.csv   # print .csv file to console
    # if parameters number == 2 -> unknown option was passed, print warning
    elif [ $# -eq 2 ]; then
        echo "Warning. Unknown option $2. Nothing was done." 
    fi
}

# main function
function main {
    # if script was called without arguments -> print help
    if [ $# -lt 1 ]; then
	help
	exit 1
    # if any arguments given -> try to generate passwords
    else
	gen_passwords $*
    fi
}

# call main function
main $*

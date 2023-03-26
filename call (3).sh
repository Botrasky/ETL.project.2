!/bin/bash

source functions.sh

run_sales

if [ $? == 1 ]; then
    echo "Send message to telegram - Process is failed!"
    # Terminate
    exit 1 # Exist if the process fail
fi



run_product

if [ $? == 1 ]; then
    echo "Send message to telegram - Process is failed!"
    # Terminate
    exit 1 # Exist if the process fail
fi


run_customer

if [ $? == 1 ]; then
    echo "Send message to telegram - Process is failed!"
    # TerminateS
    exit 1 # Exist if the process fail
fi

run_transform

sendFile
if [ $? == 1 ]; then
    echo "Send message to telegram - Process is failed!"
    # Terminate
    exit 1 # Exist if the process fail
fi





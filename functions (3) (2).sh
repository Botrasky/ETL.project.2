#!/bin/bash

#show commands being executed, per debug
set -x

# define database connectivity - global vars
_db=db_name
_db_user=root

_db_password=password
_db_host=localhost
_db_port=3306
_sql_dir=/var/lib/mysql-files/
_file_url=/home/atemis/ETL/


function run_sales()
{


sale_file="SALES.csv"
entry_sale=${_file_url}${sale_file}


if [ -f "$entry_sale" ]; then


    #1. extracting the rows 
   sed -n '1p;30p' SALES.csv


    #2. Delete the existed records
   /usr/bin/mysql --local-infile=1 -h $_db_host -P $_db_port -u $_db_user -p$_db_password $_db --execute="TRUNCATE TABLE SALES;"

   # 3. Copy from current directory to sql secure directory
    dst="${_sql_dir}${sale_file}"
    sudo cp "$entry_sale" "$dst"
     
   
   # 4. Check if the file exist in secure sql directory

    if sudo test -f $dst; then
        sudo /usr/bin/mysql --local-infile=1 -h $_db_host -P $_db_port -u $_db_user -p$_db_password $_db --execute="LOAD DATA INFILE '${dst}' INTO TABLE SALES character set latin1
        FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';"
        return $?
    else
        echo "File does not exist in secure sql directory!"
        return 1
    fi

else
    echo "File does not exist."
    return 1
fi

}


function run_product(){

#checking whether file exists or not.
product_file="PRODUCT.csv"
entry_product=${file_url}${product_file}

if [ -f "$entry_product" ]; then

     #creating product table if table doest not exist
       
     #1. extracting the rows
   sed -n '1p;30p' PRODUCT.csv
  
    #2- Delete the existed records
   /usr/bin/mysql --local-infile=1 -h $_db_host -P $_db_port -u $_db_user -p$_db_password $_db --execute="TRUNCATE TABLE PRODUCT;"

   # 3- Copy from current directory to secure sql directory
  dst="${_sql_dir}${product_file}"
  sudo cp "$entry_product" "$dst"
   
   # 4- Check if the file exist in secure sql directory

    if sudo test -f $dst; then
        sudo /usr/bin/mysql --local-infile=1 -h $_db_host -P $_db_port -u $_db_user -p$_db_password $_db --execute="LOAD DATA INFILE '${dst}' INTO TABLE PRODUCT character set latin1
        FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';"
        return $?
    else
        echo "File does not exist in secure sql directory!"
        return 1
    fi

else
    echo "File does not exist."
    return 1
fi
}

function run_customer(){


   #checking whether file exists or not.

    customer_file="CUSTOMER.csv"
    entry_customer=${file_url}${customer_file}
   
   if [ -f "$entry_customer" ]; then  
 
        sed -n '1p;30p' CUSTOMER.csv

          #2- Delete the existed records
        /usr/bin/mysql --local-infile=1 -h $_db_host -P $_db_port -u $_db_user -p$_db_password $_db --execute="TRUNCATE TABLE CUSTOMER;"

        # 3- Copy from current directory to secure sql directory
        dst="${_sql_dir}${customer_file}"
        sudo cp "$entry_customer" "$dst"
        
        # 4- Check if the file exist in secure sql directory

        if sudo test -f $dst; then
            sudo /usr/bin/mysql --local-infile=1 -h $_db_host -P $_db_port -u $_db_user -p$_db_password $_db --execute="LOAD DATA INFILE '${dst}' INTO TABLE CUSTOMER character set latin1
            FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';"
            return $?
        else
            echo "File does not exist in secure sql directory!"
            return 1
        fi

    else
        echo "File does not exist."
        return 1
    fi

}

function run_transform(){



    mysql_dir='/var/lib/mysql-files/SALES_SUMMARY.csv'
    desktop='/home/atemis/Desktop'

    #1. Excuting the store procedure
        sudo /usr/bin/mysql --local-infile=1 -h $_db_host -P $_db_port -u $_db_user -p$_db_password $_db --execute="call SALES_TRANFORMATION;";
    
    # 2. Check if the file exist in secure sql directory
                echo $?

        if sudo test -f $mysql_dir; then

    #3. Removing the existing file in mysql folder if exist
            
            sudo rm $mysql_dir
        fi

    #4. Coverting the table into csv file
        sudo /usr/bin/mysql --local-infile=1 -h $_db_host -P $_db_port -u $_db_user -p$_db_password $_db --execute="SELECT * FROM SALES_TRANSFORM INTO OUTFILE '/var/lib/mysql-files/SALES_SUMMARY.csv';";

    #5. Changing the user of csv file.
        sudo chown atemis $mysql_dir  

    #6. cp the file from root user into home dir.
        sudo cp $mysql_dir $desktop 

}

function sendFile()
{
    api_token="6161890087:AAEQLkwhqQF0OH4DbM7c4tWHo3nz_CsZQOA"
    group_chat_id="-888747204"
    csvFile='/home/atemis/Desktop/SALES_SUMMARY.csv'

    url="https://api.telegram.org/bot$api_token/sendDocument?chat_id=$group_chat_id"
    sudo curl -X POST --silent -F document=@$csvFile $url > /dev/null
    return 1
}




#!/bin/bash

CMD=$1
FILE_PATH=~/bin/todo.txt

#YELLOW=1;33m
#GREEN=1;32m
#RED=1;31m

#Function to get the number of tasks
get_num_of_tasks () {
    LINE1=$(awk 'FNR>0&&FNR<2' $FILE_PATH)
    NumOfTasks=$(echo "$LINE1" | grep Total: | awk '{print $2}')
    return $NumOfTasks
}
    
# Add task 
if [ $CMD == '-a' ]; then
    TASK=$2
    DDL=$3
   
    get_num_of_tasks
    OldNum=$?
    let "NewNum = $OldNum + 1"
    
    sed -i '' '1s/'$OldNum'/'$NewNum'/' $FILE_PATH
    echo "$NewNum). $TASK [ ]" >> $FILE_PATH
    echo -e "\x1B[1;33mDeadline: $DDL \x1B[1;32m" >> $FILE_PATH
    echo Successfully added task $NewNum   

# List all taks
elif  [ $CMD == '-l' ]; then
    DATE=$(date '+%d/%m')
    
    get_num_of_tasks
    NumOfTasks=$?

    let "CUR = 2"
    let "NEXT = CUR++"
    let "TASK = 1" 

    while IFS= read line
    do   
        DDL=$(echo "$line" | grep Deadline: | awk '{print $2}')
        if [ "$DDL" = "$DATE" ]; then
            echo -e "\x1B[1;31mDeadline: $DDL\x1B[1;32m"
        else
            echo $line
        fi   
    done < "$FILE_PATH"

# Clear all tasks
elif [ $CMD == '-c' ]; then
    echo "Total: 0" > $FILE_PATH
    echo Task cleared.

# Remove a task
elif [ $CMD == '-r' ]; then
    get_num_of_tasks
    NumOfTasks=$?
    let "NewNum = $NumOfTasks - 1"    

    let "CUR = $2"
    let "NEXT = $CUR + 1"

    let "DeleteLine = $CUR * 2"
    let "DeleteDDL = $DeleteLine + 1"
    sed -i '' ''$DeleteLine','$DeleteDDL'd' $FILE_PATH
    echo Successfully removed task $CUR
 
    while [ $CUR -le $NumOfTasks ]
    do
        sed -i '' '/^'$NEXT'/ s/'$NEXT'/'$CUR'/' $FILE_PATH
        ((CUR++))
        ((NEXT++))
    done
 
    sed -i '' '1s/'$NumOfTasks'/'$NewNum'/' $FILE_PATH

# Mark a task as done
elif [ $CMD == '-d' ]; then
    DONE=$2
    sed -i '' '/^'$DONE'/ s/[[ ]]/x]/' $FILE_PATH
    echo Succesfully markes task $DONE as done

# Undone a task
elif [ $CMD == '-u' ]; then
    UNDONE=$2
    sed -i '' '/^'$UNDONE'/ s/[[x]]/ ]/' $FILE_PATH
    echo "Successfully undone task $UNDONE"    

fi

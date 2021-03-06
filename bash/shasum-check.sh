#!/bin/bash
# shasum_check with package "dialog" and "shasum"

declare -i PERCENT=0 
(
if [ -f ./shasum.txt ];then
    num=0
    while read line
    do
        if [ $PERCENT -le 100 ];then
            sha=`shasum -a 512 ${line##* }`
            if [ "${sha%% *}" = "${line%% *}" ];then
                echo "XXX"
                echo "check ${line##* }..."
                echo "XXX"
            else
                echo "XXX"
                echo "check ${line##* } error!" >/tmp/check_failed
                echo "XXX"
                break
            fi
            echo $PERCENT   
        fi
        let num+=1
        if [ "$num" == "5" ];then
            let PERCENT+=1;
            num=0
        fi
    done < ./shasum.txt
fi
) | dialog --title "check md5..." --gauge "starting to check md5..." 6 100 0

if [ -f /tmp/check_failed ];then
    value=`cat /tmp/check_failed`
    dialog --title "check md5" --msgbox "checksum failed \n  $value "  10 60 
else
    dialog --title "check md5" --msgbox "checksum success"  10 20
fi

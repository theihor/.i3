#!/bin/bash
# script for getting status of workers from dwarfpool.com
DP_XMR_ADDRESS=4YourRealXMRAddressMustBeSpecifiedHereInOrderForThisScriptToBeWorkingOtherwiseItDoesntMakeSense

DETP='[0-9]+.[0-9]+ XMR</span>\nCurrent balance<br>'
EP='[0-9]+.[0-9]+ XMR</span>\nEarning in last 24 hours'
CUTP='[0-9]\+.[0-9]\+'

function check_worker {
    o=$(grep -A 1 "$1<" tmp.html | grep -o "(.* ago)")
    m=$(echo $o | grep 'min')
    t=$(echo $o | grep -o "[0-9]\+")
    if [ -n "$m" ]
    then
        if [ $t -gt 15 ]
        then
            echo -n "<span color='red'>$1: ${t}m</span>"
        else
            echo -n "<span color='#0AFF0A'>$1: ${t}m</span>"
        fi
    else
        if [ -n "$t" ]
        then
            echo -n "<span color='red'>$1: ${t}h</span>"
        else
            n=$(grep -A 1 "$1<" tmp.html  | grep 'now')
            if [ -n "$n" ]
            then 
                echo -n "<span color='#0AFF0A'>$1: 0m</span>"
            else
                echo -n "<span color='red'>$1: N/A</span>"
            fi
        fi
    fi
    echo -n "   "
}

if [ ! -z ${DP_XMR_ADDRESS+x} ]; then
	ADDR=https://dwarfpool.com/xmr/address?wallet=$DP_XMR_ADDRESS
    curl -s --connect-timeout 30 -X GET $ADDR > ~/tmp.html
	BALANCE=$(cat ~/tmp.html | pcregrep -M "$DETP" | grep -o "$CUTP" | xargs printf "%.3f" $1 | sed -e 's/,/\./g')
    E=$(cat ~/tmp.html | pcregrep -M "$EP" | grep -o "$CUTP" | xargs printf "%.3f" $1 | sed -e 's/,/\./g')
    echo -n "$BALANCE <span color='grey'>(+$E)</span>     "
else
	echo -n "N/A"
fi

workers=("worker_id" "another_worker_id")
for w in ${workers[*]}
do
    check_worker $w
done

rm -f ~/tmp.html

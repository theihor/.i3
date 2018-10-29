#!/bin/bash
# check worker status on supportxmr.com
DP_XMR_ADDRESS=4YourRealXMRAddressMustBeSpecifiedHereInOrderForThisScriptToBeWorkingOtherwiseItDoesntMakeSense

function check_worker {
    lts=$(curl -s --connect-timeout 16 -X GET https://www.supportxmr.com/api/miner/$DP_XMR_ADDRESS/stats/$1  | grep -o "\"lts\":[0-9]*" | grep -o "[0-9]*")
    t0=$(date +"%s")
    if [ -z "$lts" ]
    then
        echo -n "<span color='red'>$1: N/A</span>"
    else
        let "m = ($t0 - $lts) / 60"
        if [ $m -gt 15 ]
        then
            echo -n "<span color='red'>$1: ${m}m</span>"
        else
            echo -n "<span color='#0AFF0A'>$1: ${m}m</span>"
        fi
    fi
    echo -n "   "
}

if [ ! -z ${DP_XMR_ADDRESS+x} ]; then
	ADDR=https://www.supportxmr.com/api/miner/$DP_XMR_ADDRESS/stats
    s=$(curl -s --connect-timeout 30 -X GET $ADDR | grep -o '"amtDue":[0-9]*' | grep -o "[0-9]*")
	BALANCE=$(echo "scale=3; $s / 1000000000000" | bc | sed -e 's/,/\./g')
    s=$(~/amt.py $BALANCE)
    #echo $BALANCE
    #echo -n "$BALANCE <span color='grey'>(+$E)</span>     "
   
    ts=$(date +%s)
    last_block_ts=$(curl -sS https://www.supportxmr.com/api/pool/stats | grep -o "\"lastBlockFoundTime\":[0-9]\+" | grep -o "[0-9]\+")
    diff=$(expr $ts - $last_block_ts)
    diffm=$(echo "scale=1; $diff / 60" | bc)
   
    d=$(curl -sS https://www.supportxmr.com/api/network/stats | grep -o "\"difficulty\":[0-9]*" | grep -o "[0-9]\+")
    h=$(curl -sS https://www.supportxmr.com/api/pool/stats | grep -o "\"hashRate\":[0-9]*" | grep -o "[0-9]\+")
    t=$(python -c "$d/$h")
    if [ $diff -gt $t ]
    then
        diffm="<span color='red'>${diffm}m</span>"
    else
        diffm="<span color='#0AFF0A'>${diffm}m</span>"
    fi
    
    echo -n "[ ${diffm} ]  $s     "
else
	echo -n "N/A"
fi

workers=("worker_id" "another_worker_id")
for w in ${workers[*]}
do
    check_worker $w
done


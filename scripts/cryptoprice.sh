#! /bin/sh

#------------------------------------------------------------------------------
# Retrieve <currency>-USD price where <currency> is passed by $1 parameter and
# must be a official cryptocurrency symbol (BTC, XMR, ETC, etc)
#------------------------------------------------------------------------------

data=$(curl -sL https://api.coinmarketcap.com/v1/ticker/$1)

prec=$2

if [[ -z $prec ]]; then
    prec=0
fi

if [[ ! -z $data ]]; then
    echo '$'$(echo $data | jq .[0].price_usd | tr -d '"' | xargs printf "%.*f" $prec)
else
    echo "N/A"
fi

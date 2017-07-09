#! /usr/bin/python3

import time
import urllib.request
import json
import codecs

btc = 1
xmr = 1
ltc = 1
sc  = 1

reader = codecs.getreader("utf-8")

# while 1:
response = urllib.request.urlopen("https://poloniex.com/public?command=returnTicker")
obj = json.load(reader(response))

usd_btc = float(obj['USDT_BTC']['last'])
btc_xmr = float(obj['BTC_XMR']['last'])
btc_ltc = float(obj['BTC_LTC']['last'])
btc_sc  = float(obj['BTC_SC']['last'])
x = usd_btc * (btc + xmr * btc_xmr + ltc * btc_ltc + sc * btc_sc)
x = round(x)
# log.write(str(x) + "\n")
# t = time.strftime("%d.%m.%y %H:%M")
# s = t + " " + str(x) + " " + str(usd_btc) + " " + str(btc_xmr) + " " + str(btc_ltc) + " " + str(btc_sc)
# print(t, x, usd_btc, btc_xmr, btc_ltc, btc_sc)
print(x)
# with open("x.log", "a") as log:
#     log.write(s + "\n")
# time.sleep(1024)


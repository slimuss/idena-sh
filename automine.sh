#!/bin/bash

DAEMON_PATH="idena/datadir"
SCRIPT_PATH="idena-scripts"
SCRIPT_NAME="automineon.sh"

CURRENTDIR=$(pwd)
if [[ "$USER" == "root" ]]; then
        HOMEFOLDER="/root"
 else
        HOMEFOLDER="/home/$USER"
fi


echo 'PORT=9009' > $SCRIPT_NAME
echo -e "APIPATH=$HOMEFOLDER$DAEMON_PATH" >> $SCRIPT_NAME
echo >> $SCRIPT_NAME
echo 'CURRENTDIR=$(pwd)' >> $SCRIPT_NAME
echo >> $SCRIPT_NAME
echo 'cd $APIPATH' >> $SCRIPT_NAME
echo 'API_KEY=$(cat api.key)' >> $SCRIPT_NAME
echo >> $SCRIPT_NAME
echo 'DATA='{"method": "dna_getCoinbaseAddr","params":[],"id": 8,"key":"'$API_KEY'"}'' >> $SCRIPT_NAME
echo 'ADDR=$(curl http://127.0.0.1:$PORT -H "content-type:application/json;" -d "$DATA" | jq -r '.result')' >> $SCRIPT_NAME
echo 'DATA='{"method": "dna_identity","params":["'$ADDR'"],"id": 9,"key":"'$API_KEY'"}'' >> $SCRIPT_NAME
echo 'STATUS=$(curl http://127.0.0.1:$PORT -H "content-type:application/json;" -d "$DATA" | jq -r '.result.online')' >> $SCRIPT_NAME
echo >> $SCRIPT_NAME
echo 'if [ $STATUS = 'false' ]; then' >> $SCRIPT_NAME
echo '   DATA='{"method":"dna_epoch","params":[],"id":4,"key":"'$API_KEY'"}'' >> $SCRIPT_NAME
echo '   EPOCH=$(curl http://127.0.0.1:$PORT -H "content-type:application/json;" -d "$DATA" | jq -r '.result.epoch')' >> $SCRIPT_NAME
echo '   DATA='{"method": "dna_becomeOnline","params": [{"nonce": 0,"epoch":'$EPOCH'}],"id": 1}'' >> $SCRIPT_NAME
echo '   curl http://127.0.0.1:$PORT -H "content-type:application/json;" -d "$DATA"' >> $SCRIPT_NAME
echo 'fi' >> $SCRIPT_NAME
echo 'cd $CURRENTDIR' >> $SCRIPT_NAME
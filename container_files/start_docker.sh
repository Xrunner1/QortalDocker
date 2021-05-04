#!/bin/bash

if [ -z ${NET_PORT} ]; then
    NET_PORT=62402
fi
if [ -z ${API_PORT} ]; then
    API_PORT=62401
fi

echo
echo "Running Qortal with settings:"
echo "{
  \"isTestNet\": true,
  \"bitcoinNet\": \"TEST3\",
  \"litecoinNet\": \"TEST3\",
  \"repositoryPath\": \"db\",
  \"blockchainConfig\": \"testchain.json\",
  \"minBlockchainPeers\": 1,
  \"apiDocumentationEnabled\": true,
  \"tradebotSystrayEnabled\": true,
  \"apiRestricted\": false,
  \"bindAddress\": \"0.0.0.0\",
  \"listenPort\": ${NET_PORT},
  \"apiPort\": ${API_PORT}
}" > settings-test.json

cat settings-test.json

java -Djava.net.preferIPv4Stack=false -jar qortal.jar settings-test.json

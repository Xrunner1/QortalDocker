#!/bin/bash

API_PORT=$(cat settings-test.json | jq '.apiPort')

curl "http://localhost:${API_PORT}/admin/stop"

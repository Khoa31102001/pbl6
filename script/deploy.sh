#!/usr/bin/env bash
cd ~/eshopping/BE/api-service && npm i --force && cd ~/eshopping/BE/email-service && npm i --force && cd ~/eshopping/BE && pm2 start app_all.json && cd ~/eshopping/FE && npm i && npm run build && pm2 start app.json
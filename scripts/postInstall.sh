#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 30s;

target=$(docker-compose port www 80)

curl http://${target}/register \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6' \
  -H 'cache-control: max-age=0' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36' \
  --data-raw 'user_register%5Busername%5D=admin&user_register%5Bemail%5D='${ADMIN_EMAIL}'&user_register%5BplainPassword%5D%5Bfirst%5D='${ADMIN_PASSWORD}'&user_register%5BplainPassword%5D%5Bsecond%5D='${ADMIN_PASSWORD}'&user_register%5BagreeTerms%5D=1&user_register%5Bsubmit%5D=&user_register%5B_token%5D=22d952804cbeb349e599795d5efba12f.3zkDWoKa6sAP4C-F1_gwBFgL7JUwTXEzCRHDUPRObjc.smsuOdvDsPNXin_Dm7dpZQl4puJpP0lVcVSWNrB5KFSnDmUA8MKMtGGNbg' \
  --compressed
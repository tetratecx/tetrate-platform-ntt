#!/usr/bin/env bash
export GATEWAY_IP=$(dig +short $(kubectl get svc -n transaction-oversight transaction-gw -o jsonpath='{.status.loadBalancer.ingress[0].hostname}') | head -n 1)
echo $GATEWAY_IP

N=1
while true; do
  result=$(curl -s -o /dev/null -w '%{http_code} %{time_total}' \
    "https://online.banking.dynabank.com" \
    --resolve online.banking.dynabank.com:80:$GATEWAY_IP \
    --retry 5 --retry-all-errors --retry-delay 0 --max-time 3) || result="000 0"

  read -r status time_total <<< "$result"

  # normal printf format (no Task interpolation because this is an external script)
  time_total_fmt=$(printf '%.3f' "$time_total")

  echo "Code: $status  Time(s): $time_total_fmt  $(date +%T)  Request: $N"

  N=$((N+1))
  sleep 1
done

#!/usr/bin/env bash
N=1
while true; do
  result=$(curl -sk -o /dev/null -w '%{http_code} %{time_total}' \
    "https://online-banking.dynabank.com/web-portal" \
    --resolve online-banking.dynabank.com:443:3.134.119.133 \
    --retry 5 --retry-all-errors --retry-delay 0 --max-time 3) || result="000 0"

  read -r status time_total <<< "$result"

  # normal printf format (no Task interpolation because this is an external script)
  time_total_fmt=$(printf '%.3f' "$time_total")

  echo "Code: $status  Time(s): $time_total_fmt  $(date +%T)  Request: $N"

  N=$((N+1))
  sleep 1
done
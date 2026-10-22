#!/bin/bash
# CTI Portal quraşdırma skripti: parolları yaradır və hər şeyi qaldırır.
set -e
cd "$(dirname "$0")"

gen() { tr -dc 'A-Za-z0-9' </dev/urandom | head -c "$1"; }

if [ ! -f .env ] || grep -q DEYISDIR_BURANI .env; then
  cp .env.example .env
  sed -i "s/DEYISDIR_BURANI_1/$(gen 24)/;s/DEYISDIR_BURANI_2/$(gen 12)/;s/DEYISDIR_BURANI_3/$(gen 32)/;s/DEYISDIR_BURANI_4/$(gen 40)/" .env
  echo ".env faylı yaradıldı."
else
  echo ".env faylı artıq var, dəyişmədim."
fi

echo
echo "Panelə giriş məlumatları (yazıb saxla):"
grep -E '^DASH_(USER|PASS)=' .env
echo

if [ "$1" != "--env-only" ]; then
  docker compose up -d --build
  echo
  docker compose ps
fi

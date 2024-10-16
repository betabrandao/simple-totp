#!/usr/bin/env bash
# pass otp - Password Store Extension (https://www.passwordstore.org/)
# Copyright (C) 2024 Roberta Brandao
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

local path="${1%/}"
local passfile="$PREFIX/$path.gpg"
local count="$(printf '%.16x' $(($(date +%s)/30)))"
check_sneaky_paths "$path"

local hexkey=$(gpg -d "${GPG_OPTS[@]}" "$passfile" | grep -E 'otp|secret' | tr -d ' ' | cut -d':' -f2 | base32 -d | xxd -ps -c 128)

[[ -z "$hexkey" ]] && die "Failed to generate TOTP code: otp or secret not found. Example in pass file secret: YourTotpBase32SecretNoSpacesBetweenChars"

local hash="$(echo -n "$count" | xxd -r -p | openssl mac -digest sha1 -macopt hexkey:"$hexkey" HMAC)"
local offset="$((16#${hash:39}))"
local extracted="${hash:$((offset * 2)):8}"
local token="$(((16#$extracted & 16#7fffffff) % 1000000))"
local print="$(printf '%06d' ${token})"

qrcode ()
{
  local issuer=$(basename $(dirname ${path}))
  local name=$(basename ${path})
  local secret=$(gpg -d "${GPG_OPTS[@]}" "$passfile" | grep -E 'otp|secret' | tr -d ' ' | cut -d':' -f2)
  qrencode -o - \
    -t UTF8 \
    -s 10 \
    -v 1 \
    -m 2 \
    -l m \
    "otpauth://totp/${name}?secret=${secret}&issuer=${issuer^}"
}


# 
# Print TOTP
#

case "${2%/}" in
  -c|--clip) clip $print ;;
  -qr|--qrcode) qrcode ;;
  *) echo $print ;;
esac
  

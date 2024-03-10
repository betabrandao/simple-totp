# simple-totp
Simple TOTP Extenstion to Pass

TODO: Add port to MacOs pbcopy.

## Requirements:
- bash
- openssl
- NTP configured

## Instalation

```bash
$ sudo install totp.bash /usr/lib/password-store/extensions/
```

## Usage:
Step 1: Add to your secret a `totp_secret:` key. 

Example:

`$ pass edit mypass/example`

```text
anpasswordexempleusingpass
---
user: aUserExample
pass: anpasswordexempleusingpass
url: https://anpasswordexempleusingpass.example.com
totp_secret: YOURTOTPBASE32SECRET
```
Save this.

Step 2: Get topt code. To copy to clipboard, use -c option:

```bash
$ pass totp mypass/example
```

Done! Simple TOTP!

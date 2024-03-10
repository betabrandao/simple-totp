# simple-totp
Simple TOTP Extenstion to [Pass Project](https://www.passwordstore.org/). 

TODO: Add port to MacOs pbcopy.

This plugin use openssl to decode the base32 TOTP secret, based in timestamp. Is **super important** your system datetime is syncked to NTP servers.

## Requirements:
- pass
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

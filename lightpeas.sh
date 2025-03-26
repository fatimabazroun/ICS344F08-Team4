#!/bin/bash

echo "[+] Current User:"
whoami
echo

echo "[+] Hostname:"
hostname
echo

echo "[+] Kernel Info:"
uname -a
echo

echo "[+] Sudo Permissions (if any):"
sudo -l 2>/dev/null
echo

echo "[+] SUID Binaries:"
find / -perm -4000 -type f 2>/dev/null
echo

echo "[+] Writable files owned by root:"
find / -writable -type f -user root 2>/dev/null
echo

echo "[+] Crontab Entries:"
cat /etc/crontab 2>/dev/null
ls -la /etc/cron* 2>/dev/null
echo

echo "[+] Environment PATH:"
echo $PATH
echo

echo "[+] Processes Running as Root:"
ps -U root -u root u 2>/dev/null
echo

echo "[+] Network Connections (Listening):"
ss -tulwn 2>/dev/null || netstat -tuln
echo

echo "[+] Interesting Files (passwords, keys, etc):"
find / -type f \( -iname "*pass*" -o -iname "*key*" -o -iname "*.conf" \) -exec ls -lah {} \; 2>/dev/null | grep -v "Permission denied"
echo

echo "[+] Done. Review the above output for possible escalation paths."

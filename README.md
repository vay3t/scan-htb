# scan-htb
automatic scan for hackthebox

# Usage
Need root

```
[*] Usage: bash scan-htb.sh <target>
```

# Install masscan
```bash
sudo apt update
sudo apt install git gcc make libpcap-dev -y
git clone https://github.com/robertdavidgraham/masscan
cd masscan
make
sudo make install
```

# Install nmap
```
sudo apt update
sudo apt install nmap -y
```

# Install scan-htb
```
git clone https://github.com/vay3t/scan-htb
```

# Credits

* dplastico

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
NC='\e[0m'

if command -v certstrap >/dev/null 2>&1; then
  echo -e "${GREEN}certstrap is available${NC}"
else
  echo """${RED}
Requires certstrap for the creation of auto-signed certificates

$ git clone https://github.com/square/certstrap
$ cd certstrap
$ go build

These commands will create a binary called certstrap under the project root directory.
\nRequires Go version 1.18+ :
  * Debian/Ubuntu : sudo apt install golang-go
  * Fedora/RedHat : sudo dnf install golang${NC}
  """
fi

echo -e """${YELLOW}
This script will create :
-------------------------

* a CA (Certificate Authority) certificate used to sign the other certificates below
* a TLS certificate for the PostgreSQL server
* a TLS certificate for the pgAdmin4 server
${NC}
"""

echo -e "\n${GREEN}Initializing a local Certificate Authority :${NC}\n"
certstrap init --common-name myCA

echo -e "\n${GREEN}Requesting a certificate and its keypair for postgres :${NC}"
echo -e "Don't set a password for the certificate request\n"
certstrap request-cert --common-name postgres --domain localhost --domain postgres-server

echo -e "\n${GREEN}Requesting a certificate and its keypair for pgadmin :${NC}"
echo -e "Don't set a password for the certificate request\n"
certstrap request-cert --common-name pgadmin --domain localhost --domain pgadmin

echo -e "\n${GREEN}Signing the request and generating the certificate.${NC}\n"
certstrap sign postgres --CA myCA
certstrap sign pgadmin  --CA myCA

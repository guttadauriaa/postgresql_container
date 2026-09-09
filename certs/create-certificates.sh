echo """
Requires certstrap for the creation of auto-signed certificates
$ git clone https://github.com/square/certstrap
$ cd certstrap
$ go build
\nThese commands will create a binary called certstrap under the project root directory.
\nRequires Go version 1.18+
"""

echo "Initializing a local Certificate Authority."
certstrap init --common-name myCA

echo "Requesting a certificate and its keypair."
echo "Don't set a password for the certificate request"
certstrap request-cert --common-name postgres --domain localhost --domain postgres-server

echo "Signing the request and generating the certificate."
certstrap sign postgres --CA myCA


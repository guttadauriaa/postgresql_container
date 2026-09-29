Write-Host "Requires certstrap for the creation of auto-signed certificates"
Write-Host "\$ git clone https://github.com/square/certstrap"
Write-Host "\$ cd certstrap"
Write-Host "\$ go build"
Write-Host "`nThese commands will create a binary called certstrap under the project root directory."
Write-Host "`nRequires Go version 1.18+"

Write-Host "Initializing a local Certificate Authority."
certstrap init --common-name myCA

Write-Host "Don't set a password for the certificate requests."

Write-Host "Requesting a certificate and its keypair for postgres :"
certstrap request-cert --common-name postgres --domain localhost --domain postgres-server

Write-Host "Requesting a certificate and its keypair for pgadmin :"
certstrap request-cert --common-name pgadmin --domain localhost --domain pgadmin

Write-Host "Signing the requests and generating the certificate."
certstrap sign postgres --CA myCA
certstrap sign pgadmin  --CA myCA

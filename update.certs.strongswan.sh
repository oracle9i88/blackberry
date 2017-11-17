#!/bin/sh
VPN_SERVER=${1}
CertRoot=/usr/local/etc/ipsec.d/
wget -O - https://letsencrypt.org/certs/isrgrootx1.pem > ${CertRoot}/cacerts/ca.cert.pem
cp /srv/docker/certs/${VPN_SERVER}.crt ${CertRoot}/certs/server.cert.pem
cp /srv/docker/certs/${VPN_SERVER}.crt ${CertRoot}/certs/client.cert.pem
cp /srv/docker/certs/${VPN_SERVER}.key ${CertRoot}/private/server.pem
cp /srv/docker/certs/${VPN_SERVER}.key ${CertRoot}/private/client.pem
ipsec rereadcacerts && ipsec rereadall && ipsec rereadacerts
ipsec update


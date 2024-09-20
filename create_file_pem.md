Open a text editor (such as wordpad) and paste the entire body of each certificate into one text file in the following order:
 
The Private Key - your_domain_name.key

The Primary Certificate - your_domain_name.crt

The Intermediate Certificate - DigiCertCA.crt

The Root Certificate - TrustedRoot.crt

Make sure to include the beginning and end tags on each certificate. The result should look like this:
 
 ```
-----BEGIN RSA PRIVATE KEY-----
(Your Private Key: your_domain_name.key)
-----END RSA PRIVATE KEY-----
-----BEGIN CERTIFICATE-----
(Your Primary SSL certificate: your_domain_name.crt) =>thuho-uds.xxx.com.vn.cer
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
(Your Intermediate certificate: DigiCertCA.crt) => 1.Root CA.cer
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
(Your Root certificate: TrustedRoot.crt) => 2.intermediate.cer
-----END CERTIFICATE-----
```

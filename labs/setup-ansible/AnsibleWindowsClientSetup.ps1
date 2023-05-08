winrm set winrm/config/service '@{AllowUnencrypted="true"}'

# Create self-signed certificate
$cert = New-SelfSignedCertificate -DnsName "localhost" -CertStoreLocation "cert:\LocalMachine\My"

# Get the certificate thumbprint
$thumbprint = $cert.Thumbprint

# Create a new listener using the certificate thumbprint
New-Item -Path WSMan:\localhost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $thumbprint -Force

#Create a windows defender firewall inbound rule for ports 5985,5986
New-NetFirewallRule -DisplayName "Allow Ansible" -Direction Inbound -LocalPort 5985,5986 -Protocol TCP -Action Allow

Enable-PSRemoting -Force

Restart-Service winrm

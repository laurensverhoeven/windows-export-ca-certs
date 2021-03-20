# https://gist.github.com/zakird/a8582ced2f50cfe1c702

$type = [System.Security.Cryptography.X509Certificates.X509ContentType]::Cert

$output_dir = "$(Get-Location)\certificates"

New-Item -Force -ItemType "directory" -Path "$output_dir"

get-childitem -path cert:\LocalMachine\AuthRoot | ForEach-Object {
	$hash = $_.GetCertHashString()
	$friendly_name = $_.FriendlyName
	$issuer_name = $_.IssuerName.Name
	$name = $_.DnsNameList.Unicode
    write-host "Certificate with name: $name, friendly_name: $friendly_name, issuer_name: $issuer_name and hash $hash"
	[System.IO.File]::WriteAllBytes("$output_dir\$friendly_name--$hash.der", $_.export($type) )
}

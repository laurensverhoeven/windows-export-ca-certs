# https://gist.github.com/zakird/a8582ced2f50cfe1c702

write-host "Running export-ca-certs.ps1."

$type = [System.Security.Cryptography.X509Certificates.X509ContentType]::Cert

$output_dir = "$(Get-Location)\certificates"

New-Item -Force -ItemType "directory" -Path "$output_dir\der"
New-Item -Force -ItemType "directory" -Path "$output_dir\pem"
New-Item -Force -ItemType "directory" -Path "$output_dir\crt"

get-childitem -path cert:\LocalMachine\Root | ForEach-Object {
	$hash = $_.GetCertHashString()
    $common_name = if($_.Issuer -match "CN=(?<cn>[^,\r\n]+)")
    {
        $matches.cn
    }  # https://stackoverflow.com/questions/49810619/formatting-certificates-list-with-powershell
    # $issuer_name = $_.IssuerName.Name
	# $friendly_name = $_.FriendlyName
    $der_file = "$output_dir\der\$common_name--$hash.der"
    $pem_file = "$output_dir\pem\$common_name--$hash.pem"
    $crt_file = "$output_dir\crt\$common_name--$hash.crt"

    # write-host "Exporting certificate $issuer_name"
    write-host "`nExporting certificate $common_name ($hash) to $output_dir"

	[System.IO.File]::WriteAllBytes($der_file, $_.export($type) )
    certutil -encode -f $der_file $pem_file
    Copy-Item $pem_file -Destination $crt_file
}

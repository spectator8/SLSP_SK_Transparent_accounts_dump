#acc get

$llf="fakepath\acc_list.txt"
Clear-Content $llf

$size=20000

$link="https://api.slsp.sk/ta-accounts/api/accounts?size=$size"

$accGetRes=""
$accGetRes=irm $link

$ibanNamePF="fakepath\iban-name-mapping.properties"
Clear-Content $ibanNamePF


Write-Host "acc count is: " $accGetRes.accounts.Count

foreach ( $rr in $accGetRes.accounts)

{

$rrx=""
$rrx=$rr.name + "|" + $rr.created + "|" + $rr.iban +"|" + $rr.balance.value + "|" +  $rr.balance.currency


Out-File -FilePath $llf -InputObject $rrx -Width 99999 -Append

#acc get

#iban-name mapping file


$ibanMap=""
$ibanMap=$rr.iban +"="+ $rr.name
Out-File -FilePath $ibanNamePF -InputObject $ibanMap -Width 99999 -Append

#iban-name mapping file

}



#turnovers get

$ttc=0

$llff="fakepath\full_list.txt"
Clear-Content $llff



$ii=0

foreach ($iban in $accGetRes.accounts.iban)

{

$linkx=""
$linkx="https://api.slsp.sk/ta-turnovers/api/accounts/$iban/turnovers?size=100000"

$fxres=""
$fxres=irm $linkx



#full get start

$ttcx=0
$ttc=$fxres.turnovers.Count

foreach ($to in $fxres.turnovers)

{

$ibb=""
$ibb=$to.accountIban
$hhh=""
[string]$hhh=(Get-Content $ibanNamePF | Select-String $ibb)

$nameX=""
$nameX=$hhh.Substring($hhh.IndexOf("=")+1)


$full=""
$full=$nameX + "|" + $to.accountIban + "|" + $to.turnoverId + "|" + $to.counterAccountName + "|" + $to.date + "|" + $to.amount.value + "|" + $to.amount.currency + "|" + $to.note + "|" + $to.description

Out-File -FilePath $llff -InputObject $full -Width 99999 -Append

$ttcX++

Write-Host $ii / $accGetRes.accounts.Count --------------------$ttcx / $ttc


}
#full get end

$ii++


}

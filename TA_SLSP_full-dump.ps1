#acc get

$llf="fakepath\acc_list.txt"
Clear-Content $llf

$size=20000

$link="https://api.slsp.sk/ta-accounts/api/accounts?size=$size"

$accGetRes=""
$accGetRes=irm $link




Write-Host "acc count is: " $accGetRes.accounts.Count

foreach ( $rr in $accGetRes.accounts)

{

$rrx=""
$rrx=$rr.name + "|" + $rr.created + "|" + $rr.iban +"|" + $rr.balance.value + "|" +  $rr.balance.currency


Out-File -FilePath $llf -InputObject $rrx -Width 99999 -Append

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

#ibanToName
$ibb=""
$ibb=$to.accountIban
$nameX=""
$nameX=(irm https://api.slsp.sk/ta-accounts/api/accounts/$ibb | Select-Object name).name
#ibanToName

$full=""
$full=$nameX + "|" + $to.accountIban + "|" + $to.turnoverId + "|" + $to.counterAccountName + "|" + $to.date + "|" + $to.amount.value + "|" + $o.amount.currency + "|" + $to.note + "|" + $to.description

Out-File -FilePath $llff -InputObject $full -Width 99999 -Append

$ttcX++

Write-Host $ii / $accGetRes.accounts.Count --------------------$ttcx / $ttc


}
#full get end

$ii++


}

$admincsv = import-csv -Path "C:\Users\$env:USERNAME\Documents\admin.csv" | Select-Object -First 9
$usercsv = import-csv -Path "C:\Users\$env:USERNAME\Documents\admin.csv" | Select-Object -Skip 9


# Get AD-Users from windows, selects the accounts that are NOT the built in Administrator, Guest, Windows Defender Account, the Default user account, and the Kerberos account. Outputs a hashtable in 
$currentUsers = get-aduser -filter * | Where-Object {$_.Name -ne "Administrator" -and $_.Name -ne "Guest" -and $_.Name -ne "WDAGUtilityAccount" -and $_.Name -ne "DefaultAccount" -and $_.Name -ne "krbtgt" -and $_.Name -ne "black_team" } | select SamAccountName 

# Getting the currentUsers out of the hash table
$currentUsers = $currentUsers | ForEach-Object { $_.SamAccountName }


# log users to remove
$currentUsers | Where-Object { $_ -notin $usercsv.ForEach{$_.username} -and $_ -notin $admincsv.ForEach{$_.username} } | ForEach-Object{Add-Content -Path "C:\Users\$env:USERNAME\Documents\DelUser.txt" -Value "$_"}

# Finding and deleting unauthorized users
$currentUsers | Where-Object { $_ -notin $usercsv.ForEach{$_.username} -and $_ -notin $admincsv.ForEach{$_.username} } | ForEach-Object {Remove-ADUser -Identity $_}


# Log users to add
$admincsv | Where-Object { $_.username -notin $currentUsers } | ForEach-Object{
Add-Content -Path "C:\Users\$env:USERNAME\Documents\AddUser.txt" -Value "$($_.username)"
}

# Log users to add
$usercsv | Where-Object { $_.username -notin $currentUsers } | ForEach-Object{
Add-Content -Path "C:\Users\$env:USERNAME\Documents\AddUser.txt" -Value "$($_.username)"
}

$userPassword = ConvertTo-SecureString "team1Adm!n!" -AsPlainText -Force
$adminPassword = ConvertTo-SecureString "team1Adm!n!" -AsPlainText -Force

$usercsv | Where-Object { $_.username -notin $currentUsers } | ForEach-Object{New-ADUser -Name $_.username -AccountPassword $userPasssword -Enabled $true}
$admincsv | Where-Object { $_.username -notin $currentUsers } | ForEach-Object{New-ADUser -Name $_.username -AccountPassword $adminPasssword -Enabled $true}


# Get AD-Users from windows, selects the accounts that are NOT the built in Administrator, Guest, Windows Defender Account, the Default user account, and the Kerberos account. Outputs a hashtable in 
$currentUsers = get-aduser -filter * | Where-Object {$_.Name -ne "Administrator" -and $_.Name -ne "Guest" -and $_.Name -ne "WDAGUtilityAccount" -and $_.Name -ne "DefaultAccount" -and $_.Name -ne "krbtgt" -and $_.Name -ne "black_team" } | select SamAccountName 

# Getting the currentUsers out of the hash table
$currentUsers = $currentUsers | ForEach-Object { $_.SamAccountName }


#Make sure password stored using reversable encryption off
$currentUsers | ForEach-Object {Set-ADUser -Identity $_ -AllowReversiblePasswordEncryption $false}

# Make sure all authorized accounts are enabled
$currentUsers | ForEach-Object {Enable-ADAccount $_}

#Accounts not for delegation
$currentUsers | ForEach-Object {Set-ADUser -Identity $_ -AccountNotDelegated $true}

#Disable do not require kerberos preauth
$currentUsers | ForEach-Object {Set-ADAccountControl -Identity $_ -DoesNotRequirePreAuth $false}

#Account Delegation
$currentUsers | ForEach-Object {Set-ADAccountControl -Identity $_ -AccountNotDelegated $true}

#Enable accounts
$currentUsers | ForEach-Object {Set-ADAccountControl -Identity $_ -Enabled $true}

#Deleting sID history
$currentUsers | ForEach-Object {Set-ADUser $_ -remove @{sidhistory=$_.sidhistory.value}}

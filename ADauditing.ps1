# clear the terminal
Clear-Host

import-module ActiveDirectory

# Get path to the text document with the list of users
$userListPath = "C:\Users\$env:USERNAME\Documents\User.txt"

# Get the list of users from the text document
$requiredUsers = Get-Content $userListPath

# Get AD-Users from windows, selects the accounts that are NOT the built in Administrator, Guest, Windows Defender Account, the Default user account, and the Kerberos account. Outputs a hashtable in 
$currentUsers = get-aduser -filter * | Where-Object {$_.Name -ne "Administrator" -and $_.Name -ne "Guest" -and $_.Name -ne "WDAGUtilityAccount" -and $_.Name -ne "DefaultAccount" -and $_.Name -ne "krbtgt"  } | select SamAccountName 

# Getting the currentUsers out of the hash table
$currentUsers = $currentUsers | ForEach-Object { $_.SamAccountName }




# log users to remove
$currentUsers | Where-Object { $_ -notin $requiredUsers } | ForEach-Object{Add-Content -Path "C:\Users\$env:USERNAME\Documents\DelUser.txt" -Value "$_"}

# remove user 
$currentUsers | Where-Object { $_ -notin $requiredUsers } | ForEach-Object {Remove-ADUser -Identity $_}

#log users to add
$requiredUsers | Where-Object {$_ -notin $currentUsers } | ForEach-Object {Add-Content -Path "C:\Users\$env:USERNAME\Documents\AddUser.txt" -Value "$_"}

# add users
$requiredUsers | Where-Object {$_ -notin $currentUsers } | ForEach-Object {New-ADUser -Name $_ }




#get primary group
$primarygroup = get-adgroup "Domain Users" -properties @("primaryGroupToken") 
#set for everyone
$requiredUsers | ForEach-Object{get-aduser $_ | set-aduser -replace @{primaryGroupID=$primarygroup.primaryGroupToken} }




#Add Admin to the admin group
$requiredAdmin = Get-Content -Path "C:\Users\$env:USERNAME\Documents\Admin.txt"
$requiredAdmin | ForEach-Object {Add-ADGroupMember -Identity Administrators -Members $_}

#Remove unrestricted admin 
$requiredUsers | Where-Object { $_ -notin $requiredAdmin} | ForEach-Object {Remove-ADGroupMember -Identity Administrators -Members $_}


#Add to domain admin
$requiredAdmin | ForEach-Object {Add-ADGroupMember -Identity "Domain Admins" -Members $_}
#Remover non admin
$requiredUsers | Where-Object { $_ -notin $requiredAdmin} | ForEach-Object {Remove-ADGroupMember -Identity "Domain Admins" -Members $_}


#Add to dns admin
$requiredAdmin | ForEach-Object {Add-ADGroupMember -Identity "DnsAdmins" -Members $_}
#Remover non admin
$requiredUsers | Where-Object { $_ -notin $requiredAdmin} | ForEach-Object {Remove-ADGroupMember -Identity "DnsAdmins" -Members $_}

#add Schema Admins
$requiredAdmin | ForEach-Object {Add-ADGroupMember -Identity "Schema Admins" -Members $_}
#Remover non admin
$requiredUsers | Where-Object { $_ -notin $requiredAdmin} | ForEach-Object {Remove-ADGroupMember -Identity "Schema Admins" -Members $_}

#add Key Admins
$requiredAdmin | ForEach-Object {Add-ADGroupMember -Identity "Key Admins" -Members $_}
#Remover non admin
$requiredUsers | Where-Object { $_ -notin $requiredAdmin} | ForEach-Object {Remove-ADGroupMember -Identity "Key Admins" -Members $_}





#Make sure all auth accounts can change password
$requiredUsers | ForEach-Object {Set-ADUser -Identity $_ -CannotChangePassword $false}

#Make sure all auth accounts passwords expire
$requiredUsers | ForEach-Object {Set-ADUser -Identity $_ -PasswordNeverExpires $false}

#Make sure password stored using reversable encryption off
$requiredUsers | ForEach-Object {Set-ADUser -Identity $_ -AllowReversiblePasswordEncryption $false}

# Make sure all authorized accounts are enabled
$requiredUsers | ForEach-Object {Enable-ADAccount $_}

#Accounts not for delegation
$requiredUsers | ForEach-Object {Set-ADUser -Identity $_ -AccountNotDelegated $true}

#Disable do not require kerberos preauth
$requiredUsers | ForEach-Object {Set-ADAccountControl -Identity $_ -DoesNotRequirePreAuth $false}

#Account Delegation
$requiredUsers | ForEach-Object {Set-ADAccountControl -Identity $_ -AccountNotDelegated $true}


#Get all groups
$groups = Get-ADGroup -filter * | select name
#Remove managed by
$groups | foreach-object{Set-ADGroup -Identity $_.name -ManagedBy $null}


import-module ActiveDirectory
$csv = import-csv -Path "C:\Users\Strik\Documents\Goodness-gracious-great-walls-of-fire\csv\admin.csv"

Foreach($user in $csv)
{
    echo($user.username)
    echo($user.password)
    #Set-ADAccountPassword -Identity $user.username -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $user.password -Force)
}





# Do NOT delete BLACK TEAM !!!!!!!
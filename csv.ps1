import-module ActiveDirectory
$csv = import-csv -Path "C:\Users\Strik\Documents\Goodness-gracious-great-walls-of-fire\csv\admin.csv"

Foreach($user in $csv)
{
    echo($user.username)
    echo($user.password)
    #Set-ADAccountPassword -Identity $user.username -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $user.password -Force)
}









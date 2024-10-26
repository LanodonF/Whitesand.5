# Shellbags
# Windows scripts



 
# Wireshark
Invoke-WebRequest https://2.na.dl.wireshark.org/win64/Wireshark-4.4.1-x64.exe -OutFile "Wireshark.exe"

#Sysinternals
Invoke-WebRequest https://download.sysinternals.com/files/SysinternalsSuite.zip -OutFile "Sysinternals.zip"
Expand-Archive -Path "Sysinternals.zip"

Invoke-WebRequest "https://objects.githubusercontent.com/github-production-release-asset-2e65be/23216272/b956bf27-aac4-4674-bcf3-bb4ff2e61e22?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20241026%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20241026T014651Z&X-Amz-Expires=300&X-Amz-Signature=43c140188e76e6173c598f852c7bacb333ef9ee41f1ddb7f94893fd01ec9bdbf&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3DGit-2.47.0-64-bit.exe&response-content-type=application%2Foctet-stream" -OutFile "gitinstall.exe"
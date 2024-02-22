Option Explicit

Dim fso, hostFile, temp, hosts(), i, choice, sshCommand
Dim WshShell, hostListFilePath

' Path to your host list file
hostListFilePath = "C:\path\to\your\host_list.txt"

' Create FileSystemObject
Set fso = CreateObject("Scripting.FileSystemObject")

' Check if the host list file exists
If Not fso.FileExists(hostListFilePath) Then
    WScript.Echo "Host list file not found: " & hostListFilePath
    WScript.Quit
End If

' Read hosts from file
i = 0
Set hostFile = fso.OpenTextFile(hostListFilePath, 1) ' 1 = ForReading
Do Until hostFile.AtEndOfStream
    ReDim Preserve hosts(i)
    hosts(i) = hostFile.ReadLine
    i = i + 1
Loop
hostFile.Close

' Prompt user to select a host
For i = 0 To UBound(hosts)
    WScript.Echo i + 1 & ". " & hosts(i)
Next

choice = InputBox("Enter the number of the host you want to SSH into:", "Select Host")

If choice = "" Then
    WScript.Echo "No host selected. Exiting."
    WScript.Quit
End If

If IsNumeric(choice) Then
    If choice >= 1 And choice <= UBound(hosts) + 1 Then
        ' Construct SSH command
        sshCommand = "cmd /c ssh " & hosts(choice - 1)
        
        ' Execute SSH command
        Set WshShell = CreateObject("WScript.Shell")
        WshShell.Run sshCommand, 1, False
    Else
        WScript.Echo "Invalid selection. Exiting."
    End If
Else
    WScript.Echo "Invalid input. Exiting."
End If

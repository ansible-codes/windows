Option Explicit

Dim objFSO, objTextFile
Dim strLine, strCommand, strNsLookupResult, strIP, strHostname
Dim objShell, objExecObject
Dim outputFile, htmlContent

' File containing URLs
Const urlListFile = "url_list_file.txt"
' Output HTML File
Const outputHtml = "output.html"

' Create FileSystemObject
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Open the URL list file
Set objTextFile = objFSO.OpenTextFile(urlListFile, 1)

' Prepare HTML content
htmlContent = "<html><body><table border='1'><tr><th>URL</th><th>IP Address</th><th>Hostname</th></tr>"

' Create WScript Shell object
Set objShell = WScript.CreateObject("WScript.Shell")

' Read each URL and perform nslookup
Do While objTextFile.AtEndOfStream <> True
    strLine = objTextFile.ReadLine

    ' First nslookup to get IP Address
    strCommand = "nslookup " & strLine
    Set objExecObject = objShell.Exec("%COMSPEC% /c " & strCommand)
    strNsLookupResult = objExecObject.StdOut.ReadAll
    strIP = ExtractValue(strNsLookupResult, "Address: ")

    ' Second nslookup to get Hostname
    strCommand = "nslookup " & strIP
    Set objExecObject = objShell.Exec("%COMSPEC% /c " & strCommand)
    strNsLookupResult = objExecObject.StdOut.ReadAll
    strHostname = ExtractValue(strNsLookupResult, "Name: ")

    ' Append to HTML content
    htmlContent = htmlContent & "<tr><td>" & strLine & "</td><td>" & strIP & "</td><td>" & strHostname & "</td></tr>"
Loop

' Close the file
objTextFile.Close

' Finalize HTML content
htmlContent = htmlContent & "</table></body></html>"

' Write the HTML file
Set outputFile = objFSO.CreateTextFile(outputHtml, True)
outputFile.WriteLine(htmlContent)
outputFile.Close

' Function to extract specific value from nslookup result
Function ExtractValue(result, label)
    Dim lines, line, i
    ExtractValue = ""
    lines = Split(result, vbCrLf)
    For i = 0 To UBound(lines)
        line = Trim(lines(i))
        If InStr(line, label) > 0 Then
            ExtractValue = Trim(M

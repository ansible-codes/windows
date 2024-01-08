Set fso = CreateObject("Scripting.FileSystemObject")
Set inputFile = fso.OpenTextFile("url_to_dnslookup.txt", 1)
Set outputFile = fso.CreateTextFile("dns_lookup_results.html", True)

outputFile.WriteLine "<html><head><title>DNS Lookup Results</title></head><body>"
outputFile.WriteLine "<h1>DNS Lookup Results</h1>"
outputFile.WriteLine "<table border='1'><tr><th>URL</th><th>IP Address</th><th>Hostname</th></tr>"

Do While inputFile.AtEndOfStream <> True
    url = inputFile.ReadLine
    Set shell = CreateObject("WScript.Shell")
    Set execObj = shell.Exec("nslookup " & url)
    result = execObj.StdOut.ReadAll

    ' Extract IP and Hostname from result
    ' This is a simplistic extraction method and might need adjustments based on actual nslookup output
    ip = "Not Found"
    hostname = "Not Found"
    If InStr(result, "Name:") > 0 Then
        hostname = Mid(result, InStr(result, "Name:") + 6)
        hostname = Split(hostname, vbCrLf)(0)
    End If
    If InStr(result, "Address:") > 0 Then
        ip = Mid(result, InStrRev(result, "Address:") + 9)
        ip = Split(ip, vbCrLf)(0)
    End If

    outputFile.WriteLine "<tr><td>" & url & "</td><td>" & ip & "</td><td>" & hostname & "</td></tr>"
Loop

outputFile.WriteLine "</table></body></html>"
outputFile.Close
inputFile.Close

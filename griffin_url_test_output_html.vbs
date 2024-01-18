' Path to the file containing URLs
fileName = "C:\path\to\your\file.txt"

' HTML file to save results
htmlFileName = "C:\path\to\your\results.html"

' HTML content initialization
Dim htmlHeader, htmlFooter, htmlContent
htmlHeader = "<html><head><title>URL Check Results</title></head><body><h1>URL Check Results</h1><table border='1'><tr><th>URL</th><th>Status Code</th><th>Date and Time</th><th>Status</th></tr>"
htmlContent = ""
htmlFooter = "</table></body></html>"

' Create the File System Object
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Check if the file exists
If objFSO.FileExists(fileName) Then
    Set objFile = objFSO.OpenTextFile(fileName, 1)
    Do Until objFile.AtEndOfStream
        url = objFile.ReadLine
        CheckURL url
    Loop
    objFile.Close
Else
    WScript.Echo "File not found."
    WScript.Quit
End If

' Function to check URL and append to HTML content
Sub CheckURL(url)
    Set objHTTP = CreateObject("Microsoft.XMLHTTP")
    On Error Resume Next
    objHTTP.Open "GET", url, False
    objHTTP.Send ""
    If Err.Number = 0 Then
        If objHTTP.Status = 200 Then
            htmlContent = htmlContent & "<tr><td>" & url & "</td><td>" & objHTTP.Status & "</td><td>" & Now & "</td><td>Accessible</td></tr>"
        Else
            htmlContent = htmlContent & "<tr><td>" & url & "</td><td>" & objHTTP.Status & "</td><td>" & Now & "</td><td>Not Accessible</td></tr>"
        End If
    Else
        htmlContent = htmlContent & "<tr><td>" & url & "</td><td>Error</td><td>" & Now & "</td><td>Not Accessible</td></tr>"
    End If
    On Error GoTo 0
    Set objHTTP = Nothing
End Sub

' Save the HTML content to a file
Set htmlFile = objFSO.CreateTextFile(htmlFileName, True)
htmlFile.Write(htmlHeader & htmlContent & htmlFooter)
htmlFile.Close

' Notify the user
MsgBox "HTML report generated: " & htmlFileName

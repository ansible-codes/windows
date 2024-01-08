Option Explicit

Dim objFSO, objTextFile, strLine, objHTTP, url

' Create the File System Object
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Open the text file - replace 'url_list.txt' with your path
Set objTextFile = objFSO.OpenTextFile("url_list.txt", 1) ' 1 = ForReading

' Create HTTP request object
Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP")

' Read and process each line from the file
Do Until objTextFile.AtEndOfStream
    strLine = objTextFile.ReadLine
    url = Trim(strLine) ' Read URL

    ' Send HTTP request to the URL
    objHTTP.Open "GET", url, False
    objHTTP.Send ""

    ' Check response status and print the result
    If objHTTP.Status = 200 Then
        WScript.Echo "URL: " & url & vbCrLf & "Response: " & objHTTP.responseText & vbCrLf
    Else
        WScript.Echo "Error fetching " & url & ": " & objHTTP.Status & " " & objHTTP.statusText & vbCrLf
    End If
Loop

' Clean up
objTextFile.Close
Set objTextFile = Nothing
Set objFSO = Nothing
Set objHTTP = Nothing

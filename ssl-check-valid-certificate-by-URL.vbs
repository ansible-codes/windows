Option Explicit

Dim objFSO, objTextFile, strLine, objHTTP, url
Dim htmlOutputOK, htmlOutputFail, finalHtmlOutput, msgBoxOutputOK, msgBoxOutputFail

' Initialize HTML and MessageBox Outputs
htmlOutputOK = "<html><body><h2>SSL Check - OK</h2><table border='1'><tr><th>URL</th></tr>"
htmlOutputFail = "<h2>SSL Check - FAILED</h2><table border='1'><tr><th>URL</th></tr>"
msgBoxOutputOK = "SSL Check OK for URLs:" & vbCrLf
msgBoxOutputFail = "SSL Check FAILED for URLs:" & vbCrLf

' Create the File System Object
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Open the text file
Set objTextFile = objFSO.OpenTextFile("url_list.txt", 1) ' 1 = ForReading

' Create HTTP request object
Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP.6.0")

' Read and process each line from the file
Do Until objTextFile.AtEndOfStream
    strLine = objTextFile.ReadLine
    url = Trim(strLine) ' Read URL

    On Error Resume Next ' Enable error handling

    ' Attempt to connect to the URL
    objHTTP.Open "GET", url, False
    objHTTP.Send ""

    ' Check SSL status
    If Err.Number = 0 Then
        ' No error, SSL is assumed OK
        htmlOutputOK = htmlOutputOK & "<tr><td>" & url & "</td></tr>"
        msgBoxOutputOK = msgBoxOutputOK & url & vbCrLf
    Else
        ' Error occurred, SSL check failed
        htmlOutputFail = htmlOutputFail & "<tr><td>" & url & "</td></tr>"
        msgBoxOutputFail = msgBoxOutputFail & url & vbCrLf
    End If

    On Error Goto 0 ' Disable error handling
Loop

' Finalize HTML Outputs
htmlOutputOK = htmlOutputOK & "</table>"
htmlOutputFail = htmlOutputFail & "</table>"
finalHtmlOutput = htmlOutputOK & htmlOutputFail & "</body></html>"

' Write the HTML output to a file
Set objTextFile = objFSO.CreateTextFile("SSL-check-result.html", True)
objTextFile.Write finalHtmlOutput
objTextFile.Close

' Display results in message boxes
If Len(msgBoxOutputOK) > 23 Then ' Length of initial message + vbCrLf
    MsgBox msgBoxOutputOK, vbInformation, "SSL Check - OK"
End If
If Len(msgBoxOutputFail) > 27 Then ' Length of initial message + vbCrLf
    MsgBox msgBoxOutputFail, vbExclamation, "SSL Check - Failed"

' Clean up
Set objTextFile = Nothing
Set objFSO = Nothing
Set objHTTP = Nothing

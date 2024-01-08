Option Explicit

Dim objFSO, objTextFile, strLine, objHTTP, url, htmlOutput, sslResult

' Initialize HTML Output
htmlOutput = "<html><body><table border='1'><tr><th>URL</th><th>SSL Check Result</th></tr>"

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
        sslResult = "<td style='color: green;'>OK</td>"
    Else
        ' Error occurred, SSL check failed
        sslResult = "<td style='color: red;'>FAIL SSL check</td>"
    End If

    ' Append to HTML output
    htmlOutput = htmlOutput & "<tr><td>" & url & "</td>" & sslResult & "</tr>"

    On Error Goto 0 ' Disable error handling
Loop

' Finalize HTML Output
htmlOutput = htmlOutput & "</table></body></html>"

' Write the HTML output to a file
Set objTextFile = objFSO.CreateTextFile("SSL-check-result.html", True)
objTextFile.Write htmlOutput
objTextFile.Close

' Clean up
Set objTextFile = Nothing
Set objFSO = Nothing
Set objHTTP = Nothing

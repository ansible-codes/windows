' Path to the file containing URLs
fileName = "C:\path\to\your\file.txt"

' Lists to hold the status of URLs
Dim goodUrls, badUrls
goodUrls = ""
badUrls = ""

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

' Function to check URL
Sub CheckURL(url)
    Set objHTTP = CreateObject("Microsoft.XMLHTTP")
    On Error Resume Next
    objHTTP.Open "GET", url, False
    objHTTP.Send ""
    If Err.Number = 0 Then
        If objHTTP.Status = 200 Then
            goodUrls = goodUrls & url & vbCrLf
        Else
            badUrls = badUrls & url & " - Status: " & objHTTP.Status & vbCrLf
        End If
    Else
        badUrls = badUrls & url & " - Error accessing URL" & vbCrLf
    End If
    On Error GoTo 0
    Set objHTTP = Nothing
End Sub

' Show message boxes
If goodUrls <> "" Then
    MsgBox "Accessible URLs:" & vbCrLf & goodUrls
Else
    MsgBox "No accessible URLs found."
End If

If badUrls <> "" Then
    MsgBox "Not Accessible URLs:" & vbCrLf & badUrls
Else
    MsgBox "All URLs are accessible."
End If

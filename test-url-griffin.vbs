' Path to the file containing URLs
fileName = "C:\path\to\your\file.txt"

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
End If

' Function to check URL
Sub CheckURL(url)
    Set objHTTP = CreateObject("Microsoft.XMLHTTP")
    On Error Resume Next
    objHTTP.Open "GET", url, False
    objHTTP.Send ""
    If Err.Number = 0 Then
        If objHTTP.Status = 200 Then
            WScript.Echo "URL is accessible: " & url
        Else
            WScript.Echo "URL is not accessible: " & url & ". Status: " & objHTTP.Status
        End If
    Else
        WScript.Echo "Error accessing URL: " & url
    End If
    On Error GoTo 0
    Set objHTTP = Nothing
End Sub

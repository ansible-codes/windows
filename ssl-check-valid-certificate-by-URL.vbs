Option Explicit

Dim strURL, objFSO, objTextFile, objWinHttp
Dim strFilePath, strLine, blnSSLValid

' Path to the text file with URLs
strFilePath = "C:\path\to\list.txt"

' Create FileSystemObject
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Open text file with list of URLs
Set objTextFile = objFSO.OpenTextFile(strFilePath, 1)

' Loop through each line in the text file
Do While objTextFile.AtEndOfStream <> True
    strLine = objTextFile.ReadLine
    strURL = Trim(strLine)

    ' Check if the line is not empty
    If strURL <> "" Then
        blnSSLValid = CheckSSL(strURL)
        If blnSSLValid Then
            WScript.Echo "SSL Valid for URL: " & strURL
        Else
            WScript.Echo "SSL Invalid or Error for URL: " & strURL
        End If
    End If
Loop

' Close the text file
objTextFile.Close

' Function to check SSL
Function CheckSSL(strURL)
    On Error Resume Next
    Set objWinHttp = CreateObject("WinHttp.WinHttpRequest.5.1")
    objWinHttp.Open "GET", strURL, False
    objWinHttp.Send

    ' Check if error occurs
    If Err.Number = 0 Then
        CheckSSL = True
    Else
        CheckSSL = False
    End If

    On Error GoTo 0
    Set objWinHttp = Nothing
End Function

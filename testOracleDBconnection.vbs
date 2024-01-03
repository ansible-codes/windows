Option Explicit

Dim connectionString, username, password, server, database
Dim objConnection

' Set your database connection details
username = "your_username"  ' Replace with your username
password = "your_password"  ' Replace with your password
server = "your_server"      ' Replace with your server address
database = "your_database"  ' Replace with your database name or service name

' Construct connection string
connectionString = "Provider=OraOLEDB.Oracle;Data Source=" & server & "/" & database & ";User Id=" & username & ";Password=" & password & ";"

Set objConnection = CreateObject("ADODB.Connection")

On Error Resume Next
objConnection.Open connectionString

If objConnection.State = 1 Then
    WScript.Echo "Connection successful"
Else
    WScript.Echo "Connection failed. Check your credentials and connection details: " & vbCrLf & _
                 "Username: " & username & vbCrLf & _
                 "Password: [Hidden for Security]" & vbCrLf & _
                 "Server: " & server & vbCrLf & _
                 "Database: " & database & vbCrLf & _
                 "Error: " & Err.Description
End If

objConnection.Close
Set objConnection = Nothing

Option Explicit

Dim shell, fso, textFile, gitLogFile
Dim gitCloneCmd, destinationPath, jiraNumber, repoName
Dim userInputFile, newBranchCmd, checkoutBranchCmd, checkoutJiraBranchCmd, gitBranchCmd
Dim gitStatusCmd, gitLogCmd

' Create FileSystemObject
Set fso = CreateObject("Scripting.FileSystemObject")

' Set the path for the user input options file and git log file
userInputFile = "userInputOptions.txt"
gitLogFile = "gitlog.txt"

' Open the text files for writing
Set textFile = fso.OpenTextFile(userInputFile, 8, True)
Set gitLogFile = fso.OpenTextFile(gitLogFile, 8, True)

' Create Shell object
Set shell = CreateObject("WScript.Shell")

' Ask for the Git clone command
gitCloneCmd = InputBox("Enter the Git clone command:", "Git Clone")
textFile.WriteLine("Git Clone Command: " & gitCloneCmd)

' Ask for the destination path directory to clone
destinationPath = InputBox("Enter the destination path directory to clone:", "Destination Path")
textFile.WriteLine("Destination Path: " & destinationPath)

' Run the Git clone command
shell.Run "cmd /k cd /d " & destinationPath & " & " & gitCloneCmd, 1, True

' Extract repository name from the Git clone command
repoName = Mid(gitCloneCmd, InStrRev(gitCloneCmd, "/") + 1)
If InStr(repoName, ".git") > 0 Then
    repoName = Left(repoName, InStrRev(repoName, ".git") - 1)
End If

' Change directory to the cloned repository
shell.Run "cmd /k cd /d " & destinationPath & "\" & repoName, 1, True

' Checkout the 'develop' branch
shell.Run "cmd /k git checkout develop", 1, True

' Get git status
gitStatusCmd = "git status"
shell.Run "cmd /k " & gitStatusCmd & " > " & destinationPath & "\" & repoName & "\" & gitLogFile, 1, True
gitLogFile.WriteLine("Git Status: " & gitStatusCmd)

' Ask for the JIRA number
jiraNumber = InputBox("Enter the Griffin JIRA number:", "JIRA Number")
textFile.WriteLine("JIRA Number: " & jiraNumber)

' Create and checkout new branch based on JIRA number
newBranchCmd = "git checkout -b " & jiraNumber
shell.Run "cmd /k " & newBranchCmd, 1, True
textFile.WriteLine("New Branch Command: " & newBranchCmd)

' Pull the new branch
checkoutBranchCmd = "git pull origin " & jiraNumber
shell.Run "cmd /k " & checkoutBranchCmd, 1, True
textFile.WriteLine("Checkout Branch Command: " & checkoutBranchCmd)

' Checkout the JIRA branch
checkoutJiraBranchCmd = "git checkout " & jiraNumber
shell.Run "cmd /k " & checkoutJiraBranchCmd, 1, True
gitLogFile.WriteLine("Checkout JIRA Branch Command: " & checkoutJiraBranchCmd)

' Run git branch and log it
gitBranchCmd = "git branch"
shell.Run "cmd /k " & gitBranchCmd & " >> " & destinationPath & "\" & repoName & "\" & gitLogFile, 1, True
gitLogFile.WriteLine("Git Branch Command: " & gitBranchCmd)

' Get git log
gitLogCmd = "git log"
shell.Run "cmd /k " & gitLogCmd & " >> " & destinationPath & "\" & repoName & "\" & gitLogFile, 1, True
gitLogFile.WriteLine("Git Log: " & gitLogCmd)

' Close the text files
textFile.Close
gitLogFile.Close

Set shell = Nothing
Set fso = Nothing

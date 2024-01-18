Option Explicit

Dim shell, fso, textFile
Dim gitCloneCmd, destinationPath, jiraNumber
Dim userInputFile

' Set the path for the user input options file
userInputFile = "userInputOptions.txt"

' Create FileSystemObject
Set fso = CreateObject("Scripting.FileSystemObject")

' Open the text file for writing
Set textFile = fso.OpenTextFile(userInputFile, 8, True)

' Create Shell object
Set shell = CreateObject("WScript.Shell")

' Ask for the Git clone command
gitCloneCmd = InputBox("Enter the Git clone command:", "Git Clone")
textFile.WriteLine("Git Clone Command: " & gitCloneCmd)

' Ask for the destination path directory to clone
destinationPath = InputBox("Enter the destination path directory to clone:", "Destination Path")
textFile.WriteLine("Destination Path: " & destinationPath)

' Change directory to the destination path
shell.Run "cmd /c cd /d " & destinationPath, 0, True

' Run the Git clone command
shell.Run "cmd /c " & gitCloneCmd, 0, True

' Change directory to the cloned repository
Dim repoName
repoName = Mid(gitCloneCmd, InStrRev(gitCloneCmd, " ") + 1)
shell.Run "cmd /c cd " & repoName, 0, True

' Checkout the 'develop' branch
shell.Run "cmd /c git checkout develop", 0, True

' Ask for the JIRA number
jiraNumber = InputBox("Enter the Griffin JIRA number:", "JIRA Number")
textFile.WriteLine("JIRA Number: " & jiraNumber)

' Create and checkout new branch based on JIRA number
Dim newBranchCmd
newBranchCmd = "git checkout -b " & jiraNumber
shell.Run "cmd /c " & newBranchCmd, 0, True
textFile.WriteLine("New Branch Command: " & newBranchCmd)

' Pull the new branch
Dim checkoutBranchCmd
checkoutBranchCmd = "git pull origin " & jiraNumber
shell.Run "cmd /c " & checkoutBranchCmd, 0, True
textFile.WriteLine("Checkout Branch Command: " & checkoutBranchCmd)

' Close the text file
textFile.Close

Set shell = Nothing
Set fso = Nothing

On Error Resume Next
Dim wbemCimtypeString 
wbemCimtypeString = 8 
Set oLocation = CreateObject("WbemScripting.SWbemLocator") 

Set oServices = oLocation.ConnectServer(,"root\cimv2") 
set oNewObject = oServices.Get("WIN32_localadmins") 
oNewObject.Delete_ 


' Create data class structure 
Set oDataObject = oServices.Get 
oDataObject.Path_.Class = "WIN32_localadmins" 
oDataObject.Properties_.add "Account" , wbemCimtypeString 
oDataObject.Properties_("Account").Qualifiers_.add "key" , True 
oDataObject.Properties_.add "Domain" , wbemCimtypeString
oDataObject.Properties_.add "Type" , wbemCimtypeString
oDataObject.Properties_.add "Name" , wbemCimtypeString
oDataObject.Properties_("Name").Qualifiers_.add "key" , True
oDataObject.Put_ 

Dim objGroup, strComputer ,strUserPath ,arrUserBits ,wshNetwork ,Domain,Name , Type1
Set wshNetwork = WScript.CreateObject( "WScript.Network" )
strComputer = wshNetwork.ComputerName
Set objGroup = GetObject("WinNT://" & strComputer & "/Administrators,group") 
Dim objMember 
For Each objMember In objGroup.Members 
                strUserPath = Mid(objMember.aDSPath, 9)
				arrUserBits = Split(strUserPath, "/")
				If UBound(arrUserBits) = 2 Then
					strUserPath = arrUserBits(1) & "/" & arrUserBits(2)
				Else
					strUserPath = arrUserBits(0) & "/" & arrUserBits(1)
				End If

arrUserBits = Split(strUserPath, "/")
Domain = arrUserBits(0)
Name= arrUserBits(1)
If Domain = strComputer Then
Type1 = "Local" 
Else 
Type1 = "Domain" 
End If

Set oNewObject = oServices.Get("WIN32_localadmins" ).SpawnInstance_ 
oNewObject.Type =  Type1
oNewObject.Domain = Domain 
oNewObject.Account = objMember.Class 
oNewObject.Name = Name
oNewObject.Put_ 
Next
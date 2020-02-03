On Error Resume Next

Dim wbemCimtypeSint16 
Dim wbemCimtypeSint32 
Dim wbemCimtypeReal32 
Dim wbemCimtypeReal64 
Dim wbemCimtypeString 
Dim wbemCimtypeBoolean 
Dim wbemCimtypeObject 
Dim wbemCimtypeSint8 
Dim wbemCimtypeUint8 
Dim wbemCimtypeUint16 
Dim wbemCimtypeUint32 
Dim wbemCimtypeSint64 
Dim wbemCimtypeUint64 
Dim wbemCimtypeDateTime 
Dim wbemCimtypeReference 
Dim wbemCimtypeChar16 

wbemCimtypeSint16 = 2 
wbemCimtypeSint32 = 3 
wbemCimtypeReal32 = 4 
wbemCimtypeReal64 = 5 
wbemCimtypeString = 8 
wbemCimtypeBoolean = 11 
wbemCimtypeObject = 13 
wbemCimtypeSint8 = 16 
wbemCimtypeUint8 = 17 
wbemCimtypeUint16 = 18 
wbemCimtypeUint32 = 19 
wbemCimtypeSint64 = 20 
wbemCimtypeUint64 = 21 
wbemCimtypeDateTime = 101 
wbemCimtypeReference = 102 
wbemCimtypeChar16 = 103

Set oLocation = CreateObject("WbemScripting.SWbemLocator") 

Set oServices = oLocation.ConnectServer(,"root\cimv2") 
set oNewObject = oServices.Get("WIN32_LocalAdmins") 
oNewObject.Delete_ 


' Create data class structure 
Set oDataObject = oServices.Get 
oDataObject.Path_.Class = "WIN32_LocalAdmins" 
oDataObject.Properties_.add "Account" , wbemCimtypeString 
oDataObject.Properties_("Account").Qualifiers_.add "key" , True 
oDataObject.Properties_.add "Domain" , wbemCimtypeString
oDataObject.Properties_.add "Type" , wbemCimtypeString
oDataObject.Properties_.add "Name" , wbemCimtypeString
oDataObject.Properties_("Name").Qualifiers_.add "key" , True
oDataObject.Put_ 

Dim objGroup, strComputer ,strUserPath ,arrUserBits ,wshNetwork ,Domain, Name, Type1
Set wshNetwork = WScript.CreateObject( "WScript.Network" )
strComputer = wshNetwork.ComputerName

'ORIGINAL LOOP, GETS MEMBERS OF "ADMINISTRATORS" GROUP
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

	Set oNewObject = oServices.Get("WIN32_LocalAdmins" ).SpawnInstance_ 
	oNewObject.Type =  Type1
	oNewObject.Domain = Domain 
	oNewObject.Account = objMember.Class 
	oNewObject.Name = Name
	oNewObject.Put_ 
Next 


'NEW LOOP, GETS MEMBERS OF "ADMINISTRADORES" GROUP
Set objGroup = GetObject("WinNT://" & strComputer & "/Administradores,group") 
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

	Set oNewObject = oServices.Get("WIN32_LocalAdmins" ).SpawnInstance_ 
	oNewObject.Type =  Type1
	oNewObject.Domain = Domain 
	oNewObject.Account = objMember.Class 
	oNewObject.Name = Name
	oNewObject.Put_ 
Next 



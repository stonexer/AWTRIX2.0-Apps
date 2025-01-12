﻿B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
	Dim sb As StringBuilder
End Sub

Public Sub Initialize() As String
	sb.Initialize
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.AppName="Tankerkoenig"
	
	'Version of the App
	App.AppVersion="2.1"
	
	'Description of the App. You can use HTML to format it
	App.AppDescription=$"
	Zeigt dir die die Spritpreise in Deiner Nähe an.<br/>
	Powered by Tankerkoenig.<br />
	<small>Created by AWTRIX</small>
	"$
		
	'SetupInstructions. You can use HTML to format it
	App.SetupInfos= $"
	<b>APIkey:</b> https://creativecommons.tankerkoenig.de/.<br/><br/>
	<b>Latitude & Longitude:</b> Koordinaten kann man hier bekommen https://www.latlong.net/.<br/><br/>
	<b>Radius:</b> Suchradius in km.<br/><br/>
	<b>Type:</b> Spritsorte ('e5', 'e10', 'diesel' oder 'all')<br/><br/>	
	"$
	
	'How many downloadhandlers should be generated
	App.NeedDownloads=1
	
	'IconIDs from AWTRIXER.
	App.Icons=Array As Int(128)
	
	'Tickinterval in ms (should be 65 by default)
	App.TickInterval=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.LockApp=True
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.appSettings= CreateMap("Latitude":"","Longitude":"","APIKey":"","Radius":3,"Type":"diesel")
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.AppName
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.AppControl(Tag,Params)
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.DownloadURL= "https://creativecommons.tankerkoenig.de/json/list.php?lat="&App.get("Latitude")&"&lng="&App.get("Longitude")&"&rad="&App.get("Radius")&"&sort=dist&Type="&App.get("Type")&"&apikey="&App.get("APIKey")
	End Select
End Sub

'process the response from each download handler
'if youre working with JSONs you can use this online parser
'to generate the code automaticly
'https://json.blueforcer.de/ 
Sub App_evalJobResponse(Resp As JobResponse)
	Try
		If Resp.success Then
			Select Resp.jobNr
				Case 1
					sb.Initialize
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					Dim stations As List = root.Get("stations")
					For Each colstations As Map In stations
						sb.Append(colstations.Get("brand")).Append(": ").Append(colstations.Get(App.get("Type"))).Append("€").Append("          ")
					Next
			End Select
		End If
	Catch
		Log("Error in: "& App.AppName & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

Sub App_genFrame
	App.genText(sb.ToString,True,1,Null)

	
	If App.scrollposition>9 Then
		App.drawBMP(0,0,App.getIcon(128),8,8)
	Else
		If App.scrollposition>-8 Then
			App.drawBMP(App.scrollposition-9,0,App.getIcon(128),8,8)
		End If
	End If
End Sub
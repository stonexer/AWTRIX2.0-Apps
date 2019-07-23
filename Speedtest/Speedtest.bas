﻿B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
End Sub

Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'change plugin name (must be unique, avoid spaces)
	App.AppName="Speedtest"
	
	'Version of the App
	App.AppVersion="2.2"
	
	'Description of the App. You can use HTML to format it
	App.AppDescription="Messures the time between the Frames"
		
	App.AppAuthor="Blueforcer"

	'How many downloadhandlers should be generated
	App.NeedDownloads=0
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.TickInterval=80
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.LockApp=False
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.appSettings=CreateMap()
	
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

Sub App_genFrame
	App.customCommand(CreateMap("type":"speedtest","random":DateTime.Now))
End Sub

B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim scroll As Int
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.AppName
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.AppControl(Tag,Params)
End Sub

' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.AppName="BME280"
	
	'Version of the App
	App.AppVersion="2.1"
	
	'Description of the App. You can use HTML to format it
	App.AppDescription=$"
	This app shows the temperature and humidity your connected BME280<br/>
	<small>Created by AWTRIX</small>
	"$
		
	'SetupInstructions. You can use HTML to format it
	App.SetupInfos= $"
	
	"$
	
	'How many downloadhandlers should be generated
	App.NeedDownloads=0
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(693,235)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.TickInterval=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.LockApp=False
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.appSettings=CreateMap()
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

Sub App_Started
	scroll=1
End Sub


'With this sub you build your frame.
Sub App_genFrame
	If App.StartedAt<DateTime.Now-App.Appduration*1000/2 Then
		App.genText(App.MatrixInfo.Get("Temp")&"°",True,scroll,Null,False)
		App.drawBMP(0,scroll-1,App.getIcon(235),8,8)
		
		App.genText(App.MatrixInfo.Get("Hum")&"%",True,scroll-8,Null,False)
		App.drawBMP(0,scroll-9,App.getIcon(693),8,8)
		If scroll<9 Then
			scroll=scroll+1
		End If
	Else
		App.genText(App.MatrixInfo.Get("Temp")&"°",True,1,Null,False)
		App.drawBMP(0,0,App.getIcon(235),8,8)
	End If
End Sub
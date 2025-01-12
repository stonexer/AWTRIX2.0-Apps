﻿B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.31
@EndOfDesignText@
Sub Class_Globals
	Dim App As AWTRIX
End Sub

' Config your App
Public Sub Initialize() As String
	
	App.Initialize(Me,"App")
	
	'App name (must be unique, avoid spaces)
	App.AppName="Countdown"
	
	'Version of the App
	App.AppVersion="2.1"
	
	'Description of the App. You can use HTML to format it
	App.AppDescription=$"
	Shows the remaining days from now to a target date <br/>
	<small>Created by 0o.y.o0</small> 
	"$
		
	'SetupInstructions. You can use HTML to format it
	App.SetupInfos= $"
	<b>Date:</b>  Target date (Format: dd.mm.yyyy).<br />
	<b>IconID:</b>  Choose your desired IconID from AWTRIXER.<br />
	<b>Identifier:</b>  Enter your desired translation for "days,day" Example: Tage,Tag.<br />
	"$
	
	'How many downloadhandlers should be generated
	App.NeedDownloads=0
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int(62)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.TickInterval=65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.LockApp=False
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.appSettings=CreateMap("Date":"01.01.2000", "Identifier":"Days,Day", "IconID":62)
	
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

'this sub is called right before AWTRIX will display your App
Sub App_iconRequest
	App.Icons=Array As Int(App.Get("IconID"))
End Sub

'is called every tick, generates the commandlist (drawingroutines) and send it to awtrix
Sub App_genFrame
	App.genText(CountedDays,True,1,Null)
	App.drawBMP(0,0,App.getIcon(App.Get("IconID")),8,8)
End Sub


Sub CountedDays As String
	Dim AmountOfDays As String
	Dim Diff As Int
	Dim PerDiff As Period

	'----------------separate identifiers ------------------------
	Dim separatedIdentifier() As String
	separatedIdentifier=Regex.split(",",App.Get("Identifier"))
	
	'----------------calculate difference ------------------------
	DateTime.DateFormat = "dd.MM.yyyy"
	PerDiff = DateUtils.PeriodBetweenInDays(DateTime.now, datetime.DateParse(App.Get("Date")))
	Diff= PerDiff.Days
	
	'----------------process result ------------------------
	If Diff >=0 Then AmountOfDays = Diff +1 'we have to add one day since the current day is missing
		
	If Diff < 0 Then AmountOfDays = "0"	'we set the amount of days to zero here too
		
	If App.Get("Date") = DateTime.Date(DateTime.now) Then AmountOfDays = Diff 'we set the amount of days to zero because the target date is today

	'----------------select identifier ------------------------
	Dim IdentifierId As Int
	
	If AmountOfDays > 1	Then IdentifierId = 0
	If AmountOfDays = 1 Then IdentifierId = 1
	If AmountOfDays = 0	Then IdentifierId = 0
	
	AmountOfDays = AmountOfDays & " " & separatedIdentifier(IdentifierId)
	
	Return AmountOfDays
End Sub
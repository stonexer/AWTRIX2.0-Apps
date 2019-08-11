﻿B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim artist As String
	Dim song As String
	
	Dim oldartist As String
	Dim oldsong As String
End Sub

' ignore
public Sub GetNiceName() As String
	Return App.name
End Sub

' ignore
public Sub Run(Tag As String, Params As Map) As Object
	Return App.interface(Tag,Params)
End Sub

' Config your App
Public Sub Initialize() As String
	
	'initialize the AWTRIX class and parse the instance; dont touch this
	App.Initialize(Me,"App")
	
	'App name (must be unique, no spaces)
	App.name = "FitBit"
	
	'Version of the App
	App.version = "2.1"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Shows the current music track played on Spotify
	"$
	
	'The developer if this App
	App.author = "Blueforcer"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 120
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)	
	
	'How many downloadhandlers should be generated
	App.downloads = 1
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(120)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick = 65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.lock = True
	
	'This tolds AWTRIX that this App is an Game.
	App.isGame = False
	
	'If set to true, AWTRIX will download new data before each start.
	App.forceDownload = False
 	
	App.InitializeOAuth(" https://www.fitbit.com/oauth2/authorize", "https://api.fitbit.com/oauth2/token ","22B6J2","3fcaa852237ba7bd112922c2c6cea075","activity")

	'ignore
	App.makeSettings
	Return "AWTRIX20"
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	
	
End Sub
	
	
'this sub is called if AWTRIX switch to thee next app and pause this one
Sub App_Exited
	
End Sub	

'this sub is called right before AWTRIX will display your App.
'if you need to another Icon you can set your Iconlist here again.
Sub App_iconRequest
	'App.Icons = Array As Int(4)
End Sub

'If the user change any Settings in the webinterface, this sub will be called
Sub App_settingsChanged
	
End Sub

'if you create an Game, use this sub to get the button presses from the Weeebinterface or Controller
'button defines the buttonID of thee controller, dir is true if it is pressed
Sub App_controllerButton(button As Int,dir As Boolean)
	
End Sub

'if you create an Game, use this sub to get the Analog Values of thee connected Controller
Sub App_controllerAxis(axis As Int, dir As Float)
	
End Sub


'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	
	Select jobNr
		Case 1
			App.Download("https://api.fitbit.com/1/user/-/profile.json")
			App.header = CreateMap("Authorization": "Bearer " & App.Token)
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
			
				Log(Resp.ResponseString)
								
			End Select
			Else

		End If
	Catch
		App.throwError(LastException)
	End Try
End Sub

Sub App_isReady As Boolean
	Return App.Token.Length>0
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	App.genText(artist & " - " & song,True,1,Null,True)
	
	If App.scrollposition>9 Then
		App.drawBMP(0,0,App.getIcon(120),8,8)
	Else
		If App.scrollposition>-8 Then
			App.drawBMP(App.scrollposition-9,0,App.getIcon(120),8,8)
		End If
	End If
End Sub
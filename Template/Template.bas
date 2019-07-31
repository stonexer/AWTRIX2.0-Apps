B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim first_name As String
	
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
	
	'initialize the AWTRIX class and parse the instance; dont touch this
	App.Initialize(Me,"App")
	
	'App name (must be unique, no spaces)
	App.AppName = "Template"
	
	'Version of the App
	App.AppVersion = "2.0"
	
	'Description of the App. You can use HTML to format it
	App.AppDescription = $"
	This is just a template
	"$
	
	'The developer if this App"
	App.AppAuthor = "Blueforcer"
	
	'Icon (ID) to be displayed in the Appstore and MyApps
	App.CoverIcon = 6
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.appSettings=CreateMap("CustomText":"Hello World")
		
	'Setup Instructions. You can use HTML to format it
	App.SetupInfos = $"
	<b>CustomText:</b>Text wich will be shown<br/>
	"$
	
	'define some tags to simplify the search in the Appstore
	App.Tags = Array As String("Template", "Awesome") 
	
	'How many downloadhandlers should be generated
	App.NeedDownloads = 1
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.Icons = Array As Int(6)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.TickInterval = 65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.LockApp = False
	
	'This tolds AWTRIX that this App is an Game.
	App.isGame = False
	
	'If set to true, AWTRIX will download new data before each start.
	App.forceDownload = False
	
	'ignore
	App.MakeSettings
	Return "AWTRIX2"
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
			App.DownloadURL= "https://reqres.in/api/users/2"
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
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					Dim data As Map = root.Get("data")
					first_name = data.Get("first_name")
			End Select
		End If
	Catch
		Log("Error in: "& App.AppName & CRLF & LastException)
		Log("API response: " & CRLF & Resp.ResponseString)
	End Try
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	App.genText(App.get("CustomText") & " " & first_name ,True,1,Null,False)
	App.drawBMP(0,0,App.getIcon(6),8,8)
End Sub
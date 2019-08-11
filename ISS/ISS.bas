B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here
	Dim nextpass As Long
	Dim passduration As Int
	Dim restzeit As Int
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
	App.name = "ISS"
	
	'Version of the App
	App.version = "1.0"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	This is just a template
	"$
	
	'The developer if this App
	App.author = "Blueforcer"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 6
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.settings = CreateMap("Latitude":"","Longitude":"")
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	<b>CustomText:</b>Text wich will be shown<br/>
	"$
	
	'How many downloadhandlers should be generated
	App.downloads = 1
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(6)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick = 65
	
	'ignore
	App.makeSettings
	Return "AWTRIX20"
End Sub


'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	Select jobNr
		Case 1
			App.Download($"http://api.open-notify.org/iss-pass.json?lat=${App.get("Latitude")}&lon=${App.get("Longitude")}"$)
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
					Dim request As Map = root.Get("request")
					Dim passes As Int = request.Get("passes")
					Dim response As List = root.Get("response")
					If passes>0 Then
						Dim pass As Map = response.Get(0)
						passduration = pass.Get("duration")
						nextpass = pass.Get("risetime")
					End If
					calcDuration
			End Select
		End If
	Catch
		App.throwError(LastException)
	End Try
End Sub

'With this sub you build your frame wtih every Tick.
Sub App_genFrame
	calcDuration
	App.genText(calcDuration & "s" ,True,1,Null,False)
	App.drawBMP(0,0,App.getIcon(6),8,8)
End Sub


Sub calcDuration As Int
	If DateTime.Now>nextpass Then
		Dim restzeit As Int = passduration-((DateTime.Now-nextpass)/1000)
		If restzeit>passduration Then App.shouldShow=False
		Return restzeit
	Else
		Return 0
		App.shouldShow=False
	End If
End Sub
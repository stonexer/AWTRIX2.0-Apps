B4J=true
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
	App.name = "Spotify"
	
	'Version of the App
	App.version = "1.0"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Shows the current music track played on Spotify
	"$
	
	'The developer if this App
	App.author = "Blueforcer"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 121
	
	'How many downloadhandlers should be generated
	App.downloads = 1
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(121)
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.tick = 65
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.lock = True
 	
	App.InitializeOAuth("https://accounts.spotify.com/authorize","https://accounts.spotify.com/api/token","8e75610e2e624450b83e420cad84ad4e","0baabd23f75746cb83c8be78f1583d9d","user-read-currently-playing")

	App.polling(True,"")
	
	App.Hidden=True
	'ignore
	App.makeSettings
	Return "AWTRIX20"
End Sub

'Called with every update from Awtrix
'return one URL for each downloadhandler
Sub App_startDownload(jobNr As Int)
	
	Select jobNr
		Case 1
			App.Download("https://api.spotify.com/v1/me/player/currently-playing")
			App.header= CreateMap("Authorization": "Bearer " & App.Token)
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
					If Resp.ResponseString="" Then
						App.shouldShow=False
						Return
					End If
					Dim parser As JSONParser
					parser.Initialize(Resp.ResponseString)
					Dim root As Map = parser.NextObject
					Dim item As Map = root.Get("item")
				
					Dim album As Map = item.Get("album")
					Dim artists As List = album.Get("artists")
					For Each colartists As Map In artists
						artist = colartists.Get("name")
					Next
					song = item.Get("name")
					App.shouldShow=False
					If Not(song=oldsong) Or Not(artist=oldartist) Then
						oldsong=song
						oldartist=artist
						App.shouldShow=True
					End If
			End Select
		Else
			App.shouldShow=False
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
		App.drawBMP(0,0,App.getIcon(121),8,8)
	Else
		If App.scrollposition>-8 Then
			App.drawBMP(App.scrollposition-9,0,App.getIcon(121),8,8)
		End If
	End If
End Sub
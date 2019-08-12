B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	
	'Declare your variables here	
	Dim TTR As String
	Dim QTTR As String
	Dim outputString As String
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
	App.name = "myTischtennis"
	
	'Version of the App
	App.version = "1.01"
	
	'Description of the App. You can use HTML to format it
	App.description = $"
	Shows your TTR (Table Tennis Ranking) from myTischtennis.de
	"$
	
	'The developer if this App
	App.author = "Matthias Wahl"

	'Icon (ID) to be displayed in the Appstore and MyApps
	App.coverIcon = 761
	
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.settings = CreateMap("UserName":"","Password":"","StringFormat":"&TTR/&QTTR")
		
	'Setup Instructions. You can use HTML to format it
	App.setupDescription = $"
	You need a premium account for myTischtennis.de<br>
	<b>UserName:</b> Write your UserName from myTischtennis.de here.<br>
	<b>Password:</b> Write your Password from myTischtennis.de here.<br>
	<b>StringFormat:</b> Form your own Format: "&TTR" will be replaced by your TTR and "&QTTR" by your QTTR.
	"$
	
	'define some tags to simplify the search in the Appstore
	App.tags = Array As String("myTischtennis", "TTR")
	
	'How many downloadhandlers should be generated
	App.downloads = 1.01
	
	'IconIDs from AWTRIXER. You can add multiple if you need more
	App.icons = Array As Int(761)
	
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
			App.PostMultipart("https://www.mytischtennis.de/community/events",CreateMap("userNameB":App.get("UserName"),"userPassWordB":App.get("Password")),Null)
			App.setHeader(CreateMap("goLogin":"Einloggen","Accept-Encoding":"identity"))
		End Select
End Sub

Sub App_Started
	outputString = App.get("StringFormat")
	outputString = outputString.Replace("&TTR","" & TTR)
	outputString = outputString.Replace("&QTTR","" & QTTR)
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
					Dim Reader As TextReader
					Reader.Initialize(Resp.Stream)
					Dim line As String
					line = Reader.ReadLine
					Do While line <> Null
						If line.Contains("<span>TTR:</span>") Then
							TTR = line.SubString2(18,line.Length)
						End If
						If line.Contains(">Q-TTR:</span>") Then
							QTTR = line.SubString2(120,line.Length)
						End If
						line = Reader.ReadLine
					Loop
			End Select
		End If
	Catch
		Log("Try Catch rausgeflogen...")
		App.throwError(LastException)
	End Try
End Sub

'With this sub you build your frame wtih eveery Tick.
Sub App_genFrame
	App.genText(outputString ,True,1,Null,False)
	App.drawBMP(0,0,App.getIcon(761),8,8)
End Sub
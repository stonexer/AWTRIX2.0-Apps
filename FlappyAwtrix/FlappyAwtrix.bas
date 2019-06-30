B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@

Sub Class_Globals
	Dim App As AWTRIX
	'Declare your variables here
	Dim heroY As Double = 5
	Dim tower1X As Double = 31
	Dim tower2X As Double = 31+10
	Dim tower3X As Double = 31+20
	Dim hSpeed As Double = 0.5
	Dim gap1Y As Int = 3
	Dim gap2Y As Int = 3
	Dim gap3Y As Int = 3
	Dim isHome As Boolean
	Dim vSpeed As Double =0.5
	Dim doJump As Boolean
	Dim Points As Int
	Dim failed As Boolean
	Dim prevMillis As Long
	Dim color1() As Int=Array As Int (0,0,255)
	Dim color2() As Int=Array As Int (0,0,255)
	Dim color3() As Int=Array As Int (0,0,255)
	Dim abort As Boolean = False
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
	App.AppName="FlappyAwtrix"
	
	'Version of the App
	App.AppVersion="2.1"
	
	'Description of the App. You can use HTML to format it
	App.AppDescription=$"
	Play the Flappy Bird clone on your AWTRIX<br/>
	Official AWTRIX App is required!<br/>
	<small>Created by AWTRIX</small>
	"$
		
	'SetupInstructions. You can use HTML to format it
	App.SetupInfos= $"
	
	"$
	
	App.Tags=Array As String("Games","Interactive")
		
	'How many downloadhandlers should be generated
	App.NeedDownloads=0
	
	'IconIDs from AWTRIXER. You can add multiple if you want to display them at the same time
	App.Icons=Array As Int()
	
	'Tickinterval in ms (should be 65 by default, for smooth scrolling))
	App.TickInterval=50
	
	'If set to true AWTRIX will wait for the "finish" command before switch to the next app.
	App.LockApp=True
	App.ShouldShow=False
	'needed Settings for this App (Wich can be configurate from user via webinterface)
	App.appSettings=CreateMap()
	
	App.MakeSettings
	Return "AWTRIX20"
End Sub

Sub App_externalCommand(cmd As Object)
	Select cmd
		Case 0
			doJump=False
		Case 1
			doJump=True
			isHome=False
		Case 2
			abort=True
		Case 3
			App.ShouldShow=True
	End Select
End Sub

Sub App_AppExited
	App.ShouldShow=False
End Sub

'this sub is called right before AWTRIX will display your App
Sub App_Started
	abort=False
	isHome=True
	gap1Y = Rnd(0, 3)
	gap2Y = Rnd(0, 3)
	gap3Y = Rnd(0, 3)
End Sub

'With this sub you build your frame.
Sub App_genFrame
	If abort Then
		abort=False
		App.finish
		App.ShouldShow=False
	End If
	
	If failed Then
		showScore
		If (DateTime.Now - prevMillis >= 2000) Then
			failed=False
			Points=0
			isHome=True
		End If
	Else
		gameUpdate
	End If
End Sub


Sub gameUpdate
	drawTower1 ' show the tower in the screen
	drawTower2
	drawTower3
	drawHero 'show the hero in the scene
End Sub


Sub drawTower1
	tower1X = tower1X - hSpeed 'move the tower To the left
	Dim x As Int = tower1X
	If x < -3 Then '// If moved To 0, returns To the right
		x = 31
		tower1X = x
		gap1Y = Rnd(0, 3)
		color1=Array As Int(Rnd(20,255),Rnd(20,255),Rnd(20,255))
	End If
	App.drawRect(x,0,2,8,color1)
	App.drawRect(x,gap1Y,2,4,Array As Int (0,0,0))
	If(x = 2) Then	checkCollisions1(gap1Y)
End Sub

Sub drawTower2
	tower2X = tower2X- hSpeed 'move the tower To the left
	Dim x As Int = tower2X
	If x < -3 Then '// If moved To 0, returns To the right
		x = 31+10
		tower2X = x
		gap2Y = Rnd(0, 3)
		color2=Array As Int(Rnd(20,255),Rnd(20,255),Rnd(20,255))
	End If
	App.drawRect(x,0,2,8,color2)
	App.drawRect(x,gap2Y,2,4,Array As Int (0,0,0))
	If(x = 2) Then	checkCollisions2(gap2Y)
End Sub

Sub drawTower3
	tower3X = tower3X - hSpeed 'move the tower To the left
	Dim x As Int = tower3X
	If x< -3 Then '// If moved To 0, returns To the right
		x = 31+20
		tower3X = x
		gap3Y = Rnd(0, 3)
		color3=Array As Int(Rnd(20,255),Rnd(20,255),Rnd(20,255))
	End If
	App.drawRect(x,0,2,8,color3)
	App.drawRect(x,gap3Y,2,4,Array As Int (0,0,0))
	If(x = 2) Then	checkCollisions3(gap3Y)
End Sub

Sub drawHero
	If Not(isHome) Then
		heroY =heroY+ vSpeed
	Else
		App.drawPixel(2,heroY,  Array As Int (0,255,0))
		App.drawPixel(1,heroY,  Array As Int(150,150,150))
		Return
	End If
		
	If doJump Then
		If(heroY > 0) Then
			heroY =heroY - 1
			App.drawPixel(2,heroY,  Array As Int (0,255,0))
			App.drawPixel(1,heroY+1,  Array As Int (150,150,150))
		Else
			App.drawPixel(2,heroY,  Array As Int (0,255,0))
			App.drawPixel(1,heroY,  Array As Int (150,150,150))
		End If
	Else
		App.drawPixel(2,heroY,  Array As Int (0,255,0))
		App.drawPixel(1,heroY-1,  Array As Int (150,150,150))
	End If
	
	If heroY>7 Then heroDie
End Sub

Sub showScore
	App.genText(NumberFormat(Points/2,0,0),False,1,Array As Int(0,255,0),False)
End Sub

Sub checkCollisions1(gap As Int)
	If (heroY <= gap Or heroY >= gap+4) Then
		heroDie
	Else
		Points=Points+1
	End If
End Sub

Sub checkCollisions2(gap As Int)
	If (heroY <= gap Or heroY >= gap+4) Then
		heroDie
	Else
		Points=Points+1
	End If
End Sub

Sub checkCollisions3(gap As Int)
	If (heroY <= gap Or heroY >= gap+4) Then
		heroDie
	Else
		Points=Points+1
	End If
End Sub

Sub restartGame
	tower1X = 31
	tower2X =31+10
	tower3X =31+20
	gap1Y = Rnd(0, 3)
	gap2Y = Rnd(0, 3)
	gap3Y = Rnd(0, 3)
	heroY=5
	isHome = True
End Sub

Sub heroDie
	App.fill(Array As Int(255,0,0))
	failed=True
	prevMillis=DateTime.Now
	restartGame
End Sub
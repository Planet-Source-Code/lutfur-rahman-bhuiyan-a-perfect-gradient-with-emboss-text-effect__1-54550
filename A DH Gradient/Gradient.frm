VERSION 5.00
Begin VB.Form Drawing 
   AutoRedraw      =   -1  'True
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Digital Home Gradient"
   ClientHeight    =   6030
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8700
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6030
   ScaleWidth      =   8700
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox Picture2 
      Align           =   1  'Align Top
      AutoRedraw      =   -1  'True
      BorderStyle     =   0  'None
      Height          =   855
      Left            =   0
      ScaleHeight     =   855
      ScaleWidth      =   8700
      TabIndex        =   1
      Top             =   0
      Width           =   8700
   End
   Begin VB.PictureBox Picture1 
      Align           =   2  'Align Bottom
      AutoRedraw      =   -1  'True
      BorderStyle     =   0  'None
      Height          =   855
      Left            =   0
      ScaleHeight     =   855
      ScaleWidth      =   8700
      TabIndex        =   0
      Top             =   5175
      Width           =   8700
   End
End
Attribute VB_Name = "Drawing"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Declare Function CreateFontIndirect Lib "gdi32" Alias _
       "CreateFontIndirectA" (lpLogFont As LOGFONT) As Long

Private Type LOGFONT
    lfHeight As Long
    lfWidth As Long
    lfEscapement As Long
    lfOrientation As Long
    lfWeight As Long
    lfItalic As Byte
    lfUnderline As Byte
    lfStrikeOut As Byte
    lfCharSet As Byte
    lfOutPrecision As Byte
    lfClipPrecision As Byte
    lfQuality As Byte
    lfPitchAndFamily As Byte
    lfFaceName As String * 33
End Type

Private Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, _
    ByVal hObject As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function SetGraphicsMode Lib "gdi32" (ByVal hdc As Long, ByVal iMode As Long) As Long
Const GM_ADVANCED = 2

Private Sub Gradient(obj As Object, Color1 As Double, Color2 As Double, Optional Orientation)
Dim VR, VG, VB As Single
Dim R, G, B, R2, G2, B2 As Integer
Dim temp As Long
temp = (Color1 And 255)
R = temp And 255
temp = Int(Color1 / 256)
G = temp And 255
temp = Int(Color1 / 65536)
B = temp And 255
temp = (Color2 And 255)
R2 = temp And 255
temp = Int(Color2 / 256)
G2 = temp And 255
temp = Int(Color2 / 65536)
B2 = temp And 255
If Orientation = 1 Then
VR = Abs(R - R2) / obj.ScaleHeight
VG = Abs(G - G2) / obj.ScaleHeight
VB = Abs(B - B2) / obj.ScaleHeight
If R2 < R Then VR = -VR
If G2 < G Then VG = -VG
If B2 < B Then VB = -VB
For y = 0 To obj.ScaleHeight
R2 = R + VR * y
G2 = G + VG * y
B2 = B + VB * y
obj.Line (0, y)-(obj.ScaleWidth, y), RGB(R2, G2, B2)
Next y
Else
VR = Abs(R - R2) / obj.ScaleWidth
VG = Abs(G - G2) / obj.ScaleWidth
VB = Abs(B - B2) / obj.ScaleWidth
If R2 < R Then VR = -VR
If G2 < G Then VG = -VG
If B2 < B Then VB = -VB
For x = 0 To obj.ScaleWidth
R2 = R + VR * x
G2 = G + VG * x
B2 = B + VB * x
obj.Line (x, 0)-(x, obj.ScaleHeight), RGB(R2, G2, B2)
Next x
End If
End Sub

Private Sub Form_Resize()
Gradient Me, &HFF8080, vbRed, 2
Gradient Picture1, 255, &H800000, 1
Gradient Picture2, &HFF8080, &H80C0FF, 2
Dim x As Single, y As Single
x = Me.ScaleLeft + 150
y = Me.ScaleTop + 10
RotateText Picture2, "Developed by: Lutfur Rahman Bhuiyan", "Times New Roman", True, False, 18, 0, 1, vbWhite, &H808080, vbBlack, x, y
End Sub


Function RotateText(inObj As Object, inText As String, inFontName As String, _
        inBold As Boolean, inItalic As Boolean, inFontSize As Integer, _
        inAngle As Long, inStyle As Integer, _
        firstClr As Long, secondClr As Long, mainClr As Long, _
        x As Single, y As Single, _
        Optional inDepth As Integer = 1) As Boolean
    RotateText = False
    Dim L As LOGFONT
    Dim mFont As Long
    Dim mPrevFont As Long
    Dim i As Integer
    Dim origMode As Integer
    Dim tmpX As Single, tmpY As Single
    Dim mresult
    mresult = SetGraphicsMode(inObj.hdc, GM_ADVANCED)
    origMode = inObj.ScaleMode
    inObj.ScaleMode = vbPixels
    If inBold = True And inItalic = True Then
        L.lfFaceName = inFontName & Space(1) & "Bold" & Space(1) & "Italic" & Chr(0)    ' Must be null terminated
    ElseIf inBold = True And inItalic = False Then
        L.lfFaceName = inFontName & Space(1) & "Bold" + Chr$(0)
    ElseIf inBold = False And inItalic = True Then
        L.lfFaceName = inFontName & Space(1) & "Italic" + Chr$(0)
    Else
        L.lfFaceName = inFontName & Chr$(0)
    End If

    L.lfEscapement = inAngle * 10
    L.lfHeight = inFontSize * -20 / Screen.TwipsPerPixelY
       
    mFont = CreateFontIndirect(L)
    mPrevFont = SelectObject(inObj.hdc, mFont)
    inObj.CurrentX = x
    inObj.CurrentY = y
    tmpX = x
    tmpY = y
    Select Case inStyle
            
        Case 1
            If firstClr <> -1 Then
                inObj.ForeColor = firstClr
                For i = 1 To inDepth
                    tmpX = tmpX - 1: tmpY = tmpY - 1
                    inObj.CurrentX = tmpX
                    inObj.CurrentY = tmpY
                    inObj.Print inText
                Next i
            End If
            
            If secondClr <> -1 Then
                inObj.CurrentX = x
                inObj.CurrentY = y
                tmpX = x
                tmpY = y
                inObj.ForeColor = secondClr
                For i = 1 To inDepth
                    tmpX = tmpX + 1: tmpY = tmpY + 1
                    inObj.CurrentX = tmpX
                    inObj.CurrentY = tmpY
                    inObj.Print inText
                Next i
            End If
            
            If mainClr <> -1 Then
                inObj.CurrentX = x
                inObj.CurrentY = y
                inObj.ForeColor = mainClr
                inObj.Print inText
            End If
            
    End Select
            
    mresult = SelectObject(inObj.hdc, mPrevFont)
    mresult = DeleteObject(mFont)
    inObj.ScaleMode = origMode
    RotateText = True
    Exit Function
    
errHandler:
    inObj.ScaleMode = origMode
    MsgBox "RotateText"
End Function



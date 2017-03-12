object FormStyle: TFormStyle
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Style'
  ClientHeight = 142
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 140
    Top = 90
    Width = 183
    Height = 13
    Alignment = taCenter
    Caption = 'Toutes les fen'#234'tres vont '#234'tre ferm'#233'es'
  end
  object cbxVclStyles: TComboBox
    Left = 140
    Top = 8
    Width = 197
    Height = 21
    Style = csDropDownList
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 256
    Top = 109
    Width = 81
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 140
    Top = 109
    Width = 77
    Height = 25
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
  end
end

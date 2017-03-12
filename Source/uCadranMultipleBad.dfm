inherited CadranMultipleDlg: TCadranMultipleDlg
  Caption = 'Cadran multiple'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Width = 177
    Height = 113
    ExplicitWidth = 177
    ExplicitHeight = 113
  end
  object NbCadHauteurLbl: TLabel [1]
    Left = 53
    Top = 86
    Width = 53
    Height = 13
    Caption = 'En hauteur'
  end
  object NbCadLargeurLbl: TLabel [2]
    Left = 57
    Top = 46
    Width = 49
    Height = 14
    Caption = 'En largeur'
  end
  object Label3: TLabel [3]
    Left = 19
    Top = 24
    Width = 102
    Height = 13
    Caption = 'Nombres de cadrans:'
  end
  object SpeedButton1: TSpeedButton [4]
    Left = 240
    Top = 80
    Width = 23
    Height = 22
  end
  inherited OKBtn: TButton
    Left = 70
    ExplicitLeft = 70
  end
  inherited CancelBtn: TButton
    Left = 150
    ExplicitLeft = 150
  end
  object HelpBtn: TButton
    Left = 230
    Top = 180
    Width = 75
    Height = 25
    Caption = '&Aide'
    TabOrder = 2
    OnClick = HelpBtnClick
  end
  object nbCadLargeurEdit: TSpinEdit
    Left = 112
    Top = 43
    Width = 57
    Height = 22
    MaxValue = 10
    MinValue = 1
    TabOrder = 3
    Value = 1
  end
  object NbCadHauteurEdit: TSpinEdit
    Left = 112
    Top = 83
    Width = 57
    Height = 22
    MaxValue = 10
    MinValue = 1
    TabOrder = 4
    Value = 1
  end
end

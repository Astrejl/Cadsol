object VisuCadMultipleForm: TVisuCadMultipleForm
  Left = 0
  Top = 0
  AlphaBlendValue = 125
  BorderWidth = 1
  Caption = 'Cadran multiple'
  ClientHeight = 300
  ClientWidth = 696
  Color = clWindowFrame
  Constraints.MinHeight = 300
  Constraints.MinWidth = 200
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDefault
  ScreenSnap = True
  OnActivate = FormActivate
  OnClick = FormActivate
  OnClose = FormClose
  OnHide = FormHide
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object LabelDim: TLabel
    Left = 8
    Top = 8
    Width = 105
    Height = 13
    Color = clWindow
    ParentColor = False
  end
  object MainMenu1: TMainMenu
    Left = 104
    Top = 96
    object Imprimer1: TMenuItem
      Caption = 'Fichier'
      object Enregister1: TMenuItem
        Caption = 'Enregister'
      end
      object Enregistrersous1: TMenuItem
        Caption = 'Enregistrer sous...'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Imprimer2: TMenuItem
        Caption = 'Imprimer...'
        OnClick = Imprimer2Click
      end
    end
    object Affichage1: TMenuItem
      Caption = 'Affichage'
      object ItemProprietes: TMenuItem
        AutoCheck = True
        Caption = 'Dimensions'
        Checked = True
        OnClick = ItemProprietesClick
      end
      object Vue3D1: TMenuItem
        Caption = 'Vue 3D'
        Visible = False
        OnClick = Vue3D1Click
      end
      object Pages1: TMenuItem
        AutoCheck = True
        Caption = 'Pages'
        OnClick = Pages1Click
      end
    end
  end
end

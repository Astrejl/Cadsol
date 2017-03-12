object Form7: TForm7
  Left = 0
  Top = 0
  Caption = 'Form7'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 635
    Height = 29
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
    ExplicitLeft = 248
    ExplicitTop = 48
    ExplicitWidth = 150
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = FileOpen1
                ImageIndex = 7
                ShortCut = 16463
              end>
            Caption = '&Fichier'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Left = 24
    Top = 120
    StyleName = 'Platform Default'
    object FileOpen1: TFileOpen
      Category = 'Fichier'
      Caption = 'Ou&vrir...'
      Hint = 'Ouvrir|Ouvre un fichier existant'
      ImageIndex = 7
      ShortCut = 16463
    end
  end
end

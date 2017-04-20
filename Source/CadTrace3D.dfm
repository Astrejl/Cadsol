object FormCadsol3D: TFormCadsol3D
  Left = 757
  Top = 264
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Orientation  de '
  ClientHeight = 720
  ClientWidth = 1175
  Color = clBtnFace
  Constraints.MinHeight = 350
  Constraints.MinWidth = 350
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  PrintScale = poPrintToFit
  OnActivate = FormActivate
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 1018
    Height = 720
    Camera = GLCamera1
    Buffer.BackgroundColor = clWindow
    FieldOfView = 83.974426269531250000
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 1018
    Top = 0
    Width = 157
    Height = 720
    Align = alRight
    BevelEdges = [beLeft]
    BevelKind = bkFlat
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    object RadioGroupDecli: TRadioGroup
      Left = 8
      Top = 87
      Width = 121
      Height = 34
      TabOrder = 6
    end
    object DecliEdit: TFnpNumericEdit
      Left = 96
      Top = 8
      Width = 41
      Height = 21
      Hint = 'En degr'#233's d'#233'cimaux'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Decimals = 1
      MaxValue = 180.000000000000000000
    end
    object DecliTrackBar: TTrackBar
      Left = 4
      Top = 35
      Width = 141
      Height = 31
      Max = 180
      PageSize = 1
      Frequency = 10
      TabOrder = 2
      OnChange = DecliTrackBarChange
      OnEnter = DecliTrackBarChange
    end
    object LbDecli: TStaticText
      Left = 4
      Top = 12
      Width = 62
      Height = 17
      Hint = 'En degr'#233's d'#233'cimaux'
      HelpType = htKeyword
      Caption = 'D'#233'clinaison '
      TabOrder = 1
    end
    object RadBtnEst: TRadioButton
      Left = 16
      Top = 96
      Width = 41
      Height = 17
      Caption = 'Est'
      Checked = True
      TabOrder = 7
      TabStop = True
    end
    object RadBtnOuest: TRadioButton
      Left = 79
      Top = 96
      Width = 50
      Height = 17
      Caption = 'Ouest'
      TabOrder = 8
    end
    object BitBtnAppliquer: TBitBtn
      Left = 28
      Top = 373
      Width = 103
      Height = 25
      Caption = 'Appliquer'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 16
      OnClick = BitBtnAppliquerClick
    end
    object BitBtn90: TBitBtn
      Left = 56
      Top = 64
      Width = 25
      Height = 17
      Caption = '90'#176
      TabOrder = 4
      OnClick = BitBtn90Click
    end
    object BitBtn0: TBitBtn
      Left = 12
      Top = 64
      Width = 25
      Height = 17
      Caption = '0'#176
      TabOrder = 3
      OnClick = BitBtn0Click
    end
    object BitBtn180: TBitBtn
      Left = 108
      Top = 64
      Width = 29
      Height = 17
      Caption = '180'#176
      TabOrder = 5
      OnClick = BitBtn180Click
    end
    object StaticTextFaceSud: TStaticText
      Left = 28
      Top = 358
      Width = 101
      Height = 17
      Alignment = taCenter
      Caption = 'Orienter la face Sud!'
      Enabled = False
      TabOrder = 17
      Transparent = False
      Visible = False
    end
    object EquatorialBtn: TButton
      Left = 12
      Top = 222
      Width = 121
      Height = 19
      Hint = 'Inclinaison = Latitude'
      Caption = 'Cadran '#233'quatorial'
      TabOrder = 15
      OnClick = EquatorialBtnClick
    end
    object BitBtnIncli180: TBitBtn
      Left = 109
      Top = 199
      Width = 29
      Height = 17
      Caption = '180'#176
      TabOrder = 14
      OnClick = BitBtnIncli180Click
    end
    object BitBtnIncli90: TBitBtn
      Left = 60
      Top = 199
      Width = 25
      Height = 17
      Caption = '90'#176
      TabOrder = 13
      OnClick = BitBtnIncli90Click
    end
    object BitBtnIncli0: TBitBtn
      Left = 12
      Top = 199
      Width = 25
      Height = 17
      Caption = '0'#176
      TabOrder = 12
      OnClick = BitBtnIncli0Click
    end
    object IncliTrackBar: TTrackBar
      Left = 4
      Top = 163
      Width = 141
      Height = 30
      Max = 180
      PageSize = 1
      Frequency = 10
      TabOrder = 11
      OnChange = IncliTrackBarChange
    end
    object IncliEdit: TFnpNumericEdit
      Left = 96
      Top = 138
      Width = 41
      Height = 21
      Hint = 'En degr'#233's d'#233'cimaux'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      Decimals = 1
      MaxValue = 180.000000000000000000
      MinValue = -180.000000000000000000
      Value = 90.000000000000000000
    end
    object LbIncli: TStaticText
      Left = 4
      Top = 140
      Width = 54
      Height = 17
      Hint = 'En degr'#233's d'#233'cimaux'
      HelpType = htKeyword
      Caption = 'Inclinaison'
      TabOrder = 9
    end
    object ButtonMoinsIncli: TButton
      Left = 72
      Top = 138
      Width = 18
      Height = 19
      Hint = 'Changer le signe'
      Caption = '-'
      TabOrder = 18
      OnClick = ButtonMoinsIncliClick
    end
    object BitBtnRot180: TBitBtn
      Left = 109
      Top = 319
      Width = 29
      Height = 17
      Caption = '180'#176
      TabOrder = 19
      OnClick = BitBtnRot180Click
    end
    object BitBtnRot90: TBitBtn
      Left = 60
      Top = 319
      Width = 25
      Height = 17
      Caption = '90'#176
      TabOrder = 20
      OnClick = BitBtnRot90Click
    end
    object BitBtnRot0: TBitBtn
      Left = 12
      Top = 319
      Width = 25
      Height = 17
      Caption = '0'#176
      TabOrder = 21
      OnClick = BitBtnRot0Click
    end
    object RotTrackBar: TTrackBar
      Left = 4
      Top = 283
      Width = 141
      Height = 30
      Max = 180
      PageSize = 1
      Frequency = 10
      TabOrder = 22
      OnChange = RotTrackBarChange
    end
    object RotEdit: TFnpNumericEdit
      Left = 96
      Top = 258
      Width = 41
      Height = 21
      Hint = 'En degr'#233's d'#233'cimaux'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 23
      Decimals = 1
      MaxValue = 180.000000000000000000
      MinValue = -180.000000000000000000
      Value = 90.000000000000000000
    end
    object ButtonMoinsRot: TButton
      Left = 72
      Top = 258
      Width = 18
      Height = 19
      Hint = 'Changer le signe'
      Caption = '-'
      TabOrder = 24
      OnClick = ButtonMoinsRotClick
    end
    object RotLabel: TStaticText
      Left = 4
      Top = 260
      Width = 44
      Height = 17
      Hint = 'En degr'#233's d'#233'cimaux'
      HelpType = htKeyword
      Caption = 'Rotation'
      TabOrder = 25
    end
  end
  object GLScene1: TGLScene
    Left = 24
    Top = 24
    object GLDummyCube: TGLDummyCube
      Direction.Coordinates = {0000803F000000000000000000000000}
      ShowAxes = True
      CubeSize = 1.000000000000000000
      object GLLightSource1: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        Diffuse.Color = {0000003F0000003F0000003F0000803F}
        Position.Coordinates = {0000F041000048420000A0420000803F}
        LightStyle = lsOmni
        SpotCutOff = 180.000000000000000000
        SpotDirection.Coordinates = {00000000000000000000000000000000}
      end
      object GLCamera1: TGLCamera
        DepthOfView = 100.000000000000000000
        FocalLength = 400.000000000000000000
        TargetObject = GLDummyCube
        CameraStyle = csInfinitePerspective
        Position.Coordinates = {0000484200008C42000020C20000803F}
      end
      object GLArrowLineAxeTerre: TGLArrowLine
        Material.FrontProperties.Emission.Color = {0000803F00000000000000000000803F}
        Direction.Coordinates = {1FDEE9B20000803F0000000000000000}
        Scale.Coordinates = {000080BF000080BF000080BF00000000}
        Up.Coordinates = {0000000000000000000080BF00000000}
        Visible = False
        BottomRadius = 0.050000000745058060
        Height = 10.000000000000000000
        Stacks = 1
        TopRadius = 0.050000000745058060
        HeadStackingStyle = ahssCentered
        TopArrowHeadHeight = 1.000000000000000000
        TopArrowHeadRadius = 0.100000001490116100
        BottomArrowHeadHeight = 0.500000000000000000
        BottomArrowHeadRadius = 0.100000001490116100
      end
      object GLSpaceTextNadir: TGLSpaceText
        Material.FrontProperties.Emission.Color = {000000000000003F000000000000803F}
        Direction.Coordinates = {0000803F000000000000008000000000}
        Position.Coordinates = {00000000000020C1000000000000803F}
        Up.Coordinates = {00000000000000000000803F00000000}
        Extrusion = 0.009999999776482582
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Nadir')
        Adjust.Horz = haCenter
      end
      object GLSpaceText_Ouest: TGLSpaceText
        Material.FrontProperties.Emission.Color = {ACC8483EACC8483ECDCC4C3F0000803F}
        Material.MaterialLibrary = GLMaterialLibrary1
        Direction.Coordinates = {0000803F000000800000000000000000}
        Position.Coordinates = {0000000000000000000020410000803F}
        Extrusion = 0.009999999776482582
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 5
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'O')
        Adjust.Horz = haCenter
        Adjust.Vert = vaCenter
      end
      object GLSpaceText_Est: TGLSpaceText
        Material.FrontProperties.Emission.Color = {ACC8483EACC8483ECDCC4C3F0000803F}
        Direction.Coordinates = {0000803F000000000000000000000000}
        Position.Coordinates = {0000000000000000000020C10000803F}
        Extrusion = 0.009999999776482582
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'E')
        Adjust.Horz = haCenter
        Adjust.Vert = vaCenter
      end
      object GLSpaceText_Sud: TGLSpaceText
        Material.FrontProperties.Emission.Color = {0000803F00000000000000000000803F}
        Position.Coordinates = {0000204100000000000000000000803F}
        Extrusion = 0.009999999776482582
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'S')
      end
      object GLSpaceText_Nord: TGLSpaceText
        Material.FrontProperties.Emission.Color = {0000803F00000000000000000000803F}
        Position.Coordinates = {000020C100000000000000000000803F}
        Extrusion = 0.009999999776482582
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'N')
      end
      object GLSpaceTextZenith: TGLSpaceText
        Material.FrontProperties.Emission.Color = {000000000000003F000000000000803F}
        Direction.Coordinates = {0000803F000000000000008000000000}
        Position.Coordinates = {0000000000002041000000000000803F}
        Up.Coordinates = {00000000000000000000803F00000000}
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Zenith')
        AspectRatio = 1.000000000000000000
        Adjust.Horz = haCenter
      end
      object GLDummyCube2: TGLDummyCube
        Direction.Coordinates = {0000803F000000000000000000000000}
        CubeSize = 1.000000000000000000
        object GLCylinder1: TGLCylinder
          Material.FrontProperties.Ambient.Color = {00000000000000000000000000000000}
          Material.FrontProperties.Diffuse.Color = {0000003F0000003F0000003F0000803F}
          Material.FrontProperties.Emission.Color = {6666263F6666263F6666263F0000803F}
          Material.Texture.MappingSCoordinates.Coordinates = {00000000000000000000803F00000000}
          Material.Texture.MappingTCoordinates.Coordinates = {00000000000000000000803F00000000}
          Direction.Coordinates = {0000803F000000000000000000000000}
          Up.Coordinates = {00000000000080BF0000000000000000}
          Visible = False
          BottomRadius = 3.000000000000000000
          Height = 10.000000000000000000
          Slices = 32
          TopRadius = 3.000000000000000000
        end
        object GLCube1: TGLCube
          Material.BackProperties.Ambient.Color = {0000403F0000403F0000403F0000803F}
          Material.BackProperties.Diffuse.Color = {3333333F3333333F3333333F0000803F}
          Material.BackProperties.Emission.Color = {9A99193F9A99193F9A99193F0000803F}
          Material.FrontProperties.Ambient.Color = {9A99193F9A99193F9A99193F0000803F}
          Material.FrontProperties.Diffuse.Color = {9A99193F9A99193F9A99193F0000803F}
          Material.FrontProperties.Emission.Color = {0000003F0000003F0000003F0000803F}
          Material.FrontProperties.Shininess = 128
          Material.Texture.TextureWrap = twNone
          Material.Texture.MappingSCoordinates.Coordinates = {00000000000000000000803F00000000}
          Material.MaterialLibrary = GLMaterialLibrary1
          Direction.Coordinates = {0000803F000000000000000000000000}
          ShowAxes = True
          Pickable = False
          CubeSize = {00007041000020410000803F}
        end
      end
    end
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    Enabled = False
    Left = 24
    Top = 72
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Left = 24
    Top = 168
  end
  object GLSimpleNavigation1: TGLSimpleNavigation
    Form = Owner
    GLSceneViewer = GLSceneViewer1
    FormCaption = 'Vue 3D - %FPS'
    KeyCombinations = <
      item
        ShiftState = [ssLeft, ssRight]
        Action = snaZoom
      end
      item
        ShiftState = [ssLeft]
        Action = snaMoveAroundTarget
      end
      item
        ShiftState = [ssRight]
        Action = snaMoveAroundTarget
      end>
    Left = 24
    Top = 248
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 320
    object VoirItemMenu: TMenuItem
      Caption = 'Voir...'
      object Axes3DItemMenu: TMenuItem
        AutoCheck = True
        Caption = 'Axes du cadran'
        Checked = True
        OnClick = Axes3DItemMenuClick
      end
      object EONSZNitem: TMenuItem
        AutoCheck = True
        Caption = 'Axes Est, Ouest, Nord, Sud, Zenith, Nadir'
        Checked = True
        Hint = 'Est, Ouest, Nord, Sud,Zenith, Nadir'
        OnClick = EONSZNitemClick
      end
      object ItemAxederotationterrestre: TMenuItem
        AutoCheck = True
        Caption = 'Axe de rotation terrestre'
        OnClick = ItemAxederotationterrestreClick
      end
      object ItemLecadranactif: TMenuItem
        AutoCheck = True
        Caption = 'Le cadran actif'
        Checked = True
        GroupIndex = 5
        RadioItem = True
        Visible = False
        OnClick = Cadransimple1Click
      end
      object ItemLecadranmultiple: TMenuItem
        AutoCheck = True
        Caption = 'Le cadran multiple'
        GroupIndex = 5
        RadioItem = True
        Visible = False
        OnClick = ItemLecadranmultipleClick
      end
      object ItemLecadrancubique: TMenuItem
        AutoCheck = True
        Caption = 'Le cadran cubique'
        GroupIndex = 5
        RadioItem = True
        Visible = False
        OnClick = ItemLecadrancubiqueClick
      end
    end
  end
end

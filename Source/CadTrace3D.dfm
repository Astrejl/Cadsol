object FormCadsol3D: TFormCadsol3D
  Left = 757
  Top = 264
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Vue 3D'
  ClientHeight = 700
  ClientWidth = 1124
  Color = clBtnFace
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  PrintScale = poPrintToFit
  OnActivate = FormActivate
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 1124
    Height = 700
    Camera = GLCamera1
    Buffer.BackgroundColor = clWindow
    FieldOfView = 82.371849060058590000
    Align = alClient
    TabOrder = 0
    ExplicitLeft = -8
    ExplicitTop = -8
  end
  object GLScene1: TGLScene
    Left = 32
    Top = 16
    object GLDummyCube: TGLDummyCube
      Direction.Coordinates = {0000803F000000000000000000000000}
      ShowAxes = True
      CubeSize = 1.000000000000000000
      object GLCamera1: TGLCamera
        DepthOfView = 100.000000000000000000
        FocalLength = 400.000000000000000000
        TargetObject = GLCube1
        CameraStyle = csInfinitePerspective
        Position.Coordinates = {0000484200008C42000020C20000803F}
      end
      object GLLightSource1: TGLLightSource
        Ambient.Color = {CDCCCC3ECDCCCC3ECDCCCC3E0000803F}
        ConstAttenuation = 1.000000000000000000
        Diffuse.Color = {00000000000000000000000000000000}
        Position.Coordinates = {0000F041000048420000A0420000803F}
        LightStyle = lsOmni
        Specular.Color = {0000803F0000803F0000803F0000803F}
        SpotCutOff = 90.000000000000000000
        SpotDirection.Coordinates = {00000000000000000000000000000000}
      end
      object GLSpaceText_Ouest: TGLSpaceText
        Material.MaterialLibrary = GLMaterialLibrary1
        Direction.Coordinates = {0000803F000000800000000000000000}
        Position.Coordinates = {0000000000000000000020410000803F}
        Extrusion = 0.100000001490116100
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
        Direction.Coordinates = {0000803F000000000000000000000000}
        Position.Coordinates = {0000000000000000000020C10000803F}
        Extrusion = 0.100000001490116100
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
        Position.Coordinates = {0000204100000000000000000000803F}
        Extrusion = 0.100000001490116100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'S')
      end
      object GLSpaceText_Nord: TGLSpaceText
        Position.Coordinates = {000020C100000000000000000000803F}
        Extrusion = 0.100000001490116100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'N')
      end
      object GLSpaceTextZenith: TGLSpaceText
        Direction.Coordinates = {0000803F000000000000008000000000}
        Position.Coordinates = {0000000000002041000000000000803F}
        Up.Coordinates = {00000000000000000000803F00000000}
        Extrusion = 0.100000001490116100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Zenith')
        Adjust.Horz = haCenter
      end
      object GLSpaceTextNadir: TGLSpaceText
        Direction.Coordinates = {0000803F000000000000008000000000}
        Position.Coordinates = {00000000000020C1000000000000803F}
        Up.Coordinates = {00000000000000000000803F00000000}
        Extrusion = 0.100000001490116100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Nadir')
        Adjust.Horz = haCenter
      end
      object GLDummyCube2: TGLDummyCube
        Direction.Coordinates = {0000803F000000000000008000000000}
        CubeSize = 1.000000000000000000
        object GLCylinder1: TGLCylinder
          Material.FrontProperties.Ambient.Color = {00000000000000000000000000000000}
          Material.FrontProperties.Diffuse.Color = {0000003F0000003F0000003F0000803F}
          Material.FrontProperties.Emission.Color = {6666263F6666263F6666263F0000803F}
          Material.Texture.MappingSCoordinates.Coordinates = {00000000000000000000803F00000000}
          Material.Texture.MappingTCoordinates.Coordinates = {00000000000000000000803F00000000}
          Direction.Coordinates = {0000803F000000000000000000000000}
          Up.Coordinates = {00000000000080BF0000000000000000}
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
    Left = 32
    Top = 64
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Left = 32
    Top = 160
  end
  object GLSimpleNavigation1: TGLSimpleNavigation
    Form = Owner
    GLSceneViewer = GLSceneViewer1
    MoveAroundTargetSpeed = 0.200000002980232200
    RotateTargetSpeed = 0.200000002980232200
    FormCaption = 'Vue 3D - %FPS'
    Options = [snoMouseWheelHandled]
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
    Left = 32
    Top = 240
  end
  object MainMenu1: TMainMenu
    Left = 32
    Top = 312
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
      object ItemLecadranactif: TMenuItem
        AutoCheck = True
        Caption = 'Le cadran actif'
        Checked = True
        GroupIndex = 5
        RadioItem = True
        OnClick = Cadransimple1Click
      end
      object ItemLecadranmultiple: TMenuItem
        AutoCheck = True
        Caption = 'Le cadran multiple'
        Enabled = False
        GroupIndex = 5
        RadioItem = True
        OnClick = ItemLecadranmultipleClick
      end
      object ItemLecadrancubique: TMenuItem
        AutoCheck = True
        Caption = 'Le cadran cubique'
        Enabled = False
        GroupIndex = 5
        RadioItem = True
        Visible = False
        OnClick = ItemLecadrancubiqueClick
      end
    end
  end
end

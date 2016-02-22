object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 398
  ClientWidth = 778
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 105
  TextHeight = 14
  object edPathFile: TEdit
    Left = 8
    Top = 8
    Width = 425
    Height = 22
    TabOrder = 0
    Text = 'edPathFile'
  end
  object Button1: TButton
    Left = 456
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
  end
  object DBGrid1: TDBGrid
    Left = 24
    Top = 48
    Width = 320
    Height = 120
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object dsMain: TDataSource
    Left = 400
    Top = 48
  end
  object dMain: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 472
    Top = 48
  end
end

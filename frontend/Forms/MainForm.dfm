object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 216
    Width = 635
    Height = 83
    Align = alBottom
    TabOrder = 0
    object btnLoadTasks: TButton
      Left = 71
      Top = 25
      Width = 98
      Height = 35
      Caption = 'btnLoadTasks'
      TabOrder = 0
      OnClick = btnLoadTasksClick
    end
    object btnAddTask: TButton
      Left = 191
      Top = 25
      Width = 98
      Height = 35
      Caption = 'btnAddTask'
      TabOrder = 1
      OnClick = btnAddTaskClick
    end
    object btnUpdateTask: TButton
      Left = 319
      Top = 25
      Width = 98
      Height = 35
      Caption = 'btnUpdateTask'
      TabOrder = 2
      OnClick = btnUpdateTaskClick
    end
    object btnDeleteTask: TButton
      Left = 440
      Top = 25
      Width = 97
      Height = 35
      Caption = 'btnDeleteTask'
      TabOrder = 3
      OnClick = btnDeleteTaskClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 216
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 312
    ExplicitTop = 96
    ExplicitWidth = 185
    ExplicitHeight = 41
    object StringGridTasks: TStringGrid
      Left = 1
      Top = 1
      Width = 633
      Height = 214
      Align = alClient
      BiDiMode = bdLeftToRight
      ParentBiDiMode = False
      TabOrder = 0
    end
  end
end

program DelphiTodoListApp;

uses
  Vcl.Forms,
  MainForm in 'Forms\MainForm.pas' {frmMain},
  TaskService in 'Services\TaskService.pas',
  TaskModel in 'Models\TaskModel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

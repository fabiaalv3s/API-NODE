unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  TaskService, TaskModel;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnLoadTasks: TButton;
    btnAddTask: TButton;
    btnUpdateTask: TButton;
    btnDeleteTask: TButton;
    StringGridTasks: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure btnLoadTasksClick(Sender: TObject);
    procedure btnAddTaskClick(Sender: TObject);
    procedure btnUpdateTaskClick(Sender: TObject);
    procedure btnDeleteTaskClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadTasks;
    procedure DisplayTasks(const Tasks: TArray<TTask>);
    function GetSelectedTaskID: Integer;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  StringGridTasks.ColCount := 3;
  StringGridTasks.Cells[0, 0] := 'ID';
  StringGridTasks.Cells[1, 0] := 'Title';
  StringGridTasks.Cells[2, 0] := 'Status';
  StringGridTasks.RowCount := 1;  // Start with 1 row (header)
end;

procedure TfrmMain.LoadTasks;
var
  TaskService: TTaskService;
  Tasks: TArray<TTask>;
begin
  TaskService := TTaskService.Create;
  try
    Tasks := TaskService.GetAllTasks;
    DisplayTasks(Tasks);
  finally
    TaskService.Free;
  end;
end;

procedure TfrmMain.DisplayTasks(const Tasks: TArray<TTask>);
var
  I: Integer;
begin
  StringGridTasks.RowCount := Length(Tasks) + 1;  // Set row count (1 extra for header)
  for I := 0 to High(Tasks) do
  begin
    StringGridTasks.Cells[0, I + 1] := Tasks[I].ID.ToString;
    StringGridTasks.Cells[1, I + 1] := Tasks[I].Title;
    StringGridTasks.Cells[2, I + 1] := Tasks[I].Status;
  end;
end;

function TfrmMain.GetSelectedTaskID: Integer;
var
  SelectedRow: Integer;
begin
  SelectedRow := StringGridTasks.Row;

  if (SelectedRow > 0) and (StringGridTasks.Cells[0, SelectedRow] <> '') then
    Result := StrToInt(StringGridTasks.Cells[0, SelectedRow])
  else
    Result := -1;
end;

procedure TfrmMain.btnLoadTasksClick(Sender: TObject);
begin
  LoadTasks;
end;

procedure TfrmMain.btnAddTaskClick(Sender: TObject);
var
  TaskService: TTaskService;
  Title: string;
begin
  // Prompt user for task title
  if InputQuery('Adicionar Tarefa', 'Digite o título da nova tarefa:', Title) then
  begin
    TaskService := TTaskService.Create;
    try
      if TaskService.CreateTask(Title) then
        ShowMessage('Tarefa criada com sucesso!')
      else
        ShowMessage('Erro ao criar a tarefa.');
      LoadTasks;
    finally
      TaskService.Free;
    end;
  end;
end;

procedure TfrmMain.btnUpdateTaskClick(Sender: TObject);
var
  TaskService: TTaskService;
  Task: TTask;
  NewTitle, NewStatus: string;
  TaskID: Integer;
begin
  TaskID := GetSelectedTaskID;
  if TaskID = -1 then
  begin
    ShowMessage('Selecione uma tarefa para atualizar.');
    Exit;
  end;

  // Solicitar novo título e status para a tarefa
  NewTitle := StringGridTasks.Cells[1, StringGridTasks.Row];
  NewStatus := StringGridTasks.Cells[2, StringGridTasks.Row];

  if InputQuery('Atualizar Tarefa', 'Novo título:', NewTitle) then
  begin
    if InputQuery('Atualizar Tarefa', 'Novo status (pendente/completo):', NewStatus) then
    begin
      TaskService := TTaskService.Create;
      try
        Task.ID := TaskID;
        Task.Title := NewTitle;
        Task.Status := NewStatus;

        if TaskService.UpdateTask(Task) then
        begin
          ShowMessage('Tarefa atualizada com sucesso!');
          LoadTasks;  // Recarrega as tarefas
        end
        else
          ShowMessage('Erro ao atualizar a tarefa.');
      finally
        TaskService.Free;
      end;
    end;
  end;
end;

procedure TfrmMain.btnDeleteTaskClick(Sender: TObject);
var
  TaskService: TTaskService;
  TaskID: Integer;
begin
  TaskID := GetSelectedTaskID;
  if TaskID = -1 then
  begin
    ShowMessage('Selecione uma tarefa para deletar.');
    Exit;
  end;

  if MessageDlg('Deseja realmente excluir esta tarefa?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    TaskService := TTaskService.Create;
    try
      if TaskService.DeleteTask(TaskID) then
      begin
        ShowMessage('Tarefa excluída com sucesso!');
        LoadTasks;  // Recarrega as tarefas
      end
      else
        ShowMessage('Erro ao excluir a tarefa.');
    finally
      TaskService.Free;
    end;
  end;
end;

end.


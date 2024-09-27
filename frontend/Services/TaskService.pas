unit TaskService;

interface

uses
  System.SysUtils, System.Classes, System.Net.HttpClient, System.JSON, TaskModel;

type
  TTaskService = class
  private
    FHttpClient: THTTPClient;
  public
    constructor Create;
    destructor Destroy; override;

    function GetAllTasks: TArray<TTask>;
    function CreateTask(const Title: string): Boolean;
    function UpdateTask(const ATask: TTask): Boolean;
    function DeleteTask(const TaskId: Integer): Boolean;
  end;

implementation

constructor TTaskService.Create;
begin
  FHttpClient := THTTPClient.Create;
end;

destructor TTaskService.Destroy;
begin
  FHttpClient.Free;
  inherited;
end;

function TTaskService.GetAllTasks: TArray<TTask>;
var
  Response: IHTTPResponse;
  JSONArr: TJSONArray;
  Task: TTask;
  I: Integer;
begin
  Response := FHttpClient.Get('http://localhost:3333/tasks');
  if Response.StatusCode = 200 then
  begin
    JSONArr := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONArray;
    SetLength(Result, JSONArr.Count);
    for I := 0 to JSONArr.Count - 1 do
    begin
      Task.ID := JSONArr.Items[I].GetValue<Integer>('id');
      Task.Title := JSONArr.Items[I].GetValue<string>('title');
      Task.Status := JSONArr.Items[I].GetValue<string>('status');
      Result[I] := Task;
    end;
  end;
end;

function TTaskService.CreateTask(const Title: string): Boolean;
var
  JsonBody: TJSONObject;
  Response: IHTTPResponse;
  StringStream: TStringStream;
begin
  JsonBody := TJSONObject.Create;
  StringStream := TStringStream.Create;
  try
    JsonBody.AddPair('title', Title);
    StringStream.WriteString(JsonBody.ToString);
    StringStream.Position := 0;

    // Adicionando o cabeçalho diretamente
    FHttpClient.CustomHeaders['Content-Type'] := 'application/json';

    Response := FHttpClient.Post('http://localhost:3333/tasks', StringStream);

    Result := Response.StatusCode = 201;
  finally
    JsonBody.Free;
    StringStream.Free;
  end;
end;


function TTaskService.UpdateTask(const ATask: TTask): Boolean;
var
  JsonBody: TJSONObject;
  Response: IHTTPResponse;
  StringStream: TStringStream;
begin
  JsonBody := TJSONObject.Create;
  StringStream := TStringStream.Create;
  try
    JsonBody.AddPair('title', ATask.Title);
    JsonBody.AddPair('status', ATask.Status);
    StringStream.WriteString(JsonBody.ToString);
    StringStream.Position := 0;

    FHttpClient.CustomHeaders['Content-Type'] := 'application/json';

    Response := FHttpClient.Put(Format('http://localhost:3333/tasks/%d', [ATask.ID]), StringStream);

    Result := Response.StatusCode = 204;
  finally
    JsonBody.Free;
    StringStream.Free;
  end;
end;


function TTaskService.DeleteTask(const TaskId: Integer): Boolean;
var
  Response: IHTTPResponse;
begin
  Response := FHttpClient.Delete(Format('http://localhost:3333/tasks/%d', [TaskId]));
  Result := Response.StatusCode = 204;
end;

end.


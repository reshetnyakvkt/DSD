unit _wndMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls,
  uImportManager;

type
  TwndMain = class(TForm)
    edPathFile: TEdit;
    btnOpen: TButton;
    gMain: TDBGrid;
    dsMain: TDataSource;
    btnImport: TButton;
    procedure btnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
  private
    FImportManager : TImportManager;
  public
  end;

var
  wndMain: TwndMain;

implementation

{$R *.dfm}

procedure TwndMain.btnImportClick(Sender: TObject);
  procedure ControlEnabled(AEnabled : boolean);
  begin
    edPathFile.Enabled := AEnabled;
    btnOpen.Enabled := AEnabled;
    btnImport.Enabled := AEnabled;
  end;
begin
  try
    ControlEnabled(false);
    FImportManager.Import;
  finally
    ControlEnabled(true);
  end;
end;

procedure TwndMain.btnOpenClick(Sender: TObject);
var
  Dlg: TOpenDialog;
begin
  Dlg := TOpenDialog.Create(Self);
  try
    if Dlg.Execute(Self.Handle) then
    begin
      FImportManager.FileName := Dlg.FileName;
      edPathFile.Text := FImportManager.FileName;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TwndMain.FormCreate(Sender: TObject);
begin
  FImportManager := TImportManager.Create(Self, Application.ExeName);
  dsMain.DataSet := FImportManager.DataSet;

  FImportManager.FileName := wndMain.edPathFile.Text;
end;

procedure TwndMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FImportManager);
end;

end.

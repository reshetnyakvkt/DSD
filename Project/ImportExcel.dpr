program ImportExcel;

uses
  Forms,
  _wndMain in '..\Source\_wndMain.pas' {wndMain},
  uImportDriverXLS in '..\Source\uImportDriverXLS.pas',
  uImportManager in '..\Source\uImportManager.pas',
  _wndProgress in '..\Source\_wndProgress.pas' {wndProgress},
  _utils in '..\Source\_utils.pas',
  uImportFunctions in '..\Source\uImportFunctions.pas',
  uImportCondition in '..\Source\uImportCondition.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TwndMain, wndMain);
  Application.Run;
end.

program ImportExcel;

uses
  Vcl.Forms,
  _wndMain in '..\Source\_wndMain.pas' {wndMain},
  uImportXLS in '..\Source\uImportXLS.pas',
  uSettingsImport in '..\Source\uSettingsImport.pas',
  NativeXml in '..\Source\NativeXML\NativeXml.pas',
  NativeXmlObjectStorage in '..\Source\NativeXML\NativeXmlObjectStorage.pas',
  sdBufferParser in '..\Source\NativeXML\sdBufferParser.pas',
  sdDebug in '..\Source\NativeXML\sdDebug.pas',
  sdSortedLists in '..\Source\NativeXML\sdSortedLists.pas',
  sdStreams in '..\Source\NativeXML\sdStreams.pas',
  sdStringEncoding in '..\Source\NativeXML\sdStringEncoding.pas',
  sdStringTable in '..\Source\NativeXML\sdStringTable.pas',
  uImportManager in '..\Source\uImportManager.pas',
  _wndProgress in '..\Source\_wndProgress.pas' {wndProgress};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TwndMain, wndMain);
  Application.Run;
end.

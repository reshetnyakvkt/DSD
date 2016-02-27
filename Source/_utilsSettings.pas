unit _utilsSettings;

interface

uses
  uImportSettings,
  Xml.XMLIntf,
  Xml.XMLDoc;

{ Global Functions }
function GetSettingsImport(Doc: IXMLDocument): IXMLSettingsImportType;
function LoadSettingsImport(const FileName: string): IXMLSettingsImportType;
function NewSettingsImport: IXMLSettingsImportType;
function DefaultSettingsImport: IXMLSettingsImportType;




implementation

{ Global Functions }

function GetSettingsImport(Doc: IXMLDocument): IXMLSettingsImportType;
begin
  Result := Doc.GetDocBinding('SettingsImport', TXMLSettingsImportType, TargetNamespace) as IXMLSettingsImportType;
end;

function LoadSettingsImport(const FileName: string): IXMLSettingsImportType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('SettingsImport', TXMLSettingsImportType, TargetNamespace) as IXMLSettingsImportType;
end;

function NewSettingsImport: IXMLSettingsImportType;
begin
  Result := NewXMLDocument.GetDocBinding('SettingsImport', TXMLSettingsImportType, TargetNamespace) as IXMLSettingsImportType;
end;

function DefaultSettingsImport: IXMLSettingsImportType;
begin
  Result := NewSettingsImport;
  Result.Add('Name',     'String',  'UpperCase', false);
  Result.Add('Birthday', 'Date',    'Age',  false);
  Result.Add('Salary',   'Integer', '', false);
  Result.Add('Surname',  'String',  'LowerCase', true);
  Result.Add('DOB',      '',        '', false);
  Result.Add('AMOUNT',   '',        '', false);
end;

end.

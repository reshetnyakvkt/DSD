unit _utils;

interface

uses
//  Xml.XMLIntf,
//  Xml.XMLDoc,
  XMLIntf,
  XMLDoc,
  uImportCondition;

{ Global Functions }
function GetCondition(Doc: IXMLDocument): IXMLConditionType; overload;
function GetCondition(Doc: IXMLDocument; Cond: string): IXMLConditionType; overload;
function GetConditionXML(AXML: String): IXMLConditionType;
function LoadCondition(const FileName: string): IXMLConditionType;
function NewCondition: IXMLConditionType;
function DefaultCondition: IXMLConditionType;

implementation

{ Global Functions }

function GetCondition(Doc: IXMLDocument): IXMLConditionType;
begin
  Result := Doc.GetDocBinding('Condition', TXMLConditionType, TargetNamespace) as IXMLConditionType;
end;

function GetCondition(Doc: IXMLDocument; Cond: string): IXMLConditionType; overload;
begin
  Result := Doc.GetDocBinding(Cond, TXMLConditionType, TargetNamespace) as IXMLConditionType;
end;

function GetConditionXML(AXML: String): IXMLConditionType;
begin
  Result := GetCondition(LoadXMLData(AXML));
end;

function LoadCondition(const FileName: string): IXMLConditionType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Condition', TXMLConditionType, TargetNamespace) as IXMLConditionType;
end;

function NewCondition: IXMLConditionType;
begin
  Result := NewXMLDocument.GetDocBinding('Condition', TXMLConditionType, TargetNamespace) as IXMLConditionType;
end;


function DefaultCondition: IXMLConditionType;
begin
  Result := GetConditionXML(
    '<?xml version="1.0" encoding="UTF-8"?>' +
    '<Condition Name="My_name">' +
    '<Field name="Name" type="String" function="UpperCase" SkipRowIfEmpty="False"/>' +
    '<Field name="Surname" function="LowerCase" SkipRowIfEmpty="True"/>' +
    '<Field name="Birthday" type="Date" function="Age"/>' +
    '<Field name="Salary" type="Integer"/>' +
    '<Field name="DOB"/>' +
    '<Field name="AMOUNT"/>' +
    '</Condition>');
end;

end.

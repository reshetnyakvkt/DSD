unit uImportFunctions;

interface

uses
//  System.Classes,
//  System.SysUtils,
  Classes,
  SysUtils,
  Rtti;

type
  TFunc = function(Value: variant): variant of object;

{ TXMLFieldImportType }
  TXMLFunctions = class(TPersistent)
  public
    class function UpperCase(Value: variant): variant;
    class function LowerCase(Value: variant): variant;
    class function StrToInt(Value: variant): variant;
    class function Func(Value: variant): variant;
    class function GetFuncByName(AName : String) : TFunc;
  end;

implementation

{ TXMLFunctions }

class function TXMLFunctions.GetFuncByName(AName: String): TFunc;
var
  R : TRttiContext;
  T : TRttiType;
  M : TRttiMethod;
  FormClass : TPersistentClass;
  FExists : boolean;
begin
  Result := nil;
  FExists := false;
  T := R.GetType(TXMLFunctions);

  if Assigned(T) then
    for M in T.GetMethods do
      if (M.Parent = T) and (M.Name = AName) then
      begin
        TMethod(Result).Code := M.CodeAddress;
        TMethod(Result).Data := FormClass;
        FExists := true;
      end;
  if not FExists then
  begin
    M := T.GetMethod('Func');
    TMethod(Result).Code := M.CodeAddress;
    TMethod(Result).Data := FormClass;
  end;
end;

class function TXMLFunctions.Func(Value: variant): variant;
begin
  Result := Value;
end;

class function TXMLFunctions.LowerCase(Value: variant): variant;
begin
  Result := AnsiLowerCase(Value);
end;

class function TXMLFunctions.StrToInt(Value: variant): variant;
begin
//  Result := System.SysUtils.StrToInt(Value);
  Result := SysUtils.StrToInt(Value);
end;

class function TXMLFunctions.UpperCase(Value: variant): variant;
begin
  Result := AnsiUpperCase(Value);
end;

Initialization
  RegisterClass(TXMLFunctions);

end.

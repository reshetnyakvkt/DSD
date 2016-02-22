unit _wndProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, cxButtons, ImgList, ActnList, System.Actions,
  Vcl.ComCtrls, dxGDIPlusClasses, Vcl.ExtCtrls;

type
  TwndProgress = class(TForm)
    alProcess: TActionList;
    actCancel: TAction;
    ilProcess: TImageList;
    btnCancel: TButton;
    pbProgress: TProgressBar;
    lblCaption: TLabel;
    imgWait: TImage;
    procedure FormCreate(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
  private
    FNeedStop: Boolean;
  public
    property NeedStop: Boolean read FNeedStop;
  end;

var
  wndProgress: TwndProgress;

    procedure ShowProgress(nCaption: string; ProgressMaxValue: integer = 0);
    procedure ShowProgressExt(nCaption: string; ProgressMaxValue: integer = 0; ShowCancel: Boolean = True);
    procedure ShowProcessFmt(nCaption: string; Value: array of TVarRec; ProgressMaxValue: integer = 0);
    procedure StepProgress(nCaption: string=''; Value: integer = 1);
    procedure HideProgress;
    function NeedStop: Boolean;  //возвращает True если нажата кнопка остановки

implementation

{$R *.dfm}

{ TwndProgress }

function NeedStop: Boolean;
begin
  Result := False;

  if not Assigned(wndProgress) then
    Exit;

  Result := wndProgress.NeedStop;
end;

procedure HideProgress;
begin
  if not Assigned(wndProgress) then
    Exit;

  wndProgress.Close;
  FreeAndNil(wndProgress);
end;

procedure ShowProcessFmt(nCaption: string; Value: array of TVarRec; ProgressMaxValue: integer = 0);
begin
  ShowProgress(Format(nCaption, Value), ProgressMaxValue)
end;

procedure ShowProgressExt(nCaption: string; ProgressMaxValue: integer = 0; ShowCancel: Boolean = True);
begin
  if Assigned(wndProgress) then
  begin
    wndProgress.Caption := nCaption;
    if ProgressMaxValue = 0 then
      wndProgress.pbProgress.Visible := false
    else
      wndProgress.pbProgress.Max := ProgressMaxValue;
    wndProgress.pbProgress.Position := 0;
    wndProgress.lblCaption.Caption := nCaption;
  end
  else
  begin
    wndProgress := TwndProgress.Create(nil);
    wndProgress.Caption := nCaption;
    if ProgressMaxValue = 0 then
      wndProgress.pbProgress.Visible := false
    else
      wndProgress.pbProgress.Max := ProgressMaxValue;
    wndProgress.pbProgress.Position := 0;
    wndProgress.lblCaption.Caption := nCaption;
  end;

  wndProgress.actCancel.Visible := ShowCancel;
  wndProgress.actCancel.Enabled := ShowCancel;

  wndProgress.Show;

  Application.ProcessMessages;
end;

procedure ShowProgress(nCaption: string; ProgressMaxValue: integer = 0);
begin
  ShowProgressExt(nCaption, ProgressMaxValue, False);
end;

procedure StepProgress(nCaption: string = ''; Value: integer = 1);
begin
  if not Assigned(wndProgress) then
    Exit;

  wndProgress.lblCaption.Caption := wndProgress.Caption + '...' + nCaption;
  wndProgress.pbProgress.Position := wndProgress.pbProgress.Position + Value;

  Application.ProcessMessages;
end;

{ TwndProgress }

procedure TwndProgress.actCancelExecute(Sender: TObject);
begin
  if Dialogs.MessageDlg('Вы уверены что хотите остановить?',
      mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes
  then
  begin
    FNeedStop := True;
    actCancel.Enabled := False;
  end;
end;

procedure TwndProgress.FormCreate(Sender: TObject);
begin
  FNeedStop := False;
end;

end.

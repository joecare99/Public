unit fra_NavIData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Buttons, StdCtrls, Unt_IData;

type

  { TfraNavIData }

  TfraNavIData = class(TFrame)
    btnPrev: TBitBtn;
    btnFirst: TBitBtn;
    btnNext: TBitBtn;
    btnLast: TBitBtn;
    edtSeekNr: TEdit;
    procedure edtSeekNrEditingDone(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    FData: IDataRO;
    procedure SetData(AValue: IDataRO);
    Procedure DataUpdate(Sender: TObject);
  public
    Property Data:IDataRO read FData write SetData;
  end;

implementation

{$R *.lfm}

{ TfraNavIData }

procedure TfraNavIData.FrameResize(Sender: TObject);
var
  lCmp: TComponent;
  i: Integer;
begin
  For i := 0 to ControlCount-1 do
    begin
      lCmp:=Controls[i];
      if lCmp.InheritsFrom(TCustomButton) then
        TCustomButton(lcmp).Width:=Width div 7;
    end;
end;

procedure TfraNavIData.edtSeekNrEditingDone(Sender: TObject);
var
  lInt: Longint;
begin
  if assigned(Fdata) and TryStrToInt(edtSeekNr.text,lInt) then
    Fdata.Seek(lInt-1);
end;

procedure TfraNavIData.SetData(AValue: IDataRO);
begin
  if @FData=@AValue then Exit;
  FData:=AValue;
  if assigned(fdata) then
    begin
  btnFirst.OnClick := @FData.First;
  btnPrev.OnClick := @FData.Previous;
  btnNext.OnClick := @FData.Next;
  btnLast.OnClick := @FData.Last;
  Fdata.OnUpdate := @DataUpdate
    end
  else
    begin
  btnFirst.OnClick := nil;
  btnPrev.OnClick := nil;
  btnNext.OnClick := nil;
  btnLast.OnClick := nil;
     end
end;

procedure TfraNavIData.DataUpdate(Sender: TObject);
begin
//  if not edtSeekNr.editing
  edtSeekNr.text:=inttostr((sender as IDataRO).GetActID+1);
end;

end.


unit fra_Date;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, ExtCtrls;

type

    { TfraDate }

    TfraDate = class(TFrame)
        lblDate: TLabel;
        lblForPresentation: TLabel;
        lblForSorting: TLabel;
        pnlDateClient: TPanel;
        edtDateForPresentation: TEdit;
        pnlDateRight: TPanel;
        pnlDateLeft: TPanel;
        edtDateForSorting: TEdit;
        procedure edtDateForPresentationEditingDone(Sender: TObject);
        procedure edtDateForSortingEditingDone(Sender: TObject);
    private
        FDate: string;
        FSortDate: string;
        function GetVisDate: string;
        function GetVisSortDate: string;
        procedure SetDate(AValue: string);
        procedure SetSortDate(AValue: string);
        procedure SetVisDate(AValue: string);
        procedure SetVisSortDate(AValue: string);
    public
        procedure Clear;
        procedure Finishediting(Sender: TObject; AC: TWinControl);
        property Date: string read FDate write SetDate;
        property SortDate: string read FSortDate write SetSortDate;
        property VisDate: string read GetVisDate write SetVisDate;
        property VidSortDate: string read GetVisSortDate write SetVisSortDate;
    end;

implementation

{$R *.lfm}

uses Frm_Main;

procedure TfraDate.edtDateForPresentationEditingDone(Sender: TObject);

begin
    FDate := InterpreteDate(edtDateForPresentation.Text, 1);
    edtDateForPresentation.Text := ConvertDate(FDate, 1);
    edtDateForSorting.Text := edtDateForPresentation.Text;
    FsortDate := FDate;
    if FDate <> '100000000030000000000' then
        frmStemmaMainForm.AppendHistoryData('PD', FDate);
end;

procedure TfraDate.edtDateForSortingEditingDone(Sender: TObject);
begin
    FsortDate := InterpreteDate(edtDateForSorting.Text, 1);
    edtDateForSorting.Text := ConvertDate(FsortDate, 1);
    if FsortDate <> '100000000030000000000' then
        frmStemmaMainForm.AppendHistoryData('SD', FsortDate);
end;

procedure TfraDate.SetDate(AValue: string);
begin
    if FDate = AValue then
        Exit;
    FDate := AValue;
    FSortDate := Avalue;
    edtDateForPresentation.Text := ConvertDate(FDate, 1);
    edtDateForSorting := edtDateForPresentation.Text;
end;

function TfraDate.GetVisDate: string;
begin
    Result := edtDateForPresentation.Text;
end;

function TfraDate.GetVisSortDate: string;
begin
    Result := edtDateForSorting.Text;
end;

procedure TfraDate.SetSortDate(AValue: string);
begin
    if FSortDate = AValue then
        Exit;
    FSortDate := AValue;
    edtDateForSorting.Text := ConvertDate(FSortDate, 1);
end;

procedure TfraDate.SetVisDate(AValue: string);
begin
    if edtDateForPresentation.Text = Avalue then
        exit;
    FDate := InterpreteDate(AValue, 1);
    edtDateForPresentation.Text := ConvertDate(FDate, 1);
    edtDateForSorting.Text := edtDateForPresentation.Text;
    FsortDate := FDate;
end;

procedure TfraDate.SetVisSortDate(AValue: string);
begin
    if edtDateForSorting.Text = Avalue then
        exit;
    FSortDate := InterpreteDate(AValue, 1);
    edtDateForSorting.Text := ConvertDate(FSortDate, 1);
end;

procedure TfraDate.Clear;
begin
    VisDate := '';
end;

procedure TfraDate.Finishediting(Sender: TObject; AC: TWinControl);
begin
    if AC = edtDateForPresentation then
        edtDateForPresentationEditingDone(Sender)
    else if ac = edtDateForSorting then
        edtDateForSortingEditingDone(Sender);
end;


end.

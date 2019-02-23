unit Frm_CalcABOUT;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type

  { TfrmCalcAbout }

  TfrmCalcAbout = class(TForm)
    btnOK: TBitBtn;
    lblURL: TLabel;
    pnlInfo: TPanel;
    icoProgramIcon: TImage;
    lblProductName: TLabel;
    lblVersion: TLabel;
    lblCopyright: TLabel;
    lblApplicationName: TLabel;
    lblVendorName: TLabel;
    procedure lblURLClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    function GetApplicationName: String;
    function GetCopyright: String;
    function GetProductName: String;
    function GetURL: String;
    function GetVendorName: String;
    procedure SetApplicationname(AValue: String);
    procedure SetCopyright(AValue: String);
    procedure SetProductname(AValue: String);
    procedure SetURL(AValue: String);
    procedure SetVendorname(AValue: String);
    { Private declarations }
  public
    { Public declarations }
    Property ProductName:String read GetProductName Write SetProductname;
    Property VendorName:String read GetVendorName Write SetVendorname;
    Property ApplicationName:String read GetApplicationName Write SetApplicationname;
    Property Copyright:String read GetCopyright Write SetCopyright;
    Property URL:String read GetURL Write SetURL;
  end;

var
  frmCalcAbout: TfrmCalcAbout;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{ TfrmCalcAbout }

procedure TfrmCalcAbout.OKButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCalcAbout.lblURLClick(Sender: TObject);
begin
  {$IFDEF FPC}
  OpenDocument(lblURL.Caption);
  {$ENDIF}
end;

function TfrmCalcAbout.GetApplicationName: String;
begin
  result := lblApplicationName.Caption;
end;

function TfrmCalcAbout.GetCopyright: String;
begin
  result := lblCopyright.Caption;
end;

function TfrmCalcAbout.GetProductName: String;
begin
  result := lblProductName.Caption;
end;

function TfrmCalcAbout.GetURL: String;
begin
  result := lblURL.Caption;
end;

function TfrmCalcAbout.GetVendorName: String;
begin
  result := lblVendorName.Caption;
end;

procedure TfrmCalcAbout.SetApplicationname(AValue: String);
begin
  if lblApplicationName.Caption= AValue then exit;
  lblApplicationName.Caption:= AValue
end;

procedure TfrmCalcAbout.SetCopyright(AValue: String);
begin
  if lblCopyright.Caption= AValue then exit;
  lblCopyright.Caption:= AValue
end;

procedure TfrmCalcAbout.SetProductName(AValue: String);
begin
  if lblProductName.Caption= AValue then exit;
  lblProductName.Caption:= AValue
end;

procedure TfrmCalcAbout.SetURL(AValue: String);
begin
  if lblURL.Caption= AValue then exit;
  lblURL.Caption:= AValue
end;

procedure TfrmCalcAbout.SetVendorName(AValue: String);
begin
  if lblVendorName.Caption= AValue then exit;
  lblVendorName.Caption:= AValue
end;

end.
 

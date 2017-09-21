unit frm_Places;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Menus, LCLtype, ActnList, Buttons, ComCtrls;

type

  { TfrmPlace }

  TfrmPlace = class(TForm)
    actPlaceUsage: TAction;
    actPlaceDelete: TAction;
    actPlaceMerge: TAction;
    actPlaceSort: TAction;
    actPlaceSortByCountry: TAction;
    actPlaceSortByCounty: TAction;
    actPlaceSortByRegion: TAction;
    actPlaceSortByPlace: TAction;
    actPlaceSortByDetail: TAction;
    alsPlace: TActionList;
    btnPlaceOK: TBitBtn;
    ComboBox1: TComboBox;
    mniPlaceSortBy: TMenuItem;
    mniPlaceSep2: TMenuItem;
    mniPlaceDelete: TMenuItem;
    mniPlaceSortDetail: TMenuItem;
    mniPlaceSortPlace: TMenuItem;
    mniPlaceSortRegion: TMenuItem;
    mniPlaceSortCounty: TMenuItem;
    mniPlaceSortCountry: TMenuItem;
    mniPlaceMerge: TMenuItem;
    mniPlaceUsage: TMenuItem;
    mniPlaceSep1: TMenuItem;
    edtO: TEdit;
    mnuPlacePopUp: TPopupMenu;
    tblPlace: TStringGrid;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mniPlaceDeleteClick(Sender: TObject);
    procedure mniPlaceSortDetailClick(Sender: TObject);
    procedure mniPlaceSortPlaceClick(Sender: TObject);
    procedure mniPlaceSortRegionClick(Sender: TObject);
    procedure mniPlaceSortCountyClick(Sender: TObject);
    procedure mniPlaceSortCountryClick(Sender: TObject);
    procedure mniPlaceMergeClick(Sender: TObject);
    procedure mniPlaceUsageClick(Sender: TObject);
    procedure tblPlaceEditingDone(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmPlace: TfrmPlace;

implementation

uses frm_Main, cls_Translation, dm_GenData, frm_Usage;

{$R *.lfm}

{ TfrmPlace }

procedure TfrmPlace.FormResize(Sender: TObject);
begin
  tblPlace.Width := (Sender as Tform).Width-16;
  tblPlace.Height := (Sender as Tform).Height-51;
  btnPlaceOK.Top:= (Sender as Tform).Height-35;
  btnPlaceOK.Left:= (Sender as Tform).Width-80;
end;

procedure TfrmPlace.FormShow(Sender: TObject);
var
  MyCursor: TCursor;
  lOnUpdate: TNotifyEvent;
  lTblPlace: TStringGrid;
begin
  Caption:=rsPlaces;
  btnPlaceOK.Caption:=rsCmdOk;
  tblPlace.Cells[2,0]:=Translation.Items[208];
  tblPlace.Cells[3,0]:=rsDetail;
  tblPlace.Cells[4,0]:=rsCity;
  tblPlace.Cells[5,0]:=rsRegion;
  tblPlace.Cells[6,0]:=Translation.Items[212];
  tblPlace.Cells[7,0]:=Translation.Items[213];
  tblPlace.Cells[8,0]:=Translation.Items[158];
  actPlaceSort.Caption:=rsSort;
  actPlaceSortByDetail.Caption:=rsSortByDetail;
  actPlaceSortByPlace.Caption:=Translation.Items[241];
  actPlaceSortByRegion.Caption:=Translation.Items[242];
  actPlaceSortByCounty.Caption:=Translation.Items[243];
  actPlaceSortByCountry.Caption:=Translation.Items[244];
  actPlaceMerge.Caption:=rsCmdMerge;
  actPlaceUsage.Caption:=rsCmdUsageOf;
  actPlaceUsage.Caption:=rsCmdDelete;
  MyCursor := Screen.Cursor;
  try
  Screen.Cursor := crHourGlass;
  frmStemmaMainForm.ProgressBar.Position:=0;
  frmStemmaMainForm.ProgressBar.Visible:=True;
  Application.Processmessages;

  lOnUpdate := @frmStemmaMainForm.UpdateProgressBar;
  lTblPlace:=tblPlace;

  dmGenData.FillTablePlaces(lTblPlace, lOnUpdate);

  edtO.Text:='2';
  frmStemmaMainForm.ProgressBar.Visible:=False;
  finally
    Screen.Cursor := MyCursor;
  end;
end;

procedure TfrmPlace.mniPlaceDeleteClick(Sender: TObject);
var
  lPlace:string;
begin
  // Supprimer un lPlace
  if tblPlace.Row>0 then
     if tblPlace.Cells[8,tblPlace.Row]='0' then
        begin
        lPlace:='';
        if Length(trim(tblPlace.Cells[3,tblPlace.Row]))>0 then
           lPlace:=trim(tblPlace.Cells[3,tblPlace.Row]);
        if Length(trim(tblPlace.Cells[4,tblPlace.Row]))>0 then
           if length(lPlace)=0 then
              lPlace:=trim(tblPlace.Cells[4,tblPlace.Row])
           else
              lPlace:=lPlace+', '+trim(tblPlace.Cells[4,tblPlace.Row]);
        if Length(trim(tblPlace.Cells[5,tblPlace.Row]))>0 then
           if length(lPlace)=0 then
              lPlace:=trim(tblPlace.Cells[5,tblPlace.Row])
           else
              lPlace:=lPlace+', '+trim(tblPlace.Cells[5,tblPlace.Row]);
        if Length(trim(tblPlace.Cells[6,tblPlace.Row]))>0 then
           if length(lPlace)=0 then
              lPlace:=trim(tblPlace.Cells[6,tblPlace.Row])
           else
              lPlace:=lPlace+', '+trim(tblPlace.Cells[6,tblPlace.Row]);
        if Length(trim(tblPlace.Cells[7,tblPlace.Row]))>0 then
           if length(lPlace)=0 then
              lPlace:=trim(tblPlace.Cells[7,tblPlace.Row])
           else
              lPlace:=lPlace+', '+trim(tblPlace.Cells[7,tblPlace.Row]);
        if Application.MessageBox(Pchar(Translation.Items[125]+
              lPlace+
              Translation.Items[28]),pchar(SConfirmation),MB_YESNO)=IDYES then
           begin
           dmGenData.DeletePlace(PtrInt(tblPlace.Objects[0,tblPlace.Row]));
           tblPlace.DeleteRow(tblPlace.Row);
        end;
     end;
end;

procedure TfrmPlace.mniPlaceSortDetailClick(Sender: TObject);
begin
  edtO.Text:='1';
  tblPlace.SortColRow(true,3);
end;

procedure TfrmPlace.mniPlaceSortPlaceClick(Sender: TObject);
begin
  edtO.Text:='2';
  tblPlace.SortColRow(true,4);
end;

procedure TfrmPlace.mniPlaceSortRegionClick(Sender: TObject);
begin
  edtO.Text:='3';
  tblPlace.SortColRow(true,5);
end;

procedure TfrmPlace.mniPlaceSortCountyClick(Sender: TObject);
begin
  edtO.Text:='4';
  tblPlace.SortColRow(true,6);
end;

procedure TfrmPlace.mniPlaceSortCountryClick(Sender: TObject);
begin
  edtO.Text:='5';
  tblPlace.SortColRow(true,7);
end;

procedure TfrmPlace.mniPlaceMergeClick(Sender: TObject);
var
  no,Lieu,Lieu2:string;
  lidPlace: Integer;
  lidPlaceNew: Longint;
begin
  Lieu:='';
  if Length(trim(tblPlace.Cells[3,tblPlace.Row]))>0 then
     Lieu:=trim(tblPlace.Cells[3,tblPlace.Row]);
  if Length(trim(tblPlace.Cells[4,tblPlace.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(tblPlace.Cells[4,tblPlace.Row])
     else
        Lieu:=Lieu+', '+trim(tblPlace.Cells[4,tblPlace.Row]);
  if Length(trim(tblPlace.Cells[5,tblPlace.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(tblPlace.Cells[5,tblPlace.Row])
     else
        Lieu:=Lieu+', '+trim(tblPlace.Cells[5,tblPlace.Row]);
  if Length(trim(tblPlace.Cells[6,tblPlace.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(tblPlace.Cells[6,tblPlace.Row])
     else
        Lieu:=Lieu+', '+trim(tblPlace.Cells[6,tblPlace.Row]);
  if Length(trim(tblPlace.Cells[7,tblPlace.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(tblPlace.Cells[7,tblPlace.Row])
     else
        Lieu:=Lieu+', '+trim(tblPlace.Cells[7,tblPlace.Row]);
  no := InputBox(Translation.Items[119],Translation.Items[120]+Lieu+Translation.Items[121],'');
  if tryStrtoInt(no,lidPlaceNew) and (lidPlaceNew>0) then
     begin
     Lieu2:=dmGenData.GetPlaceName(lidPlaceNew);
     if Lieu2<>Lieu then
        Application.MessageBox(Pchar(Translation.Items[122]+
           Lieu+Translation.Items[123]+Lieu2+')'),pchar(Translation.Items[124]),0)
     else
        begin
        lidPlace := ptrint(tblPlace.Objects[0,tblPlace.Row]);
        dmGenData.UpdateEventsChangePlace(lidPlaceNew, lidPlace);
        // DELETE OLD LIEU
        dmGenData.DeletePlace(lidPlace);
     end;
  end;
end;

procedure TfrmPlace.mniPlaceUsageClick(Sender: TObject);
var
  Lieu:string;
begin
  Lieu:='';
  if Length(trim(tblPlace.Cells[3,tblPlace.Row]))>0 then
     Lieu:=trim(tblPlace.Cells[3,tblPlace.Row]);
  if Length(trim(tblPlace.Cells[4,tblPlace.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(tblPlace.Cells[4,tblPlace.Row])
     else
        Lieu:=Lieu+', '+trim(tblPlace.Cells[4,tblPlace.Row]);
  if Length(trim(tblPlace.Cells[5,tblPlace.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(tblPlace.Cells[5,tblPlace.Row])
     else
        Lieu:=Lieu+', '+trim(tblPlace.Cells[5,tblPlace.Row]);
  if Length(trim(tblPlace.Cells[6,tblPlace.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(tblPlace.Cells[6,tblPlace.Row])
     else
        Lieu:=Lieu+', '+trim(tblPlace.Cells[6,tblPlace.Row]);
  if Length(trim(tblPlace.Cells[7,tblPlace.Row]))>0 then
     if length(Lieu)=0 then
        Lieu:=trim(tblPlace.Cells[7,tblPlace.Row])
     else
        Lieu:=Lieu+', '+trim(tblPlace.Cells[7,tblPlace.Row]);
//  dmGenData.PutCode('L',Lieu);
  frmShowUsage.UsageOf:=eSU_Placees;
  frmShowUsage.idLink:=Ptrint(tblPlace.Objects[0,tblPlace.Row]);
  frmShowUsage.ShowModal;
end;

procedure TfrmPlace.tblPlaceEditingDone(Sender: TObject);
var
  lPlace:string;
  lidPlace: Integer;
begin
  lPlace:='';
  if Length(trim(tblPlace.Cells[2,tblPlace.Row]))>0 then
     lPlace:='<'+CTagNameArticle+'>'+trim(tblPlace.Cells[2,tblPlace.Row])+'</'+CTagNameArticle+'>';
  if Length(trim(tblPlace.Cells[3,tblPlace.Row]))>0 then
     lPlace:='<'+CTagNameDetail+'>'+trim(tblPlace.Cells[3,tblPlace.Row])+'</'+CTagNameDetail+'>';
  if Length(trim(tblPlace.Cells[4,tblPlace.Row]))>0 then
     lPlace:=lPlace+'<' + CTagNamePlace + '>'+trim(tblPlace.Cells[4,tblPlace.Row])+'</' + CTagNamePlace + '>';
  if Length(trim(tblPlace.Cells[5,tblPlace.Row]))>0 then
     lPlace:=lPlace+'<' + CTagNameRegion + '>'+trim(tblPlace.Cells[5,tblPlace.Row])+'</' + CTagNameRegion + '>';
  if Length(trim(tblPlace.Cells[6,tblPlace.Row]))>0 then
     lPlace:=lPlace+'<' + CTagNameCountry + '>'+trim(tblPlace.Cells[6,tblPlace.Row])+'</' + CTagNameCountry + '>';
  if Length(trim(tblPlace.Cells[7,tblPlace.Row]))>0 then
     lPlace:=lPlace+'<' + CTagNameState + '>'+trim(tblPlace.Cells[7,tblPlace.Row])+'</' + CTagNameState + '>';

  lidPlace := ptrint(tblPlace.Objects[0,tblPlace.Row]);
  dmgendata.UpdatePlaceData(lidPlace, lPlace);
end;

end.


unit frm_Places;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Menus, StrUtils, FMUtils, LCLtype, ActnList, Buttons, ComCtrls;

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

procedure DeletePlace(const lidPlace: Integer);
begin
  dmGenData.Query1.SQL.Text:='DELETE FROM L WHERE no=:idPlace';
  dmGenData.Query1.ParamByName('idPlace').AsInteger:=lidPlace;
  dmGenData.Query1.ExecSQL;
end;

procedure FillTablePlaces(const lTblPlace: TStringGrid;
  const lOnUpdate: TNotifyEvent);
var
  Lieu: string;
  L4: string;
  L3: string;
  L2: string;
  L1: string;
  L0: string;
  LA: string;
  pos2: integer;
  pos1: integer;
  i: integer;
begin
  with dmGenData.Query1 do begin
    SQL.Clear;
    SQL.add('SELECT L.no, L.L, COUNT(E.L) FROM L JOIN E on E.L=L.no GROUP by L.no');
    Open;
    First;
    lTblPlace.RowCount:=RecordCount+1;
    Tag:=-lTblPlace.RowCount;
    if assigned(lOnUpdate) then
       lOnUpdate(dmGenData.Query1);
    Tag:=0;
    if assigned(lOnUpdate) then
       lOnUpdate(dmGenData.Query1);
    i:=0;
    While not Eof do
       begin
       i:=i+1;
       lTblPlace.Cells[0,i]:=Fields[0].AsString;
       lTblPlace.Cells[1,i]:=Fields[0].AsString;
       Lieu:=Fields[1].AsString;
       if Copy(Lieu,1,4)='!TMG' then
          begin
          LA:='';
          Lieu:=Copy(Lieu,AnsiPos('|',Lieu)+1,Length(Lieu));
          L0:=Copy(Lieu,1,AnsiPos('|',Lieu)-1);
          Lieu:=Copy(Lieu,AnsiPos('|',Lieu)+1,Length(Lieu));
          L1:=Copy(Lieu,1,AnsiPos('|',Lieu)-1);
          Lieu:=Copy(Lieu,AnsiPos('|',Lieu)+1,Length(Lieu));
          L2:=Copy(Lieu,1,AnsiPos('|',Lieu)-1);
          Lieu:=Copy(Lieu,AnsiPos('|',Lieu)+1,Length(Lieu));
          L3:=Copy(Lieu,1,AnsiPos('|',Lieu)-1);
          Lieu:=Copy(Lieu,AnsiPos('|',Lieu)+1,Length(Lieu));
          L4:=Copy(Lieu,1,AnsiPos('|',Lieu)-1);
       end
       else
          begin
          Pos1:=AnsiPos('<'+CTagNameArticle+'>',Lieu)+Length(CTagNameArticle)+2;
          Pos2:=AnsiPos('</'+CTagNameArticle+'>',Lieu);
          if (Pos1+Pos2)>(Length(CTagNameDetail)+2) then
             LA:=Copy(Lieu,Pos1,Pos2-Pos1)
          else
             LA:='';
          Pos1:=AnsiPos('<'+CTagNameDetail+'>',Lieu)+(Length(CTagNameDetail)+2);
          Pos2:=AnsiPos('</'+CTagNameDetail+'>',Lieu);
          if (Pos1+Pos2)>(Length(CTagNameDetail)+2) then
             L0:=Copy(Lieu,Pos1,Pos2-Pos1)
          else
             L0:='';
          Pos1:=AnsiPos('<' + CTagNamePlace + '>',Lieu)+7;
          Pos2:=AnsiPos('</' + CTagNamePlace + '>',Lieu);
          if (Pos1+Pos2)>7 then
             L1:=Copy(Lieu,Pos1,Pos2-Pos1)
          else
             L1:='';
          Pos1:=AnsiPos('<' + CTagNameRegion + '>',Lieu)+9;
          Pos2:=AnsiPos('</' + CTagNameRegion + '>',Lieu);
          if (Pos1+Pos2)>9 then
             L2:=Copy(Lieu,Pos1,Pos2-Pos1)
          else
             L2:='';
          Pos1:=AnsiPos('<' + CTagNameCountry + '>',Lieu)+10;
          Pos2:=AnsiPos('</' + CTagNameCountry + '>',Lieu);
          if (Pos1+Pos2)>10 then
             L3:=Copy(Lieu,Pos1,Pos2-Pos1)
          else
             L3:='';
          Pos1:=AnsiPos('<' + CTagNameState + '>',Lieu)+6;
          Pos2:=AnsiPos('</' + CTagNameState + '>',Lieu);
          if (Pos1+Pos2)>6 then
             L4:=Copy(Lieu,Pos1,Pos2-Pos1)
          else
             L4:='';
       end;
       lTblPlace.Cells[2,i]:=LA;
       lTblPlace.Cells[3,i]:=L0;
       lTblPlace.Cells[4,i]:=L1;
       lTblPlace.Cells[5,i]:=L2;
       lTblPlace.Cells[6,i]:=L3;
       lTblPlace.Cells[7,i]:=L4;
       lTblPlace.Cells[8,i]:=Fields[2].AsString;
       Next;
       Tag:=RecNo;
       if assigned(lOnUpdate) then
          lOnUpdate(dmGenData.Query1);
    end;
  end;
  lTblPlace.SortColRow(true,3);
end;

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

  FillTablePlaces(lTblPlace, lOnUpdate);

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
           DeletePlace(PtrInt(tblPlace.Objects[0,tblPlace.Row]));
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
  if StrtoInt(no)>0 then
     begin
     dmGenData.Query1.SQL.Text:='SELECT L.no, L.L FROM L WHERE L.no='+no;
     dmGenData.Query1.Open;
     Lieu2:=DecodeChanged(dmGenData.Query1.Fields[1].AsString);
     if Lieu2<>Lieu then
        Application.MessageBox(Pchar(Translation.Items[122]+
           Lieu+Translation.Items[123]+Lieu2+')'),pchar(Translation.Items[124]),0)
     else
        begin
        dmGenData.Query1.SQL.Text:='UPDATE E SET L='+no+
          ' WHERE L='+tblPlace.Cells[0,tblPlace.Row];
        dmGenData.Query1.ExecSQL;
        // DELETE OLD LIEU
        dmGenData.Query1.SQL.Text:='DELETE FROM L WHERE no='+tblPlace.Cells[0,tblPlace.Row];
        dmGenData.Query1.ExecSQL;
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
  Lieu:string;
begin
  Lieu:='';
  if Length(trim(tblPlace.Cells[2,tblPlace.Row]))>0 then
     Lieu:='<'+CTagNameArticle+'>'+trim(tblPlace.Cells[2,tblPlace.Row])+'</'+CTagNameArticle+'>';
  if Length(trim(tblPlace.Cells[3,tblPlace.Row]))>0 then
     Lieu:='<'+CTagNameDetail+'>'+trim(tblPlace.Cells[3,tblPlace.Row])+'</'+CTagNameDetail+'>';
  if Length(trim(tblPlace.Cells[4,tblPlace.Row]))>0 then
     Lieu:=Lieu+'<' + CTagNamePlace + '>'+trim(tblPlace.Cells[4,tblPlace.Row])+'</' + CTagNamePlace + '>';
  if Length(trim(tblPlace.Cells[5,tblPlace.Row]))>0 then
     Lieu:=Lieu+'<' + CTagNameRegion + '>'+trim(tblPlace.Cells[5,tblPlace.Row])+'</' + CTagNameRegion + '>';
  if Length(trim(tblPlace.Cells[6,tblPlace.Row]))>0 then
     Lieu:=Lieu+'<' + CTagNameCountry + '>'+trim(tblPlace.Cells[6,tblPlace.Row])+'</' + CTagNameCountry + '>';
  if Length(trim(tblPlace.Cells[7,tblPlace.Row]))>0 then
     Lieu:=Lieu+'<' + CTagNameState + '>'+trim(tblPlace.Cells[7,tblPlace.Row])+'</' + CTagNameState + '>';
  dmGenData.Query1.SQL.Clear;
  dmGenData.Query1.SQL.Add('UPDATE L SET L='''+
    AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Lieu),'\','\\'),'"','\"'),'''','\''')+
    ''' WHERE no='+tblPlace.Cells[0,tblPlace.Row]);
  dmGenData.Query1.ExecSQL;
end;

end.


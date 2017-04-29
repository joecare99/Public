unit frm_Explorer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, Menus, FMUtils;

type

  { TfrmExplorer }

  TfrmExplorer = class(TForm)
    O: TEdit;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    PopupMenu1: TPopupMenu;
    Recherche: TEdit;
    Index: TStringGrid;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IndexDblClick(Sender: TObject);
    procedure IndexDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect;
      aState: TGridDrawState);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure RechercheChange(Sender: TObject);
    procedure RechercheKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
    procedure PopulateIndex(ordre: integer);
    procedure TrouveIndividu;
  end;



var
  frmExplorer: TfrmExplorer;

implementation

uses
  frm_Main,dm_GenData, Traduction;

{$R *.lfm}

{ TfrmExplorer }

procedure TfrmExplorer.PopulateIndex(ordre:integer);
var
  row:integer;
  MyCursor: TCursor;
begin
     MyCursor := Screen.Cursor;
     Screen.Cursor := crHourGlass;
     try
     frmStemmaMainForm.ProgressBar.Position:=0;
     frmStemmaMainForm.ProgressBar.Visible:=True;

     Application.Processmessages;
      dmGenData.Query5.SQL.Clear;
     frmExplorer.O.text:=inttostr(ordre);
     case ordre of
       1:  dmGenData.Query5.SQL.add('SELECT no, I, N, I1, I2, I3, I4, X FROM N ORDER BY I2, I1, I3, I4');
       2:  dmGenData.Query5.SQL.add('SELECT no, I, N, I1, I2, I3, I4, X FROM N ORDER BY I1, I2, I3, I4');
       3:  dmGenData.Query5.SQL.add('SELECT no, I, N, I1, I2, I3, I4, X FROM N ORDER BY I3, I4, I1, I2');
       4:  dmGenData.Query5.SQL.add('SELECT no, I, N, I1, I2, I3, I4, X FROM N ORDER BY I4, I3, I1, I2');
     end;
      dmGenData.Query5.Open;
      dmGenData.Query5.First;
     row:=1;
     frmExplorer.Index.RowCount:= dmGenData.Query5.RecordCount+1;
     frmStemmaMainForm.ProgressBar.Max:=frmExplorer.Index.RowCount;
     While not  dmGenData.Query5.EOF do
     begin
       frmExplorer.Index.Cells[0,row]:= dmGenData.Query5.Fields[0].AsString;
       frmExplorer.Index.Objects[0,Row]:=TObject(ptrint(dmGenData.Query5.Fields[0].AsInteger));
       frmExplorer.Index.Cells[1,row]:= dmGenData.Query5.Fields[1].AsString;
       frmExplorer.Index.Objects[1,Row]:=TObject(ptrint(dmGenData.Query5.Fields[1].AsInteger));
       // Change col 2 selon ordre
       case ordre of
         1: frmExplorer.Index.Cells[2,row]:=(DecodeName( dmGenData.Query5.Fields[2].AsString,1));
         2: frmExplorer.Index.Cells[2,row]:=(DecodeName( dmGenData.Query5.Fields[2].AsString,2));
         3: frmExplorer.Index.Cells[2,row]:=(DecodeName( dmGenData.Query5.Fields[2].AsString,2));
         4: frmExplorer.Index.Cells[2,row]:=(DecodeName( dmGenData.Query5.Fields[2].AsString,2));
       end;
       frmExplorer.Index.Cells[3,row]:=ConvertDate( dmGenData.Query5.Fields[5].AsString,1);
       frmExplorer.Index.Cells[4,row]:=ConvertDate( dmGenData.Query5.Fields[6].AsString,1);
       if  dmGenData.Query5.Fields[7].AsBoolean then
          frmExplorer.Index.Cells[5,row]:='*'
       else
          frmExplorer.Index.Cells[5,row]:='';
       // Change col 6 selon ordre
       case ordre of
         1: frmExplorer.Index.Cells[6,row]:=dmGenData.Query5.Fields[4].AsString +
            ' '+ dmGenData.Query5.Fields[3].AsString;
         2: frmExplorer.Index.Cells[6,row]:=RemoveUTF8( dmGenData.Query5.Fields[3].AsString)+
            ', '+RemoveUTF8( dmGenData.Query5.Fields[4].AsString);
         3: frmExplorer.Index.Cells[6,row]:=ConvertDate( dmGenData.Query5.Fields[5].AsString,1);
         4: frmExplorer.Index.Cells[6,row]:=ConvertDate( dmGenData.Query5.Fields[6].AsString,1);
       end;
       row:=row+1;
        dmGenData.Query5.Next;
       frmStemmaMainForm.ProgressBar.Position:=frmStemmaMainForm.ProgressBar.Position+1;
       Application.ProcessMessages;
     end;
     finally
     frmStemmaMainForm.ProgressBar.Visible:=False;
     Screen.Cursor := MyCursor;
     end;
end;

procedure TfrmExplorer.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
     SaveFormPosition(Sender as TForm);
     SaveGridPosition(Index as TStringGrid,4);
end;

procedure TfrmExplorer.FormResize(Sender: TObject);
begin
     Index.Height:=frmExplorer.Height-42;
     Index.Width:=frmExplorer.Width-16;
     Recherche.Width:=frmExplorer.Width-16;
     Recherche.Top:=frmExplorer.Height-27;
     Index.Columns[1].Width := frmExplorer.Width-156;
end;

procedure TfrmExplorer.FormShow(Sender: TObject);
begin
     Caption:=Traduction.Items[202];
     Index.Cells[1,0]:='#';
     Index.Cells[2,0]:=Traduction.Items[176];
     Index.Cells[3,0]:=Traduction.Items[203];
     Index.Cells[4,0]:=Traduction.Items[204];
     MenuItem3.Caption:=Traduction.Items[235];
     MenuItem4.Caption:=Traduction.Items[236];
     MenuItem5.Caption:=Traduction.Items[237];
     MenuItem6.Caption:=Traduction.Items[238];
     GetFormPosition(Sender as TForm,0,0,70,1000);
     GetGridPosition(Index as TStringGrid,4);
     PopulateIndex(2);
     TrouveIndividu;
end;

procedure TfrmExplorer.IndexDblClick(Sender: TObject);
begin
  If Index.Row>0 then
     frmStemmaMainForm.iID:=ptrint(Index.Objects[1,Index.Row]);
end;

procedure TfrmExplorer.IndexDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
     if ((Sender as TStringGrid).Cells[5,aRow]='*') and (aCol=2) then
        begin
        (Sender as TStringGrid).Canvas.Font.Bold := true;
        (Sender as TStringGrid).Canvas.TextOut(aRect.Left+2,aRect.Top+2,(Sender as TStringGrid).Cells[aCol,aRow]);
     end;
end;

procedure TfrmExplorer.MenuItem3Click(Sender: TObject);
begin
   PopulateIndex(1);
end;

procedure TfrmExplorer.MenuItem4Click(Sender: TObject);
begin
  PopulateIndex(2);
end;

procedure TfrmExplorer.MenuItem5Click(Sender: TObject);
begin
  PopulateIndex(3);
end;

procedure TfrmExplorer.MenuItem6Click(Sender: TObject);
begin
  PopulateIndex(4);
end;


procedure TfrmExplorer.RechercheChange(Sender: TObject);
var
  i:integer;
  temp:string;
begin
   temp:=RemoveUTF8(recherche.text);
   if length(recherche.text)>0 then
      begin
      i:=Index.Row;
      If AnsiCompareText((copy(Index.Cells[6,i],1,length(temp))),temp)>0 then
         begin
         while (AnsiCompareText((copy(Index.Cells[6,i],1,length(temp))),temp)>0) and (i>1) do
            begin
            Application.ProcessMessages;
            i:=i-1;
         end;
      end
      else
         begin
         while (AnsiCompareText((copy(Index.Cells[6,i],1,length(temp))),temp)<0) and (i<index.rowcount-1) do
            begin
            Application.ProcessMessages;
            i:=i+1;
         end;
      end;
      Index.Row:=i;
   end;
end;

procedure TfrmExplorer.TrouveIndividu;
var
  i:integer;
begin
    if (frmExplorer.Index.Cells[1,frmExplorer.Index.Row]<>frmStemmaMainForm.sID) then
       // or (frmExplorer.Index.Cells[5,frmExplorer.Index.Row]<>'*') then
       begin
       i:=0;
       // Rechercher le nom  principal
       while ((ptrint(Index.Objects[1,i])<>frmStemmaMainForm.iID) or
              (frmExplorer.Index.Cells[5,i]='')) and
             (i<frmExplorer.index.rowcount-1) do
          i:=i+1;
       if (ptrint(Index.objects[1,i])=frmStemmaMainForm.iID) then
          frmExplorer.Index.Row:=i
       else
          frmExplorer.Index.Row:=1;
    end;
    if frmExplorer.CanFocus then frmExplorer.Index.SetFocus;
end;

procedure TfrmExplorer.RechercheKeyPress(Sender: TObject; var Key: char);
var
  row:integer;
  MyCursor: TCursor;
begin
     if (Key=chr(13)) and (length(recherche.text)>3) then
        begin
        MyCursor := Screen.Cursor;
        Screen.Cursor := crHourGlass;
         dmGenData.Query5.SQL.Clear;
         dmGenData.Query5.SQL.add('SELECT no, I, N, I1, I2, I3, I4, X FROM N WHERE MATCH (N) AGAINST ('''+
                                  recherche.text+''' IN BOOLEAN MODE) ORDER BY I1, I2');
         dmGenData.Query5.Open;
         dmGenData.Query5.First;
        row:=1;
        if not  dmGenData.Query5.EOF then
           begin
           frmExplorer.Index.RowCount:= dmGenData.Query5.RecordCount+1;
           frmStemmaMainForm.ProgressBar.Max:=frmExplorer.Index.RowCount;
           frmStemmaMainForm.ProgressBar.Position:=0;
           frmStemmaMainForm.ProgressBar.Visible:=True;
           While not  dmGenData.Query5.EOF do
              begin
              frmExplorer.Index.Cells[0,row]:= dmGenData.Query5.Fields[0].AsString;
              frmExplorer.Index.Cells[1,row]:= dmGenData.Query5.Fields[1].AsString;
              frmExplorer.Index.Cells[2,row]:=DecodeName( dmGenData.Query5.Fields[2].AsString,2);
              frmExplorer.Index.Cells[3,row]:=ConvertDate( dmGenData.Query5.Fields[5].AsString,1);
              frmExplorer.Index.Cells[4,row]:=ConvertDate( dmGenData.Query5.Fields[6].AsString,1);
              if  dmGenData.Query5.Fields[7].AsBoolean then
                 frmExplorer.Index.Cells[5,row]:='*'
              else
                 frmExplorer.Index.Cells[5,row]:='';
              frmExplorer.Index.Cells[6,row]:=RemoveUTF8( dmGenData.Query5.Fields[3].AsString)+', '+RemoveUTF8( dmGenData.Query5.Fields[4].AsString);
              row:=row+1;
               dmGenData.Query5.Next;
              frmStemmaMainForm.ProgressBar.Position:=frmStemmaMainForm.ProgressBar.Position+1;
           end;
           frmStemmaMainForm.ProgressBar.Visible:=False;
           RechercheChange(Sender);
           Screen.Cursor := MyCursor;
        end;
        TrouveIndividu;
    end;
end;


end.


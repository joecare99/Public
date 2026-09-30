unit fra_GenShowIndivid;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Grids, Buttons, Cls_GedComExt, Types;

type

  { TParentControls }

  TParentControls=record
     btnGParents:TButton;
     btnSelSpouse:TSpeedButton;
     gbxPerson:TGroupBox;
     lblBirth:TStaticText;
     lblDeath:TStaticText;
     lblSCount:TStaticText;
     Procedure Clear;
  end;

  { TFraShowIndiv }

  TFraShowIndiv = class(TFrame)
    btnHParents: TButton;
    btnWParents: TButton;
    Button1: TButton;
    DrawGrid1: TStringGrid;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    lblWBirth: TLabel;
    lblWBirthData: TStaticText;
    lblHDeath: TLabel;
    lblWDeath: TLabel;
    lblWDeathData: TStaticText;
    ListBox1: TListBox;
    Panel1: TPanel;
    Panel4: TPanel;
    pnlTop: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pnlClient: TPanel;
    pnlLeft: TPanel;
    btnHSelSp: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    btnWSelSp: TSpeedButton;
    lblHSCount: TStaticText;
    StaticText2: TStaticText;
    lblHBirth:TLabel;
    lblHBirthData: TStaticText;
    lblHDeathData: TStaticText;
    lblWSCount: TStaticText;
    procedure btnHParentsClick(Sender: TObject);
    procedure btnHSelSpClick(Sender: TObject);
    procedure DrawGrid1ButtonClick(Sender: TObject; aCol, aRow: Integer);
    procedure DrawGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1Exit(Sender: TObject);
    procedure pnlTopResize(Sender: TObject);
  private
    FFamily: TGedFamily;
    FIndividual: TGedIndividual;
    FOnFamBrowse: TNotifyEvent;
    FOnIndBrowse: TNotifyEvent;
    Husband:TParentControls;
    Wife:TParentControls;
    FChildren:array of TGedIndividual;
    Procedure InsertChildren(const aInd:TGedIndividual);
    procedure SetFamily(AValue: TGedFamily);
    procedure SetIndividual(AValue: TGedIndividual);
    procedure SetOnFamBrowse(AValue: TNotifyEvent);
    procedure SetOnIndBrowse(AValue: TNotifyEvent);

    procedure UpdateFamily;
    Procedure UpdateIndi(aind:TGedIndividual;aParCtrls:TParentControls);
  public
    constructor Create(TheOwner: TComponent); override;
    Property Individual:TGedIndividual read FIndividual write SetIndividual;
    Property Family:TGedFamily read FFamily write SetFamily;
    property OnFamBrowse:TNotifyEvent read FOnFamBrowse write SetOnFamBrowse;
    property OnIndBrowse:TNotifyEvent read FOnIndBrowse write SetOnIndBrowse;
  end;

implementation

{$R *.lfm}

{ TParentControls }

procedure TParentControls.Clear;
begin
  btnGParents.Enabled:=false;
  btnGParents.tag:=0;
  btnGParents.Caption:='';
  btnSelSpouse.Enabled:=false;
  btnGParents.tag:=0;
  btnGParents.Caption:='';
  gbxPerson.Enabled:=true;
  gbxPerson.tag:=0;
  gbxPerson.Caption:='<hinzufügen>';
  lblBirth.Caption := '';
  lblBirth.Tag := 0;
  lblDeath.Caption := '';
  lblDeath.Tag := 0;
  lblSCount.caption := '';
end;

{ TFraShowIndiv }

procedure TFraShowIndiv.pnlTopResize(Sender: TObject);
begin
  pnlLeft.Width:=pnlTop.Width div 2;
end;

procedure TFraShowIndiv.DrawGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  lText, lPlac: string;
begin
  lText := format('(%d, %d)',[aCol,arow]);
  if arow = 0 then
    lText:=DrawGrid1.Columns[aCol].Title.Caption
  else if length(FChildren)>=arow then
  case aCol of
     0:begin
         if FChildren[arow-1].ChildrenCount >0 then lText:='<' else lText:='';
         DrawGrid1.Cols[0].Objects[arow]:=FChildren[arow-1];
     end;
     1: begin
         if FChildren[arow-1].father = FFamily.Husband then
                    lText :='V' else lText := ' ';
         if FChildren[arow-1].Mother = FFamily.Wife then
                    lText :=lText+'M' else lText :=lText+ ' ';
     end;
     2: ltext := FChildren[arow-1].Name;
     3: ltext := FChildren[arow-1].sex.Replace('F','W');
     4: begin ltext := FChildren[arow-1].BirthDate;
         lPlac:=FChildren[arow-1].BirthPlace;
         if lplac <> '' then
           ltext := lText +' in ' + lplac;
       end;
     5: begin ltext := FChildren[arow-1].DeathDate;
              lPlac:=FChildren[arow-1].DeathPlace;
         if lplac <> '' then
           ltext := lText +' in ' + lplac;
end
  end;
  DrawGrid1.Canvas.TextRect(aRect,aRect.Left+2,0,lText);
end;

procedure TFraShowIndiv.ListBox1Click(Sender: TObject);
begin
  if assigned(FOnFamBrowse) and (Listbox1.ItemIndex>=0) then
    begin
      Button1.Tag:=ptrint(Listbox1.Items.Objects[Listbox1.ItemIndex]);
      FOnFamBrowse(Button1);
    end;
  ListBox1.Hide;
end;

procedure TFraShowIndiv.ListBox1Exit(Sender: TObject);
begin
  ListBox1.hide;
end;

procedure TFraShowIndiv.btnHParentsClick(Sender: TObject);
begin
  if assigned(FOnFamBrowse) then
    FOnFamBrowse(Sender);
end;

procedure TFraShowIndiv.btnHSelSpClick(Sender: TObject);
var
  lind, lSp: TGedIndividual;
  lw: Boolean;
  lFam: TGedFamily;
  lbtn: TSpeedButton;
  lPnt: TPoint;
begin
  if sender.InheritsFrom(TSpeedButton) and (tspeedbutton(sender).tag <>0) then
     begin
       //
       lbtn := TSpeedButton(sender);
       lind := TGedIndividual(lbtn.tag);
       ListBox1.clear;
       lw:=Sender=btnWSelSp; //!!
       if lind.FamCount >1 then
         for lFam in lind.EnumerateFamiliy do
           begin
             if lw then lSp := lfam.Husband else lsp := lFam.wife;
             if assigned(lSp) then
           listbox1.AddItem(lsp.name,lsp)
               else
                 Listbox1.AddItem('[unbekannt]',lsp);
           end;
       lPnt := lbtn.ClientToParent(point(lbtn.Left,lbtn.top),self);
       listbox1.width := pnlLeft.Width div 2;
       listbox1.height := self.Height;
       Listbox1.Canvas.Font := ListBox1.Font;
       listbox1.ItemHeight:=ListBox1.canvas.textheight('Wg')+2;
       if listbox1.ItemHeight*listbox1.items.count < listbox1.height then
         listbox1.height :=listbox1.ItemHeight*listbox1.items.count ;
       listbox1.Top :=  lpnt.Y+lbtn.height div 2-ListBox1.Height div 2;
       if ListBox1.top<0 then ListBox1.top:=0;
       listbox1.left := lpnt.X-ListBox1.Width;
       ListBox1.Show;
       TForm(Owner).ActiveControl := ListBox1;
     end;
end;

procedure TFraShowIndiv.DrawGrid1ButtonClick(Sender: TObject; aCol,
  aRow: Integer);
begin
  Button1.tag := ptrint(DrawGrid1.Cols[0].Objects[aRow]);
  if assigned(FOnIndBrowse) then
    FOnIndBrowse(Button1);
end;

procedure TFraShowIndiv.InsertChildren(const aInd: TGedIndividual);
var
  i: Integer;
  lflag: Boolean;
  lInd2: TGedIndividual;
begin
  if (length(FChildren) = 0) and Assigned(aInd) then
    begin
      SetLength(FChildren,aInd.ChildrenCount);
      for i := 0 to high(FChildren) do
        FChildren[i] := aInd.Children[I];
    end
  else if Assigned(aInd) then
    begin
      for i := 0 to aind.ChildrenCount-1 do
        begin
          lflag := false;
          for lInd2 in FChildren do
            if lind2 = aind.Children[i] then
              begin
                lflag := true;
                exit;
              end;
          if not lflag then
            begin
              setlength(FChildren,high(FChildren)+2);
                FChildren[high(FChildren)] := aInd.Children[I];
            end;
        end;
    end;
end;

procedure TFraShowIndiv.SetFamily(AValue: TGedFamily);
begin
  if FFamily=AValue then Exit;
  FFamily:=AValue;
  UpdateFamily;
end;

procedure TFraShowIndiv.SetIndividual(AValue: TGedIndividual);
begin
  if FIndividual=AValue then Exit;
  FIndividual:=AValue;
  if Assigned(FIndividual) then
     begin
       if FIndividual.FamCount>0 then
         SetFamily(FIndividual.Familys[0])
       else
         begin
           SetFamily(nil);
         if FIndividual.Sex='F' then
           begin
             UpdateIndi(FIndividual,Wife);
             setlength(FChildren,0);
             InsertChildren(FIndividual);
             Husband.Clear;
             DrawGrid1.Invalidate;
           end
         else
           begin
             UpdateIndi(FIndividual,Husband);
             setlength(FChildren,0);
             InsertChildren(FIndividual);
             wife.Clear;
             DrawGrid1.Invalidate;
           end
         end
     end
end;

procedure TFraShowIndiv.SetOnFamBrowse(AValue: TNotifyEvent);
begin
  if @FOnFamBrowse=@AValue then Exit;
  FOnFamBrowse:=AValue;
end;

procedure TFraShowIndiv.SetOnIndBrowse(AValue: TNotifyEvent);
begin
  if @FOnIndBrowse=@AValue then Exit;
  FOnIndBrowse:=AValue;
end;

procedure TFraShowIndiv.UpdateFamily;
begin
  if assigned(FFamily) then
    begin
  UpdateIndi(Family.Husband,Husband);
  UpdateIndi(Family.Wife,Wife);
  setlength(FChildren,0);
  InsertChildren(Family.Husband);
  InsertChildren(Family.Wife);
  DrawGrid1.RowCount:=Length(FChildren)+1;
  if Family.MarriageDate <>'' then
    begin
      StaticText2.caption:='Geheiratet am '+Family.MarriageDate;
      if Family.MarriagePlace<>'' then
        StaticText2.caption:=StaticText2.caption + ' in '+Family.MarriagePlace;
    end else StaticText2.caption:='';
    end
  else
    begin
      Husband.Clear;
      Wife.Clear;
      DrawGrid1.RowCount:=1;
    end;
  DrawGrid1.Invalidate;
end;

procedure TFraShowIndiv.UpdateIndi(aind: TGedIndividual; aParCtrls: TParentControls);
begin
  if not assigned(aind) then
     aParCtrls.Clear
  else
   with aind do
   begin
     with aParCtrls do begin
       btnGParents.Enabled:=true;
       btnGParents.tag:=0;
       if not assigned(Father) and not Assigned(Mother) then
         btnGParents.Caption:='Eltern hinzufügen'
       else
         begin
           if Assigned(Father) then
             btnGParents.Caption:=Father.name
           else
             btnGParents.Caption:='[unbek.]';
           if Assigned(mother) then
             btnGParents.Caption:=btnGParents.Caption+' && '+Mother.name
           else
             btnGParents.Caption:=btnGParents.Caption+' && [unbek.]';
//           btnGParents.tag:=ptrint(ParentFam);
           btnGParents.tag := Ptrint(find('FAMC').link);
         end;
       gbxPerson.Enabled:=true;
       gbxPerson.tag:=0;
       gbxPerson.Caption:=Name;
       lblBirth.Caption := BirthDate;
       lblBirth.Tag := ptrint(Birth);
       if lblBirth.Caption='' then
         lblBirth.Caption := BaptDate;
       if Birthplace <> '' then
         lblBirth.Caption:=lblBirth.Caption + lineending + 'in '+BirthPlace;
       lblDeath.Caption := DeathDate;
       if lblDeath.Caption='' then
         lblDeath.Caption := BurialDate;
       if DeathPlace <> '' then
         lblDeath.Caption:=lblDeath.Caption + lineending + 'in '+DeathPlace;
       lblDeath.Tag := ptrint(Death);

       lblSCount.Caption:=inttostr(SpouseCount);
       btnSelSpouse.tag := ptrint(aind);
       btnSelSpouse.Enabled:=aind.FamCount <> 1;
     end;
   end
end;

constructor TFraShowIndiv.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
// Group Controls
  Husband.btnGParents := btnHParents;
  Husband.btnSelSpouse := btnHSelSp;
  Husband.gbxPerson := GroupBox1;
  Husband.lblBirth := lblHBirthData;
  Husband.lblDeath := lblHDeathData;
  Husband.lblSCount:= lblHSCount;
  Wife.btnGParents := btnWParents;
  Wife.btnSelSpouse := btnWSelSp;
  Wife.gbxPerson := GroupBox2;
  Wife.lblBirth := lblWBirthData;
  Wife.lblDeath := lblWDeathData;
  Wife.lblSCount:= lblWSCount;
end;

end.


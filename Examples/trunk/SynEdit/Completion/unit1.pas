unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  Forms, StdCtrls, ExtCtrls,
  LazStringUtils,
  SynEdit, SynCompletion;

type

  { TForm1 }

  TForm1 = class(TForm)
    chkSizeDrag: TCheckBox;
    chkSearch: TCheckBox;
    chkExec: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    SynAutoComplete1: TSynAutoComplete;
    SynCompletion1: TSynCompletion;
    SynEdit1: TSynEdit;
    procedure chkExecChange(Sender: TObject);
    procedure chkSearchChange(Sender: TObject);
    procedure chkSizeDragChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure DoExecute(Sender: TObject);
    procedure DoSearchPosition(var APosition: integer);
  private

  public

  end; 

var
  Form1: TForm1; 

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Memo1Change(Sender: TObject);
begin
  SynAutoComplete1.AutoCompleteList := Memo1.Lines;
end;

procedure TForm1.DoExecute(Sender: TObject);
(* Filter the initial list, to match the pre-fix.

   Depending on chkExec.Checked entries may be:
   - filtered to match the pre-fix
   - displayed always

   This is called once, when the completion dropdown is initially shown
*)
  procedure Add(s: String);
  begin
    if LazStartsText(SynCompletion1.CurrentString, s) then
      SynCompletion1.ItemList.Add(s);
  end;
begin
  SynCompletion1.ItemList.Clear;
  if chkExec.Checked then begin
    Add('Personal Computer');
    Add('Personal');
    Add('Computer');
    Add('Police Constable');
    Add('Police');
    Add('Constable');
  end else begin
    SynCompletion1.ItemList.Add('Personal Computer');
    SynCompletion1.ItemList.Add('Personal');
    SynCompletion1.ItemList.Add('Computer');
    SynCompletion1.ItemList.Add('Police Constable');
    SynCompletion1.ItemList.Add('Police');
    SynCompletion1.ItemList.Add('Constable');
  end;
end;

procedure TForm1.DoSearchPosition(var APosition: integer);
(* Filter the list, to match the pre-fix.
   See TForm1.chkSearchChange, this event is removed, if filtering is not needed.

   Only display entries that match the prefix.
   APosition is the index, of the entry that will be selected.

   This is called everytime the user changes the pre-fix, while the completion is already open
*)
  procedure Add(s: String);
  begin
    if LazStartsText(SynCompletion1.CurrentString, s) then
      SynCompletion1.ItemList.Add(s);
  end;
begin
  SynCompletion1.ItemList.Clear;
  Add('Personal Computer');
  Add('Personal');
  Add('Computer');
  Add('Police Constable');
  Add('Police');
  Add('Constable');
  if SynCompletion1.ItemList.Count > 0 then
    APosition := 0
  else
    APosition := -1;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1Change(nil);
end;

procedure TForm1.chkExecChange(Sender: TObject);
begin
  SynEdit1.SetFocus;
end;

procedure TForm1.chkSearchChange(Sender: TObject);
begin
  if chkSearch.Checked then
    SynCompletion1.OnSearchPosition := @DoSearchPosition
  else
    SynCompletion1.OnSearchPosition := nil;
  SynEdit1.SetFocus;
end;

procedure TForm1.chkSizeDragChange(Sender: TObject);
begin
  SynCompletion1.ShowSizeDrag := chkSizeDrag.Checked;
end;

end.


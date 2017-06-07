unit unt_Componentprocs;
// Diese Unit Stellt eine Proceduren zum kopieren von Komponenten bereit.
{*v 1.00.00}

interface

uses Controls,StdCtrls,extctrls;

type TWhereToCopy = (wtc_Equal,wtc_Left,wtc_Right,wtc_Over,wtc_Under);

procedure ContrCopy(var dest:TControl;const source:TControl);Overload;
procedure ContrCopy(var dest:TControl;const source:TControl;createnew:boolean);Overload;
procedure ContrCopy(var dest:TControl;const source:TControl;createnew:boolean;wtc:TWhereToCopy);Overload;
procedure ContrCopy(var dest:TWinControl;const source:TWinControl);Overload;
procedure ContrCopy(var dest:TWinControl;const source:TWinControl;createnew:boolean);Overload;
procedure ContrCopy(var dest:TWinControl;const source:TWinControl;createnew:boolean;wtc:TWhereToCopy);Overload;
procedure ContrCopy(var dest:TLabel;const source:TLabel);Overload;
procedure ContrCopy(var dest:TLabel;const source:TLabel;createnew:boolean);Overload;
procedure ContrCopy(var dest:TLabel;const source:TLabel;createnew:boolean;wtc:TWhereToCopy);Overload;
procedure ContrCopy(var dest:TButton;const source:TButton);Overload;
procedure ContrCopy(var dest:TButton;const source:TButton;createnew:boolean);Overload;
procedure ContrCopy(var dest:TButton;const source:TButton;createnew:boolean;wtc:TWhereToCopy);Overload;
procedure ContrCopy(var dest:Tpanel;const source:TPanel);Overload;
procedure ContrCopy(var dest:Tpanel;const source:TPanel;createnew:boolean);Overload;
procedure ContrCopy(var dest:Tpanel;const source:TPanel;createnew:boolean;wtc:TWhereToCopy);Overload;
Procedure ContrCopy(var dest:TEdit;const source:TEdit);Overload;
Procedure ContrCopy(var dest:TEdit;const source:TEdit;createnew:boolean);Overload;
Procedure ContrCopy(var dest:TEdit;const source:TEdit;createnew:boolean;wtc:TWhereToCopy);Overload;
procedure ContrMoveTo(var dest:TControl;wtc:TWhereToCopy);

implementation

procedure ContrCopy(var dest:TLabel;const source:TLabel);

begin
  dest.parent := source.parent;
  dest.Autosize:=source.AutoSize  ;
  dest.focusControl:=source.focuscontrol;
  contrcopy(Tcontrol(dest),source);
  dest.Alignment:=source.Alignment;
  dest.caption := source.caption;
  dest.color := source.color;
  dest.OnClick := source.OnClick;
  dest.OnDblClick := source.OnDblClick;
  dest.font := source.font;
  dest.WordWrap := source.WordWrap;
end;

procedure ContrCopy(var dest:TLabel;const source:TLabel;createNew:Boolean);

begin
  if createnew then
     dest := Tlabel.Create (source.parent);
  ContrCopy(dest,source);
end;

procedure ContrCopy(var dest:TLabel;const source:TLabel;createNew:Boolean;wtc:TWhereToCopy);

begin
  if createnew then
     dest := Tlabel.Create (source.parent);
  ContrCopy(dest,source);
end;

procedure ContrCopy(var dest:TControl;const source:TControl);

begin
  dest.parent := source.Parent;
  dest.height := source.height;
  dest.width := source.width;
  dest.top:= source.top;
  dest.left := source.left;
  dest.Cursor := source.Cursor;
  dest.enabled := source.enabled;
  dest.visible := source.visible;
end;

procedure ContrCopy(var dest:TControl;const source:TControl;createNew:Boolean );

begin
  if createnew then
     dest := TControl.Create (source.parent);
  ContrCopy(dest,source);
end;

procedure ContrCopy(var dest:TControl;const source:TControl;createNew:Boolean;wtc:TWhereToCopy );

begin
  if createnew then
     dest := TControl.Create (source.parent);
  ContrCopy(dest,source);
end;

procedure ContrCopy(var dest:TwinControl;const source:TwinControl);

begin
  contrcopy(Tcontrol(dest),source);
  dest.ParentWindow:=source.ParentWindow ;
  dest.tabstop:=source.TabStop;
  dest.TabOrder:=source.TabOrder;
end;

procedure ContrCopy(var dest:TwinControl;const source:TwinControl;createNew:Boolean );

begin
  if createnew then
     dest := TWinControl.Create (source.parent);
  ContrCopy(dest,source);
end;

procedure ContrCopy(var dest:TwinControl;const source:TwinControl;createNew:Boolean;wtc:TWhereToCopy );

begin
  if createnew then
     dest := TWinControl.Create (source.parent);
  ContrCopy(dest,source);
end;

procedure ContrCopy(var dest:TButton;const source:TButton);

begin
  dest.parent := source.parent;
  contrcopy(TWinControl(dest),source);
  dest.caption := source.caption;
  dest.OnClick := source.OnClick;
  dest.font := source.font;
end;

procedure ContrCopy(var dest:TButton;const source:TButton;createNew:Boolean;wtc:TWhereToCopy );

begin
  if createnew then
     dest := TButton.Create (source.parent);
  ContrCopy(dest,source);
end;

procedure ContrCopy(var dest:TButton;const source:TButton;createNew:Boolean );

begin
  if createnew then
     dest := TButton.Create (source.parent);
  ContrCopy(dest,source);
end;

procedure ContrCopy(var dest:Tpanel;const source:TPanel);

begin
  dest.parent := source.parent;
  dest.Autosize:=source.AutoSize  ;
  contrcopy(Twincontrol(dest),source);
  dest.Alignment:=source.Alignment;
  dest.caption := source.caption;
  dest.OnClick := source.OnClick;
  dest.BevelInner := source.BevelInner ;
  dest.BevelOuter  := source.BevelOuter  ;
  dest.BevelWidth := source.BevelWidth ;
  dest.OnDblClick := source.OnDblClick;
  dest.font := source.font;
end;

procedure ContrCopy(var dest:Tpanel;const source:TPanel;createNew:Boolean );

begin
  if createnew then
     dest := TPanel.Create (source.parent);
  ContrCopy(dest,source);
end;

procedure ContrCopy(var dest:Tpanel;const source:TPanel;createNew:Boolean;wtc:TWhereToCopy );

begin
  if createnew then
     dest := TPanel.Create (source.parent);
  ContrCopy(dest,source);
end;

procedure ContrCopy(var dest:TEdit;const source:TEdit);

begin
   dest.AutoSelect:=source.AutoSelect;
   dest.AutoSize:=source.AutoSize;
   contrcopy(Twincontrol(Dest),source);
   dest.borderStyle:=source.BorderStyle;
   // dest.CanUndo:=source.CanUndo;
   dest.CharCase:=source.CharCase ;
   dest.BorderStyle :=source.BorderStyle;
   dest.Font := source.Font;
   dest.Color := source.color;
   dest.HideSelection:=source.HideSelection ;
   dest.MaxLength:=source.MaxLength ;
   dest.Modified:=source.Modified;
   dest.OEMConvert:=source.OEMConvert ;
   dest.PasswordChar:=source.PasswordChar;
   dest.ReadOnly:=source.ReadOnly ;
end;

procedure ContrCopy(var dest:TEdit;const source:TEdit;createNew:Boolean );

begin
  if createnew then
     dest := TEdit.Create (source.parent);
  ContrCopy(dest,source);
end;

procedure ContrCopy(var dest:TEdit;const source:TEdit;createNew:Boolean ;wtc:TWhereToCopy);

begin
  if createnew then
     dest := TEdit.Create (source.parent);
  ContrCopy(dest,source);
  contrmoveto(TControl(dest),wtc);
end;

procedure ContrMoveTo(var dest:TControl;wtc:TWhereToCopy);

begin
  case wtc of
    wtc_Left  : dest.left:=dest.left-dest.width-2;
    wtc_Right : dest.left:=dest.left+dest.width+2;
    wtc_Over  : dest.top:=dest.top-dest.width-2;
    wtc_Under : dest.top:=dest.top+dest.width+2;
  end;

end;


end.


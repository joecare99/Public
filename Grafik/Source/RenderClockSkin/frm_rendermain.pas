unit Frm_RenderMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ExtDlgs, Spin, StdCtrls,dom;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    ImageList1: TImageList;
    Label1: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    PaintBox1: TPaintBox;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    Timer1: TTimer;
    ToggleBox1: TToggleBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
  private
    { private declarations }
    Fbitmap:TBitmap;
    FDisplay:integer;
    Finfo:TXMLDocument;
  public
    { public declarations }
  end;

var
  Form1: TForm1;


implementation

{$R *.lfm}
uses Unt_RenderObjects,XMLRead,XMLWrite;

{ TForm1 }

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  I, Wh, th, tw, oo, cv: Integer;
  Pts:array of TPoint;
  s, c: ValReal;
  d, r: Extended;
  bb: TBitmap;
begin
  bb:=Tbitmap.Create;
  bb.Width:=PaintBox1.Width*3;
  bb.height:=PaintBox1.Width*3;
  Wh:=bb.Width div 2;
  with bb.canvas do
    begin
      // Hintergrund: weiss:
      brush.Color:=clWhite;
      FillRect(0,0,wh*2,wh*2);
      // Äusserer Rahmen1
      for I := wh div 100 to wh div 10 do
        begin
          cv := 145 + (i * 750) div wh;
          pen.Color:= RGBToColor(cv,cv,cv);
          pen.Width:=2;
          Ellipse(i,i,wh*2-i,wh*2-i);
        end;
      // innerer Rahmen1
      for I := 0 to wh div 5 do
        begin
          cv := 155 + (i * 500) div wh;
          pen.Color:= RGBToColor(cv,cv,cv);
          pen.Width:=2;
          Ellipse(i+wh div 10,i+wh div 10,wh*2-wh div 10-i,wh*2-wh div 10-i);
        end;
      // Äusserer Rahmen1
      for I := wh div 100 to wh div 10 do
        begin
          cv := 195 + (i * 500) div wh;
          pen.Color:= RGBToColor(cv,cv,cv);
          pen.Width:=2;
          oo := (i * 500) div wh;
          Arc(i,i,wh*2-i,wh*2-i,160+oo,3000-oo*2);
        end;
      // innerer Rahmen1
      for I := 0 to wh div 5 do
        begin
          cv := 180 + (i * 375) div wh;
          pen.Color:= RGBToColor(cv,cv,cv);
          pen.Width:=2;
           oo := ((i+wh div 10)* 500) div wh;;
          Arc(i+wh div 10,i+wh div 10,wh*2-wh div 10-i,wh*2-wh div 10-i,160+oo,3000-oo*2);
        end;
      // Dots
      setlength(Pts,4);

      r:=0.87;
      for I := 0 to 59 do
        begin
          d:=0.02;
          if i mod 5>0 then
            d:=0.013;
          brush.Color:=clBlack;
          pen.Color:= clBlack;
          pen.Width:=1;
          s:=sin(i/30*pi);
          c:=cos(i/30*pi);
          pts[0]:=Point(wh+trunc(-d*wh*c+r*wh*s),wh+trunc(-r*wh*c- d*wh*s));
          pts[1]:=Point(wh+trunc( d*wh*c+r*wh*s),wh+trunc(-r*wh*c+ d*wh*s));
          pts[2]:=Point(wh+trunc( d*wh*c+(r-2*d)*wh*s),wh+trunc(-(r-2*d)*wh*c+ d*wh*s));
          pts[3]:=Point(wh+trunc(-d*wh*c+(r-2*d)*wh*s),wh+trunc(-(r-2*d)*wh*c- d*wh*s));
          Polygon(Pts);
        end;
      Font.Name:='Arial';
      font.Size:=wh div 6;
      font.Bold:=true;
      font.Pitch:=fpVariable;
 //     TextStyle.Opaque:=false;
      r:=0.84;
      th:=textheight(inttostr(0));
      for I := 1 to 12 do
        begin
          brush.Style:=bsClear;
          pen.Color:= clBlack;
          pen.Width:=1;
          s:=sin(i/6*pi);
          c:=cos(i/6*pi);
          tw:=textwidth(inttostr(i));
          TextOut(wh+trunc((r*wh-0.6*tw)*s-tw*0.5),wh+trunc((-r*wh+0.45*th)*c-0.5*th),inttostr(i));
        end;
    end;
  bb.SaveToFile('..\..\glyphs\wallclock.bmp');
  PaintBox1.Canvas.StretchDraw(PaintBox1.Canvas.ClipRect,bb);
  freeandnil(bb);
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var cbm :TCustomBitmap;
  PictInfo: TDOMNode;
begin
  if OpenPictureDialog1.Execute then
    begin
      if not assigned(Fbitmap) then
        Fbitmap:= TBitmap.Create;
      try
      if LowerCase(ExtractFileExt(OpenPictureDialog1.FileName))='.png' then
        cbm:=TPortableNetworkGraphic.Create
      else if LowerCase(ExtractFileExt(OpenPictureDialog1.FileName))='.gif' then
        cbm:=TGIFImage.Create
      else if LowerCase(ExtractFileExt(OpenPictureDialog1.FileName))='.jpg' then
        cbm:=TJPEGImage.Create
      else if LowerCase(ExtractFileExt(OpenPictureDialog1.FileName))='.jpeg' then
        cbm:=TJPEGImage.Create
      else
        cbm := TBitmap.create;
      cbm.LoadFromFile(OpenPictureDialog1.FileName);
      Fbitmap.assign(cbm);
      finally
        freeandnil(cbm);
      end;
      spinedit1.MaxValue:=Fbitmap.Width;
      spinedit3.MaxValue:=Fbitmap.Width;
      spinedit2.MaxValue:=Fbitmap.Height;
      spinedit4.MaxValue:=Fbitmap.Height;

      if FileExists(ChangeFileExt(OpenPictureDialog1.FileName,'.XInfo')) then
        begin
          ReadXMLFile(FInfo,ChangeFileExt(OpenPictureDialog1.FileName,'.XInfo'));
          PictInfo := Finfo.FindNode('PICTUREINFO');
          if assigned(PictInfo) then with PictInfo.FindNode('METADATA').Attributes do
            if GetNamedItem('type').NodeValue = 'isosize1' then
            begin
            CheckBox1.Checked:=false;
            SpinEdit1.Caption:= GetNamedItem('Width').NodeValue;
            SpinEdit2.Caption:= GetNamedItem('Height').NodeValue;
            SpinEdit3.Caption:='0';
            SpinEdit4.Caption:='0';
            end
          else
          if GetNamedItem('type').NodeValue = 'isosize2' then
          begin
          CheckBox1.Checked:=false;
          SpinEdit1.Caption:= GetNamedItem('Width').NodeValue;
          SpinEdit2.Caption:= GetNamedItem('Height').NodeValue;
          SpinEdit3.Caption:=GetNamedItem('Left').NodeValue;;
          SpinEdit4.Caption:=GetNamedItem('Top').NodeValue;;
          end;

        end
      else
        PaintBox1.canvas.Draw(0,0,Fbitmap);
    end;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
var
  PictInfo: TDOMElement;
  DataNode: TDOMElement;
begin
  if not CheckBox1.Checked then
    if fileexists(OpenPictureDialog1.FileName) then
      begin
        if assigned(Finfo) then
          freeandnil(Finfo);
        Finfo:= TXMLDocument.Create;
        PictInfo :=Finfo.CreateElement('PICTUREINFO');
        PictInfo.SetAttribute('Version','1.1');


        DataNode :=Finfo.CreateElement('METADATA');
        if (SpinEdit3.Value=0) and (SpinEdit4.Value=0) then
        DataNode.SetAttribute('type','isosize1')
        else
          begin
            DataNode.SetAttribute('type','isosize2');
            DataNode.SetAttribute('Left',SpinEdit3.Caption);
            DataNode.SetAttribute('Top',SpinEdit4.Caption);
          end;
        DataNode.SetAttribute('Width',SpinEdit1.Caption);
        DataNode.SetAttribute('Height',SpinEdit2.Caption);
        PictInfo.AppendChild(Datanode);
        Finfo.AppendChild(PictInfo);
        WriteXMLFile(Finfo,ChangeFileExt(OpenPictureDialog1.FileName,'.XInfo'));
      end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if assigned(Fbitmap) then
    freeandnil(Fbitmap);
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  PaintBox1.Canvas.Clear;
  PaintBox1.canvas.Draw(0,0,Fbitmap);
  paintbox1.canvas.DrawFocusRect(rect(SpinEdit3.value,SpinEdit4.value,SpinEdit3.value+SpinEdit1.value,SpinEdit4.value+SpinEdit2.value));
  //Last
  paintbox1.canvas.DrawFocusRect(rect(SpinEdit3.value+SpinEdit1.value,SpinEdit4.value+SpinEdit2.value,
    SpinEdit3.value+SpinEdit1.value*2,SpinEdit4.value+SpinEdit2.value*2));
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  maxDisp, maxBpr, xsz, ysz, zx, zy: Integer;
begin
  maxBpr := (Fbitmap.Width div SpinEdit1.Value);
  maxDisp := (Fbitmap.Height div SpinEdit2.Value) * maxBpr;
  if maxDisp = 0 then exit;
  FDisplay := (FDisplay + 1) mod maxDisp;
  label1.Caption:=inttostr(FDisplay);
  xsz:= SpinEdit3.Value+(FDisplay mod maxBpr)*SpinEdit1.Value;
  ysz:= SpinEdit4.Value+(FDisplay div maxBpr)*SpinEdit2.Value;
  zx:=Fbitmap.Width;
  zy:=0;
  if zx > PaintBox1.Width-SpinEdit1.Value then
    if Fbitmap.height+SpinEdit2.Value < PaintBox1.Height then
    begin
    zx:=0;
    zy:=Fbitmap.Height;

    end
   else
     begin
       zx:= PaintBox1.Width-SpinEdit1.Value;
       zy := PaintBox1.Height-SpinEdit2.Value;
     end;
  PaintBox1.Canvas.FillRect(rect(zx,zy,zx+SpinEdit1.Value,zy+SpinEdit2.Value));
  PaintBox1.Canvas.CopyRect(rect(zx,zy,zx+SpinEdit1.Value,zy+SpinEdit2.Value),
    Fbitmap.Canvas,rect(xsz,ysz,xsz+SpinEdit1.Value,ysz+SpinEdit2.Value));
end;

procedure TForm1.ToggleBox1Change(Sender: TObject);
begin
  timer1.Enabled:=not Timer1.Enabled;
  ToggleBox1.Checked := timer1.Enabled;
end;

end.


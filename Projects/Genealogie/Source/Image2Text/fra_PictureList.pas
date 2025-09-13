unit fra_PictureList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ShellCtrls, BGRAImageList, unt_iData,
  ComCtrls, Types;

type
  TRenameFileEvent=Procedure(sender:TObject;Oldfile,NewFile:String) of Object;
  { TfraPictureList }

  TfraPictureList = class(TFrame,IDataRO)
    ilsDirImages: TBGRAImageList;
    lstPictures: TShellListView;
    procedure lstPicturesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lstPicturesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lstPicturesMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure lstPicturesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    FOnRenameFile: TRenameFileEvent;
    FonUpdate:TNotifyEvent;
    FFileName: String;
    function GetBasePath: String;
    function GetCount: integer;
    function getFilemask: string;
    procedure SetBasePath(AValue: String);
    procedure SetFilemask(AValue: string);
    procedure SetOnRenameFile(AValue: TRenameFileEvent);
    procedure UpdateListImage(Data: PtrInt);

  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    function getdata:variant;
      procedure First(Sender:Tobject=nil);
      Procedure Last(Sender:Tobject=nil);
      Procedure Next(Sender:Tobject=nil);
      Procedure Previous(Sender:Tobject=nil);
      Procedure Seek(aID:Integer);
      Function EOF:boolean;
      function BOF:boolean;
      Function GetActID:integer;
      function GetOnUpdate: TNotifyEvent;
      procedure SetOnUpdate(AValue: TNotifyEvent);
      Procedure Select(aFile:string);
      property Count:integer read GetCount;
      property Data:variant read getdata;
      property OnUpdate:TNotifyEvent read GetOnUpdate write SetOnUpdate;
      property OnRenameFile:TRenameFileEvent read FOnRenameFile write SetOnRenameFile;
      property BasePath:String read GetBasePath write SetBasePath;
      property Filemask:string read getFilemask write SetFilemask;
  end;

implementation

uses BGRAReadJpeg,BGRABitmap,BGRABitmapTypes;
{$R *.lfm}

{ TfraPictureList }

procedure TfraPictureList.lstPicturesChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  NewPath: String;
begin
  if assigned(Item) and (ctText = change) and (Item=lstPictures.Selected)  then
    begin
      if ExtractFileExt(item.caption) ='' then
        begin
          item.caption := item.caption + ExtractFileExt(FFileName);
          exit;
        end;
      NewPath := lstPictures.GetPathFromItem(Item);
          if not fileexists(lstPictures.GetPathFromItem(Item)) then
            begin
              RenameFile(FFilename,NewPath);
              if assigned(FOnRenameFile) then
                FOnRenameFile(self,FFileName,NewPath);
              FFileName:=NewPath;
            end
          else
            item.Caption:=ExtractFileName(FFileName);
    end
  else if assigned(Item) and (ctText= Change) and (item.ImageIndex=-1) then
    begin
      if (item.top < lstPictures.Height) and (item.top>-64) then
        Application.QueueAsyncCall(@UpdateListImage, ptrint(Item.Index));
    end;
end;

procedure TfraPictureList.lstPicturesMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
  var
    Item: TListItem;
  begin
    if ssLeft in shift then
      begin
        for Item in lstPictures.Items do
        if (item.ImageIndex=-1) and (item.top < lstPictures.Height) and (item.top>-64) then
          Application.QueueAsyncCall(@UpdateListImage, ptrint(Item.Index));
      end;
  end;

procedure TfraPictureList.lstPicturesMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
  var
    Item: TListItem;
  begin
    for Item in lstPictures.Items do
    if (item.ImageIndex=-1) and (item.top-lstPictures.ViewOrigin.y < lstPictures.Height) and (item.top>lstPictures.ViewOrigin.y-64) then
      Application.QueueAsyncCall(@UpdateListImage, ptrint(Item.Index));
  end;


procedure TfraPictureList.lstPicturesSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
  var
    lItem: TListItem;
  begin
    if FFilename = lstPictures.GetPathFromItem(Item) then
      begin
        if Item.ImageIndex = -1 then
          Application.QueueAsyncCall(@UpdateListImage, ptrint(Item));
        exit;
      end;
    FFilename := lstPictures.GetPathFromItem(Item);
    for lItem in lstPictures.Items do
    if (litem.ImageIndex=-1) and (litem.top-lstPictures.ViewOrigin.y < lstPictures.Height) and (litem.top>lstPictures.ViewOrigin.y-64) then
      Application.QueueAsyncCall(@UpdateListImage, litem.Index);
    if assigned(FonUpdate) then
      FonUpdate(self);
  end;


procedure TfraPictureList.SetOnRenameFile(AValue: TRenameFileEvent);
begin
  if FOnRenameFile=AValue then Exit;
  FOnRenameFile:=AValue;
end;

procedure TfraPictureList.SetBasePath(AValue: String);
begin
  if lstPictures.Root=AValue then Exit;
         try
//           lstPictures.ViewStyle := vsList;
           lstPictures.items.Clear;
           ilsDirImages.clear;
         lstPictures.Root:=AValue;
         lstPictures.ViewStyle:=vsIcon;

         except
           exit
         end;

end;

procedure TfraPictureList.SetFilemask(AValue: string);
begin
  if lstPictures.Mask=AValue then Exit;
  lstPictures.Mask:=AValue;
end;

function TfraPictureList.GetBasePath: String;
begin
  result := lstPictures.Root;
end;

function TfraPictureList.GetCount: integer;
begin
  Result := lstPictures.Items.Count;
end;

function TfraPictureList.getFilemask: string;
begin
  result := lstPictures.Mask;
end;

procedure TfraPictureList.UpdateListImage(Data: PtrInt);
var
  Item: TListItem;
  lImage,lBmp: TBGRACustomBitmap;
  reader:TBGRAReaderJpeg;
  NewPath: String;
  lMs: TStream;
begin
  lBmp:=nil;
  if (Data>=0) and (Data<=lstPictures.Items.Count-1) then
    begin
      Item := lstPictures.Items[Data];
      NewPath := lstPictures.GetPathFromItem(Item);
      if FileExists(NewPath) then
      try
      if (uppercase(ExtractFileExt(item.Caption)) = '.JPG') or
         (uppercase(ExtractFileExt(item.Caption)) = '.JPEG') then
        try
          reader:= TBGRAReaderJpeg.Create;
          lMs := TFileStream.create(lstPictures.GetPathFromItem(item),fmOpenRead,fmShareDenyNone);
          reader.Scale:=jsEighth;
          reader.Performance:=jpBestSpeed;
          lImage:=TBGRABitmap(reader.ImageRead(lms,TBGRABitmap.Create));
        finally
          freeandnil(reader);
          freeandnil(lms);
        end
      else
        try
        lImage:=TBGRABitmap.Create(lstPictures.GetPathFromItem(item));
        except
          lImage:=nil;
        end;
        lBmp:=lImage.Resample(64,64,rmSimpleStretch);
        ilsDirImages.Add(lBmp.Bitmap,nil);
        item.ImageIndex:=ilsDirImages.Count-1;
      finally
        freeandnil(lBmp);
        freeandnil(lImage)
      end;
    end;
end;

constructor TfraPictureList.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  lstPictures.Mask:='*.jpg;*.jpeg;*.png;*.bmp;*.gif';
end;

destructor TfraPictureList.Destroy;
begin
  ilsDirImages.Clear;
  inherited Destroy;
end;

function TfraPictureList.getdata: variant;
begin
  result := Null;
  if assigned(lstPictures.Selected) then
    result:=lstPictures.GetPathFromItem(lstPictures.Selected);
end;

procedure TfraPictureList.First(Sender: Tobject);
begin
  if bof then exit;
  lstPictures.ItemIndex:=0;
end;

procedure TfraPictureList.Last(Sender: Tobject);
begin
  if Eof then exit;
  lstPictures.ItemIndex:=lstPictures.Items.Count-1;

end;

procedure TfraPictureList.Next(Sender: Tobject);
begin
  if not EOF then
    begin
    lstPictures.ItemIndex:=lstPictures.ItemIndex+1;
    end
end;

procedure TfraPictureList.Previous(Sender: Tobject);
begin
  if not BOF then
    begin
    lstPictures.ItemIndex:=lstPictures.ItemIndex-1;

    end;
end;

procedure TfraPictureList.Seek(aID: Integer);
begin
  if lstPictures.ItemIndex=aid then exit;
  lstPictures.ItemIndex:=aid;
end;

function TfraPictureList.EOF: boolean;
begin
  result := lstPictures.ItemIndex >= lstPictures.Items.Count-1;
end;

function TfraPictureList.BOF: boolean;
begin
  result := lstPictures.ItemIndex <= 0;
end;

function TfraPictureList.GetActID: integer;
begin
  result := lstPictures.ItemIndex
end;

function TfraPictureList.GetOnUpdate: TNotifyEvent;
begin
  result :=  FonUpdate;
end;

procedure TfraPictureList.SetOnUpdate(AValue: TNotifyEvent);
begin
  if AValue= FonUpdate then exit;
  FonUpdate:=AValue;
end;

procedure TfraPictureList.Select(aFile: string);
var
  lFnd: TListItem;
begin
  lFnd :=lstPictures.FindCaption(0,ExtractFileName(aFile),false,false,false,false);
  if Assigned(lFnd) then
    lstPictures.itemindex:= lFnd.Index;
end;

end.


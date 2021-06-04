unit fra_PlaceEdit;

{$mode delphi}{$H+}

interface

uses
    Classes, SysUtils, DB, FileUtil, Forms, Controls, DBGrids, DBCtrls,
    ExtCtrls, Buttons, Dialogs, StdCtrls, ComCtrls, ColorBox, mvGeoNames,
    mvMapViewer, VisualHTTPClient, dm_RNZAnzeigen, cmp_GedComFile, mvTypes,
    mvDrawingEngine;

type

    { TFraPlaceEdit }

    TFraPlaceEdit = class(TFrame)
      Bevel1: TBevel;
      BtnGoTo: TButton;
      btnImportGedCom: TBitBtn;
      BtnLoadMapProviders: TSpeedButton;
      BtnPOITextFont: TButton;
      BtnSaveMapProviders: TSpeedButton;
      BtnSaveToFile: TButton;
      BtnSearch: TButton;
      btnSync: TBitBtn;
      CbDebugTiles: TCheckBox;
      cbxDistanceUnits: TComboBox;
      CbDoubleBuffer: TCheckBox;
      CbDrawingEngine: TComboBox;
      CbFoundLocations: TComboBox;
      CbLocations: TComboBox;
      CbMouseCoords: TGroupBox;
      cbPOITextBgColor: TColorBox;
      CbProviders: TComboBox;
      CbShowPOIImage: TCheckBox;
      CbUseThreads: TCheckBox;
        DataSource1: TDataSource;
        DBEdit1: TDBEdit;
        DBGrid1: TDBGrid;
        DBNavigator1: TDBNavigator;
        Edit1: TEdit;
        GbCenterCoords: TGroupBox;
        GbScreenSize: TGroupBox;
        GbSearch: TGroupBox;
        GeoNames: TMVGeoNames;
        IdleTimer1: TIdleTimer;
        InfoCenterLatitude: TLabel;
        InfoCenterLongitude: TLabel;
        InfoPositionLatitude: TLabel;
        InfoPositionLongitude: TLabel;
        InfoViewportHeight: TLabel;
        InfoViewportWidth: TLabel;
        Label1: TLabel;
        LblCenterLatitude: TLabel;
        LblCenterLongitude: TLabel;
        LblPOITextBgColor: TLabel;
        LblPositionLatitude: TLabel;
        LblPositionLongitude: TLabel;
        LblProviders: TLabel;
        LblSelectLocation: TLabel;
        LblViewportHeight: TLabel;
        LblViewportWidth: TLabel;
        LblZoom: TLabel;
        MapView: TMapView;
        OpenDialog1: TOpenDialog;
        PageControl: TPageControl;
        Panel1: TPanel;
        Panel2: TPanel;
        PgConfig: TTabSheet;
        PgData: TTabSheet;
        pnlLeft: TPanel;
        PgGedCom: TTabSheet;
        ProgressBar1: TProgressBar;
        VisualHTTPClient1: TVisualHTTPClient;
        ZoomTrackBar: TTrackBar;
        procedure btnImportGedComClick(Sender: TObject);
        procedure btnSyncClick(Sender: TObject);
        procedure Edit1Change(Sender: TObject);
        procedure IdleTimer1Timer(Sender: TObject);
        procedure DataSource1DataChange(Sender: TObject; Field: TField);

        procedure BtnGoToClick(Sender: TObject);
        procedure BtnSearchClick(Sender: TObject);
        procedure cbxDistanceUnitsChange(Sender: TObject);
        procedure CbFoundLocationsDrawItem(Control: TWinControl;
          Index: Integer; ARect: TRect; State: TOwnerDrawState);
        procedure GeoNamesNameFound(const AName: string; const ADescr: String;
          const ALoc: TRealPoint);
        procedure MapView1Change(Sender: TObject);
        procedure MapView1MouseLeave(Sender: TObject);
        procedure MapView1MouseMove(Sender: TObject; Shift: TShiftState; X,
          Y: Integer);
        procedure MapView1MouseUp(Sender: TObject; Button: TMouseButton;
          Shift: TShiftState; X, Y: Integer);
        procedure MapView1ZoomChange(Sender: TObject);
        procedure ZoomTrackBarChange(Sender: TObject);
     {--- config ---}
        procedure CbDrawingEngineChange(Sender: TObject);
        procedure cbPOITextBgColorChange(Sender: TObject);
        procedure CbProvidersChange(Sender: TObject);
        procedure CbDoubleBufferChange(Sender: TObject);
        procedure CbUseThreadsChange(Sender: TObject);
    private
      FRGBGraphicsDrawingEngine: TMvCustomDrawingEngine;
      procedure ClearFoundLocations;
      procedure DoLocatePlace(Data: PtrInt);
      procedure UpdateCoords(X, Y: Integer);
      procedure UpdateDropdownWidth(ACombobox: TCombobox);
      procedure UpdateViewportSize;

    public
      constructor Create(TheOwner: TComponent); override;
    end;

implementation

 uses LCLType, LazUTF8 ,graphics, mvEngine, mvDE_BGRA, Cls_GedComExt ;

 {$R *.lfm}

 type
  TLocationParam = class
    Descr: String;
    Loc: TRealPoint;
  end;

const
 // MAX_LOCATIONS_HISTORY = 50;
     USE_DMS = true;

  DistanceUnit_Names: array[TDistanceUnits] of string = ('m', 'km', 'miles');

var
  DistanceUnit: TDistanceUnits = duKilometers;

{ TFraPlaceEdit }


procedure TFraPlaceEdit.IdleTimer1Timer(Sender: TObject);
var s:String;
  pt: TRealPoint;
  du: TDistanceUnits;
  PointFormatSettings: TFormatSettings;

begin
    IdleTimer1.Enabled := not assigned(dmRNZAnzeigen);
    if assigned(dmRNZAnzeigen)  then
      begin
        dmRNZAnzeigen.qryTableOrte.Active := dmRNZAnzeigen.sqlconMySQL57Connection1.Connected;

       PointFormatSettings.DecimalSeparator := '.';
       ForceDirectories(dmRNZAnzeigen.cDataBasePath+DirectorySeparator + 'cache');
      MapView.CachePath := dmRNZAnzeigen.cDataBasePath+DirectorySeparator + 'cache'+DirectorySeparator;
      MapView.GetMapProviders(CbProviders.Items);
      CbProviders.ItemIndex := CbProviders.Items.Indexof(MapView.MapProvider);
      MapView.DoubleBuffered := true;
      MapView.Zoom := 1;
      CbUseThreads.Checked := MapView.UseThreads;
      CbDoubleBuffer.Checked := MapView.DoubleBuffered;
      CbPOITextBgColor.Selected := MapView.POITextBgColor;

      InfoPositionLongitude.Caption := '';
      InfoPositionLatitude.Caption := '';
      InfoCenterLongitude.Caption := '';
      InfoCenterLatitude.Caption := '';
      InfoViewportWidth.Caption := '';
      InfoViewportHeight.Caption := '';

        s := dmRNZAnzeigen.getConfigValue('MapView', 'Provider', MapView.MapProvider);
        if CbProviders.Items.IndexOf(s) = -1 then begin
          MessageDlg('Map provider "' + s + '" not found.', mtError, [mbOK], 0);
          s := CbProviders.Items[0];
        end;
        MapView.MapProvider := s;
        CbProviders.Text := MapView.MapProvider;

        MapView.Zoom := dmRNZAnzeigen.getConfigValue('MapView', 'Zoom', MapView.Zoom);
        pt.Lon := StrToFloatDef(dmRNZAnzeigen.getConfigValue('MapView', 'Center.Longitude', ''), 0.0, PointFormatSettings);
        pt.Lat := StrToFloatDef(dmRNZAnzeigen.getConfigValue('MapView', 'Center.Latitude', ''), 0.0, PointFormatSettings);
        MapView.Center := pt;
        MapView.Active:=true;
        s := dmRNZAnzeigen.getConfigValue('MapView', 'DistanceUnits', '');
        if s <> '' then begin
          for du in TDistanceUnits do
            if DistanceUnit_Names[du] = s then begin
              DistanceUnit := du;
              cbxDistanceUnits.ItemIndex := ord(du);
              break;
            end;
        end;
      end;
end;

procedure TFraPlaceEdit.DataSource1DataChange(Sender: TObject; Field: TField);
var
  lLong, lLati: String;
  lpnt:TRealPoint;
  lfs: TFormatSettings;
begin
  if DataSource1.DataSet.State = dsBrowse then
    begin
      CbLocations.Text:=DataSource1.DataSet.FieldByName('Ortname').AsString;
      lLong := DataSource1.DataSet.FieldByName(rsOrteLongitude).AsString;
      lLati := DataSource1.DataSet.FieldByName(rsOrteLatitude).AsString;
      if (lLong<>'') and (lLati<>'') then
        begin
          lfs.DecimalSeparator:=',';
          if TryStrToFloat(copy(lLati,2),lpnt.lat,lfs) and
             TryStrToFloat(copy(lLong,2),lpnt.Lon,lfs) then
               begin
                 if lLati[1]='S' then lpnt.lat:=-lpnt.lat;
                 if lLong[1]='W' then lpnt.Lon:=-lpnt.Lon;
                 // Show location in center of mapview
                   MapView.Zoom := 12;
                   MapView.Center := lpnt;
                   MapView.Invalidate;
               end
        end
//      MapView1;
    end;
end;

procedure TFraPlaceEdit.BtnGoToClick(Sender: TObject);
var
  s: String;
  P: TLocationParam;
begin
  if CbFoundLocations.ItemIndex = -1 then
    exit;

  // Extract parameters of found locations. We need that to get the coordinates.
  s := CbFoundLocations.Items.Strings[CbFoundLocations.ItemIndex];
  P := TLocationParam(CbFoundLocations.Items.Objects[CbFoundLocations.ItemIndex]);
  if P = nil then
    exit;
  CbFoundLocations.Text := s;

  // Show location in center of mapview
  MapView.Zoom := 12;
  MapView.Center := P.Loc;
  MapView.Invalidate;
end;

procedure TFraPlaceEdit.BtnSearchClick(Sender: TObject);
begin
  ClearFoundLocations;
  GeoNames.Search(CbLocations.Text, MapView.DownloadEngine);
  UpdateDropdownWidth(CbFoundLocations);
//  UpdateLocationHistory(CbLocations.Text);
  if CbFoundLocations.Items.Count > 0 then CbFoundLocations.ItemIndex := 0;
end;


procedure TFraPlaceEdit.cbxDistanceUnitsChange(Sender: TObject);
begin
  DistanceUnit := TDistanceUnits(cbxDistanceUnits.ItemIndex);
  UpdateViewPortSize;
end;

procedure TFraPlaceEdit.CbFoundLocationsDrawItem(Control: TWinControl;
  Index: Integer; ARect: TRect; State: TOwnerDrawState);
var
  s: String;
  P: TLocationParam;
  combo: TCombobox;
  x, y: Integer;
begin
  combo := TCombobox(Control);
  if (State * [odSelected, odFocused] <> []) then begin
    combo.Canvas.Brush.Color := clHighlight;
    combo.Canvas.Font.Color := clHighlightText;
  end else begin
    combo.Canvas.Brush.Color := clWindow;
    combo.Canvas.Font.Color := clWindowText;
  end;
  combo.Canvas.FillRect(ARect);
  combo.Canvas.Brush.Style := bsClear;
  s := combo.Items.Strings[Index];
  P := TLocationParam(combo.Items.Objects[Index]);
  x := ARect.Left + 2;
  y := ARect.Top + 2;
  combo.Canvas.Font.Style := [fsBold];
  combo.Canvas.TextOut(x, y, s);
  inc(y, combo.Canvas.TextHeight('Tg'));
  combo.Canvas.Font.Style := [];
  combo.Canvas.TextOut(x, y, P.Descr);
end;

procedure TFraPlaceEdit.GeoNamesNameFound(const AName: string;
  const ADescr: String; const ALoc: TRealPoint);
var
  P: TLocationParam;
begin
  P := TLocationParam.Create;
  P.Descr := ADescr;
  P.Loc := ALoc;
  CbFoundLocations.Items.AddObject(AName, P);
end;

procedure TFraPlaceEdit.MapView1Change(Sender: TObject);
begin
  UpdateViewportSize;
end;

procedure TFraPlaceEdit.MapView1MouseLeave(Sender: TObject);
begin
  UpdateCoords(MaxInt, MaxInt);
end;

procedure TFraPlaceEdit.MapView1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
const
  DELTA = 3;
var
  rArea: TRealArea;
 // gpsList: TGpsObjList;
begin
  UpdateCoords(X, Y);

  rArea.TopLeft := MapView.ScreenToLonLat(Point(X-DELTA, Y-DELTA));
  rArea.BottomRight := MapView.ScreenToLonLat(Point(X+DELTA, Y+DELTA));

end;

procedure TFraPlaceEdit.MapView1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Nothing to do
end;

procedure TFraPlaceEdit.MapView1ZoomChange(Sender: TObject);
begin
  ZoomTrackbar.Position := MapView.Zoom;
end;

procedure TFraPlaceEdit.ZoomTrackBarChange(Sender: TObject);
begin
  MapView.Zoom := ZoomTrackBar.Position;
  LblZoom.Caption := Format('Zoom (%d):', [ZoomTrackbar.Position]);
end;

procedure TFraPlaceEdit.CbDrawingEngineChange(Sender: TObject);
begin
  case CbDrawingEngine.ItemIndex of
    0: MapView.DrawingEngine := nil;
    1: begin
         if FRGBGraphicsDrawingEngine = nil then
           FRGBGraphicsDrawingEngine := TMvBGRADrawingEngine.Create(self);
         MapView.DrawingEngine := FRGBGraphicsDrawingEngine;
       end;
  end;
end;

procedure TFraPlaceEdit.cbPOITextBgColorChange(Sender: TObject);
begin
  MapView.POITextBgColor := cbPOITextBgColor.Selected;
end;

procedure TFraPlaceEdit.CbProvidersChange(Sender: TObject);
begin
  MapView.MapProvider := CbProviders.Text;
end;

procedure TFraPlaceEdit.CbDoubleBufferChange(Sender: TObject);
begin
   MapView.DoubleBuffered:=CbDoubleBuffer.Checked;
end;

procedure TFraPlaceEdit.CbUseThreadsChange(Sender: TObject);
begin
  MapView.UseThreads:=CbUseThreads.Checked;
end;

procedure TFraPlaceEdit.ClearFoundLocations;
var
  i: Integer;
  P: TLocationParam;
begin
  for i:=0 to CbFoundLocations.Items.Count-1 do begin
    P := TLocationParam(CbFoundLocations.Items.Objects[i]);
    P.Free;
  end;
  CbFoundLocations.Items.Clear;
end;

procedure TFraPlaceEdit.DoLocatePlace(Data: PtrInt);
begin
  if not DataSource1.DataSet.Locate(rsOrteName, edit1.Text,[loPartialKey,loCaseInsensitive]) then
    DataSource1.DataSet.Locate(rsOrteName, winCPtoutf8(edit1.Text),[loPartialKey,loCaseInsensitive]);

end;

procedure TFraPlaceEdit.UpdateCoords(X, Y: Integer);
var
  rPt: TRealPoint;
begin
  rPt := MapView.Center;
  InfoCenterLongitude.Caption := LonToStr(rPt.Lon, USE_DMS);
  InfoCenterLatitude.Caption := LatToStr(rPt.Lat, USE_DMS);

  if (X <> MaxInt) and (Y <> MaxInt) then begin
    rPt := MapView.ScreenToLonLat(Point(X, Y));
    InfoPositionLongitude.Caption := LonToStr(rPt.Lon, USE_DMS);
    InfoPositionLatitude.Caption := LatToStr(rPt.Lat, USE_DMS);
  end else begin
    InfoPositionLongitude.Caption := '-';
    InfoPositionLatitude.Caption := '-';
  end;
end;

procedure TFraPlaceEdit.UpdateDropdownWidth(ACombobox: TCombobox);
begin

end;

procedure TFraPlaceEdit.UpdateViewportSize;
begin
  InfoViewportWidth.Caption := Format('%.2n %s', [
    CalcGeoDistance(
      MapView.GetVisibleArea.TopLeft.Lat,
      MapView.GetVisibleArea.TopLeft.Lon,
      MapView.GetVisibleArea.TopLeft.Lat,
      MapView.GetVisibleArea.BottomRight.Lon,
      DistanceUnit
    ),
    DistanceUnit_Names[DistanceUnit]
  ]);
  InfoViewportHeight.Caption := Format('%.2n %s', [
    CalcGeoDistance(
      MapView.GetVisibleArea.TopLeft.Lat,
      MapView.GetVisibleArea.TopLeft.Lon,
      MapView.GetVisibleArea.BottomRight.Lat,
      MapView.GetVisibleArea.TopLeft.Lon,
      DistanceUnit
    ),
    DistanceUnit_Names[DistanceUnit]
  ]);
end;

constructor TFraPlaceEdit.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
end;


procedure TFraPlaceEdit.btnImportGedComClick(Sender: TObject);
var
    lActChild, lReffn, lDeath: TGedComObj;
    FReffn, Fplace: string;
    lDataSet: TDataSet;
    lplace: TGedPlace;
    lTime: QWord;
begin
    OpenDialog1.FileName := '*.ged';
    if OpenDialog1.Execute then
      try
        btnImportGedCom.Enabled:=false;
        lDataSet := DataSource1.DataSet;
        DataSource1.DataSet:=nil;
        dmRNZAnzeigen.OpenGedcomFile(OpenDialog1.FileName);
        lTime:=GetTickCount64;
        ProgressBar1.Max:=dmRNZAnzeigen.GedComFile.Count-1;
        // Iterate Through Individuals
        for lActChild in dmRNZAnzeigen.GedComFile do
          begin
            FReffn := '';
            Fplace := '';
            if lActChild.NodeType = 'INDI' then
                begin
                  lReffn:=lActChild.Find('REFN');
                  if assigned(lReffn) then
                      FReffn := lReffn.Data;
                  lDeath:=TGedIndividual(lActChild).Death;
                  if assigned(lDeath) then
                    begin
                      lplace:=TGedEvent(lDeath).Place;
                      if assigned(lplace) then
                        Fplace := lplace.Data;
                    end
                end;
            if (FReffn <> '') and (length(Fplace)>10) then
              dmRNZAnzeigen.UpdateLongPlaceName( FReffn,lplace);
            if (GetTickCount64- lTime)> 200 then
              begin
                ProgressBar1.Position:=lActChild.ID;
                Application.ProcessMessages;
                lTime:=GetTickCount64;
              end
          end;
      finally
        btnImportGedCom.Enabled:=true;
        DataSource1.DataSet := lDataSet;
      end;
    DataSource1.DataSet.Refresh;
end;

procedure TFraPlaceEdit.btnSyncClick(Sender: TObject);
begin
  dmRNZAnzeigen.SyncUpdatePlaces;
end;

procedure TFraPlaceEdit.Edit1Change(Sender: TObject);
begin
  Application.QueueAsyncCall(DoLocatePlace,0);
end;

end.

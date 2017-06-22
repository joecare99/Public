unit ucaldata;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, StdCtrls, Spin, Contnrs;

type Tcalevent = class(TObject)
  id: AnsiString;
  gid: AnsiString;
  title: AnsiString;
  location: AnsiString;
  description: AnsiString;
  category: AnsiString;
  start: TDateTime;
  finish: TDateTime;
  entrytype: Integer;
  remtype: Integer;
  remtime: TDateTime;
  end;
type

  { TFcaldata }

  TFcaldata = class(TForm)
    ButtonOkay: TButton;
    ButtonCancel: TButton;
    EditRepeatDate: TDateTimePicker;
    EditRepeatEnd: TComboBox;
    EditRepeatType: TComboBox;
    EditCategory: TComboBox;
    EditCategoryColor: TButton;
    EditConnected: TCheckBox;
    EditDescription: TMemo;
    EditFinishDate: TDateTimePicker;
    EditFinishTime: TDateTimePicker;
    EditFullDays: TCheckBox;
    EditLocation: TEdit;
    EditRemind: TComboBox;
    EditRemindDate: TDateTimePicker;
    EditRemindTime: TDateTimePicker;
    EditStartDate: TDateTimePicker;
    EditStartTime: TDateTimePicker;
    DialogCategoryColor: TColorDialog;
    EditTitle: TEdit;
    EditType: TComboBox;
    LabelCategory: TLabel;
    LabelDescription: TLabel;
    LabelFinish: TLabel;
    LabelFinishTime: TLabel;
    LabelFullDays: TLabel;
    LabelLocation: TLabel;
    LabelRepeat: TLabel;
    LabelRemindTime: TLabel;
    LabelStart: TLabel;
    LabelStartTime: TLabel;
    LabelRemind: TLabel;
    EditRepeatRhythm: TSpinEdit;
    EditRepeatNumber: TSpinEdit;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOkayClick(Sender: TObject);
    procedure EditCategoryChange(Sender: TObject);
    procedure EditCategoryColorClick(Sender: TObject);
    procedure EditConnectedChange(Sender: TObject);
    procedure EditFinishDateChange(Sender: TObject);
    procedure EditFinishTimeChange(Sender: TObject);
    procedure EditFullDaysChange(Sender: TObject);
    procedure EditRemindChange(Sender: TObject);
    procedure EditRepeatEndChange(Sender: TObject);
    procedure EditRepeatTypeChange(Sender: TObject);
    procedure EditStartDateChange(Sender: TObject);
    procedure EditStartTimeChange(Sender: TObject);
    procedure EditTypeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    currentevent: Integer;
    duration: Double;
    filename: String;
    eventlist: TObjectList;
    calendarfile: TStringList;
    categories: TStringlist; //key-value category=color
    procedure Importdata();
    procedure Exportdata();
    procedure DelRepeatedEvents();
  public
    { public declarations }
    procedure LoadFile();
    procedure SaveFile();
    procedure EditEventData(eventnumber: Integer);
    procedure AddEventData(EventDate: TDateTime);
    function  CountEvents: Integer;
  end;

var
  Fcaldata: TFcaldata;

implementation

{$R *.lfm}

procedure TFcaldata.FormCreate(Sender: TObject);
begin
  // ToDo: Make a more senseful filename
  filename := ExtractFilePath(Application.ExeName)+'mycalendar.cal';
  calendarfile := TStringList.Create;
  // key-value for categories
  categories:= TStringlist.Create;
  categories.Duplicates:=dupIgnore;
  //categories.Sorted:=true;
  eventlist := TObjectList.Create;
  eventlist.OwnsObjects := true;  //destroys items automatically
  currentevent := -1;
  self.LoadFile();
end;

procedure TFcaldata.FormShow(Sender: TObject);
begin
  EditTitle.SetFocus;
end;

procedure TFcaldata.ButtonOkayClick(Sender: TObject);
var
  memoline, repeatmax, repeatcurrent, count: Integer;
  repeatmaxdate, repeatcurrentdate, repeattime: TDateTime;
  repeatyear, repeatmonth, repeatday, repeatdayofmonth: Word;
  realstring: AnsiString;
begin
  //add calender event if needed
  if currentevent = -1 then
  begin
    eventlist.Add(Tcalevent.create());
    currentevent:=eventlist.Count-1;
    //Tcalevent(eventlist[currentevent]).id := DateTimeToStr(Now);
    Str(Now,realstring);
    Tcalevent(eventlist[currentevent]).id := realstring;
  end;
  // write new data into eventlist
  // write TColor and add color to categories if needed
  Tcalevent(eventlist[currentevent]).category := EditCategory.Text;
  if EditCategory.Text <>'' then
    begin
      // add category to list
      if categories.IndexOfName(EditCategory.Text) = -1 then
        categories.Add(EditCategory.Text + '=' + ColorToString(EditCategoryColor.Color))
      else
        categories.Values[EditCategory.Text]:=ColorToString(EditCategoryColor.Color);
      categories.Sort;
    end;
  Tcalevent(eventlist[currentevent]).title := EditTitle.Caption;
  Tcalevent(eventlist[currentevent]).location := EditLocation.Caption;
  Tcalevent(eventlist[currentevent]).finish:=EditFinishDate.Date + EditFinishTime.Time;
  Tcalevent(eventlist[currentevent]).description:=EditDescription.Lines[0];
  memoline:=0;
  while memoline < (EditDescription.Lines.Count-1) do
  begin
    memoline := memoline + 1;
    Tcalevent(eventlist[currentevent]).description:=Tcalevent(eventlist[currentevent]).description + ' ' + EditDescription.Lines[memoline];
  end;
  //check for event or todo
  if EditType.ItemIndex = 1 then
    begin  // todo
      Tcalevent(eventlist[currentevent]).entrytype:=1;
      Tcalevent(eventlist[currentevent]).start:=0;
    end
  else
    begin  // event
      Tcalevent(eventlist[currentevent]).entrytype:=0;
      Tcalevent(eventlist[currentevent]).start:=EditStartDate.Date + EditStartTime.Time;
    end;
    Tcalevent(eventlist[currentevent]).remtype:=EditRemind.ItemIndex;
    Tcalevent(eventlist[currentevent]).remtime:=EditRemindDate.Date+EditRemindTime.Time;
  // repeat event if wanted
  If EditRepeatType.ItemIndex>0 then
    begin
      // set gid=id (delete repeat counter from id)
      if Tcalevent(eventlist[currentevent]).gid='' then
        Tcalevent(eventlist[currentevent]).gid:=Tcalevent(eventlist[currentevent]).id
      else
        Tcalevent(eventlist[currentevent]).id:=Tcalevent(eventlist[currentevent]).gid;
      DelRepeatedEvents(); // delete all grouped events except of this one
      repeatcurrent:=0;
      repeatmax:=EditRepeatNumber.Value;
      repeatcurrentdate:=Tcalevent(eventlist[currentevent]).start;
      repeatmaxdate:=EditRepeatDate.Date;
      If EditRepeatEnd.ItemIndex=0 then
        repeatmax:=-1
      else
        repeatmaxdate:=EncodeDate(2200,12,31);
      // save day of month for monthly repeat and time
      DecodeDate(repeatcurrentdate,repeatyear,repeatmonth,repeatdayofmonth);
      repeattime:=Tcalevent(eventlist[currentevent]).start-int(repeatcurrentdate);
      repeat
        case EditRepeatType.ItemIndex of
        1: repeatcurrentdate:=repeatcurrentdate+EditRepeatRhythm.Value; // days
        2: for count:=1 to EditRepeatRhythm.Value do // working days
             if DayOfWeek(repeatcurrentdate) = 6 then
               repeatcurrentdate:=repeatcurrentdate+3
             else
               repeatcurrentdate:=repeatcurrentdate+1;
        3: repeatcurrentdate:=repeatcurrentdate+7*EditRepeatRhythm.Value; // weeks
        4: begin // months
             DecodeDate(repeatcurrentdate,repeatyear,repeatmonth,repeatday);
             inc(repeatmonth,EditRepeatRhythm.Value);
             while repeatmonth>11 do
               begin
                 inc(repeatyear);
                 dec(repeatmonth,12);
               end;
             try
               repeatcurrentdate:=EncodeDate(repeatyear,repeatmonth,repeatdayofmonth)+repeattime;
             except
             // catch illegal dates, e.g. 2000-02-31
               begin
                 inc(repeatmonth);
                 if repeatmonth=12 then
                   begin
                     inc(repeatyear);
                     dec(repeatmonth,12);
                   end;
                 repeatcurrentdate:=EncodeDate(repeatyear,repeatmonth,1)-1+repeattime;
               end;
             end;
           end;
        5: begin // years
             DecodeDate(repeatcurrentdate,repeatyear,repeatmonth,repeatday);
             inc(repeatyear,EditRepeatRhythm.Value);
             repeatcurrentdate:=EncodeDate(repeatyear,repeatmonth,repeatday)+repeattime;
            end;
        end;
        inc(repeatcurrent);
        if not (repeatcurrentdate>repeatmaxdate) then
          begin
            eventlist.Add(Tcalevent.create());
            Str(repeatcurrent,realstring);
            Tcalevent(eventlist.Last).id:=Tcalevent(eventlist[currentevent]).id + '-' + realstring;
            Tcalevent(eventlist.Last).gid:=Tcalevent(eventlist[currentevent]).gid;
            Tcalevent(eventlist.Last).title:=Tcalevent(eventlist[currentevent]).title;
            Tcalevent(eventlist.Last).location:=Tcalevent(eventlist[currentevent]).location;
            Tcalevent(eventlist.Last).description:=Tcalevent(eventlist[currentevent]).description;
            Tcalevent(eventlist.Last).category:=Tcalevent(eventlist[currentevent]).category;
            Tcalevent(eventlist.Last).start:=repeatcurrentdate;
            Tcalevent(eventlist.Last).finish:=repeatcurrentdate+duration;
            Tcalevent(eventlist.Last).entrytype:=Tcalevent(eventlist[currentevent]).entrytype;
            Tcalevent(eventlist.Last).remtype:=Tcalevent(eventlist[currentevent]).remtype;
            // #todo correct remtime (no remind?)
            Tcalevent(eventlist.Last).remtime:=repeatcurrentdate-(Tcalevent(eventlist[currentevent]).start-Tcalevent(eventlist[currentevent]).remtime);
          end;
      until (repeatcurrentdate>repeatmaxdate) or (repeatcurrent=repeatmax)
    end;
  self.close;
end;

procedure TFcaldata.EditCategoryChange(Sender: TObject);
begin
  if EditCategory.Text = '' then
    begin
      EditCategoryColor.Color:=clDefault;
      EditCategoryColor.Enabled:=false
    end
  else
    begin
      if categories.IndexOfName(EditCategory.Text) = -1 then
        EditCategoryColor.Color:=clWhite
      else
        EditCategoryColor.Color:=StringToColor(categories.Values[EditCategory.Text]);
      EditCategoryColor.Enabled:=true;
    end
end;

procedure TFcaldata.EditCategoryColorClick(Sender: TObject);
begin
   DialogCategoryColor.Color:=EditCategoryColor.Color;
   if DialogCategoryColor.Execute then
     EditCategoryColor.Color:=DialogCategoryColor.Color;
end;

procedure TFcaldata.EditConnectedChange(Sender: TObject);
begin
  if EditConnected.Checked = true then
    EditConnected.Caption:='Verbunden'
  else
    EditConnected.Caption:='Nicht verbunden';
end;

procedure TFcaldata.EditFinishDateChange(Sender: TObject);
var
  movedatetime: TDateTime;
begin
  if EditConnected.Checked = true then
    begin
      movedatetime:= EditFinishDate.Date + EditFinishTime.Time - duration;
      EditStartDate.Date:=Int(movedatetime);
      EditStartTime.Time:=movedatetime-Int(movedatetime);
    end
  else
    duration:=EditFinishDate.Date+EditFinishTime.Time-EditStartDate.Date-EditStartTime.Time;
end;

procedure TFcaldata.EditFinishTimeChange(Sender: TObject);
var
  movedatetime: TDateTime;
begin
  if EditConnected.Checked = true then
    begin
      movedatetime:= EditFinishDate.Date + EditFinishTime.Time - duration;
      EditStartDate.Date:=Int(movedatetime);
      EditStartTime.Time:=movedatetime-Int(movedatetime);
    end
  else
    duration:=EditFinishDate.Date+EditFinishTime.Time-EditStartDate.Date-EditStartTime.Time;
end;

procedure TFcaldata.EditFullDaysChange(Sender: TObject);
begin
  if EditFullDays.Checked=true then
    begin
      EditStartTime.Enabled:=false;
      EditStartTime.DateTime:=0;
      LabelStartTime.Enabled:=false;
      EditFinishTime.Enabled:=false;
      EditFinishTime.DateTime:=0;
      LabelFinishTime.Enabled:=false;
    end
  else
    begin
      if EditType.ItemIndex=0 then
        begin
          EditStartTime.Enabled:=true;
          EditStartTime.DateTime:=0.5;
          LabelStartTime.Enabled:=true;
        end;
      EditFinishTime.Enabled:=true;
      EditFinishTime.DateTime:=0.5;
      LabelFinishTime.Enabled:=true;
    end;
    duration:=EditFinishDate.Date-EditStartDate.Date;
end;

procedure TFcaldata.EditRemindChange(Sender: TObject);
var
  RemindDateTime: TDateTime;
  StartDateTime: TDateTime;
begin
  StartDateTime:=EditStartDate.Date+EditStartTime.Time;
  if EditRemind.ItemIndex=0 then
    begin
      EditRemindDate.Visible:=false;
      EditRemindTime.Visible:=false;
      LabelRemindTime.Visible:=false;
      RemindDateTime:=0;
    end
  else
    begin
      EditRemindDate.Visible:=true;
      EditRemindTime.Visible:=true;
      LabelRemindTime.Visible:=true;
    end;
  if EditRemind.ItemIndex=1 then
    begin
      EditRemindDate.Enabled:=true;
      EditRemindTime.Enabled:=true;
      RemindDateTime:=EditRemindDate.Date+EditRemindTime.Time;
      If RemindDateTime=0 then
        RemindDateTime:=StartDateTime;
    end
  else
    begin
      EditRemindDate.Enabled:=false;
      EditRemindTime.Enabled:=false;
    end;
  // calculate RemindDateTime and store it
  case EditRemind.ItemIndex of
    2:RemindDateTime:=StartDateTime;
    3:RemindDateTime:=StartDateTime-EncodeTime(0,5,0,0);
    4:RemindDateTime:=StartDateTime-EncodeTime(0,15,0,0);
    5:RemindDateTime:=StartDateTime-EncodeTime(0,30,0,0);
    6:RemindDateTime:=StartDateTime-EncodeTime(1,0,0,0);
    7:RemindDateTime:=StartDateTime-EncodeTime(2,0,0,0);
    8:RemindDateTime:=StartDateTime-EncodeTime(12,0,0,0);
    9:RemindDateTime:=StartDateTime-1;
    10:RemindDateTime:=StartDateTime-2;
    11:RemindDateTime:=StartDateTime-7;
  end;
  EditRemindDate.Date:=Int(RemindDateTime);
  EditRemindTime.Time:=RemindDateTime-Int(RemindDateTime);
end;

procedure TFcaldata.EditRepeatEndChange(Sender: TObject);
begin
  if EditRepeatEnd.Text='bis' then
    begin
      EditRepeatDate.Enabled:=true;
      EditRepeatDate.Visible:=true;
      EditRepeatNumber.Enabled:=false;
      EditRepeatNumber.Visible:=false;
    end
  else
    begin
      EditRepeatDate.Enabled:=false;
      EditRepeatDate.Visible:=false;
      EditRepeatNumber.Enabled:=true;
      EditRepeatNumber.Visible:=true;
    end;
end;

procedure TFcaldata.EditRepeatTypeChange(Sender: TObject);
begin
  if EditRepeatType.ItemIndex=0 then
    begin
      EditRepeatRhythm.Value:=0;
      EditRepeatRhythm.Enabled:=false;
      EditRepeatEnd.Enabled:=false;
      EditRepeatEnd.Visible:=false;
      EditRepeatDate.Enabled:=false;
      EditRepeatDate.Visible:=false;
      EditRepeatNumber.Enabled:=false;
      EditRepeatNumber.Visible:=false;
    end
  else
    begin
      if EditRepeatRhythm.Value=0 then
        EditRepeatRhythm.Value:=1;
      EditRepeatRhythm.Enabled:=true;
      EditRepeatEnd.Enabled:=true;
      EditRepeatEnd.Visible:=true;
      if EditRepeatEnd.Text='bis' then
        begin
          EditRepeatDate.Enabled:=true;
          EditRepeatDate.Visible:=true;
          EditRepeatNumber.Enabled:=false;
          EditRepeatNumber.Visible:=false;
        end
      else
        begin
          EditRepeatDate.Enabled:=false;
          EditRepeatDate.Visible:=false;
          EditRepeatNumber.Enabled:=true;
          EditRepeatNumber.Visible:=true;
        end;
    end;
end;

procedure TFcaldata.EditStartDateChange(Sender: TObject);
var
  movedatetime: TDateTime;
begin
  if EditConnected.Checked = true then
    begin
      movedatetime:= EditStartDate.Date + EditStartTime.Time + duration;
      EditFinishDate.Date:=Int(movedatetime);
      EditFinishTime.Time:=movedatetime-Int(movedatetime);
    end
  else
    duration:=EditFinishDate.Date+EditFinishTime.Time-EditStartDate.Date-EditStartTime.Time;
end;

procedure TFcaldata.EditStartTimeChange(Sender: TObject);
var
  movedatetime: TDateTime;
begin
  if EditConnected.Checked = true then
    begin
      movedatetime:= EditStartDate.Date + EditStartTime.Time + duration;
      EditFinishDate.Date:=Int(movedatetime);
      EditFinishTime.Time:=movedatetime-Int(movedatetime);
    end
  else
    duration:=EditFinishDate.Date+EditFinishTime.Time-EditStartDate.Date-EditStartTime.Time;
end;

procedure TFcaldata.EditTypeChange(Sender: TObject);
begin
   if EditType.ItemIndex = 1 then
     begin
       // activate todo
       EditStartDate.Enabled:=false;
       EditStartDate.DateTime:=Date;
       EditConnected.Enabled:=false;
       EditStartTime.Enabled:=false;
       LabelStart.Enabled:=false;
       LabelStartTime.Enabled:=false;
       EditRepeatType.ItemIndex:=0;
       EditRepeatType.Enabled:=false;
       // #todo Why is this needed?
       EditRepeatTypeChange(nil);
     end
   else
     begin
       // activate event
       EditStartDate.Enabled:=true;
       EditStartDate.DateTime:=Date;
       EditConnected.Enabled:=true;
       LabelStart.Enabled:=true;
       if EditFullDays.Checked = false then
         begin
           EditStartTime.Enabled:=true;
           LabelStartTime.Enabled:=true;
         end;
       EditRepeatType.ItemIndex:=0;
       EditRepeatType.Enabled:=true;
       EditRepeatTypeChange(nil);  // Why is this needed?
     end;

end;

procedure TFcaldata.ButtonCancelClick(Sender: TObject);
begin
  self.close;
end;

procedure TFcaldata.LoadFile();
begin
   if FileExists(filename) then
     begin
       calendarfile.LoadFromFile(filename);
       self.Importdata();
     end
   else
     ShowMessage('Neuer Kalender angelegt!');
end;

procedure TFcaldata.SaveFile();
begin
   Exportdata();
   calendarfile.SaveToFile(filename);
end;

procedure TFcaldata.Importdata();
var
  linenumber,return : Integer;
  line : String;
begin
  linenumber := 0;
  while linenumber < calendarfile.Count do
  begin
    line := calendarfile[linenumber];
    case copy(line,1,8) of
    // id: TDateTime;
    'NEWEVEN:' :
      begin
        eventlist.Add(Tcalevent.create());
        Tcalevent(eventlist.Last).id:=copy(line,9);
      end;
    // gid: TDateTime;
    'GROUPID:' :
      begin
        Tcalevent(eventlist.Last).gid:=copy(line,9);
      end;
    // name: String;
    'TITLEEV:' :
      begin
        Tcalevent(eventlist.Last).title := copy(line,9);
      end;
    // location: String;
    'LOCATIO:' :
      begin
        Tcalevent(eventlist.Last).location := copy(line,9);
      end;
    // description: String;
    'DESCRIP:' :
      begin
        Tcalevent(eventlist.Last).description := copy(line,9);
      end;
    // category: String;
    'CATEGOR:' :
      begin
        Tcalevent(eventlist.Last).category := copy(line,9);
      end;
    // category: String;
    'CACOLOR:' :
      begin
        // add category to list
        if categories.IndexOfName(Tcalevent(eventlist.Last).category) = -1 then
          begin
            categories.Add(Tcalevent(eventlist.Last).category + '=' + copy(line,9))
          end;
      end;
    // start: TDateTime;
    'STARTEV:' :
      begin
        Val(copy(line,9),Tcalevent(eventlist.Last).start,return);
      end;
    // finish: TDateTime;
    'FINISHE:' :
      begin
        Val(copy(line,9),Tcalevent(eventlist.Last).finish,return);
      end;
    // remtype: integer;
    'REMTYPE:' :
      begin
        Tcalevent(eventlist.Last).remtype := StrToInt(copy(line,9));
      end;
    // remtime: TDateTime;
    'REMTIME:' :
      begin
        Val(copy(line,9),Tcalevent(eventlist.Last).remtime,return);
      end;
    // entrytype: integer;
    'TYPE-EV:' :
      begin
        Tcalevent(eventlist.Last).entrytype := StrToInt(copy(line,9));
      end;
    end;
    linenumber := linenumber + 1;
  end;
  categories.Sort;
end;

procedure TFcaldata.Exportdata();
var
  count: Integer;
  realstring: String;
begin
   calendarfile.Clear;
   for count := 0 to (eventlist.Count - 1) do
   begin
     // #todo Remove debugging string
     calendarfile.Add('--------------------');
     calendarfile.Add('NEWEVEN:' + Tcalevent(eventlist.Items[count]).id);
     if not Tcalevent(eventlist.Items[count]).gid.IsEmpty then
       calendarfile.Add('GROUPID:' + Tcalevent(eventlist.Items[count]).gid);
     calendarfile.Add('TITLEEV:' + Tcalevent(eventlist.Items[count]).title);
     if not Tcalevent(eventlist.Items[count]).location.IsEmpty then
       calendarfile.Add('LOCATIO:' + Tcalevent(eventlist.Items[count]).location);
     if not Tcalevent(eventlist.Items[count]).description.IsEmpty then
       calendarfile.Add('DESCRIP:' + Tcalevent(eventlist.Items[count]).description);
     if not Tcalevent(eventlist.Items[count]).category.IsEmpty then
     begin
       calendarfile.Add('CATEGOR:' + Tcalevent(eventlist.Items[count]).category);
       calendarfile.Add('CACOLOR:' + categories.Values[Tcalevent(eventlist.Items[count]).category]);
     end;
     Str(Tcalevent(eventlist.Items[count]).start,realstring);
     calendarfile.Add('STARTEV:' + realstring);
     // #todo Remove debugging string 2
     calendarfile.Add('STARTDATUM:'+DateTimeToStr(Tcalevent(eventlist.Items[count]).start));
     Str(Tcalevent(eventlist.Items[count]).finish,realstring);
     calendarfile.Add('FINISHE:' + realstring);
     calendarfile.Add('TYPE-EV:' + IntToStr(Tcalevent(eventlist.Items[count]).entrytype));
     if Tcalevent(eventlist.Items[count]).remtype > 0 then
       begin
         calendarfile.Add('REMTYPE:' + IntToStr(Tcalevent(eventlist.Items[count]).remtype));
         Str(Tcalevent(eventlist.Items[count]).remtime,realstring);
         calendarfile.Add('REMTIME:' + realstring);
       end;
   end;
end;

procedure TFcaldata.EditEventData(eventnumber: Integer);
var
  itemcount: Integer;
begin
  currentevent := eventnumber;
  // Reset form
  Caption:='Eintrag editieren...';
  EditType.ItemIndex:= 0;
  EditCategory.ItemIndex:= -1;
  EditCategoryColor.Color:=clDefault;
  EditTitle.Caption:='';
  EditLocation.Caption:='';
  EditDescription.Clear;
  EditFullDays.Enabled:=true;
  EditFullDays.Checked:=false;
  EditStartDate.Enabled:=true;
  EditStartTime.Enabled:=true;
  EditFinishDate.Enabled:=true;
  EditFinishTime.Enabled:=true;
  EditStartDate.Date:=Date();
  EditStartTime.Time:=0.5;
  EditFinishDate.Date:=Date();
  EditFinishTime.Time:=0.5;
  duration := 0;
  EditConnected.Enabled:=true;
  EditConnected.Checked:=true;
  EditRemind.Enabled:=true;
  EditRemind.ItemIndex:=0;
  EditRemindDate.Enabled:=false;
  EditRemindDate.Visible:=false;
  EditRemindDate.DateTime:=0;
  EditRemindTime.Enabled:=false;
  EditRemindTime.Visible:=false;
  EditRemindTime.DateTime:=0;
  LabelRemindTime.Visible:=false;
  // Repeat
  EditRepeatRhythm.Value:=0;
  EditRepeatRhythm.Enabled:=false;
  EditRepeatType.ItemIndex:=0;
  EditRepeatEnd.Enabled:=false;
  EditRepeatEnd.Visible:=false;
  EditRepeatDate.Enabled:=false;
  EditRepeatDate.Visible:=false;
  EditRepeatNumber.Enabled:=false;
  EditRepeatNumber.Visible:=false;
  EditRepeatDate.Date:=Now;
  // Fill form with data
  EditCategory.Text:=Tcalevent(eventlist[currentevent]).category;
  if (EditCategory.Text <> '') and (categories.IndexOfName(EditCategory.Text) <>-1) then
    EditCategoryColor.Color:=StringToColor(categories.Values[EditCategory.Text])
  else
    EditCategoryColor.Enabled:=false;
  // fill category drop down
  EditCategory.Items.Clear;
  for itemcount :=0 to (categories.Count-1) do
    EditCategory.Items.Add(categories.Names[itemcount]);
  EditTitle.Caption:=Tcalevent(eventlist[currentevent]).title;
  EditLocation.Caption:=Tcalevent(eventlist[currentevent]).location;
  EditDescription.Text:=Tcalevent(eventlist[currentevent]).description;
  // Full days?
  if Tcalevent(eventlist[currentevent]).start = int(Tcalevent(eventlist[currentevent]).start) then
      if Tcalevent(eventlist[currentevent]).finish = int(Tcalevent(eventlist[currentevent]).finish) then
        begin
          EditFullDays.Checked:=true;
          // disable time elements for full days
          EditStartTime.Enabled:=false;
          EditFinishTime.Enabled:=false;
        end;
  EditStartDate.DateTime:=int(Tcalevent(eventlist[currentevent]).start);
  EditStartTime.DateTime:=int(Tcalevent(eventlist[currentevent]).start)-Tcalevent(eventlist[currentevent]).start;
  EditFinishDate.DateTime:=int(Tcalevent(eventlist[currentevent]).finish);
  EditFinishTime.DateTime:=int(Tcalevent(eventlist[currentevent]).finish)-Tcalevent(eventlist[currentevent]).finish;
  duration:=Tcalevent(eventlist[currentevent]).finish-Tcalevent(eventlist[currentevent]).start;
  // event or todo entry?
  if Tcalevent(eventlist[currentevent]).entrytype=0 then
    EditType.ItemIndex:=0
  else
    begin
      EditType.ItemIndex:=1;
      // disable elemnents for todo entry
      EditStartDate.Enabled:=false;
      EditStartTime.Enabled:=false;
      EditConnected.Enabled:=false;
    end;
  // fill reminder at the end, because it triggers the onchange event and calculates the date and time
  EditRemind.ItemIndex:=Tcalevent(eventlist[currentevent]).remtype;
  if EditRemind.Itemindex=1 then
    begin
      EditRemindDate.DateTime:=Int(Tcalevent(eventlist[currentevent]).remtime);
      EditRemindTime.DateTime:=Tcalevent(eventlist[currentevent]).remtime-Int(Tcalevent(eventlist[currentevent]).remtime);
    end;
  self.Showmodal();
  //EditStartDate.Paint;
end;
procedure TFcaldata.AddEventData(EventDate: TDateTime);
var
  itemcount: Integer;
begin
  currentevent := -1;
  Caption:='Neuer Eintrag...';
  EditType.ItemIndex:= 0;
  EditCategory.ItemIndex:= -1;
  EditCategory.Text:='';
  EditCategoryColor.Color:=clDefault;
  EditTitle.Caption:='Neuer Eintrag';
  EditTitle.SelectAll;
  EditLocation.Caption:='';
  EditDescription.Clear;
  EditFullDays.Enabled:=true;
  EditFullDays.Checked:=false;
  EditStartDate.Enabled:=true;
  EditStartTime.Enabled:=true;
  EditFinishDate.Enabled:=true;
  EditFinishTime.Enabled:=true;
  EditStartDate.Date:=EventDate;
  EditStartTime.Time:=0.5;
  EditFinishDate.Date:=EventDate;
  EditFinishTime.Time:=0.5;
  duration:=0;
  EditConnected.Enabled:=true;
  EditConnected.Checked:=false;
  EditRemind.Enabled:=true;
  EditRemind.ItemIndex:=0;
  EditRemindDate.Enabled:=false;
  EditRemindDate.Visible:=false;
  EditRemindDate.DateTime:=0;
  EditRemindTime.Enabled:=false;
  EditRemindTime.Visible:=false;
  EditRemindTime.DateTime:=0;
  LabelRemindTime.Visible:=false;
  // fill category drop down
  EditCategory.Items.Clear;
  for itemcount :=0 to (categories.Count-1) do
    EditCategory.Items.Add(categories.Names[itemcount]);
  // Repeat
  EditRepeatRhythm.Value:=0;
  EditRepeatRhythm.Enabled:=false;
  EditRepeatType.ItemIndex:=0;
  EditRepeatEnd.Enabled:=false;
  EditRepeatEnd.Visible:=false;
  EditRepeatDate.Enabled:=false;
  EditRepeatDate.Date:=Now;
  EditRepeatDate.Visible:=false;
  EditRepeatNumber.Enabled:=false;
  EditRepeatNumber.Visible:=false;
  self.ShowModal();
end;

function  TFcaldata.CountEvents: Integer;
begin
  Result:=eventlist.Count;
end;

procedure TFcaldata.DelRepeatedEvents();
var
  count: Integer;
  delgid: AnsiString;
begin
  count:=0;
  delgid:=Tcalevent(eventlist[currentevent]).gid;
  if not delgid.IsEmpty then
    repeat
      if (count<>currentevent) and (Tcalevent(eventlist[count]).gid=delgid) then
        begin
          //move currentevent if an event before is deleted
          if count<currentevent then
            dec(currentevent);
          eventlist.Delete(count)
        end
      else
        inc(count);
    until count=eventlist.Count;
end;
end.


{$IFDEF DPMI}
	{$A+,B-,E+,F-,G+,I+,N+,P-,T-,V-,X+}
	{$M 65520,0}
{$ELSE}
	{$A+,B-,E+,F-,G+,I+,N+,O+,P-,T-,V-,X+}
	{$M 8192,8192,614400}
{$ENDIF}

program DialTest;

{*******************************************************}
{														}
{						DialTest						}
{														}
{*******************************************************}

uses Dos, Objects, Drivers, Memory, Views, Menus, Dialogs,
	StdDlg, MsgBox, App, Params, TvInput;

const
	CopyNote = 'DialTest 1-14-94 (C) J.M.Clark';

	cmTestDial	= 101;
	cmEditItem	= 102;
	cmNewItem	= 103;

{-------------------------------------------------------}

{ ItemDialog }

type
	PItemDialog = ^TItemDialog;
	TItemDialog = object(TDialog)
		constructor Init(T: TTitleStr);
	end;

{ ClusterDialog }

type
	PClusterDialog = ^TClusterDialog;
	TClusterDialog = object(TDialog)
		ListBox: PListBox;
		constructor Init;
		procedure HandleEvent(var Event: TEvent); virtual;
	end;

	PClusterData = ^TClusterData;
	TClusterData = record
		RStrings: PStringCollection;
		RFocused: integer;
		RDataName: string[80];
		RLabel: string[80];
	end;

{ SampleDialog }

type
	PSampleDialog = ^TSampleDialog;
	TSampleDialog = object(TDialog)
		constructor Init;
	end;

	PSampleData = ^TSampleData;
	TSampleData = record
		Choices: longint;
		List: PStringCollection;
		Selection: integer;
		Mode: word;
		Options: word;
		Name: longint;
	end;

{ TDialTestApp }

type
	PDialTestApp = ^TDialTestApp;
	TDialTestApp = object(TApplication)
		constructor Init;
		destructor Done; virtual;
		procedure HandleEvent(var Event: TEvent); virtual;
		procedure InitScreen; virtual;
		procedure InitMenuBar; virtual;
		procedure InitStatusLine; virtual;
		procedure OutOfMemory; virtual;
	end;

var
	ClusterData: TClusterData;
	SampleData: TSampleData;
	DialTestApp: TDialTestApp;
	Strings: PStringCollection;

{*******************************************************}

{ ItemDialog }

constructor TItemDialog.Init(T: TTitleStr);
var
	R: TRect;
	IL: PInputLine;
	CB: PCheckBoxes;
	RB: PRadioButtons;
begin
	R.Assign(4, 4, 31, 16);
	inherited Init(R, T+' Item');

	R.Assign(3, 4, 24, 5);
	IL:= New(PInputLine, Init(R, 80));	Insert(IL);
	R.Assign(3, 3, 13, 4);
	Insert(New(PLabel, Init(R, 'Item ~N~ame', IL)));

	R.Assign(3, 7, 13, 9);
	Insert(New(PButton, Init(R, 'C~a~ncel', cmCancel, bfNormal)));

	R.Assign(14, 7, 24, 9);
	Insert(New(PButton, Init(R, '~O~k', cmOK, bfDefault)));
end; {TItemDialog.Init}

{ ClusterDialog }

constructor TClusterDialog.Init;
var
	R: TRect;
	IL: PInputLine;
	RB: PRadioButtons;
	SB: PScrollBar;
begin
	R.Assign(47, 17, 76, 45);
	inherited Init(R, 'Change Cluster');

	R.Assign(25, 7, 26, 17);
	SB:= New(PScrollBar, Init(R));	Insert(SB);
	R.Assign(3, 7, 25, 17);
	ListBox:= New(PListBox, Init(R, 2, SB));  Insert(ListBox);
	R.Assign(3, 6, 14, 7);
	Insert(New(PLabel, Init(R, '~I~tem Names', ListBox)));

	R.Assign(15, 4, 26, 5);
	IL:= New(PInputLine, Init(R, 80));	Insert(IL);
	R.Assign(15, 3, 26, 4);
	Insert(New(PLabel, Init(R, '~D~ata Name', IL)));

	R.Assign(3, 4, 14, 5);
	IL:= New(PInputLine, Init(R, 80));	Insert(IL);
	R.Assign(3, 3, 10, 4);
	Insert(New(PLabel, Init(R, '~L~abel', IL)));

	R.Assign(3, 19, 13, 21);
	Insert(New(PButton, Init(R, '~E~dit', cmEditItem, bfNormal)));

	R.Assign(15, 19, 25, 21);
	Insert(New(PButton, Init(R, '~N~ew', cmNewItem, bfNormal)));

	R.Assign(3, 23, 13, 25);
	Insert(New(PButton, Init(R, 'C~a~ncel', cmCancel, bfNormal)));

	R.Assign(15, 23, 25, 25);
	Insert(New(PButton, Init(R, '~O~k', cmOK, bfDefault)));
end; {TClusterDialog.Init}

procedure TClusterDialog.HandleEvent(var Event: TEvent);
var
	ItemName: string[80];

	procedure NewName;
	begin
		with Strings^ do begin
			if ItemName <> '' then
			AtInsert(ListBox^.Focused, NewStr(ItemName));
			ListBox^.SetRange(Strings^.Count);
			ListBox^.Draw;
		end;
	end; {NewName}

begin
	inherited HandleEvent(Event);
	if (Event.What = evCommand) then begin
		case Event.Command of
		 cmNewItem:
			begin
				ItemName:= '';
				if DialTestApp.ExecuteDialog(New(PItemDialog,
						Init('New')), @ItemName) = cmOK
				then NewName;
			end;

		 cmEditItem:
			begin
				ItemName:= PString(Strings^.At(ListBox^.Focused))^;
				if ItemName <> ' ' then begin
					if DialTestApp.ExecuteDialog(New(PItemDialog,
							Init('Change')), @ItemName) = cmOK
					then begin
						Strings^.AtDelete(ListBox^.Focused);
						NewName;
					end;
				end;
			end;

		 else exit;
		end; {case}
		ClearEvent(Event);
	end;
end; {TClusterDialog.HandleEvent}

{-------------------------------------------------------}

{ SampleDialog }

constructor TSampleDialog.Init;
var
	R: TRect;
	IL: PInputLine;
	CB: PCheckBoxes;
	MB: PMultiCheckBoxes;
	RB: PRadioButtons;
	SB: PScrollBar;
	LB: PListBox;
begin
	R.Assign(4, 4, 37, 37);
	inherited Init(R, 'Sample Dialog');
	Options:= Options or ofCentered;

	R.Assign(2, 23, 30, 27);
	MB:= New(PMultiCheckBoxes, Init(R,
		NewSItem('before',
		NewSItem('early',
		NewSItem('late',
		NewSItem('after',
		NewSItem('never',
		NewSItem('ever',
		NewSItem('always',
		NewSItem('sometimes',
		nil)))))))), 16, cfFourBits, '0123456789abcdef'));
	Insert(MB);
	R.Assign(2, 22, 11, 23);
	Insert(New(PLabel, Init(R, '~C~hoices', MB)));

	R.Assign(29, 11, 30, 21);
	SB:= New(PScrollBar, Init(R));	Insert(SB);
	R.Assign(3, 11, 29, 21);
	LB:= New(PListBox, Init(R, 2, SB));  Insert(LB);
	R.Assign(3, 10, 14, 11);
	Insert(New(PLabel, Init(R, '~S~election', LB)));

	R.Assign(18, 6, 30, 9);
	RB:= New(PRadioButtons, Init(R,
		NewSItem('apples',
		NewSItem('bacon',
		NewSItem('cereal',
		nil)))
	));  Insert(RB);
	R.Assign(18, 5, 24, 6);
	Insert(New(PLabel, Init(R, '~M~ode', RB)));

	R.Assign(3, 6, 16, 9);
	CB:= New(PCheckBoxes, Init(R,
		NewSItem('able',
		NewSItem('baker',
		NewSItem('charlie',
		nil)))
	));  Insert(CB);
	R.Assign(3, 5, 12, 6);
	Insert(New(PLabel, Init(R, '~O~ptions', CB)));

	R.Assign(3, 3, 30, 4);
	IL:= New(PRangeInputLine, Init(R, 80, 1, 10));	Insert(IL);
	R.Assign(3, 2, 9, 3);
	Insert(New(PLabel, Init(R, '~N~ame', IL)));

	R.Assign(18, 2, 29, 3);
	Insert(New(PStaticText, Init(R, 'static text')));

	R.Assign(5, 29, 15, 31);
	Insert(New(PButton, Init(R, 'C~a~ncel', cmCancel, bfNormal)));

	R.Assign(18, 29, 28, 31);
	Insert(New(PButton, Init(R, '~O~k', cmOK, bfDefault)));
end; {TSampleDialog.Init}

{-------------------------------------------------------}

{ TDialTestApp }

{	NOTE:
	TApplication handles cmTile, cmCascade, & cmDosShell, and
	its ancestor TProgram handles Alt-1 .. Alt-9 & cmQuit.
}
procedure TDialTestApp.HandleEvent(var Event: TEvent);

begin {TDialTestApp.HandleEvent}
	inherited HandleEvent(Event);
	case Event.What of
		evCommand:
			case Event.Command of
				cmChangeDir:
					ExecuteDialog(New(PChDirDialog,
						Init(cdNormal, 0)), nil);

				cmCloseAll:
					Message(DeskTop, evBroadcast, cmCloseAll, nil);

				cmTestDial:
					(**
					ExecuteDialog(New(PClusterDialog,
						Init), @ClusterData);
					**)
					ExecuteDialog(New(PSampleDialog,
						Init), @SampleData);

				else Exit;
			end;
		else Exit;
	end;
	ClearEvent(Event);
end; {TDialTestApp.HandleEvent}

procedure TDialTestApp.InitScreen;
var
	R: TRect;
begin
	if HiResScreen then begin
		{ This is basicly SetScreenMode(Mode), except  }
		{ that Mode is "ScreenMode or smFont8x8" and   }
		{ that inherited InitScreen is called (else we }
		{ would have a recursive loop). }
		HideMouse;
		SetVideoMode(ScreenMode or smFont8x8);
		DoneMemory;
		InitMemory;
		inherited InitScreen;
		Buffer:= ScreenBuffer;
		R.Assign(0, 0, ScreenWidth, ScreenHeight);
		ChangeBounds(R);
		ShowMouse;
	end else begin
		inherited InitScreen;
	end;
end; {TDialTestApp.InitScreen}

procedure TDialTestApp.InitMenuBar;
var
	R: TRect;
begin
	GetExtent(R);
	R.B.Y:= R.A.Y + 1;
	MenuBar:= New(PMenuBar, Init(R, NewMenu(
		NewSubMenu('DialTest', hcNoContext, NewMenu(
			NewItem(CopyNote, '', kbNoKey, cmNo, hcNoContext,
			nil)),
		NewSubMenu('~F~ile', hcNoContext, NewMenu(
			NewItem('~C~hange dir...', '', kbNoKey, cmChangeDir,
					hcNoContext,
			NewItem('~T~est Dialog', '', kbAltT, cmTestDial, hcNoContext,
			NewItem('~D~OS shell', '', kbNoKey, cmDosShell, hcNoContext,
			NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext,
			nil))))),
		NewSubMenu('~W~indows', hcNoContext, NewMenu(
			StdWindowMenuItems(
			nil)),
		nil)))
	)));
end; {TDialTestApp.InitMenuBar}

procedure TDialTestApp.InitStatusLine;
var
	R: TRect;
begin
	GetExtent(R);
	R.A.Y:= R.B.Y - 1;
	New(StatusLine, Init(R,
		NewStatusDef(0, $FFFF,
			NewStatusKey('~F5~ Zoom', kbF5, cmZoom,
			NewStatusKey('~F6~ Next', kbF6, cmNext,
			NewStatusKey('~F10~ Menu', kbF10, cmMenu,
			NewStatusKey('', kbCtrlF5, cmResize,
			nil)))),
		nil)
	));
end; {TDialTestApp.InitStatusLine}

procedure TDialTestApp.OutOfMemory;
begin
	MessageBox('Not enough memory for this operation.',
		nil, mfError + mfOkButton);
end; {TDialTestApp.OutOfMemory}

{configuration data; compatable with CONFIG program:}
type
	tConfig = record
		Magic: string[10];
		Data:  string[100]; {max length is 255}
	end;

const
	Config: tConfig = (
		Magic: '!)@(#*$&%^';	{must appear nowhere else in code!}

		{default options:}
		Data:	'/////////////////////////'+
				'/////////////////////////'+
				'/////////////////////////'+
				'/////////////////////////'
		{reserve space for reconfiguration with '/' padding}
	);

{ShowUsage: explain command-line parameters and options:}
procedure ShowUsage; far;
var
	OS: string;
	CP: integer;
begin
	writeln('Usage: DialTest ');
	OS:= GetDefaults(Config.data);
	CP:= Pos('/_', OS)-1;
	if CP >= 0 then OS[0]:= char(CP);
	writeln('Default options are: ', OS);
end; {ShowUsage}

procedure SetOpt; far;
begin
	case OptChr of

		'?':
			begin
				DialTestApp.Done;
				ShowUsage;
				Halt;
			end;

		else RptError('Undefined option', Option, 'u');
	end;
end; {SetOpt}

{DoFile: process the file FName:}
procedure DoFile(FName: PathStr; Expdd: boolean); far;
begin
	if not Expdd then begin
		inc(FileNo);  inc(FPars);
	end;

end; {DoFile}

procedure AppDone; far;
begin
	DialTestApp.Done;
end; {AppDone}

constructor TDialTestApp.Init;
var
	H: Word;
	R: TRect;
	Dir: DirStr;
	Name: NameStr;
	Ext: ExtStr;

begin
	PShowUsage:= ShowUsage;
	PSetOpt:= SetOpt;
	PDoFile:= DoFile;
	PAppDone:= AppDone;

	ParseOpts(Config.Data); {set default options}

	TApplication.Init;

	DisableCommands([cmTile, cmCascade, cmCloseAll]);

	if ParamCount = 0 then begin

	end else begin
		{ParNo := 1 to ParamCount used here:}
		ScanPars;	{scan the command line}
	end;
	Strings:= New(PStringCollection, Init(16, 8));
	with Strings^ do begin
		AtInsert(0, NewStr('Able'));
		AtInsert(1, NewStr('Baker'));
		AtInsert(2, NewStr('Charlie'));
		AtInsert(3, NewStr('David'));
		AtInsert(4, NewStr('Eagle'));
		AtInsert(5, NewStr('Fox'));
		AtInsert(6, NewStr('George'));
		AtInsert(7, NewStr('Harvey'));
		AtInsert(8, NewStr('Isaac'));
		AtInsert(9, NewStr('John'));
		AtInsert(10, NewStr('King'));
		AtInsert(11, NewStr('Larry'));
		AtInsert(12, NewStr('Marvin'));
		AtInsert(13, NewStr(' '));
	end;
	with ClusterData do begin
		RStrings:= Strings;
		RFocused:= 0;
		RDataName:= '';
		RLabel:= '';
	end;
end; {TDialTestApp.Init}

destructor TDialTestApp.Done;
begin
	TApplication.Done;
	writeln(CopyNote);
end; {TDialTestApp.Done}

begin
	DialTestApp.Init;
	DialTestApp.Run;
	DialTestApp.Done;
end.


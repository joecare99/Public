unit Unit1;

{-------------------------------------------------------------------------------
  Unit1 - TForm1, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit1.pas and the original resource
  Source\Projects_AhnenWin\Form1.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, Menus, ExtCtrls, ComCtrls, DBCtrls, StdCtrls, Grids, Dialogs, DBGrids, ExtDlgs, FileCtrl, DBTables, DBCommon, DB, Buttons, DBClient, Forms, Controls;

type
  TForm1 = class(TForm)
  published
    MainMenu1: TMainMenu; //2F0
    Datei1: TMenuItem; //2F4
    Datensatz1: TMenuItem; //2F8
    neu1: TMenuItem; //2FC
    N1: TMenuItem; //300
    schen1: TMenuItem; //304
    Shape1: TShape; //308
    Suchen1: TMenuItem; //30C
    DatensatzNr1: TMenuItem; //310
    Datenaustausch1: TMenuItem; //314
    Listen1: TMenuItem; //318
    Vorfahren1: TMenuItem; //31C
    Nachfahren1: TMenuItem; //320
    Kalender1: TMenuItem; //324
    Bilder1: TMenuItem; //328
    Datenprfung1: TMenuItem; //32C
    Info1: TMenuItem; //330
    Datensicherung1: TMenuItem; //334
    PageControl1: TPageControl; //338
    TabSheet1: TTabSheet; //33C
    TabSheet2: TTabSheet; //340
    TabSheet3: TTabSheet; //344
    TabSheet4: TTabSheet; //348
    TabSheet5: TTabSheet; //34C
    TabSheet6: TTabSheet; //350
    DBNavigator1: TDBNavigator; //354
    Label1: TLabel; //358
    Label2: TLabel; //35C
    Label3: TLabel; //360
    DBEdit2: TDBEdit; //364
    DBEdit3: TDBEdit; //368
    Label5: TLabel; //36C
    StringGrid1: TStringGrid; //370
    StringGrid2: TStringGrid; //374
    Label6: TLabel; //378
    Label7: TLabel; //37C
    Shape2: TShape; //380
    Label8: TLabel; //384
    DBEdit5: TDBEdit; //388
    Label9: TLabel; //38C
    Label10: TLabel; //390
    DBEdit6: TDBEdit; //394
    Prfen1: TMenuItem; //398
    Shape3: TShape; //39C
    Label11: TLabel; //3A0
    Label12: TLabel; //3A4
    Edit1: TEdit; //3A8
    Edit2: TEdit; //3AC
    DBEdit7: TDBEdit; //3B0
    Label4: TLabel; //3B4
    Label13: TLabel; //3B8
    DBEdit8: TDBEdit; //3BC
    DBEdit9: TDBEdit; //3C0
    DBEdit10: TDBEdit; //3C4
    Label14: TLabel; //3C8
    Label15: TLabel; //3CC
    DBEdit12: TDBEdit; //3D0
    DBEdit13: TDBEdit; //3D4
    DBEdit14: TDBEdit; //3D8
    Label16: TLabel; //3DC
    DBEdit16: TDBEdit; //3E0
    DBEdit17: TDBEdit; //3E4
    DBEdit18: TDBEdit; //3E8
    Label17: TLabel; //3EC
    DBEdit20: TDBEdit; //3F0
    DBEdit21: TDBEdit; //3F4
    DBEdit22: TDBEdit; //3F8
    SaveDialog1: TSaveDialog; //3FC
    Label18: TLabel; //400
    Label19: TLabel; //404
    DBMemo1: TDBMemo; //408
    Memo1: TMemo; //40C
    Datensichern1: TMenuItem; //410
    OpenDialog1: TOpenDialog; //414
    Datenlschen1: TMenuItem; //418
    Label20: TLabel; //41C
    Label21: TLabel; //420
    DBGrid1: TDBGrid; //424
    GregorianischerKalender1: TMenuItem; //428
    FrzRevolutionskalender1: TMenuItem; //42C
    Osterberechnung1: TMenuItem; //430
    ChristlicheNamenstage1: TMenuItem; //434
    N3: TMenuItem; //438
    IDSatznr1: TMenuItem; //43C
    IDslschen1: TMenuItem; //440
    N4: TMenuItem; //444
    DBEdit4: TDBEdit; //448
    Label22: TLabel; //44C
    Label23: TLabel; //450
    Label24: TLabel; //454
    Label25: TLabel; //458
    PopupMenu1: TPopupMenu; //45C
    PopupMenu2: TPopupMenu; //460
    Verbindungeinfgen1: TMenuItem; //464
    Verbindunglschen1: TMenuItem; //468
    Kindereinfgen1: TMenuItem; //46C
    Kinderentfernen1: TMenuItem; //470
    Label26: TLabel; //474
    StringGrid4: TStringGrid; //478
    beenden1: TMenuItem; //47C
    TabSheet7: TTabSheet; //480
    TabSheet8: TTabSheet; //484
    DBGrid2: TDBGrid; //488
    Label27: TLabel; //48C
    Label28: TLabel; //490
    Label35: TLabel; //494
    Label41: TLabel; //498
    DBEdit25: TDBEdit; //49C
    Label63: TLabel; //4A0
    Label29: TLabel; //4A4
    Label30: TLabel; //4A8
    Label31: TLabel; //4AC
    Label32: TLabel; //4B0
    Label52: TLabel; //4B4
    Label33: TLabel; //4B8
    Label34: TLabel; //4BC
    Label39: TLabel; //4C0
    Label40: TLabel; //4C4
    Label42: TLabel; //4C8
    Label43: TLabel; //4CC
    DBEdit57: TDBEdit; //4D0
    DBEdit56: TDBEdit; //4D4
    DBEdit55: TDBEdit; //4D8
    DBEdit60: TDBEdit; //4DC
    DBEdit52: TDBEdit; //4E0
    DBEdit51: TDBEdit; //4E4
    DBEdit50: TDBEdit; //4E8
    DBEdit59: TDBEdit; //4EC
    DBEdit49: TDBEdit; //4F0
    DBEdit48: TDBEdit; //4F4
    DBEdit47: TDBEdit; //4F8
    DBEdit44: TDBEdit; //4FC
    DBEdit43: TDBEdit; //500
    DBEdit42: TDBEdit; //504
    DBEdit26: TDBEdit; //508
    DBEdit40: TDBEdit; //50C
    DBComboBox7: TDBComboBox; //510
    DBCheckBox2: TDBCheckBox; //514
    Edit32: TEdit; //518
    Label53: TLabel; //51C
    Label60: TLabel; //520
    Label59: TLabel; //524
    Label58: TLabel; //528
    Label57: TLabel; //52C
    DBEdit31: TDBEdit; //530
    Label50: TLabel; //534
    Label44: TLabel; //538
    Label45: TLabel; //53C
    Label46: TLabel; //540
    Label47: TLabel; //544
    Label49: TLabel; //548
    Label48: TLabel; //54C
    Edit4: TEdit; //550
    Edit5: TEdit; //554
    Edit6: TEdit; //558
    Shape4: TShape; //55C
    Shape5: TShape; //560
    Edit30: TEdit; //564
    Edit10: TEdit; //568
    Edit9: TEdit; //56C
    Edit8: TEdit; //570
    Edit31: TEdit; //574
    Edit13: TEdit; //578
    Edit14: TEdit; //57C
    Edit15: TEdit; //580
    Panel1: TPanel; //584
    Label64: TLabel; //588
    DBEdit32: TDBEdit; //58C
    DBEdit33: TDBEdit; //590
    DBText2: TDBText; //594
    ComboBox5: TComboBox; //598
    Shape6: TShape; //59C
    Shape7: TShape; //5A0
    StringGrid3: TStringGrid; //5A4
    Label62: TLabel; //5A8
    Label36: TLabel; //5AC
    Label37: TLabel; //5B0
    Label38: TLabel; //5B4
    Label54: TLabel; //5B8
    Label51: TLabel; //5BC
    Label55: TLabel; //5C0
    Label56: TLabel; //5C4
    Label61: TLabel; //5C8
    Label65: TLabel; //5CC
    Shape8: TShape; //5D0
    Label66: TLabel; //5D4
    Label67: TLabel; //5D8
    DBEdit35: TDBEdit; //5DC
    DBEdit36: TDBEdit; //5E0
    DBEdit37: TDBEdit; //5E4
    DBEdit38: TDBEdit; //5E8
    DBEdit39: TDBEdit; //5EC
    DBEdit41: TDBEdit; //5F0
    DBEdit45: TDBEdit; //5F4
    DBEdit46: TDBEdit; //5F8
    DBComboBox1: TDBComboBox; //5FC
    DBEdit61: TDBEdit; //600
    DBEdit62: TDBEdit; //604
    DBEdit63: TDBEdit; //608
    Label68: TLabel; //60C
    Filter1: TMenuItem; //610
    ID1: TMenuItem; //614
    N2: TMenuItem; //618
    aus1: TMenuItem; //61C
    Datenschutzein1: TMenuItem; //620
    Datenschutzaus1: TMenuItem; //624
    N5: TMenuItem; //628
    DBCheckBox1: TDBCheckBox; //62C
    PopupMenu3: TPopupMenu; //630
    PopupMenu4: TPopupMenu; //634
    Vatereinfgen1: TMenuItem; //638
    Vaterentfernen1: TMenuItem; //63C
    Muttereinfgen1: TMenuItem; //640
    Mutterentfernen1: TMenuItem; //644
    Label69: TLabel; //648
    Label71: TLabel; //64C
    Label70: TLabel; //650
    Name1: TMenuItem; //654
    Druckereinstellung1: TMenuItem; //658
    Bildschirmdrucken1: TMenuItem; //65C
    N6: TMenuItem; //660
    PrintDialog1: TPrintDialog; //664
    ExcelExport1: TMenuItem; //668
    N8: TMenuItem; //66C
    Partnersuche1: TMenuItem; //670
    StringGrid5: TStringGrid; //674
    GlobaleSuche1: TMenuItem; //678
    LetzteSuche1: TMenuItem; //67C
    anzeigen1: TMenuItem; //680
    Hilfe1: TMenuItem; //684
    N10: TMenuItem; //688
    zuAHNENWIN1: TMenuItem; //68C
    Hausname1: TMenuItem; //690
    N11: TMenuItem; //694
    Namensliste1: TMenuItem; //698
    allePersonen1: TMenuItem; //69C
    frbestimmtenOrt1: TMenuItem; //6A0
    Ortsliste1: TMenuItem; //6A4
    allePersonen2: TMenuItem; //6A8
    Probandenname1: TMenuItem; //6AC
    FamGrafik1: TMenuItem; //6B0
    einfgen1: TMenuItem; //6B4
    Image1: TImage; //6B8
    OpenPictureDialog1: TOpenPictureDialog; //6BC
    UpDown1: TUpDown; //6C0
    entfernen1: TMenuItem; //6C4
    Grafik1: TMenuItem; //6C8
    Grafikneu1: TMenuItem; //6CC
    Familienblatt2: TMenuItem; //6D0
    Liste1: TMenuItem; //6D4
    N13: TMenuItem; //6D8
    FOKODateierstellen1: TMenuItem; //6DC
    N14: TMenuItem; //6E0
    inyTafelerstellen1: TMenuItem; //6E4
    FOKODateieditieren1: TMenuItem; //6E8
    N15: TMenuItem; //6EC
    OFBDruck1: TMenuItem; //6F0
    N16: TMenuItem; //6F4
    alleBilderentfernen1: TMenuItem; //6F8
    FileListBox1: TFileListBox; //6FC
    N17: TMenuItem; //700
    bmpjpg1: TMenuItem; //704
    N18: TMenuItem; //708
    GedcomDateischreiben1: TMenuItem; //70C
    GedcomDateieinlesen1: TMenuItem; //710
    GedcomXMLschreiben1: TMenuItem; //714
    N19: TMenuItem; //718
    GedcomXMLeinlesen1: TMenuItem; //71C
    Grafikalt1: TMenuItem; //720
    Listen2: TMenuItem; //724
    N21: TMenuItem; //728
    N7: TMenuItem; //72C
    N22: TMenuItem; //730
    AHNENDOSeinlesen1: TMenuItem; //734
    OSBeinlesen1: TMenuItem; //738
    Adressendateischreiben1: TMenuItem; //73C
    Panel2: TPanel; //740
    Label73: TLabel; //744
    Label74: TLabel; //748
    Label75: TLabel; //74C
    Label76: TLabel; //750
    Label77: TLabel; //754
    DBEdit64: TDBEdit; //758
    DBEdit65: TDBEdit; //75C
    DBEdit66: TDBEdit; //760
    DBEdit68: TDBEdit; //764
    Label78: TLabel; //768
    geschachtelt1: TMenuItem; //76C
    N24: TMenuItem; //770
    GrafikI1: TMenuItem; //774
    Label79: TLabel; //778
    Spitzenahnen1: TMenuItem; //77C
    Proband1: TMenuItem; //780
    allePersonen3: TMenuItem; //784
    Basisahnen1: TMenuItem; //788
    N25: TMenuItem; //78C
    DBEdit69: TDBEdit; //790
    N20: TMenuItem; //794
    Verwandtschaft1: TMenuItem; //798
    FamilienblattHTML1: TMenuItem; //79C
    N12: TMenuItem; //7A0
    OrtsDatei1: TMenuItem; //7A4
    NamensListeeditieren1: TMenuItem; //7A8
    N26: TMenuItem; //7AC
    Listenaktualisieren1: TMenuItem; //7B0
    DBText1: TDBText; //7B4
    ComboBox1: TComboBox; //7B8
    ComboBox2: TComboBox; //7BC
    ComboBox3: TComboBox; //7C0
    QuellenListeeditieren1: TMenuItem; //7C4
    N27: TMenuItem; //7C8
    drucken1: TMenuItem; //7CC
    DBComboBox2: TDBComboBox; //7D0
    DBComboBox3: TDBComboBox; //7D4
    Query1: TQuery; //7D8
    Label80: TLabel; //7DC
    DBGrid3: TDBGrid; //7E0
    DataSource1: TDataSource; //7E4
    Label81: TLabel; //7E8
    Shape9: TShape; //7EC
    Label82: TLabel; //7F0
    Label83: TLabel; //7F4
    Label84: TLabel; //7F8
    DBEdit1: TDBEdit; //7FC
    DBEdit11: TDBEdit; //800
    DBEdit15: TDBEdit; //804
    Shape10: TShape; //808
    Shape11: TShape; //80C
    Label86: TLabel; //810
    Label87: TLabel; //814
    Label85: TLabel; //818
    Label88: TLabel; //81C
    Label89: TLabel; //820
    Label90: TLabel; //824
    Label91: TLabel; //828
    Label92: TLabel; //82C
    Label93: TLabel; //830
    N29: TMenuItem; //834
    DoppelteEintrge1: TMenuItem; //838
    N30: TMenuItem; //83C
    nichtverknpfteBeziehungen1: TMenuItem; //840
    Einzelpersonen1: TMenuItem; //844
    FileListBox2: TFileListBox; //848
    bernehmen1: TMenuItem; //84C
    Neu2: TMenuItem; //850
    SpeedButton1: TSpeedButton; //854
    ComboBox4: TComboBox; //858
    ComboBox6: TComboBox; //85C
    ComboBox7: TComboBox; //860
    ComboBox8: TComboBox; //864
    ComboBox9: TComboBox; //868
    ComboBox10: TComboBox; //86C
    ComboBox11: TComboBox; //870
    ComboBox12: TComboBox; //874
    ComboBox13: TComboBox; //878
    ComboBox14: TComboBox; //87C
    ComboBox15: TComboBox; //880
    ComboBox16: TComboBox; //884
    ComboBox17: TComboBox; //888
    ComboBox18: TComboBox; //88C
    ComboBox19: TComboBox; //890
    ComboBox20: TComboBox; //894
    ComboBox21: TComboBox; //898
    ComboBox22: TComboBox; //89C
    ComboBox23: TComboBox; //8A0
    ComboBox24: TComboBox; //8A4
    ComboBox25: TComboBox; //8A8
    ComboBox26: TComboBox; //8AC
    BerufeVerwaltung1: TMenuItem; //8B0
    DataSource2: TDataSource; //8B4
    lfbh2: TClientDataSet; //8B8
    DataSource4: TDataSource; //8BC
    Repso2: TClientDataSet; //8C0
    Repso2z: TAutoIncField; //8C4
    Repso2nr: TIntegerField; //8C8
    Repso2inh: TStringField; //8CC
    Repso2inh2: TMemoField; //8D0
    Repso2alt: TStringField; //8D4
    N28: TMenuItem; //8D8
    EhenKiordnen1: TMenuItem; //8DC
    PrinterSetupDialog1: TPrinterSetupDialog; //8E0
    Edit3: TEdit; //8E4
    Edit7: TEdit; //8E8
    Edit11: TEdit; //8EC
    Edit12: TEdit; //8F0
    Edit16: TEdit; //8F4
    N31: TMenuItem; //8F8
    Fenstertitelndern1: TMenuItem; //8FC
    Quellenliste1: TMenuItem; //900
    HofnamenVerwaltung1: TMenuItem; //904
    lfbh2Nr: TAutoIncField; //908
    lfbh2Nm: TIntegerField; //90C
    lfbh2Prob: TStringField; //910
    lfbh2Eh: TStringField; //914
    lfbh2Ix: TStringField; //918
    lfbh2Nam: TStringField; //91C
    lfbh2Aus: TIntegerField; //920
    lfbh2Hei: TStringField; //924
    Vettern1: TMenuItem; //928
    Basen1: TMenuItem; //92C
    TabSheet9: TTabSheet; //930
    Image2: TImage; //934
    Image3: TImage; //938
    Image4: TImage; //93C
    Image5: TImage; //940
    Image6: TImage; //944
    Image7: TImage; //948
    Image13: TImage; //94C
    Image12: TImage; //950
    Image11: TImage; //954
    Image10: TImage; //958
    Image9: TImage; //95C
    Image8: TImage; //960
    Image14: TImage; //964
    Image15: TImage; //968
    Image16: TImage; //96C
    Image17: TImage; //970
    Image18: TImage; //974
    Image19: TImage; //978
    Image26: TImage; //97C
    Image25: TImage; //980
    Image24: TImage; //984
    Image23: TImage; //988
    Image22: TImage; //98C
    Image21: TImage; //990
    Image20: TImage; //994
    Label94: TLabel; //998
    Label95: TLabel; //99C
    Label96: TLabel; //9A0
    Label97: TLabel; //9A4
    Label98: TLabel; //9A8
    ColorDialog1: TColorDialog; //9AC
    Label99: TLabel; //9B0
    DBEdit19: TDBEdit; //9B4
    Label72: TLabel; //9B8
    GebDatumTaufdatum1: TMenuItem; //9BC
    N32: TMenuItem; //9C0
    SicherungsDateieinlesen2: TMenuItem; //9C4
    Button1: TButton; //9C8
    procedure listen_akt; //005F0AF0
    procedure ComboBox1Exit(Sender: TObject); //00603A50
    procedure DBLookupComboBox17Exit(Sender: TObject); //00603740
    procedure DBLookupComboBox16Exit(Sender: TObject); //006038A8
    procedure TabSheet2Exit(Sender:TObject); //00603D50
    procedure DBLookupComboBox12MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); //00603EE0
    procedure ComboBox2Exit(Sender: TObject); //00603B50
    procedure ComboBox3Exit(Sender: TObject); //00603C50
    procedure TabSheet7Enter(Sender:TObject); //006036AC
    procedure FamilienblattHTML1Click(Sender:TObject); //00602D2C
    procedure OrtsDatei1Click(Sender:TObject); //00602E00
    procedure DBEdit69Change(Sender: TObject); //00602C14
    procedure PopupMenu1Popup; //00602C34
    procedure gridanp; //005D3EF8
    procedure NamensListeeditieren1Click(Sender:TObject); //00603678
    procedure DBLookupComboBox4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); //00602F3C
    procedure DBLookupComboBox17MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); //006034D8
    procedure Einzelpersonenmarkieren1Click(Sender: TObject); //00605A2C
    procedure DBLookupComboBox4Enter(Sender: TObject); //00606D80
    procedure DBGrid3Exit(Sender:TObject); //006059B8
    procedure DBGrid3KeyDown(Sender:TObject; var Key:Word; Shift:TShiftState); //006059E4
    procedure DBLookupComboBox7Enter(Sender: TObject); //00606D8C
    procedure DBLookupComboBox8Enter(Sender: TObject); //00606D90
    procedure DBLookupComboBox5Enter(Sender: TObject); //00606D84
    procedure DBLookupComboBox6Enter(Sender: TObject); //00606D88
    procedure DBGrid3DblClick(Sender:TObject); //00605814
    procedure QuellenListeeditieren1Click(Sender:TObject); //00604810
    procedure Quellesuchen1Click(Sender: TObject); //00604820
    procedure DBLookupComboBox19MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); //006044C4
    procedure DBLookupComboBox19Click(Sender: TObject); //006047EC
    procedure DBComboBox3Change(Sender: TObject); //006053EC
    procedure DBComboBox3Exit(Sender:TObject); //00605754
    procedure drucken1Click(Sender:TObject); //0060482C
    procedure QRDefault; //005F0170
    procedure druck(AMode: Integer; AText: AnsiString); //005EFF30
    procedure vorf_erm2(ANummer: Integer; AFlag: Boolean; AText: AnsiString); //00600F50
    procedure Hilfe1Click(Sender:TObject); //006023F4
    procedure GrafikI1Click(Sender:TObject); //00600D58
    procedure Grafikalt1Click(Sender:TObject); //006022BC
    procedure allePersonen3Click(Sender:TObject); //006024D0
    procedure Basisahnen1Click(Sender:TObject); //00602544
    procedure Listen; //005FBF0C
    procedure Proband1Click(Sender:TObject); //0060243C
    procedure ehtest; //005FE42C
    procedure Adressendateischreiben1Click(Sender:TObject); //005FD964
    procedure TabSheet8Enter(Sender:TObject); //005FD9DC
    procedure Listen2Click(Sender:TObject); //005FD640
    procedure Button1Click(Sender:TObject); //005FD6A0
    procedure geschachtelt1Click(Sender:TObject); //005FE844
    procedure geb_sterb(AAnsiString: AnsiString); //005FDF68
    procedure AHNENDOSeinlesen1Click(Sender:TObject); //005FDAA4
    procedure OSBeinlesen1Click(Sender:TObject); //005FDD0C
    procedure Edit13Exit(Sender:TObject); //00602B58
    procedure PageControl1Exit(Sender:TObject); //00602BE0
    procedure Edit6Exit(Sender:TObject); //00602A48
    procedure Edit10Exit(Sender:TObject); //00602AD0
    procedure FormActivate(Sender:TObject); //00602BF0
    procedure DBCheckBox1Exit(Sender:TObject); //00602C04
    procedure ComboBox5Change(Sender: TObject); //00602BE4
    procedure DBEdit47Exit(Sender:TObject); //006028B0
    procedure DBEdit55Exit(Sender:TObject); //006029C0
    procedure aspitz; //005E4C30
    procedure pspitz; //005E4D60
    procedure spitzbas; //005E3454
    procedure basahnen; //005E4AB8
    procedure DBEdit44Exit(Sender:TObject); //00602828
    procedure DBEdit52Exit(Sender:TObject); //00602938
    procedure DBEdit40Exit(Sender:TObject); //006025B8
    procedure DBEdit7Exit(Sender:TObject); //006026F0
    procedure Quellenliste1Click(Sender:TObject); //0060E890
    procedure TabSheet1Show(Sender:TObject); //0060EAF0
    procedure fcapt; //0060E714
    procedure Fenstertitelndern1Click(Sender:TObject); //0060E888
    procedure HofnamenVerwaltung1Click(Sender:TObject); //0060EF00
    procedure Vettern1Click(Sender:TObject); //0060EF34
    procedure Verwandtschaft1Click(Sender:TObject); //0060EC94
    procedure DBEdit6Exit(Sender:TObject); //0060EDE8
    procedure EhenKiordnen1Click(Sender:TObject); //0060DDA4
    procedure ComboBox20Exit(Sender:TObject); //0060D28C
    procedure ComboBox11Exit(Sender:TObject); //0060D780
    procedure StringGrid5MouseDown(Sender:TObject; Button:TMouseButton; Shift:TShiftState; X:Integer; Y:Integer); //0060C3A8
    procedure ComboBox4Exit(Sender:TObject); //0060C678
    procedure DBEdit32Exit(Sender:TObject); //0060DC84
    procedure TabSheet4Show(Sender:TObject); //0060DDA0
    procedure BerufeVerwaltung1Click(Sender:TObject); //0060DB58
    procedure DBEdit3Exit(Sender:TObject); //0060DB68
    procedure GebDatumTaufdatum1Click(Sender:TObject); //006180D8
    procedure DBComboBox1Exit(Sender:TObject); //00618254
    procedure DBEdit10Change(Sender: TObject); //006180CC
    procedure DBMemo1Exit(Sender:TObject); //006180D0
    procedure PopupMenu2Popup; //00618938
    procedure DBComboBox7Exit(Sender:TObject); //00618A30
    procedure ComboBox5Exit(Sender:TObject); //006183B8
    procedure Lb_speich(ATabelle: Integer); //006184B0
    procedure DBEdit9Change(Sender: TObject); //006180C8
    procedure Image2Click(Sender:TObject); //00614074
    procedure TabSheet9Show(Sender:TObject); //00615FD8
    procedure Basen1Click(Sender:TObject); //0061182C
    procedure TabSheet2Show(Sender:TObject); //00614068
    procedure DBEdit5MouseDown(Sender:TObject; Button:TMouseButton; Shift:TShiftState; X:Integer; Y:Integer); //006180BC
    procedure DBEdit8Change(Sender: TObject); //006180C4
    procedure TabSheet9Exit(Sender:TObject); //00617F78
    procedure ComboBox4DblClick(Sender:TObject); //006180B8
    procedure Vorlist; //00607C78
    procedure DBLookupComboBox6KeyPress(Sender: TObject; var Key: Char); //0060746C
    procedure DBLookupComboBox7KeyPress(Sender: TObject; var Key: Char); //006074AC
    procedure DBLookupComboBox4KeyPress(Sender: TObject; var Key: Char); //006073EC
    procedure DBLookupComboBox5KeyPress(Sender: TObject; var Key: Char); //0060742C
    procedure DBLookupComboBox10KeyPress(Sender: TObject; var Key: Char); //006074FC
    procedure DBLookupComboBox11KeyPress(Sender: TObject; var Key: Char); //00607504
    procedure DBLookupComboBox8KeyPress(Sender: TObject; var Key: Char); //006074EC
    procedure DBLookupComboBox9KeyPress(Sender: TObject; var Key: Char); //006074F4
    procedure Einzelpersonen1Click(Sender:TObject); //006073B8
    procedure DBLookupComboBox11Enter(Sender: TObject); //00606D9C
    procedure DBLookupComboBox1Enter(Sender: TObject); //00606DA0
    procedure DBLookupComboBox9Enter(Sender: TObject); //00606D94
    procedure DBLookupComboBox10Enter(Sender: TObject); //00606D98
    procedure NichtverknpfteBeziehungen1Click(Sender:TObject); //00606DAC
    procedure DoppelteEintrge1Click(Sender:TObject); //00607310
    procedure DBLookupComboBox2Enter(Sender: TObject); //00606DA4
    procedure DBLookupComboBox3Enter(Sender: TObject); //00606DA8
    procedure DBLookupComboBox18KeyPress(Sender: TObject; var Key: Char); //00607704
    procedure DBLookupComboBox19KeyPress(Sender: TObject; var Key: Char); //00607744
    procedure DBLookupComboBox13KeyPress(Sender: TObject; var Key: Char); //00607684
    procedure DBLookupComboBox14KeyPress(Sender: TObject; var Key: Char); //006076C4
    procedure DBLookupComboBox22KeyPress(Sender: TObject; var Key: Char); //0060781C
    procedure bernehmen1Click(Sender:TObject); //0060785C
    procedure DBLookupComboBox20KeyPress(Sender: TObject; var Key: Char); //0060778C
    procedure DBLookupComboBox21KeyPress(Sender: TObject; var Key: Char); //006077D4
    procedure DBLookupComboBox12KeyPress(Sender: TObject; var Key: Char); //00607644
    procedure ComboBox3KeyPress(Sender:TObject; var Key:Char); //0060759C
    procedure DBLookupComboBox1KeyPress(Sender: TObject; var Key: Char); //006075E4
    procedure ComboBox1KeyPress(Sender:TObject; var Key:Char); //0060750C
    procedure ComboBox2KeyPress(Sender:TObject; var Key:Char); //00607554
    procedure DBLookupComboBox16KeyPress(Sender: TObject; var Key: Char); //006075FC
    procedure DBLookupComboBox17KeyPress(Sender: TObject; var Key: Char); //0060763C
    procedure DBLookupComboBox2KeyPress(Sender: TObject; var Key: Char); //006075EC
    procedure DBLookupComboBox3KeyPress(Sender: TObject; var Key: Char); //006075F4
    procedure DBEdit8Exit(Sender:TObject); //005E5CF0
    procedure DBEdit13Exit(Sender:TObject); //005E5E28
    procedure DBEdit22Exit(Sender:TObject); //005E5AC8
    procedure DBEdit9Exit(Sender:TObject); //005E5B50
    procedure DBEdit16Exit(Sender:TObject); //005E5F70
    procedure DBEdit21Exit(Sender:TObject); //005E60A8
    procedure DBEdit12Exit(Sender:TObject); //005E5E30
    procedure DBEdit17Exit(Sender:TObject); //005E5E38
    procedure DBEdit18Exit(Sender:TObject); //005E593C
    procedure wt35; //005D8024
    procedure wt36; //005D813C
    procedure wt33; //005D7DF4
    procedure wt34; //005D7F0C
    procedure wt39; //005D8484
    procedure DBEdit14Exit(Sender:TObject); //005E57B0
    procedure wt37; //005D8254
    procedure wt38; //005D836C
    procedure Verbindungeinfgen1Click(Sender:TObject); //005E844C
    procedure DBGrid2DblClick(Sender:TObject); //005E89E8
    procedure Kinderentfernen1Click(Sender:TObject); //005E7870
    procedure Kindereinfgen1Click(Sender:TObject); //005E7A14
    procedure StringGrid3Click(Sender:TObject); //005E9118
    procedure TabSheet4Exit(Sender:TObject); //005E9330
    procedure TabSheet7MouseDown(Sender:TObject; Button:TMouseButton; Shift:TShiftState; X:Integer; Y:Integer); //005E8F94
    procedure TabSheet4Enter(Sender:TObject); //005E8FC4
    procedure beenden1Click(Sender:TObject); //005E7844
    procedure TabSheet1MouseDown(Sender:TObject; Button:TMouseButton; Shift:TShiftState; X:Integer; Y:Integer); //005E62D4
    procedure ucase(AAnsiString: AnsiString; AFormat: Integer); //005D7AA8
    procedure DBEdit20Exit(Sender:TObject); //005E60B0
    procedure Verbindunglschen1Click(Sender:TObject); //005E60B8
    procedure StringGrid4DblClick(Sender:TObject); //005E7654
    procedure DBGrid1KeyDown(Sender:TObject; var Key:Word; Shift:TShiftState); //005E7728
    procedure TabSheet5Enter(Sender:TObject); //005E683C
    procedure geschw(A1, A2, A3, A4, A5, A6, A7, A8, A9, A10: Integer); //005E6304
    procedure datcheck(AMode: Integer; AShow: Boolean; AText: AnsiString); //005D859C
    procedure kinderanz; //005D6E2C
    procedure eltanz; //005D76D0
    procedure StringGrid1DblClick(Sender:TObject); //005D93E8
    procedure StringGrid2DblClick(Sender:TObject); //005D94C0
    procedure Edit1DblClick(Sender:TObject); //005DCBD4
    procedure Edit2DblClick(Sender:TObject); //005DCC94
    procedure DatensatzNr1Click(Sender:TObject); //005D9598
    procedure Prfen1Click(Sender:TObject); //005D9778
    procedure DBNavigator1Click(Sender:TObject); //005D93B8
    procedure neu1Click(Sender:TObject); //005D8B60
    procedure speich1; //005D78BC
    procedure FormCreate(Sender:TObject); //005D4E28
    procedure FormClose(Sender:TObject; var Action:TCloseAction); //005D879C
    procedure ehenanz; //005D6604
    procedure FormShow(Sender:TObject); //005D92AC
    procedure schen1Click(Sender:TObject); //005D8E30
    procedure DBNavigator1BeforeAction; //005D92A4
    procedure DBGrid1DblClick(Sender:TObject); //005E2C2C
    procedure anzeigen; //005D42BC
    procedure FormKeyPress(Sender:TObject; var Key:Char); //005E28AC
    procedure TabSheet6Enter(Sender:TObject); //005E28CC
    procedure IDslschen1Click(Sender:TObject); //005E53B4
    procedure DBEdit10Exit(Sender:TObject); //005E5624
    procedure TabSheet1Exit(Sender:TObject); //005E4FB0
    procedure IDSatznr1Click(Sender:TObject); //005E4FC4
    procedure Datenlschen1Click(Sender:TObject); //005E2064
    procedure Sikoein; //005DF5EC
    procedure tabdisab; //005D8754
    procedure lab18ein; //005D8704
    procedure datsich; //005DCD54
    procedure Datensichern1Click(Sender:TObject); //005E1DC0
    procedure alineu(AAnsiString: AnsiString); //005E1DF8
    procedure tabenab; //005D8778
    procedure SicherungsDateieinlesen1Click(Sender:TObject); //005E1D2C
    procedure ChristlicheNamenstage1Click(Sender:TObject); //005FA138
    procedure FamGrafik1Click(Sender:TObject); //005FA868
    procedure famblattx_daten; //005F2F6C
    procedure Osterberechnung1Click(Sender:TObject); //005FA0EC
    procedure entfernen1Click(Sender:TObject); //005FAFD4
    procedure Listenaktualisieren1Click(Sender:TObject); //005FB1A0
    procedure einfgen1Click(Sender:TObject); //005FA898
    procedure UpDown1Click(Sender: TObject); //005FAC9C
    procedure FamblHTML; //005F53E4
    procedure allePersonen1Click(Sender:TObject); //005F0AA4
    procedure Probandenname1Click(Sender:TObject); //005F26E0
    procedure StringGrid2RowMoved; //005EFD84
    procedure frbestimmtenOrt1Click(Sender:TObject); //005F02D8
    procedure Browser1Click(AUrl: AnsiString); //005F2F00
    procedure FormResize(Sender:TObject); //005F2F3C
    procedure allePersonen2Click(Sender:TObject); //005F2E20
    procedure Browser; //005F2E6C
    procedure OFBDruck1Click(Sender:TObject); //005FC700
    procedure alleBilderentfernen1Click(Sender:TObject); //005FCB20
    procedure sdx(A1, A2, A3, A4, A5, A6, A7, A8, A9: Integer); //005D34D8
    procedure FOKODateieditieren1Click(Sender:TObject); //005FC67C
    procedure GedcomDateieinlesen1Click(Sender:TObject); //005FCDA0
    procedure GedcomDateischreiben1Click(Sender:TObject); //005FD330
    procedure bild_entf; //005FC794
    procedure bmpjpg1Click(Sender:TObject); //005FCC0C
    procedure inyTafelerstellen1Click(Sender:TObject); //005FC5B0
    procedure Familienblatt2Click(Sender:TObject); //005FB580
    procedure Famblatt; //005FB604
    procedure Grafik1Click(Sender:TObject); //005FB294
    procedure Grafikneu1Click(Sender:TObject); //005FB3CC
    procedure Liste1Click(Sender:TObject); //005FBEAC
    procedure FOKODateierstellen1Click(Sender:TObject); //005FC4F0
    procedure showpreview(AForm: Integer); //005FBD5C
    procedure GlobaleSuche1Click(Sender:TObject); //005FBD98
    procedure StringGrid1RowMoved; //005EFBF4
    procedure PopupMenu3Popup; //005EB760
    procedure PopupMenu4Popup; //005EB870
    procedure elem; //005E8284
    procedure elem_leer; //005E81BC
    procedure Vatereinfgen1Click(Sender:TObject); //005EBB58
    procedure Muttereinfgen1Click(Sender:TObject); //005EBEB0
    procedure Vaterentfernen1Click(Sender:TObject); //005EB980
    procedure Mutterentfernen1Click(Sender:TObject); //005EBA6C
    procedure DBEdit2Exit(Sender:TObject); //005EB534
    procedure aus1Click(Sender:TObject); //005E9B54
    procedure Datenschutzein1Click(Sender:TObject); //005E9D04
    procedure roem(ANummer: Integer; AFlag: Boolean); //005E2CA4
    procedure ID1Click(Sender:TObject); //005E98B0
    procedure DBEdit33Exit(Sender:TObject); //005EB1C4
    procedure TabSheet3Enter(Sender:TObject); //005EB350
    procedure Datenschutzaus1Click(Sender:TObject); //005EA0B0
    procedure TabSheet3Exit(Sender:TObject); //005EA2B8
    procedure anzeigen1Click(Sender:TObject); //005EF6DC
    procedure GregorianischerKalender1Click(Sender:TObject); //005EF700
    procedure StringGrid5KeyDown(Sender:TObject; var Key:Word; Shift:TShiftState); //005EF604
    procedure StringGrid5DblClick(Sender:TObject); //005EF620
    procedure Hausname1Click(Sender:TObject); //005EF944
    procedure drucken2Click(Sender: TObject); //005D3ED0
    procedure FrzRevolutionskalender1Click(Sender:TObject); //005EF778
    procedure zuAHNENWIN1Click(Sender:TObject); //005EF7F0
    procedure Partnersuche1Click(Sender:TObject); //005EED2C
    procedure DBEdit45Exit(Sender:TObject); //005EC2E4
    procedure DBEdit63Exit(Sender:TObject); //005EC36C
    procedure TabSheet2Enter(Sender:TObject); //005EC208
    procedure DBEdit37Exit(Sender:TObject); //005EC25C
    procedure Bildschirmdrucken1Click(Sender:TObject); //005EC6C4
    procedure ExcelExport1Click(Sender:TObject); //005EC774
    procedure Name1Click(Sender:TObject); //005EC3F4
    procedure Druckereinstellung1Click(Sender:TObject); //005EC69C
  end;

var
  Form1: TForm1;

implementation

uses
  AHNGlobals, Windows, Printers, Unit2, Unit8;
{$R ..\Forms\Form1.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm1.listen_akt;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ComboBox1Exit;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox17Exit;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox16Exit;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet2Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox12MouseDown;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ComboBox2Exit;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ComboBox3Exit;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet7Enter(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.FamilienblattHTML1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.OrtsDatei1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit69Change;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.PopupMenu1Popup;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.gridanp;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.NamensListeeditieren1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox4MouseDown;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox17MouseDown;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Einzelpersonenmarkieren1Click;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox4Enter;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBGrid3Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBGrid3KeyDown(Sender:TObject; var Key:Word; Shift:TShiftState);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox7Enter;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox8Enter;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox5Enter;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox6Enter;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBGrid3DblClick(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.QuellenListeeditieren1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Quellesuchen1Click;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox19MouseDown;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox19Click;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBComboBox3Change;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBComboBox3Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.drucken1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.QRDefault;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.druck;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.vorf_erm2;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Hilfe1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.GrafikI1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Grafikalt1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.allePersonen3Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Basisahnen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Listen;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Proband1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ehtest;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Adressendateischreiben1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet8Enter(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Listen2Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Button1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.geschachtelt1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.geb_sterb;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.AHNENDOSeinlesen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.OSBeinlesen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Edit13Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.PageControl1Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Edit6Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Edit10Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.FormActivate(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBCheckBox1Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ComboBox5Change;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit47Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit55Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.aspitz;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.pspitz;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.spitzbas;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.basahnen;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit44Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit52Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit40Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit7Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Quellenliste1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet1Show(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.fcapt;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Fenstertitelndern1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.HofnamenVerwaltung1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Vettern1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Verwandtschaft1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit6Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.EhenKiordnen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ComboBox20Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ComboBox11Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.StringGrid5MouseDown(Sender:TObject; Button:TMouseButton; Shift:TShiftState; X:Integer; Y:Integer);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ComboBox4Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit32Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet4Show(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.BerufeVerwaltung1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit3Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.GebDatumTaufdatum1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBComboBox1Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit10Change;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBMemo1Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.PopupMenu2Popup;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBComboBox7Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ComboBox5Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Lb_speich;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit9Change;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Image2Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet9Show(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Basen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet2Show(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit5MouseDown(Sender:TObject; Button:TMouseButton; Shift:TShiftState; X:Integer; Y:Integer);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit8Change;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet9Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ComboBox4DblClick(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Vorlist;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox6KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox7KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox4KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox5KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox10KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox11KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox8KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox9KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Einzelpersonen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox11Enter;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox1Enter;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox9Enter;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox10Enter;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.NichtverknpfteBeziehungen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DoppelteEintrge1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox2Enter;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox3Enter;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox18KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox19KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox13KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox14KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox22KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.bernehmen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox20KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox21KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox12KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ComboBox3KeyPress(Sender:TObject; var Key:Char);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox1KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ComboBox1KeyPress(Sender:TObject; var Key:Char);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ComboBox2KeyPress(Sender:TObject; var Key:Char);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox16KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox17KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox2KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox3KeyPress;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit8Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit13Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit22Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit9Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit16Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit21Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit12Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit17Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit18Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.wt35;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.wt36;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.wt33;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.wt34;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.wt39;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit14Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.wt37;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.wt38;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Verbindungeinfgen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBGrid2DblClick(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Kinderentfernen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Kindereinfgen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.StringGrid3Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet4Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet7MouseDown(Sender:TObject; Button:TMouseButton; Shift:TShiftState; X:Integer; Y:Integer);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet4Enter(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.beenden1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet1MouseDown(Sender:TObject; Button:TMouseButton; Shift:TShiftState; X:Integer; Y:Integer);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ucase;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit20Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Verbindunglschen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.StringGrid4DblClick(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBGrid1KeyDown(Sender:TObject; var Key:Word; Shift:TShiftState);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet5Enter(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.geschw;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.datcheck;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.kinderanz;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.eltanz;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.StringGrid1DblClick(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.StringGrid2DblClick(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Edit1DblClick(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Edit2DblClick(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DatensatzNr1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Prfen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBNavigator1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.neu1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.speich1;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  OsVersion: TOsVersionInfo;
  Faktor: Double;
  i: Integer;
  h: Integer;
begin
  { The directory of the program is remembered in the global string
    gvar_02536B9C; it is the base for the help file, for the alias of the
    BDE and for the configuration file. }
  gvar_02536B9C := ExtractFilePath(ParamStr(0));

  { The title and the help file depend on the Windows version: from Windows
    2000 on the program uses the compiled help file, before that the old
    help file. On a system that does not know GetVersionEx at all the
    except branch sets a blank help file. }
  try
    OsVersion.dwOSVersionInfoSize := SizeOf(OsVersion);
    GetVersionEx(OsVersion);
    if OsVersion.dwMajorVersion >= 6 then
    begin
      Application.Title := 'AHNENWIN 5.1';
      Application.HelpFile := gvar_02536B9C + 'AHNWIN50.chm';
    end
    else
    begin
      Application.Title := 'AHNENWIN 5.1';
      Application.HelpFile := gvar_02536B9C + 'AHNWIN51.HLP';
    end;
  except
    Application.Title := 'AHNENWIN 5.1';
    Application.HelpFile := gvar_02536B9C + ' ';
  end;

  { The screen dimensions at the moment of the start are remembered, they
    are the reference for the scaling of the other forms. }
  gvar_02536BA8 := Screen.Height;
  gvar_02536BAC := Screen.Width;
  gvar_02536BA4 := Height;

  { The directory for the pictures of the family chart.

    The listing calls a function of the VCL that reports whether the
    directory exists - FileExists would return false for a directory, so
    DirectoryExists is the equivalent that matches the behaviour of the
    original. }
  if not DirectoryExists('Bilder') then
    if not CreateDir('Bilder') then
      raise Exception.Create('Verzeichnis Bilder kann nicht erstellt werden');

  UpDown1.Visible := False;

  { The BDE is configured for the directory of the program: the tables
    are found through the standard alias "PARADOX". The configuration mode
    cfmSession (the value 4 of the listing) keeps the alias for the
    session only. }
  gvar_0253692C := 'crea';
  gvar_02536B9C := ExtractFilePath(ParamStr(0));
  Session.ConfigMode := [cfmSession];
  Session.AddStandardAlias(' ', gvar_02536B9C, 'PARADOX');
  Application.CreateForm(TDataModule2, DataModule2);

  alineu(' ');

  { The program needs a printer; the list of the installed printers is
    shown in the memo while it is checked. }
  Memo1.Clear;
  Memo1.Lines := Printer.Printers;
  if Trim(Memo1.Lines[0]) = '' then
  begin
    ShowMessage('Bitte zuerst einen Drucker installieren.');
    Halt(0);
  end;
  Memo1.Clear;

  { The form is scaled to the screen, and the row height and the column
    widths of the five month grids are taken from the height of the edit
    field. The listing multiplies the column widths with the factor 1.0;
    the value is kept as it is. }
  Scaled := True;
  Faktor := 1.0;

  StringGrid1.DefaultRowHeight := DBEdit2.Height - 2;
  for i := 0 to 5 do
    StringGrid1.ColWidths[i] := Round(StringGrid1.ColWidths[i] * Faktor);

  StringGrid2.DefaultRowHeight := DBEdit2.Height - 2;
  for i := 0 to 5 do
    StringGrid2.ColWidths[i] := Round(StringGrid2.ColWidths[i] * Faktor);

  StringGrid3.DefaultRowHeight := DBEdit2.Height - 2;
  for i := 0 to 4 do
    StringGrid3.ColWidths[i] := Round(StringGrid3.ColWidths[i] * Faktor);

  StringGrid4.DefaultRowHeight := DBEdit2.Height - 2;
  for i := 0 to 4 do
    StringGrid4.ColWidths[i] := Round(StringGrid4.ColWidths[i] * Faktor);

  StringGrid5.DefaultRowHeight := DBEdit2.Height - 2;
  for i := 0 to 3 do
    StringGrid5.ColWidths[i] := Round(StringGrid5.ColWidths[i] * Faktor);

  { The password of the Paradox tables. }
  Session.AddPassword('hheerrii');

  { The five edit fields for the unused import are put behind. }
  Edit3.SendToBack;
  Edit7.SendToBack;
  Edit11.SendToBack;
  Edit12.SendToBack;
  Edit16.SendToBack;

  { The dates of the program file and of the database are shown in the
    about box.

    The original opens both files without checking the result. When a file
    is missing, FileOpen returns -1 and FileGetDate(-1) returns -1, so
    FileDateToDateTime raises EConvertError ("Ungueltiges Argument zum
    Codieren des Datums"). The reconstruction checks the handle, uses the
    date when the file is there and falls back to 0 (the epoch) when it is
    not, so that the program starts without a database as well. The file
    handles are closed in every case - the original closes them too. }
  h := FileOpen('AHNWIN51.exe', 64);
  if h >= 0 then
  begin
    gvar_02536924 := FileDateToDateTime(FileGetDate(h));
    FileClose(h);
  end
  else
    gvar_02536924 := 0;

  h := FileOpen('awd.db', 64);
  if h >= 0 then
  begin
    gvar_0253691C := FileDateToDateTime(FileGetDate(h));
    FileClose(h);
  end
  else
    gvar_0253691C := 0;

  Application.ShowHint := True;

  { The tables of the database are opened. Table1 and Table5 are opened
    exclusively for a moment, so that the maximum number of the persons
    can be read. }
  DataModule2.Table1.Exclusive := True;
  DataModule2.Table1.Exclusive := False;
  DataModule2.Table1.Open;
  DataModule2.Table1.IndexName := '';
  DataModule2.Table1.Last;
  gvar_0253690C := DataModule2.Table1Nummer.AsInteger + 1;
  DataModule2.Table1.First;

  DataModule2.Table2.Open;
  DataModule2.Table3.Open;
  DataModule2.Table3.IndexName := '';
  DataModule2.Table4.Open;
  DataModule2.Table4.IndexName := '';

  DataModule2.Table5.Exclusive := True;
  DataModule2.Table5.Exclusive := False;
  DataModule2.Table5.Open;
  DataModule2.Table5.IndexName := 'num';
  DataModule2.Table6.Open;
  DataModule2.Table6.IndexName := '';
  DataModule2.Table7.Open;
  DataModule2.Table7.IndexName := 'vat';
  DataModule2.Table8.Open;
  DataModule2.Table8.IndexName := '';
  DataModule2.Table9.Open;
  DataModule2.Table9.IndexName := '';
  DataModule2.Table10.Open;
  DataModule2.Table10.IndexName := '';
  DataModule2.Table11.Open;
  DataModule2.Table11.IndexName := '';

  { The name list fills two of the combo boxes. }
  DataModule2.Table12.Exclusive := True;
  DataModule2.Table12.Exclusive := False;
  DataModule2.Table12.Open;
  ComboBox4.Clear;
  ComboBox10.Clear;
  DataModule2.Table12.First;
  while not DataModule2.Table12.Eof do
  begin
    ComboBox4.Items.Add(DataModule2.Table12Name.AsString);
    ComboBox10.Items.Add(DataModule2.Table12Name.AsString);
    DataModule2.Table12.Next;
  end;

  { The places fill the remaining combo boxes - but only when they are not
    filled already. }
  DataModule2.Table13.Open;
  DataModule2.Table13.First;
  if ComboBox6.Items.Count < 2 then
  begin
    ComboBox6.Clear;
    ComboBox1.Clear;
    ComboBox2.Clear;
    ComboBox3.Clear;
    ComboBox7.Clear;
    ComboBox8.Clear;
    ComboBox9.Clear;
    ComboBox16.Clear;
    ComboBox17.Clear;
    ComboBox18.Clear;
    ComboBox19.Clear;
    ComboBox20.Clear;
    ComboBox21.Clear;
    ComboBox22.Clear;
    ComboBox23.Clear;
    ComboBox24.Clear;
    ComboBox25.Clear;
    DataModule2.Table13.First;
    while not DataModule2.Table13.Eof do
    begin
      ComboBox6.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox1.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox2.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox3.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox7.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox8.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox9.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox16.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox17.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox18.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox19.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox20.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox21.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox22.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox11.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox12.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox13.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox14.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox15.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox23.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox24.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox25.Items.Add(DataModule2.Table13Ort.AsString);
      DataModule2.Table13.Next;
    end;
  end;

  { The sources of the current person are shown in the combo boxes. }
  DataModule2.Table37.Open;
  DataModule2.Table37.First;
  ComboBox12.Text := DataModule2.Table1Quellet.AsString;
  ComboBox13.Text := DataModule2.Table1Quelles.AsString;
  ComboBox14.Text := DataModule2.Table1Quelleb.AsString;
  ComboBox15.Text := DataModule2.Table1Quelle.AsString;

  { The fifth grid is only used while the calendar is shown. }
  StringGrid5.Visible := False;

  { One entry of the menu is removed. }
  MainMenu1.Items[3].Items[5].Visible := False;

  { The splash screen is closed. }
  Form8.Close;

  { The window caption is taken from the configuration file "par.cfg"; it
    holds a short string of up to 50 characters. When the file does not
    exist, it is created and the caption of the form is kept. }
  if FileExists(gvar_02536B9C + 'par.cfg') then
  begin
    gvar_02536BB0 := TFileStream.Create(gvar_02536B9C + 'par.cfg', fmOpenRead);
    gvar_02536BB0.ReadBuffer(gvar_02536BB4, 51);
  end
  else
    gvar_02536BB0 := TFileStream.Create(gvar_02536B9C + 'par.cfg', fmCreate);

  Caption := gvar_02536BB4;
  Application.Title := gvar_02536BB4;
  gvar_02536BB0.Free;

  DataModule2.Table1.Edit;
  DataModule2.Table5.Edit;
end;


procedure TForm1.FormClose(Sender:TObject; var Action:TCloseAction);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ehenanz;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.FormShow(Sender:TObject);
begin
  { The listing calls Table1Nummer.GetAsInteger and discards the result.
    The value was assigned to a local variable that the compiler removed
    because it was never used. }
  DataModule2.Table1Nummer.AsInteger;

  { The factor for the scaling of the display and the number of lines
    that are calculated from it. }
  gvar_0061F120 := 1.9;
  gvar_0061F11C := Round(gvar_0061F120 * 6);

  PageControl1.ActivePage := TabSheet2;

  { Without persons in the table the entry for a new person is not
    possible. }
  if DataModule2.Table1.RecordCount < 1 then
    neu1.Enabled := False;

  { The tables of the places, of the titles and of the notes are opened
    and positioned on their first record. }
  DataModule2.Table12.Open;
  DataModule2.Table12.First;
  DataModule2.Table38.Open;
  DataModule2.Table38.IndexName := 'tit';
  DataModule2.Table38.First;
  DataModule2.Table13.Open;
  DataModule2.Table13.First;

  DBGrid3.Visible := False;
  Label81.Visible := False;

  anzeigen;
end;

procedure TForm1.schen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBNavigator1BeforeAction;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBGrid1DblClick(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.anzeigen;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.FormKeyPress(Sender:TObject; var Key:Char);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet6Enter(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.IDslschen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit10Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet1Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.IDSatznr1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Datenlschen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Sikoein;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.tabdisab;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.lab18ein;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.datsich;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Datensichern1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.alineu;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.tabenab;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.SicherungsDateieinlesen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ChristlicheNamenstage1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.FamGrafik1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.famblattx_daten;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Osterberechnung1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.entfernen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Listenaktualisieren1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.einfgen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.UpDown1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.FamblHTML;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.allePersonen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Probandenname1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.StringGrid2RowMoved;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.frbestimmtenOrt1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Browser1Click;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.FormResize(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.allePersonen2Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Browser;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.OFBDruck1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.alleBilderentfernen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.sdx;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.FOKODateieditieren1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.GedcomDateieinlesen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.GedcomDateischreiben1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.bild_entf;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.bmpjpg1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.inyTafelerstellen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Familienblatt2Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Famblatt;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Grafik1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Grafikneu1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Liste1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.FOKODateierstellen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.showpreview;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.GlobaleSuche1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.StringGrid1RowMoved;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.PopupMenu3Popup;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.PopupMenu4Popup;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.elem;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.elem_leer;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Vatereinfgen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Muttereinfgen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Vaterentfernen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Mutterentfernen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit2Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.aus1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Datenschutzein1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.roem;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ID1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit33Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet3Enter(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Datenschutzaus1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet3Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.anzeigen1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.GregorianischerKalender1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.StringGrid5KeyDown(Sender:TObject; var Key:Word; Shift:TShiftState);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.StringGrid5DblClick(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Hausname1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.drucken2Click;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.FrzRevolutionskalender1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.zuAHNENWIN1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Partnersuche1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit45Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit63Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet2Enter(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBEdit37Exit(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Bildschirmdrucken1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ExcelExport1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Name1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Druckereinstellung1Click(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;


end.

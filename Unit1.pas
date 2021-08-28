unit Unit1;
interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,System.DateUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Effects, FMX.Controls.Presentation, FMX.StdCtrls, System.ImageList,
  FMX.ImgList, System.Actions, FMX.ActnList, FMX.Gestures ,  FMX.Platform ,btconfig,
  FMX.Objects, FMX.Ani , FMX.Layouts, FMX.ListBox, FMX.ScrollBox, FMX.Memo,
  FMX.Edit,FMX.SpinBox , FMXTee.Engine, FMXTee.Procs,FMXTee.Chart, FMXTee.Series,
  FMX.Memo.Types;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    MaterialOxfordBlueSB: TStyleBook;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    intestazione: TLabel;
    GestureManager1: TGestureManager;
    ActionList1: TActionList;
    NextTabAction1: TNextTabAction;
    PreviousTabAction1: TPreviousTabAction;
    prlistbox: TListBox;
    Layout1: TLayout;
    Layout2: TLayout;
    Text1: TText;
    Text2: TText;
    ToastLayout: TLayout;
    MessageRect: TRoundRect;
    ShadowEffect1: TShadowEffect;
    MsgText: TText;
    Panel_Quit: TPanel;
    QuitButton: TButton;
    Layout3: TLayout;
    services_cb: TComboBox;
    Layout6: TLayout;
    btn_connetti: TButton;
    Layout7: TLayout;
    Memo1: TMemo;
    Layout9: TLayout;
    btn_clear: TButton;
    btn_send: TButton;
    sendcmd: TEdit;
    calypso: TStyleBook;
    WedgewoodLightSB: TStyleBook;
    btnset: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure QuitButtonClick(Sender: TObject);
    procedure btn_connettiClick(Sender: TObject);
    procedure services_cbChange(Sender: TObject);
    procedure btn_clearClick(Sender: TObject);
    procedure btn_sendClick(Sender: TObject);
    procedure btnsetClick(Sender: TObject);
  private
    { Private declarations }
    SListPairedDevices : TStringList;       //
    TargetPaireNo : integer;                //
    CurDeviceServices : DServiceListType;   //
    procedure ServicesList_Add();
    procedure PairedDevices_AddListBox;
    procedure PrListItem_MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure ToastMessage_On(msg: string);
    procedure ToastMessage_Off(msg: string);
    procedure Panel_Quit_Display_OnOFF(On_Off: boolean);

    procedure start_receive;

    PROCEDURE MyButtonClick(Sender: TObject);
    procedure Myswitch_change(Sender: TObject);
    procedure Myswitch1_change(Sender: TObject);
    procedure Mycheckbox_change(Sender: TObject);
    procedure Myspinbox_change(Sender: TObject);
    procedure Myselector_change(Sender: TObject);
  public
    { Public declarations }
  end;
var
  Form1: TForm1;
implementation
{$IFDEF ANDROID}
Uses
  Androidapi.Helpers,
  Androidapi.JNI.GraphicsContentViewText;
{$ENDIF}


var
  BTMethod : TBTMethod;
  bt_on:boolean;

  cmds:TStringlist;
  kcmp:string; //parte del nome dei componenti generati dinamicamente
               //inserito per evitare conflitti con i componenti del programma
  var tipobool:char; // B: true/false e:ON OFF N:1 0

{$R *.fmx}
{$ZEROBASEDSTRINGs ON}
function Sostchar(ch ,ch1: Char; st : string) : string;
var
   wks : string;
   i   : integer;
begin
   wks:='';
   if low(st)>-1 then
   for i:= low(st) to high(st) do
    if st[i]<>ch then wks:=wks+st.chars[i]
                 else wks:=wks+ch1;
   SostChar := wks;
end;

function toglichar_(st : string) : string;
var
   wks : string;
   i   : integer;
   ch,ch1:Char;
begin
   wks:='';

   ch :='_';
   ch1:=' ';

   if low(st)>-1 then
   for i:= low(st) to high(st) do
    if st[i]<>ch then wks:=wks+st.chars[i]
                 else wks:=wks+ch1;
   toglichar_:= wks;
end;

FUNCTION realtostr(F : Extended ; MaxDecimals : BYTE) : STRING;
var ff:string;
BEGIN
    ff:=Format('%.'+IntToStr(MaxDecimals)+'f',[F]);
    WHILE ff[LENGTH(ff)]='0' DO SetLength(ff,PRED(LENGTH(ff)));
    IF ff[LENGTH(ff)] IN ['.',','] THEN SetLength(ff,PRED(LENGTH(ff)));

    Result:=Sostchar(',','.',ff);
END;

function booltostr(bb:boolean):string;
begin
  case tipobool of
   'B': if bb then result:='TRUE'
              else Result:='FALSE';
   'E': if bb then result:='ON'
              else Result:='OFF';
   'N': if bb then result:='1'
              else Result:='0';
  end;
end;

function strtobool(st:string):boolean;
begin
 (* case tipobool of
   'B': if st='TRUE' then result:=true
                     else Result:=FALSE;
   'E': if st='ON'   then result:=true
                     else Result:=FALSE;
   'N': if st='1'    then result:=true
                     else Result:=false;
  end; *)

 if (st='TRUE')or(st='1')or(st='ON') then Result:=True
                                     else result:=False;

end;

procedure TForm1.MyButtonClick(Sender: TObject);
var
  Button: TButton;
  str:string;

begin
  Button := Sender as TButton;
  str:= Button.Name;
  str:= stringreplace(str, kcmp, '',[rfReplaceAll, rfIgnoreCase]);

  BTMethod.SendData( TargetPaireNo,str+#13);

  //ShowMessage(Button.TEXT + ' clicked');
end;
procedure TForm1.Myswitch_change(Sender: TObject);
var
  swt: Tswitch;
  str:string;

begin
  swt := Sender as Tswitch;
  str:= swt.Name;
  str:= stringreplace(str, kcmp, '',[rfReplaceAll, rfIgnoreCase]);

  BTMethod.SendData( TargetPaireNo,str+':'+booltostr(swt.IsChecked)+#13);
  //ShowMessage(swt.TEXT + ' changed' );
end;
procedure TForm1.Mycheckbox_change(Sender: TObject);
var
  swt: TCheckBox;
  str:string;

begin
  swt := Sender as TCheckBox;
  str:= swt.Name;
  str:= stringreplace(str, kcmp, '',[rfReplaceAll, rfIgnoreCase]);

  BTMethod.SendData( TargetPaireNo,str+':'+booltostr(swt.IsChecked)+#13);
  //ShowMessage(swt.TEXT + ' changed' );
end;
procedure TForm1.Myswitch1_change(Sender: TObject);
var
  swt: ttrackbar;
  str:string;

  tin:boolean;

begin
  swt := Sender as ttrackbar;
  str:= swt.Name;
  str:= stringreplace(str, kcmp, '',[rfReplaceAll, rfIgnoreCase]);

  if swt.Value=0 then tin:=false
                 else tin:=True;

  BTMethod.SendData( TargetPaireNo,str+':'+booltostr(tin)+#13);
  //ShowMessage(swt.TEXT + ' changed' );
end;

procedure TForm1.Myspinbox_change(Sender: TObject);
var
  swt: tspinbox;
  str:string;

begin
  swt := Sender as tspinbox;
  str:= swt.Name;
  str:= stringreplace(str, kcmp, '',[rfReplaceAll, rfIgnoreCase]);

  BTMethod.SendData( TargetPaireNo,str+':'+realtostr(swt.value,0)+#13);
  //ShowMessage(swt.TEXT + ' changed' );
end;
procedure TForm1.Myselector_change(Sender: TObject);
var
  swt: TTrackBar;
  str:string;

begin
  swt := Sender as ttrackbar;
  str:= swt.Name;
  str:= stringreplace(str, kcmp, '',[rfReplaceAll, rfIgnoreCase]);

  BTMethod.SendData( TargetPaireNo,str+':'+realtostr(swt.value,0)+#13);
  //ShowMessage(swt.TEXT + ' changed' );
end;

function solosolonum(ag:string):string;
var ag1:string;
    ag3:byte;
begin
 ag1:='';
 if high(ag)>-1 then
   for ag3:=low(ag) to high(ag) do
    if ag[ag3] in['0'..'9'] then ag1:=ag1+ag.chars[ag3];

 if ag1='' then ag1:='0';
 solosolonum:=ag1;
end;

function solonum(ag:string):string;
var ag1:string;
    ag3:byte;
begin
 ag1:='';
 if high(ag)>-1 then
   for ag3:=low(ag) to high(ag) do
    if ag.chars[ag3] in['0'..'9','-','.'] then ag1:=ag1+ag.chars[ag3];

 if ag1='' then ag1:='0';
 solonum:=ag1;
end;


function StripChar(ch : Char; st : string) : string;
var
   wks : string;
   i   : integer;
begin
   wks:='';
   for i:=low(st) to high(st) do
    if st.chars[i]<>ch then wks:=wks+st.chars[i] ;
   StripChar := wks;
end;

FUNCTION REPLICATE(rn:byte;rc:char):STRING;
var rx:string;
    rn1:byte;
begin
 rx:='';
 for rn1:=1 to rn do rx:=rx+rc;
 result:=rx;
end;

function allinean(an1:string;am:byte):string;
var dn:byte;
    an:string;
begin
 an:=StripChar(' ',an1);
 dn:=am-high(an)-1;
 result:=Replicate(dn,'0')+an;
end;

function allineaS(an1:string;am:byte):string;
var dn:byte;
    an:string;
begin
 an:=StripChar(' ',an1);
 dn:=am-high(an)-1;
 result:=Replicate(dn,' ')+an;
end;

function allineaSX(an1:string;am:byte):string;
var dn:byte;
    an:string;
begin
 an:=an1;//StripChar(' ',an1);
 dn:=am-high(an)-1;
 result:=an+Replicate(dn,' ');
end;

function AllCaps(t : string) : string;
var
   i : integer;
   l : integer;
   s : string;
begin
   S:='';
   if low(t)>-1 then
   for l:=low(t) to high(t) do
    begin
     s:=s+upcase(t.chars[l]);
    END
    else s:=' ';
  AllCaps := s;
end;

procedure wait_for(zz1:longint);
var zz:longint;
begin
 zz:=0;
   repeat
    zz:=zz+1;
   until zz>zz1;
end;

procedure wait_ms(zz1:longint);
var zz,tt:cardinal;

begin
 tt:=millisecondoftheday(now);
   repeat
     zz:=millisecondoftheday(now);
   until (tt+zz1)<zz;
end;

function StrToReal(Str1:string):extended;
var code: integer;
    Temp: extended;
    STR:STRING;
    t:byte;
begin
   str:='';
   if Length(str1)>0 then
   begin
   for t:=Low(str1) to high(str1) do
    if str1[t] in['0'..'9','.','-'] then str:=str+str1[t];
   end;

   if length(Str) = 0 then
      StrToReal := 0
   else begin
      if Copy(Str,1,1)='.' Then
         Str:='0'+Str;
      if (Copy(Str,1,1)='-') and (Copy(Str,2,1)='.') Then
         Insert('0',Str,2);
      if Str[length(Str)] = '.' then
         Delete(Str,length(Str),1);
      val(Str,temp,code);
      if code = 0 then
         StrToReal := temp
      else
      begin
         StrToReal := 0;
      end;
   end;
end; { StrToReal }

procedure TForm1.FormShow(Sender: TObject);
begin
 PairedDevices_AddListBox();
 Text1.Text :='Paired On:'+BTMethod.MyDeviceName;

end;

procedure TForm1.PairedDevices_AddListBox();
var
  i : integer;
  subI : TListBoxItem;
begin
  SListPairedDevices := BTMethod.PairedDevices;    // 시작시 페어링 디바이스 리스트 가져옴.

  PrListBox.Items.Clear();
  PrListBox.BeginUpdate();

  for i:= 0 to SListPairedDevices.Count - 1 do
  begin
    subI := TListBoxItem.Create( PrListBox );
    subI.Height := 50;
    subI.Font.Size := 20;
    subI.TextSettings.FontColor := $FFFFFFFF;
    subI.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
    subI.Selectable := FALSE;
    subI.Text := #$20+#$20+#$20+ SListPairedDevices[i];
    subI.OnMouseUp := Form1.PrListItem_MouseUp;
    PrListBox.AddObject( subI );
  end;
  PrListBox.EndUpdate();
end;
procedure TForm1.PrListItem_MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  PrListBox.ItemByIndex( TargetPaireNo ).TextSettings.FontColor := $FFFFFFFF;  // 이전선택 항목
  TargetPaireNo :=  PrListBox.ItemIndex;

  (Sender as TListBoxItem).TextSettings.FontColor := $FF4FFFFA;
  ToastMessage_On( (Sender as TListBoxItem).Text +   ' Service Searching...' );

  TThread.CreateAnonymousThread( procedure ()
  begin
     ServicesList_Add();    // 타겟 디바이스가 바뀌므로 서비스도 다시 검색해야 함.
     TThread.Synchronize( TThread.CurrentThread, procedure ()
     begin
        //
     end);
     ToastMessage_Off( 'Searching Completed.' );
   end).Start;
end;


//---------------------------------------------------
procedure TForm1.ToastMessage_On( msg : string );
begin
  ToastLayout.Visible:=true;
  PrListBox.HitTest := FALSE;
  ToastLayout.Width := Form1.ClientWidth;
  ToastLayout.Align := TAlignLayout.Center;
  MsgText.Text := msg;
  ToastLayout.Opacity := 1.0;
end;

procedure TForm1.ToastMessage_Off( msg: string );
begin
  MsgText.Text := msg;
  PrListBox.HitTest := TRUE;
  TAnimator.Create.AnimateFloatDelay( ToastLayout, 'Opacity', 0.0, 0.3, 0.5  );
  ToastLayout.Visible:=False;
end;


//-------------------------------------------
procedure TForm1.ServicesList_Add();
var
 i : Integer;
begin
  CurDeviceServices := BTMethod.Find_ServicesList( TargetPaireNo );  // 타겟 디바이스 전체 서비스 리스트 전달

  Services_cb.Clear;
  for i:= 0 to CurDeviceServices.DServiceName.Count - 1 do
      Services_cb.Items.Add( CurDeviceServices.DServiceName[i] );   // 화면표시는 ServiceName

  Services_cb.ItemIndex := 0;
end;

procedure TForm1.Panel_Quit_Display_OnOFF( On_Off : boolean );
begin
  if On_Off then // 열림
  begin
    Panel_Quit.Tag := 1;
    Panel_Quit.Width := Form1.ClientWidth;
    Panel_Quit.Position.X := 0;
    Panel_Quit.Position.Y := Form1.ClientHeight - Panel_Quit.Height;
    Panel_Quit.Visible := TRUE;
  end
  else
  begin
    Panel_Quit.Visible := FALSE;
    Panel_Quit.Tag := 0;
  end;
end;

procedure TForm1.QuitButtonClick(Sender: TObject);
begin
  {$IFDEF ANDROID}
   SharedActivity.finish;
  {$ENDIF}
end;


function elabora_stringa(tt:string):Integer;
var x,rs:Integer;
begin
  rs:=0;
  with form1 do
     begin
       cmds.Clear;
       ExtractStrings([' '],[], PChar(tt), cmds);
       rs:=cmds.Count;

     end;
  Result:=rs;
end;


procedure TForm1.Services_cbChange(Sender: TObject);
begin
  if Services_cb.ItemIndex >= 0 then
  begin
    BTMethod.FServiceGUID := CurDeviceServices.DServiceGUID[ Services_cb.ItemIndex ];  // Service Setting
  end;
end;

function str2color(cc:string):TalphaColor;
var rs:TalphaColor;

begin
  if cc='BLACK' then rs:=TAlphaColors.Black;
  if cc='GREEN' then rs:=TAlphaColors.Green;
  if cc='YELLOW' then rs:=TAlphaColors.Yellow;
  if cc='RED' then rs:=TAlphaColors.Red;
  if (cc='BLUE')or(cc='BLU') then rs:=TAlphaColors.Blue;
  if cc='WHITE' then rs:=TAlphaColors.White;
  if cc='PURPLE' then rs:=TAlphaColors.Purple;
  if cc='GRAY' then rs:=TAlphaColors.Gray;
  if cc='INDIGO' then rs:=TAlphaColors.Indigo;
  if cc='ORANGE' then rs:=TAlphaColors.Orange;
  if cc='BROWN' then rs:=TAlphaColors.Brown;

  if cc='NULL' then rs:=TAlphaColors.Null;

  result:=rs;
end;


procedure add_memo(zz:string);
begin
 TThread.Synchronize( TThread.CurrentThread, procedure ()
     begin
      with form1 do
        begin
          memo1.Lines.Add(zz);
          if Memo1.Lines.Count>100 then memo1.Lines.Delete(0);
        end;
     end);

end;

procedure add_series(obj:tobject;valore:string);
begin
 TThread.Synchronize( TThread.CurrentThread, procedure ()
    var x:Integer;
  begin
      if obj is TLineSeries then
             with TLineSeries(obj) do
               begin
                for x:=1 to Count-1 do YValues[x-1]:=YValues[x];
                YValue[Count-1]:=StrToInt(valore);
                Repaint;
               end;

      if obj is Tbarseries then
             with Tbarseries(obj) do
               begin
                for x:=1 to Count-1 do YValues[x-1]:=YValues[x];
                YValue[Count-1]:=StrToInt(valore);
                Repaint;
               end;
  end);
end;

procedure clear_series(obj:tobject;valore:string);
begin
 TThread.Synchronize( TThread.CurrentThread, procedure ()
    var x:Integer;
  begin
      if obj is TLineSeries then
             with TLineSeries(obj) do
               begin
                for x:=0 to Count-1 do YValues[x]:=0;
                Repaint;
               end;

      if obj is Tbarseries then
             with Tbarseries(obj) do
               begin
                for x:=0 to Count-1 do YValues[x]:=0;
                Repaint;
               end;
  end);
end;


procedure set_command(x:Integer);
var c_sw:TSwitch;
    c_ck:TCheckBox;
    c_sp:Tspinbox;
    c_lb:TLabel;

    ScreenService: IFMXScreenService;
    OrientSet: TScreenOrientations;

    rs:string;
    bp:Boolean;
    obj:tobject;

    ti:Integer;

begin
 rs:='Err';
 with Form1 do
   begin
    if (cmds[1]='BOOLTYPE')and(x=3) then  // PROFILO COMPONENTI CARICATO NEL TELEFONO
        begin
          if (cmds[2]='B') then tipobool:='B';
          if (cmds[2]='E') then tipobool:='E';
          if (cmds[2]='N') then tipobool:='N';
          rs:='OK';
        end ELSE
        if (cmds[1]='PROFILE')and(x=3) then  // PROFILO COMPONENTI CARICATO NEL TELEFONO
        begin
          //cmds[2];
          rs:='OK';
        end ELSE
    if (cmds[1]='STYLE')and(x=3) then  //TEMA DI VISUALIZZAZIONE
        begin
          if StripChar(' ',cmds[2])<>'' then ti:=strtoint(cmds[2])
                                        else ti:=0;
          case ti of
          0: Form1.StyleBook := MaterialOxfordBlueSB;
          1: Form1.StyleBook := WedgewoodLightSB;
          2: form1.StyleBook := calypso;
          end;
         rs:='OK';
        end ELSE
    if (cmds[1]='LOG')and(x=3) then
        begin
          if cmds[2]='CLEAR' then memo1.Lines.clear;
          rs:='OK';
        end else
    if (cmds[1]='INTESTAZIONE')and(x=3) then
        begin
          intestazione.Text:=toglichar_(cmds[2]);
          rs:='OK';
        end else
    if (cmds[1]='SCREEN')and(x=3) then
     BEGIN
      if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
        begin
         if cmds[2]='LANDSCAPE' then OrientSet := [TScreenOrientation.soLandscape];
         if cmds[2]='PORTRAIT' then OrientSet := [TScreenOrientation.soPortrait];
         ScreenService.SetSupportedScreenOrientations(Orientset);//   .SetScreenOrientation(OrientSet);
         rs:='OK';
        end;
     END else
     if FindComponent(kcmp+cmds[1])<>nil then
      begin
        obj:=FindComponent(kcmp+cmds[1]);
        if cmds[2]='TEXT' then
          begin
           if obj is tlabel then TLabel(obj).Text:=cmds[3];
           if obj is tedit  then Tedit(obj).Text:=cmds[3];
           if obj is tcheckbox  then Tcheckbox(obj).Text:=cmds[3];
           if obj is ttext  then Ttext(obj).Text:=cmds[3];
           rs:='Ok';
           end else
        if cmds[2]='COLOR' then
          begin
           if obj is ttext    then Ttext(obj).TextSettings.fontcolor:=Str2color(cmds[3]);
           if obj is tcircle  then Tcircle(obj).Fill.Color:=Str2color(cmds[3]);
           if obj is TArc     then Tarc(obj).Stroke.Color:=Str2color(cmds[3]);
           if obj is trectangle  then TRectangle(obj).Fill.Color:=Str2color(cmds[3]);


           rs:='Ok';
          end else
        if cmds[2]='DELETE' then
          begin
           if obj is tmemo  then Tmemo(obj).Lines.Delete(StrToInt(cmds[3]));

           if obj is TLineSeries then
               begin
                TLineSeries(obj).Delete(StrToInt(cmds[3]));
                TLineSeries(obj).Repaint;
               end;
           if obj is TbarSeries then
               begin
                TbarSeries(obj).delete(StrToInt(cmds[3]));
                TLineSeries(obj).Repaint;
               end;

           rs:='Ok';
           end else
        if cmds[2]='ADD' then
          begin
           if obj is tmemo  then Tmemo(obj).Lines.Add(cmds[3]);

           add_series(obj,cmds[3]);

           rs:='Ok';
           end else
        if cmds[2]='CLEAR' then
          begin
           if obj is tmemo  then Tmemo(obj).Lines.Clear;

           CLEAR_series(obj,cmds[3]);
           //if obj is TLineSeries then TLineSeries(obj).Clear;
           //if obj is TbarSeries then Tbarseries(obj).Clear;

           rs:='Ok';
          end else
        if cmds[2]='VALUE' then
          begin
           if obj is tspinbox then TSPINBOX(obj).VALUE:=strtoreal(cmds[3]);
           if obj is tARC then TARC(obj).ENDANGLE:=strtoINT(cmds[3]);

           bp:=StrToBool(cmds[3]);
           //if ((cmds[3]='1')or(cmds[3]='TRUE'))or(cmds[3]='ON') then bp:=true
           //                                                       else bp:=false;
           if obj is TCIRCLE  then  TCIRCLE(obj).VISIBLE:=bp;

           rs:='Ok';
           end else
        if (cmds[2]='CHECKED')or(cmds[2]='STATUS') then
          begin
           //if ((cmds[3]='1')or(cmds[3]='TRUE'))or(cmds[3]='ON') then bp:=true
           //                                                   else bp:=false;
           bp:=StrToBool(cmds[3]);

           if obj is TCheckBox then TCheckBox(obj).IsChecked:=bp;
           if obj is TSwitch  then  TSwitch(obj).IsChecked:=bp;
           if obj is TCIRCLE  then  TCIRCLE(obj).VISIBLE:=bp;
           if obj is Trectangle  then  Trectangle(obj).VISIBLE:=bp;

           rs:='Ok';
          end else
        if cmds[2]='VISIBLE' then
          begin
           //if ((cmds[3]='1')or(cmds[3]='TRUE'))or(cmds[3]='ON') then bp:=true
           //                                                     else bp:=false;
           bp:=StrToBool(cmds[3]);

           if obj is TCheckBox then TCheckBox(obj).visible:=bp;
           if obj is TSwitch   then TSwitch(obj).visible:=bp;
           if obj is Tedit     then Tedit(obj).visible:=bp;
           if obj is Tlabel    then Tlabel(obj).visible:=bp;
           if obj is Tmemo     then Tmemo(obj).visible:=bp;
           if obj is Tspinbox  then Tspinbox(obj).visible:=bp;
           if obj is TCIRCLE    then  TCIRCLE(obj).VISIBLE:=bp;
           if obj is Trectangle then  Trectangle(obj).VISIBLE:=bp;
           if obj is Ttrackbar  then  TTrackBar(obj).VISIBLE:=bp;
           if obj is TArc       then  Tarc(obj).VISIBLE:=bp;
           if obj is Ttext      then  Ttext(obj).VISIBLE:=bp;

           rs:='Ok';
          end else

         if (cmds[2]='DIMXY') then
          begin
             if obj is Tmemo then
              begin
               Tmemo(obj).Width:=StrToInt(cmds[3]);
               Tmemo(obj).Height:=StrToInt(cmds[4]);
             end;
             if obj is trectangle then
              begin
               trectangle(obj).Width:=StrToInt(cmds[3]);
               trectangle(obj).Height:=StrToInt(cmds[4]);
             end;
             if obj is tcircle then
              begin
               tcircle(obj).Width:=StrToInt(cmds[3]);
               tcircle(obj).Height:=StrToInt(cmds[4]);
             end;
             if obj is tchart then
              begin
               tchart(obj).Width:=StrToInt(cmds[3]);
               tchart(obj).Height:=StrToInt(cmds[4]);
             end;

            rs:='Ok';
          end;
         if (cmds[2]='WIDTH') then
          begin
             if obj is Tmemo then
              begin
               Tmemo(obj).Width:=StrToInt(cmds[3]);
             end;
             if obj is trectangle then
              begin
               trectangle(obj).Width:=StrToInt(cmds[3]);
             end;
             if obj is tcircle then
              begin
               tcircle(obj).Width:=StrToInt(cmds[3]);
             end;
             if obj is tchart then
              begin
               tchart(obj).Width:=StrToInt(cmds[3]);
             end;

            rs:='Ok';
          end;
         if (cmds[2]='HEIGHT') then
          begin
            if obj is Tmemo then
              begin
               Tmemo(obj).Height:=StrToInt(cmds[3]);
             end;
            if obj is trectangle then
              begin
               trectangle(obj).Height:=StrToInt(cmds[3]);
             end;
             if obj is tcircle then
              begin
               tcircle(obj).Height:=StrToInt(cmds[3]);
             end;
             if obj is tchart then
              begin
               tchart(obj).Height:=StrToInt(cmds[3]);
             end;

            rs:='Ok';
          end;



         if cmds[2]='POS' then
          begin
           if obj is TCheckBox then
               begin
                TCheckBox(obj).Position.x:=StrToInt(cmds[3]);
                TCheckBox(obj).Position.y:=StrToInt(cmds[4]);
               end;
           if obj is TSwitch   then
               begin
                TSwitch(obj).Position.x:=StrToInt(cmds[3]);
                TSwitch(obj).Position.y:=StrToInt(cmds[4]);
               end;
           if obj is Tedit     then
              begin
               Tedit(obj).Position.x:=StrToInt(cmds[3]);
               Tedit(obj).Position.y:=StrToInt(cmds[4]);
              end;
           if obj is Tlabel    then
              begin
               Tlabel(obj).Position.x:=StrToInt(cmds[3]);
               Tlabel(obj).Position.y:=StrToInt(cmds[4]);
              end;
           if obj is Tmemo     then
              begin
               Tmemo(obj).Position.x:=StrToInt(cmds[3]);
               Tmemo(obj).Position.y:=StrToInt(cmds[4]);
              end;
           if obj is Tspinbox  then
              begin
               Tspinbox(obj).Position.x:=StrToInt(cmds[3]);
               Tspinbox(obj).Position.y:=StrToInt(cmds[4]);
              end;
           if obj is TTrackBar then
               begin
                Ttrackbar(obj).Position.x:=StrToInt(cmds[3]);
                Ttrackbar(obj).Position.y:=StrToInt(cmds[4]);
               end;
           if obj is TCircle then
               begin
                Tcircle(obj).Position.x:=StrToInt(cmds[3]);
                TCircle(obj).Position.y:=StrToInt(cmds[4]);
               end;
           if obj is Trectangle then
               begin
                Trectangle(obj).Position.x:=StrToInt(cmds[3]);
                Trectangle(obj).Position.y:=StrToInt(cmds[4]);
               end;
           if obj is Tarc then
               begin
                Tarc(obj).Position.x:=StrToInt(cmds[3]);
                Tarc(obj).Position.y:=StrToInt(cmds[4]);
               end;
            rs:='Ok';
          end;
      end ELSE add_memo(kcmp+cmds[1]+' Not Found');

    add_memo('Result: '+rs);
   end;
 end;


procedure destroy_command(X:integer);
var obj:tobject;
    Stt:string;
    y:Integer;
begin
  with form1 do
     begin
     if CMDS[1]='ALL!' then
      begin
       for y := ComponentCount-1 downto 0 do
         begin
          stt:=components[y].name;
          if Pos(kcmp,Stt)=1 then
             begin
              Components[y].DisposeOf;
              //obj:=FindComponent(stt);
              //FreeAndNil(obj);
              add_memo(stt+' Destroyed');
             end;
         end;
      end else begin
      if  FindComponent(kcmp+cmds[1])<>nil then
        begin
          obj:=FindComponent(kcmp+cmds[1]);
          obj.DisposeOf;
          //FreeAndNil(obj);
          add_memo(kcmp+cmds[1]+' Destroyed');
        end;
      end;
     end;
end;

procedure get_command(x:Integer);
var

    obj:TObject;

    y:Integer;

    response:string;
    bresp:Boolean;
    Rs:string;

    bb:Boolean;
begin
 rs:='Err';
 response:='';
 with form1 do
    begin
     if CMDS[1]='LISTCMP' then
     begin
      for y := 0 to componentcount-1 do
        begin
          add_memo(components[y].name);
        end;

     end else

    if FindComponent(kcmp+cmds[1])<>nil then
      begin
        obj:=FindComponent(kcmp+cmds[1]);

        if cmds[2]='VALUE' then
          begin
           if obj is TSpinBox then response:=realtostr(Tspinbox(obj).Value,0);
           if obj is Ttrackbar then response:=realtostr(Ttrackbar(obj).Value,0);
           if obj is Tarc then response:=realtostr(Tarc(obj).endangle,0);

           rs:='Ok';
           end;


        if cmds[2]='TEXT' then
          begin
           if obj is tlabel then response:=TLabel(obj).Text;
           if obj is tedit  then response:=Tedit(obj).Text;
           if obj is tcheckbox  then response:=Tcheckbox(obj).Text;
           rs:='Ok';
           end;
        if (cmds[2]='CHECKED')or(cmds[2]='STATUS') then
          begin
           if obj is TCheckBox then bresp:=TCheckBox(obj).IsChecked;
           if obj is TSwitch  then  bresp:=TSwitch(obj).IsChecked;
           if obj is Tcircle  then  bresp:=Tcircle(obj).visible;
           if obj is Trectangle  then  bresp:=Trectangle(obj).visible;

           if obj is Ttrackbar  then
              begin
               if TTrackBar(obj).Value >0 then bresp:=True
                                          else bresp:=False;
              end;
           response:=BoolToStr(bresp);
           //if bresp then response:='TRUE'
           //         else response:='FALSE';
           rs:='Ok';
          end;

       end ELSE add_memo(kcmp+cmds[1]+' Not Found');

     bb:=btmethod.SendData(TargetPaireNo,response+#13);

     add_memo('Result: '+rs);
    end;
end;


procedure Create_command(x:Integer);
var c_sw:TSwitch;
    c_ck:TCheckBox;
    c_sp:Tspinbox;
    c_lb:TLabel;
    c_et:TEdit;
    C_MM:TMemo;

    c_bt:TButton;

    C_TB:TText;

    C_C1,C_C2:TCircle;
    C_R1,C_R2:TRectangle;

    c_st:TTrackBar;

    c_g1,c_g2:TArc;  //per creare un GAUGE un po stiloso
    c_t:TLabel;

    c_tch:Tchart;     //per create tchart
    c_tba:TBarSeries;
    c_tls:TLineSeries;

    Rs:string;

begin
 rs:='Err';
 with form1 do
 begin
  if FindComponent(kcmp+cmds[2])=nil then
    begin
      if (cmds[1]='SELECTOR')and(x=9) then
          begin
           c_st:=Ttrackbar.Create(form1);
           c_st.Name:=kcmp+cmds[2];
           c_st.Parent:=tabitem2;
           c_st.Position.X:=StrToInt(cmds[3]);
           c_st.Position.Y:=StrToInt(cmds[4]);
           if (cmds[5]='HORIZONTAL')or(cmds[5]='HOR') then c_st.Orientation:=TOrientation.Horizontal;
           if (cmds[5]='VERTICAL')or(cmds[5]='VER') then c_st.Orientation:=TOrientation.Vertical;

           c_st.min:=StrToInt(cmds[6]);
           c_st.max:=StrToInt(cmds[7]);
           c_st.Value:=StrToInt(cmds[8]);
           c_st.Frequency:=1;

           c_st.OnChange:=Myselector_change;


           rs:='OK';
          end;


      if (cmds[1]='CHART')and(x=9) then
          begin
            c_tch:=tchart.Create(form1);
            c_tch.Name:=kcmp+cmds[2];
            c_tch.Parent:=tabitem2;
            c_tch.Position.X:=StrToInt(cmds[3]);
            c_tch.Position.Y:=StrToInt(cmds[4]);
            c_tch.Height:=StrToInt(cmds[5]);
            c_tch.Width:=StrToInt(cmds[6]);

            c_tch.Color:=str2color('NULL');


            c_tch.LeftAxis.SetMinMax( StrToInt(cmds[7]),StrToInt(cmds[8]));
            //c_tch.BottomAxis.SetMinMax(0,50);
            c_tch.Visible:=true;



            rs:='OK';
          end;

      if (cmds[1]='LINESERIES')and(x=6) then
          begin
           c_tls := Tlineseries.Create(form1);
           c_tls.Name:=kcmp+cmds[2];
           c_tls.ParentChart := TChart(FindComponent(kcmp+cmds[3]));
           c_tls.SeriesColor:=str2color(cmds[4]);
           c_tls.Legend.Visible:=False;
           c_tls.Marks.Visible:=False;

           c_tls.Clear;

           for x := 1 to StrToInt(cmds[5]) do
                       c_tls.Addarray([0]);

           rs:='OK';
          end;
      if (cmds[1]='BARSERIES')and(x=6) then
          begin
           c_tba := Tbarseries.Create(form1);
           c_tba.Name:=kcmp+cmds[2];
           c_tba.ParentChart := TChart(FindComponent(kcmp+cmds[3]));
           c_tba.SeriesColor:=str2color(cmds[4]);
           c_tba.Legend.Visible:=False;
           c_tba.Marks.Visible:=False;

           c_tba.Clear;

           for x := 1 to StrToInt(cmds[5]) do
                       c_tba.Addarray([0]);


           //c_tba.Addarray([0120,200,150,170]);
           rs:='OK';
          end;


      if (cmds[1]='CIRCLE')and(x=8) then
          begin
            c_C1:=TCIRCLE.Create(form1);
            
            c_C1.Name:=kcmp+cmds[2];
            C_C1.Parent:=tabitem2;
            C_C1.Position.X:=StrToInt(cmds[3]);
            C_C1.Position.Y:=StrToInt(cmds[4]);
            C_C1.Height:=StrToInt(cmds[5]);
            C_C1.Width:=StrToInt(cmds[6]);
            C_C1.FILL.Color:=str2color(cmds[7]);

            RS:='OK';
          end;

      if (cmds[1]='RECT')and(x=8) then  //Rectangle
          begin
            c_r1:=trectangle.Create(form1);

            c_r1.Name:=kcmp+cmds[2];
            C_r1.Parent:=tabitem2;
            C_r1.Position.X:=StrToInt(cmds[3]);
            C_r1.Position.Y:=StrToInt(cmds[4]);
            C_r1.Height:=StrToInt(cmds[5]);
            C_r1.Width:=StrToInt(cmds[6]);
            C_r1.FILL.Color:=str2color(cmds[7]);

            RS:='OK';
          end;

      if (cmds[1]='LED')and(x=9) then
          begin
            c_C1:=TCIRCLE.Create(form1);
            c_C2:=TCIRCLE.Create(form1);

            c_C1.Name:=kcmp+cmds[2]+'_B';
            C_C1.Parent:=tabitem2;
            C_C1.Position.X:=StrToInt(cmds[3]);
            C_C1.Position.Y:=StrToInt(cmds[4]);
            C_C1.Height:=StrToInt(cmds[5]);
            C_C1.Width:=StrToInt(cmds[6]);
            C_C1.FILL.Color:=str2color(cmds[7]);

            C_C2.Name:=kcmp+cmds[2];
            C_C2.Parent:=tabitem2;
            C_C2.Position.X:=StrToInt(cmds[3]);
            C_C2.Position.Y:=StrToInt(cmds[4]);
            C_C2.Height:=StrToInt(cmds[5]);
            C_C2.Width:=StrToInt(cmds[6]);
            C_C2.FILL.Color:=str2color(cmds[8]);

            RS:='OK';
          end;


      if (cmds[1]='SQLED')and(x=9) then  //Square led
          begin
            c_r1:=Trectangle.Create(form1);
            C_R2:=Trectangle.Create(form1);

            c_r1.Name:=kcmp+cmds[2]+'_B';
            C_r1.Parent:=tabitem2;
            C_r1.Position.X:=StrToInt(cmds[3]);
            C_r1.Position.Y:=StrToInt(cmds[4]);
            C_r1.Height:=StrToInt(cmds[5]);
            C_r1.Width:=StrToInt(cmds[6]);
            C_r1.FILL.Color:=str2color(cmds[7]);

            C_r2.Name:=kcmp+cmds[2];
            C_r2.Parent:=tabitem2;
            C_r2.Position.X:=StrToInt(cmds[3]);
            C_r2.Position.Y:=StrToInt(cmds[4]);
            C_r2.Height:=StrToInt(cmds[5]);
            C_r2.Width:=StrToInt(cmds[6]);
            C_r2.FILL.Color:=str2color(cmds[8]);

            RS:='OK';
          end;


      if (cmds[1]='GAUGE')and(x=10) then
          begin
            c_g1:=TArc.Create(form1);
            c_g2:=TArc.Create(form1);

            c_g1.Name:=kcmp+cmds[2]+'_B';
            c_g1.Parent:=tabitem2;
            c_g1.Position.X:=StrToInt(cmds[3]);
            c_g1.Position.Y:=StrToInt(cmds[4]);
            c_g1.Height:=StrToInt(cmds[5]);
            c_g1.Width:=StrToInt(cmds[6]);
            c_g1.StartAngle:=90;
            c_g1.EndAngle:=270;
            c_g1.Stroke.Color:=str2color(cmds[7]);
            c_g1.Stroke.tHickness:=StrToInt(cmds[9]);

            c_g2.Name:=kcmp+cmds[2];
            c_g2.Parent:=tabitem2;
            c_g2.Position.X:=StrToInt(cmds[3]);
            c_g2.Position.Y:=StrToInt(cmds[4]);
            c_g2.Height:=StrToInt(cmds[5]);
            c_g2.Width:=StrToInt(cmds[6]);
            c_g2.StartAngle:=90;
            c_g2.EndAngle:=90; //??
            c_g2.Stroke.Color:=str2color(cmds[8]);
            c_g2.Stroke.tHickness:=StrToInt(cmds[9]);
            //c_g2.Stroke.Cap:=tstrockecap.Round;
            RS:='OK';
          end;

      if (cmds[1]='SWITCH1')and(x>=5) then
          begin
           c_st:=Ttrackbar.Create(form1);
           c_st.Name:=kcmp+cmds[2];
           c_st.Parent:=tabitem2;
           c_st.Position.X:=StrToInt(cmds[3]);
           c_st.Position.Y:=StrToInt(cmds[4]);

           c_st.Min:=0;
           c_st.Max:=1;
           c_st.Value:=0;
           c_st.Value:=1;
           c_st.Frequency:=1;

           if (cmds[5]='HORIZONTAL')or(cmds[5]='HOR') then c_st.Orientation:=TOrientation.Horizontal;
           if (cmds[5]='VERTICAL')or(cmds[5]='VER') then c_st.Orientation:=TOrientation.Vertical;

           c_st.OnChange:=Myswitch1_change;

           rs:='OK';
          end;

      if (cmds[1]='SWITCH')and(x=5) then
          begin
           c_sw:=TSwitch.Create(form1);
           c_sw.Name:=kcmp+cmds[2];
           c_sw.Parent:=tabitem2;
           c_sw.Position.X:=StrToInt(cmds[3]);
           c_sw.Position.Y:=StrToInt(cmds[4]);

           c_sw.OnSwitch:=Myswitch_change;

           rs:='OK';
          end;

      if (cmds[1]='CHECKBOX')and(x>=5) then
          begin
           c_ck:=TCheckBox.Create(form1);
           c_ck.Name:=kcmp+cmds[2];
           c_ck.Parent:=tabitem2;
           c_ck.Position.X:=StrToInt(cmds[3]);
           c_ck.Position.Y:=StrToInt(cmds[4]);
           if x=6 then c_CK.Text:=cmds[5]
                  else c_CK.Text:=cmds[2];

           c_ck.Onchange:=Mycheckbox_change;

           rs:='OK';
          end;
      if (cmds[1]='SPINBOX')and(x=5) then
          begin
           c_sp:=Tspinbox.Create(FORM1);
           c_sp.Name:=kcmp+cmds[2];
           c_sp.Parent:=tabitem2;
           c_sp.Position.X:=StrToInt(cmds[3]);
           c_sp.Position.Y:=StrToInt(cmds[4]);

           c_sp.OnChange:=Myspinbox_change;

           rs:='OK';
          end;
      if (cmds[1]='LABEL')and(x>=5) then
          begin
           c_lb:=Tlabel.Create(form1);
           c_lb.Name:=kcmp+cmds[2];
           c_lb.Parent:=tabitem2;

           c_lb.AutoSize:=true;
           c_lb.WordWrap:=false;

           c_lb.Position.X:=StrToInt(cmds[3]);
           c_lb.Position.Y:=StrToInt(cmds[4]);
           if x=6 then c_lb.Text:=toglichar_(cmds[5])
                  else c_lb.Text:=toglichar_(cmds[2]);
           rs:='OK';
          end;

      if (cmds[1]='TEXT')and(x>=8) then
          begin
           c_Tb:=TTEXT.Create(form1);
           c_Tb.Name:=kcmp+cmds[2];
           c_Tb.Parent:=tabitem2;
           c_Tb.Position.X:=StrToInt(cmds[3]);
           c_Tb.Position.Y:=StrToInt(cmds[4]);

           c_Tb.AutoSize:=true;
           c_tb.WordWrap:=False;

           C_TB.TextSettings.Font.Size:=StrToInt(cmds[5]);
           C_tb.TextSettings.FontColor:=str2color(cmds[6]);

           if x=8 then c_TB.Text:=toglichar_(cmds[7])
                  else c_TB.Text:=toglichar_(cmds[2]);
           rs:='OK';
          end;


      if (cmds[1]='EDIT')and(x>=5) then
          begin
           c_et:=Tedit.Create(form1);
           c_et.Name:=kcmp+cmds[2];
           c_et.Parent:=tabitem2;
           c_et.Position.X:=StrToInt(cmds[3]);
           c_et.Position.Y:=StrToInt(cmds[4]);
           if x=6 then c_et.Text:=cmds[5]
                  else c_et.Text:=cmds[2];
           C_ET.Visible:=True;
           rs:='OK';
          end;

      if (cmds[1]='BUTTON')and(x>=5) then
          begin
           c_bt:=Tbutton.Create(form1);
           c_bt.Name:=kcmp+cmds[2];
           c_bt.Parent:=tabitem2;
           c_bt.Position.X:=StrToInt(cmds[3]);
           c_bt.Position.Y:=StrToInt(cmds[4]);
           if x=6 then c_bt.Text:=cmds[5]
                  else c_bt.Text:=cmds[2];

           c_bt.OnClick:=MyButtonClick;
           c_bt.Visible:=True;
           rs:='OK';
          end;


      if (cmds[1]='MEMO')and(x>=5) then
          begin
           c_MM:=TMEMO.Create(form1);
           c_MM.Name:=kcmp+cmds[2];
           c_MM.Parent:=tabitem2;
           c_MM.Position.X:=StrToInt(cmds[3]);
           c_MM.Position.Y:=StrToInt(cmds[4]);
           if x=6 then c_MM.Text:=cmds[5]
                  else c_MM.Text:='';
           C_MM.Visible:=True;
           rs:='OK';
          end;

      add_memo('Result: '+rs +' '+kcmp+cmds[2] );
    end else add_memo('Error'+kcmp+cmds[2]+' Exist!');
 end;
end;


procedure elabora_comando(cmd:string);
var x:Integer; // num voci comando
begin
 x:=elabora_stringa(cmd);
 if x>0 then
  begin
    if cmdS[0]='SET' then set_command(x);
    if cmdS[0]='GET' then get_command(x);
    if cmdS[0]='CREATE' then create_command(x);
    if cmdS[0]='DESTROY' then destroy_command(x);

  end;
   //add_memo('Parse:'+IntToStr(x)+':'+#13+cmds.Text );

end;

procedure TForm1.start_receive;
begin
  TThread.CreateAnonymousThread(
    procedure
     var ss: string;
         y:Integer;
         zz:string;
    begin
     //codesite.SendMsg('QUEUE start');
     zz:='';
     with form1 do
      repeat
         if bt_on then
          begin
            ss:=btmethod.ReceiveData(TargetPaireNo,'');
            for y := Low(ss) to High(Ss) do
              begin
                if ss[y]<>#13  then
                  begin
                    zz:=zz+ss[y];
                  end else begin
                    add_memo(zz);
                    elabora_comando(zz);
                    zz:='';
                  end;
              end;
          end;
      until 1=2; //provvisorio
    end
  ).Start;
end;


procedure TForm1.btnsetClick(Sender: TObject);
begin
  with form1 do
     begin
       if TabControl1.TabPosition=TTabPosition.none
        then TabControl1.TabPosition:=TTabPosition.Bottom
        else  TabControl1.TabPosition:=TTabPosition.none;
       TabControl1.ActiveTab:=tabitem2;

     end;
end;

procedure TForm1.btn_clearClick(Sender: TObject);
begin
TThread.Synchronize( TThread.CurrentThread, procedure ()
     begin
       memo1.Lines.Clear;
     end);
end;

procedure TForm1.btn_connettiClick(Sender: TObject);
begin
  if BTMethod.SendData( TargetPaireNo,'!START'+#13 ) then // '1' + #$15 ) then
  begin
    Tabcontrol1.ActiveTab := TabControl1.Tabs[1];
    TabControl1.TabPosition:=TTabPosition.none;

    bt_on:=true;
  end;
end;

procedure TForm1.btn_sendClick(Sender: TObject);
var bb:Boolean;
begin
 with form1 do
  if bt_on  then
   begin
     bb:=btmethod.SendData(TargetPaireNo,sendcmd.text+#13);

     add_memo('Send:'+sendcmd.text);
     sendcmd.Text:='';

   end else showmessage('No Paired Devices');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  ScreenService: IFMXScreenService;
  OrientSet: TScreenOrientations;
begin

{$IFDEF ANDROID}
  SharedActivity.getWindow.addFlags(TJWindowManager_LayoutParams.JavaClass.FLAG_KEEP_SCREEN_ON);
{$ENDIF}



  Tabcontrol1.ActiveTab := TabControl1.Tabs[0];

  tipobool:='E';
  kcmp:='XXX_'; //'GX_';

  cmds:=TStringlist.Create;
  cmds.Clear;

  bt_on:=false;
  BTMethod := TBTMethod.Create;     // BlueTooth Create


  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
  begin
    OrientSet := [TScreenOrientation.soPortrait];

    //OrientSet := [TScreenOrientation.soLandscape];
    ScreenService.SetSupportedScreenOrientations(Orientset);//   .SetScreenOrientation(OrientSet);
  end;

  ToastMessage_Off('');

  start_receive;

end;

end.

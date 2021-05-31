unit frmPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
   StdCtrls, ComCtrls, Process, fileutil;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnNewNote1: TToolButton;
    btnNewNote2: TToolButton;
    Button1: TButton;
    cbUsePutty: TCheckBox;
    edtPuttyDir: TEdit;
    ilToolbar: TImageList;
    Label1: TLabel;
    lbHosts: TListBox;
    lbTextFiles: TListBox;
    mNotes: TMemo;
    mHost: TMemo;
    mConfigFile: TMemo;
    mPubKey: TMemo;
    pcMain: TPageControl;
    pcSSH: TPageControl;
    tsConfigFile: TTabSheet;
    tbNotes: TToolBar;
    btnNewNote: TToolButton;
    ToolBar2: TToolBar;
    ToolBar3: TToolBar;
    btnOpenNote: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    tsRDP: TTabSheet;
    tsNotes: TTabSheet;
    tsSSH: TTabSheet;
    tsHost: TTabSheet;
    tsOptions: TTabSheet;
    tsPubKey: TTabSheet;
    procedure btnNewNoteClick(Sender: TObject);
    procedure btOpenConfigFileClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbUsePuttyChange(Sender: TObject);
    procedure cbUsePuttyClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbHostsClick(Sender: TObject);
    procedure lbHostsDblClick(Sender: TObject);
    procedure lbTextFilesClick(Sender: TObject);
    procedure LoadConfig(FileName:String);
    procedure mHostChange(Sender: TObject);
    procedure pcSSHChange(Sender: TObject);
    procedure SaveConfigFile;
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure tsConfigFileShow(Sender: TObject);
    procedure tsNotesShow(Sender: TObject);
  private
    Hosts:TList;
    UserDir:String;
    ConfigFileName:String;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btOpenConfigFileClick(Sender: TObject);
begin

end;

procedure TForm1.btnNewNoteClick(Sender: TObject);
begin
  lbTextFiles.Items.Add(InputBox('File name', 'Enter the file name', 'new-note.txt'));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin

end;



procedure TForm1.cbUsePuttyChange(Sender: TObject);
begin
  edtPuttyDir.Enabled:=cbUsePutty.Checked;
end;

procedure TForm1.cbUsePuttyClick(Sender: TObject);
begin

end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);

begin
  UserDir := GetUserDir;
  ConfigFileName:=UserDir+'.ssh\config';
  CopyFile(ConfigFileName,ConfigFileName+FormatDateTime('yyyymmddhhnnss',Now));
  LoadConfig(ConfigFileName);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  pcMain.ActivePage:=tsSSH;
  pcSSH.ActivePage:=tsHost;
end;

procedure TForm1.lbHostsClick(Sender: TObject);
var
  Host:TStringList;
begin
  Host:=TStringList(Hosts.Items[lbHosts.ItemIndex]);
  mHost.Lines := Host;

end;

procedure TForm1.lbHostsDblClick(Sender: TObject);
var
  sshProcess: TProcess;
begin
  sshProcess := TProcess.Create(nil);
  sshProcess.CommandLine := 'ssh ' + lbHosts.Items.Strings[lbHosts.ItemIndex];
  sshProcess.Options := sshProcess.Options + [poWaitOnExit];
  sshProcess.Execute;
  sshProcess.Free;
end;

procedure TForm1.lbTextFilesClick(Sender: TObject);
begin
  mNotes.Lines.LoadFromFile(UserDir+'Desktop\'+lbTextFiles.Items[lbTextFiles.ItemIndex]);
end;

procedure TForm1.LoadConfig(Filename: string);

var
  configFile: TextFile;
  configLine: String;
  Host:TStringList;
begin
  mHost.Lines.Clear;
  lbHosts.Items.Clear;
  AssignFile(configFile, Filename);
  Hosts:=TList.Create;
  Reset(configFile);
  Host:=TStringList.Create;
   while not Eof(configFile) do
   begin
     ReadLn(configFile, configLine);
     If (ANSIUpperCase(Trim(Copy(configLine,1,4)))='HOST') then
     begin
       Hosts.Add(Host);
       Host := TSTringList.Create;
       Host.Add(configLine);
       lbHosts.AddItem(Copy(Host.Strings[0],6,Host.Strings[0].Length), Host);
     end
     Else
     begin
       Host.Add(configLine);
     end;

   end;
    Hosts.Add(Host);
    Hosts.Delete(0);
    CloseFile(configFile);
end;

procedure TForm1.mHostChange(Sender: TObject);
begin

end;

procedure TForm1.pcSSHChange(Sender: TObject);
begin

end;

procedure TForm1.SaveConfigFile;
var
  configFile: TextFile;
  vaxI, vaxI2 :Integer;
  Host:TStringList;
begin
  AssignFile(configFile, ConfigFilename);
  ReWrite(ConfigFile);
  For vaxI:=0 to Hosts.Count-1 Do
  begin
    Host:=TStringList(Hosts.Items[vaxI]);
    For vaxI2:=0 to Host.Count-1 Do
    begin
      WriteLn(ConfigFile,Host[vaxI2]);
    end;
  end;
  CloseFile(configFile);
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
  LoadConfig(ConfigFileName);
end;

procedure TForm1.ToolButton4Click(Sender: TObject);
begin
  mConfigFile.Lines.SaveToFile(ConfigFileName);
end;

procedure TForm1.tsConfigFileShow(Sender: TObject);
begin
  mConfigFile.Lines.LoadFromFile(ConfigFileName);
end;

procedure TForm1.tsNotesShow(Sender: TObject);
var
    Info : TSearchRec;
begin
  lbTextFiles.Items.Clear;
  if FindFirst(UserDir+'Desktop\' + '*.txt', faAnyFile and faDirectory, Info)=0 then begin
    repeat
      lbTextFiles.Items.Add(Info.Name);
    until FindNext(Info) <> 0;
  end;
  FindClose(Info);
end;

end.

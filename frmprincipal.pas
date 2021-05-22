unit frmPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
   StdCtrls, ComCtrls, Process;

type

  { TForm1 }

  TForm1 = class(TForm)
    lbHosts: TListBox;
    mPubKey: TMemo;
    mHost: TMemo;
    pcFiles: TPageControl;
    tsHost: TTabSheet;
    tsPubKey: TTabSheet;
    procedure btOpenConfigFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbHostsClick(Sender: TObject);
    procedure lbHostsDblClick(Sender: TObject);
    procedure LoadConfig(FileName:String);
    procedure mHostChange(Sender: TObject);
    procedure pcFilesChange(Sender: TObject);
  private
    Hosts:TList;
    UserDir:String;
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

procedure TForm1.FormCreate(Sender: TObject);
var
  ConfigFileName:String;
begin
  UserDir := 'c:\users\andretapxure\';
  mPubKey.Lines.LoadFromFile(UserDir+'.ssh\id_rsa.pub');
  ConfigFileName:=UserDir+'.ssh\config';
  LoadConfig(ConfigFileName);
end;

procedure TForm1.lbHostsClick(Sender: TObject);
var
  Host:TStringList;
begin
//  Host:=TStringList.Create;
  Host:=TStringList(Hosts.Items[lbHosts.ItemIndex]);
  mHost.Lines := Host;

end;

procedure TForm1.lbHostsDblClick(Sender: TObject);
var
  sshProcess: TProcess;

// Aqui é onde o nosso programa inicia a execução
begin
  // Agora nós criaremos o objeto TProcess, e
  // associamos ele à variável sshProcess.
  sshProcess := TProcess.Create(nil);
  sshProcess.CommandLine := 'ssh ' + lbHosts.Items.Strings[lbHosts.ItemIndex];
  sshProcess.Options := sshProcess.Options + [poWaitOnExit];
  sshProcess.Execute;
  sshProcess.Free;
end;

procedure TForm1.LoadConfig(Filename: string);

var
  configFile: TextFile;
  configLine: String;
  Host:TStringList;
begin
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
end;

procedure TForm1.mHostChange(Sender: TObject);
begin

end;

procedure TForm1.pcFilesChange(Sender: TObject);
begin

end;

end.

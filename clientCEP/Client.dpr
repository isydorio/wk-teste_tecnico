program Client;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitClient in 'UnitClient.pas' {FormClient};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormClient, FormClient);
  Application.Run;
end.

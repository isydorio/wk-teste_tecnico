program api;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FormPrincipal},
  UnitDB in 'UnitDB.pas' {FormDB},
  UnitIntegra in 'UnitIntegra.pas' {FormIntegra};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TFormDB, FormDB);
  Application.CreateForm(TFormIntegra, FormIntegra);
  Application.Run;
end.

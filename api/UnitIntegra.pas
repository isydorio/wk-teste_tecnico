unit UnitIntegra;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope;

type
  TFormIntegra = class(TForm)
    RESTClientCEP: TRESTClient;
    RESTRequestCEP: TRESTRequest;
    RESTResponseCEP: TRESTResponse;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormIntegra: TFormIntegra;

implementation

{$R *.fmx}

end.

unit UnitClient;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox, FMX.Edit, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.JSON;

type
  TFormClient = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    cbNatureza: TComboBox;
    edtDocumento: TEdit;
    edtPrimeiro: TEdit;
    edtSegundo: TEdit;
    edtCep: TEdit;
    edtLogradouro: TEdit;
    edtComplemento: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    edtUf: TEdit;
    RESTClientCEP: TRESTClient;
    RESTRequestCEP: TRESTRequest;
    RESTResponseCEP: TRESTResponse;
    procedure edtCepExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormClient: TFormClient;
  strRetorno: String;
  retOJSON: TJSONObject;

implementation

{$R *.fmx}

procedure TFormClient.edtCepExit(Sender: TObject);
begin
RESTClient1.BaseURL:='http://viacep.com.br/ws/'+edtCep.Text+'/json';
Try
  RESTRequest1.Execute;
  strRetorno:=RESTResponse1.JSONText;
  retOJSON := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(strRetorno),0) As TJSONObject;
  edtLogradouro.Text   := retOJSON.GetValue<String>('logradouro', '');
  edtComplemento.Text   := retOJSON.GetValue<String>('complemento', '');
  edtBairro.Text   := retOJSON.GetValue<String>('bairro', '');
  edtCidade.Text   := retOJSON.GetValue<String>('localidade', '');
  edtUf.Text   := retOJSON.GetValue<String>('uf', '');
except on e: Exception do
  ShowMessage(e.Message);
End;


end;

end.

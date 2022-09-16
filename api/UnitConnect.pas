unit UnitConnect;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, IdGlobal,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IdContext, System.JSON,
  IdHeaderList, IdCustomHTTPServer, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdHTTPServer;

type
  TFormConnect = class(TForm)
    IdHTTPServer1: TIdHTTPServer;
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure IdHTTPServer1CreatePostStream(AContext: TIdContext;
      AHeaders: TIdHeaderList; var VPostStream: TStream);
    procedure IdHTTPServer1DoneWithPostStream(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; var VCanFree: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormConnect: TFormConnect;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitDB;

procedure TFormConnect.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
   AForm : TStringList;
   Obj: TJSONValue;
   jsonObj: TJSONObject;
   registroArray: TJSONArray;
   Stream : TStream;
   S: String;
begin
   Try
     if ARequestInfo.Command = 'POST' then
        begin
           Stream := ARequestInfo.PostStream;
           if assigned(Stream) then
              begin
                 Stream.Position := 0;
//                 S := UTF8ToAnsi(ReadStringFromStream(Stream, -1, IndyTextEncoding_Default));
                 jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(ReadStringFromStream(Stream, -1, IndyTextEncoding_Default)), 0) as TJSONObject;
                 registroArray := TJSONArray.Create;
                 registroArray := jsonObj.GetValue<TJSONArray>('reg');
                 TThread.Synchronize(nil,
                   procedure
                   var
                     i: Integer;
                   begin
                    for i:=0 to Pred(registroArray.Size) do
                    begin
                      Try
                        //Verifica se a pessoa já foi cadastrada
                        FormDB.FDQpessoa.Close;
                        FormDB.FDQpessoa.SQL.Clear;
                        FormDB.FDQpessoa.SQL.Add('SELECT * From pessoa where dsdocumento = '+QuotedStr(registroArray.Get(i).GetValue<string>('doc', '')));
                        FormDB.FDQpessoa.Open;
                        FormPrincipal.Memo1.Lines.Add(FormDB.FDQpessoa.SQL.Text);
                        if FormDB.FDQpessoa.Eof then
                          //Inserir registro
                          begin
                            FormDB.FDCommand1.CommandText.Add('INSERT INTO public.pessoa(flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro)');
                            FormDB.FDCommand1.CommandText.Add('VALUES ('+QuotedStr(registroArray.Get(i).GetValue<string>('nat', ''))+','+QuotedStr(registroArray.Get(i).GetValue<string>('doc', ''))+','+QuotedStr(registroArray.Get(i).GetValue<string>('pnome', ''))+','+QuotedStr(registroArray.Get(i).GetValue<string>('snome', ''))+',Now()');
                            FormDB.FDCommand1.Execute;
                          end
                        else
                          //Atualizar registro
                          begin
                            FormDB.FDCommand1.CommandText.Add('UPDATE public.pessoa');
                            FormDB.FDCommand1.CommandText.Add('SET flnatureza='+QuotedStr(registroArray.Get(i).GetValue<string>('nat', ''))+', dsdocumento='+QuotedStr(registroArray.Get(i).GetValue<string>('doc', ''))+', nmprimeiro='+QuotedStr(registroArray.Get(i).GetValue<string>('pnome', ''))+', nmsegundo='+QuotedStr(registroArray.Get(i).GetValue<string>('snome', '')));
                            FormDB.FDCommand1.CommandText.Add('WHERE idpessoa = '+QuotedStr(FormDB.FDQpessoaidpessoa.AsString));
                            FormDB.FDCommand1.Execute;
                          end;
                          FormDB.FDConnection.Commit;
                      except on e: Exception do
                        FormPrincipal.Memo1.Lines.Add(e.Message);
                      End;
                      //Retorno

                    end;
                   end);
              end;
           Exit;
        end;

        if ARequestInfo.Command = 'GET' then
        begin
          Exit;
        end;

        if ARequestInfo.Command = 'DELETE' then
        begin
          Exit;
        end;
        AResponseInfo.ContentText:='ok';
//        AResponseInfo.ResponseText:='OK';
   except on e: Exception do
      FormPrincipal.Memo1.lines.Add(e.Message);
   End;

end;

procedure TFormConnect.IdHTTPServer1CreatePostStream(AContext: TIdContext;
  AHeaders: TIdHeaderList; var VPostStream: TStream);
begin
 VPostStream := TMemoryStream.Create;
end;

procedure TFormConnect.IdHTTPServer1DoneWithPostStream(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; var VCanFree: Boolean);
begin
  VCanFree := false;
end;

end.

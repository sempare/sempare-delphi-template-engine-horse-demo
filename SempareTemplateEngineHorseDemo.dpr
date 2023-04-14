program SempareTemplateEngineHorseDemo;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  Sempare.Template,
  Horse,
  DynForm in 'DynForm.pas';

type
  TDemo = record
    Name: string;
    FrameworkUrl: string;
    Url: string;
    Current: Boolean;
    constructor Create(const AName: String; const AFrameworkUrl, AUrl: string; const ACurrent: Boolean = false);
  end;

  { TDemo }

constructor TDemo.Create(const AName, AFrameworkUrl, AUrl: string; const ACurrent: Boolean);
begin
  name := AName;
  FrameworkUrl := AFrameworkUrl;
  Url := AUrl;
  Current := ACurrent;
end;

var
  LPort: integer;
  LDemos: TArray<TDemo>;

begin
  LDemos := [ //
    TDemo.Create('Web Broker', 'https://docwiki.embarcadero.com/RADStudio/Alexandria/en/Creating_WebBroker_Applications', 'https://github.com/sempare/sempare-delphi-template-engine/tree/main/demo/WebBrokerStandalone'), //
    TDemo.Create('Horse', 'https://github.com/HashLoad/horse', 'https://github.com/sempare/sempare-delphi-template-engine-horse-demo', true) //
    ];

  Template.Resolver.ContextNameResolver := function(const AName: string; const AContext: TTemplateValue): string
    var
      LLang: string;
      LReq: THorseRequest;
    begin
      LReq := AContext.AsType<THorseRequest>;
      if LReq.Headers.TryGetValue('Accept-Language', LLang) then
      begin
        LLang := LLang.Substring(0, 2);
      end;
      if LLang.IsEmpty then
        exit(AName)
      else
        exit(AName + '_' + LLang);
    end;

  LPort := 8080;
  THorseProvider.KeepConnectionAlive := true;

  writeln('This is the Sempare Template Engine Horse Demo');
  writeln('');
  writeln(Format('This is using the Sempare Template Engine v%s', [Template.Version]));
  writeln('');
  writeln('The server is running on port ' + inttostr(LPort));
  writeln('');
  writeln(Format('Connect your browser to http://localhost:%d', [LPort]));
  writeln('');
  writeln('Press Ctrl-C to terminate.');
  THorse.Get('/',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send(Template.ResolveWithContext('index', LDemos, Req));
    end);

  THorse.Get('/form',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      LTemplateData: TTemplateData;
    begin
      LTemplateData.Title := 'User Details';
      LTemplateData.FormName := 'userinfo';
      LTemplateData.FormAction := Req.PathInfo;
      LTemplateData.Fields := [ //
        TField.Create('FirstName', 'firstname'), //
        TField.Create('LastName', 'lastname'), //
        TField.Create('Email', 'email', 'TEmail') //
        ];
      LTemplateData.Buttons := [TButton.Create('Submit', 'submit')];
      Res.Send(Template.ResolveWithContext('dynform', LTemplateData, Req));
    end);

  THorse.Post('/form',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      LFormData: TFormData;
    begin
      LFormData.firstname := Req.ContentFields['firstname'];
      LFormData.lastname := Req.ContentFields['lastname'];
      LFormData.email := Req.ContentFields['email'];
      Res.Send(Template.ResolveWithContext('submitted', LFormData, Req));
    end);

  THorse.All('/*',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send(Template.ResolveWithContext('error404', Req));
    end);

  THorse.Listen(LPort);

end.

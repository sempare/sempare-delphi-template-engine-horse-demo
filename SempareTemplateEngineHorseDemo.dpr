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

begin
  THorse.Get('/',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      LDemos: TArray<TDemo>;
    begin
      LDemos := [ //
        TDemo.Create('Web Broker', 'https://docwiki.embarcadero.com/RADStudio/Alexandria/en/Creating_WebBroker_Applications', 'https://github.com/sempare/sempare-delphi-template-engine/tree/main/demo/WebBrokerStandalone'), //
        TDemo.Create('Horse', 'https://github.com/HashLoad/horse', 'https://github.com/sempare/sempare-delphi-template-engine-horse-demo', true) //
        ];
      Res.Send(TTemplateRegistry.Instance.Eval('index', LDemos));
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
      Res.Send(TTemplateRegistry.Instance.Eval('dynform', LTemplateData));

    end);

  THorse.Post('/form',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      LFormData: TFormData;
    begin
      LFormData.firstname := Req.ContentFields['firstname'];
      LFormData.lastname := Req.ContentFields['lastname'];
      LFormData.email := Req.ContentFields['email'];
      Res.Send(TTemplateRegistry.Instance.Eval('submitted', LFormData));
    end);

  THorse.All('/*',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send(TTemplateRegistry.Instance.Eval('error404'));
    end);

  THorse.Listen(8080);

end.

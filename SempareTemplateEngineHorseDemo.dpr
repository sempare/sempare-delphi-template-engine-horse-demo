program SempareTemplateEngineHorseDemo;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  Sempare.Template,
  Horse,
  DynForm in 'DynForm.pas';

begin
  THorse.Get('/',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send(TTemplateRegistry.Instance.Eval('index'));
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
        TField.create('FirstName', 'firstname'), //
        TField.create('LastName', 'lastname'), //
        TField.create('Email', 'email', 'TEmail') //
        ];
      LTemplateData.Buttons := [TButton.create('Submit', 'submit')];
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

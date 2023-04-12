# Sempare Template Engine demo using Horse

## Setup

- Ensure you have the BOSS dependency manager

```
  Download it from https://github.com/hashload/boss/releases
```

- Clone the demo project

```
  git clone https://github.com/sempare/sempare-delphi-template-engine-horse-demo
```

- Get the dependencies

```
  boss update
```

- Open SempareTemplateEngineHorseDemo.dproj in the Delphi IDE

## Dependencies

This demo depends on the following packages:
- horse
- sempare-delphi-template-engine

## What you need to know

Open the project SempareTemplateEngineHorseDemo.dproj

Note that the Sempare.Template unit is all that is required.

TTemplateRegistry is a helper utility that allows you to chose between loading templates from file, or from the registry.

```
begin
  TTemplateRegistry.Instance.LoadStrategy := [tlsLoadFile, tlsLoadResource];
  TTemplateRegistry.Instance.RefreshIntervalS := 5;
  TTemplateRegistry.Instance.AutomaticRefresh := true;

  THorse.Get('/',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send(TTemplateRegistry.Instance.Eval('index'));
    end);
```

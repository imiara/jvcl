{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: PackageUtils.pas, released on 2004-03-29.

The Initial Developer of the Original Code is Andreas Hausladen
(Andreas dott Hausladen att gmx dott de)
Portions created by Andreas Hausladen are Copyright (C) 2004 Andreas Hausladen.
All Rights Reserved.

Contributor(s): -

You may retrieve the latest version of this file at the Project JEDI's JVCL
home page, located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

{$I jvcl.inc}

unit PackageUtils;

interface

uses
  SysUtils, Classes, Contnrs,
  JvSimpleXml,
  Utils, DelphiData, Intf, GenerateUtils, PackageInformation;

type
  TPackageTarget = class;
  TProjectGroup = class;
  TPackageInfo = class;

  TPackageGroupArray = array[{Personal:}Boolean, {Kind:}TPackageGroupKind] of TProjectGroup;

  /// <summary>
  /// TJVCLFrameworks contains all possible package lists for the target. If
  /// Items[x] is nil then there is no .bpg file for this target kind.
  /// </summary>
  TJVCLFrameworks = class(TObject)
  private
    FItems: TPackageGroupArray;
    FTargetConfig: ITargetConfig;
    function GetCount: Integer;
  public
    constructor Create(ATargetConfig: ITargetConfig);
    destructor Destroy; override;

    property Items: TPackageGroupArray read FItems write FItems;
    property Count: Integer read GetCount;
    property TargetConfig: ITargetConfig read FTargetConfig;
  end;


  /// <summary>
  /// TPackageTarget contains a .bpl target and the .xml file in the
  /// Info property. This class is used to specify if the package should be
  /// compiled and/or installed. But it does not perform these actions itself.
  /// </summary>
  TPackageTarget = class(TObject)
  private
    FOwner: TProjectGroup;
    FLockInstallChange: Integer;

    FTargetName: string;
    FSourceName: string;
    FInfo: TPackageInfo;
    FJvDependencies: TStringList;  // Strings[]: "JvXxxx-"[D|R] | "JvQXxxx-"[D|R]
                                   // Objects[]: TRequiredPackage
    FJclDependencies: TStringList; // Strings[]: "JvXxxx-"[D|R] | "JvQXxxx-"[D|R]
                                   // Objects[]: TRequiredPackage
    FCompile: Boolean;
    FInstall: Boolean;

    FRequireList: TList;
    FContaineList: TList;

    function GetRelSourceDir: string;
    function GetSourceDir: string;
    procedure SetCompile(Value: Boolean);
    procedure SetInstall(const Value: Boolean);
    function GetContainCount: Integer;
    function GetContains(Index: Integer): TContainedFile;
    function GetRequireCount: Integer;
    function GetRequires(Index: Integer): TRequiredPackage;
    function GetJclDependenciesReqPkg(Index: Integer): TRequiredPackage;
    function GetJvDependenciesReqPkg(Index: Integer): TRequiredPackage;
  protected
    procedure UpdateContainList; virtual;
    procedure UpdateRequireList; virtual;
    procedure GetDependencies; virtual; // is called after alle package targets are created
  public
    constructor Create(AOwner: TProjectGroup; const ATargetName, ASourceName: string);
    destructor Destroy; override;

    function FindRuntimePackage: TPackageTarget;

    property TargetName: string read FTargetName;
    property SourceName: string read FSourceName;
    property SourceDir: string read GetSourceDir;
    property RelSourceDir: string read GetRelSourceDir;

    property Info: TPackageInfo read FInfo;
    property JvDependencies: TStringList read FJvDependencies;
    property JvDependenciesReqPkg[Index: Integer]: TRequiredPackage read GetJvDependenciesReqPkg;
    property JclDependencies: TStringList read FJclDependencies;
    property JclDependenciesReqPkg[Index: Integer]: TRequiredPackage read GetJclDependenciesReqPkg;

    // In contrast to Info.Xxx these properties only returns the
    // required/contained for this target.
    property RequireCount: Integer read GetRequireCount;
    property Requires[Index: Integer]: TRequiredPackage read GetRequires;
    property ContainCount: Integer read GetContainCount;
    property Contains[Index: Integer]: TContainedFile read GetContains;


    property Owner: TProjectGroup read FOwner;
    property Compile: Boolean read FCompile write SetCompile;
    property Install: Boolean read FInstall write SetInstall;
  end;

  /// <summary>
  /// TProjectGroup contains the data from a .bpg (Borland Package Group) file.
  /// </summary>
  TProjectGroup = class(TInterfacedObject, IPackageXmlInfoOwner)
  private
    FPackages: TObjectList;
    FTargetConfig: ITargetConfig;
    FFilename: string;

    FOnCompileChange: TNotifyEvent;

    function GetCount: Integer;
    function GetPackages(Index: Integer): TPackageTarget;
    function GetBpgName: string;
    function GetTarget: TCompileTarget;
    function GetIsVCLX: Boolean;

    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  protected
    function Add(const TargetName, SourceName: string): TPackageTarget;
    procedure LoadFile;
    procedure DoInstallChange; virtual;
  public
    constructor Create(ATargetConfig: ITargetConfig; const AFilename: string);
    destructor Destroy; override;
    procedure AddPackage(Pkg: TPackageTarget);

    function FindPackageByXmlName(const XmlName: string): TPackageTarget;
      { FindPackageByXmlName returns the TPackageTarget object that contains
        the specified .xml file. }
    function GetBplNameOf(Package: TRequiredPackage): string;

    property Count: Integer read GetCount;
    property Packages[Index: Integer]: TPackageTarget read GetPackages; default;

    property BpgName: string read GetBpgName;
    property Filename: string read FFilename;
    property TargetConfig: ITargetConfig read FTargetConfig;
    property Target: TCompileTarget read GetTarget;
    property IsVCLX: Boolean read GetIsVCLX;

    property OnCompileChange: TNotifyEvent read FOnCompileChange;
  end;

  /// <summary>
  /// TPackageInfo is a wrapper for TPackageXmlInfo objects that contains the
  /// generic .xml file for a bpl target.
  /// </summary>
  TPackageInfo = class(TObject)
  private
    FOwner: TPackageTarget;
    FXmlInfo: TPackageXmlInfo;
    FXmlDir: string;

    function GetRequireCount: Integer;
    function GetRequires(Index: Integer): TRequiredPackage;
    function GetTarget: TCompileTarget;
    function GetContainCount: Integer;
    function GetContains(Index: Integer): TContainedFile;
    function GetBplName: string;
    function GetDescription: string;
    function GetDisplayName: string;
    function GetIsDesign: Boolean;
    function GetName: string;
    function GetRequiresDB: Boolean;
  public
    constructor Create(AOwner: TPackageTarget; const AXmlDir: string);

    property Name: string read GetName; // "PackageName-"[R|D]
    property DisplayName: string read GetDisplayName; // "PackageName"
    property BplName: string read GetBplName; // "PackageName"[D|C][5-7][R|D]
    property Description: string read GetDescription;
    property RequiresDB: Boolean read GetRequiresDB;
    property RequireCount: Integer read GetRequireCount;
    property Requires[Index: Integer]: TRequiredPackage read GetRequires;
    property ContainCount: Integer read GetContainCount;
    property Contains[Index: Integer]: TContainedFile read GetContains;
    property IsDesign: Boolean read GetIsDesign;

    property Target: TCompileTarget read GetTarget;
    property Owner: TPackageTarget read FOwner;
  end;

implementation

function BplNameToGenericName(const BplName: string): string;
begin
   // obtain package name used in the xml file
  Result := ChangeFileExt(BplName, '');
  Delete(Result, Length(Result) - 2, 1);
  Result[Length(Result) - 1] := '-';
  if Result[3] = 'Q' then
    Delete(Result, 3, 1);
end;

{ TJVCLFrameworks }

constructor TJVCLFrameworks.Create(ATargetConfig: ITargetConfig);
var
  Kind: TPackageGroupKind;
begin
  inherited Create;
  FTargetConfig := ATargetConfig;
  for Kind := pkFirst to pkLast do
  begin
    if FileExists(TargetConfig.GetBpgFilename(False, Kind)) then
      FItems[False, Kind] := TProjectGroup.Create(TargetConfig, TargetConfig.GetBpgFilename(False, Kind));
    if FileExists(TargetConfig.GetBpgFilename(True, Kind)) then
      FItems[True, Kind] := TProjectGroup.Create(TargetConfig, TargetConfig.GetBpgFilename(True, Kind));
  end;
end;

destructor TJVCLFrameworks.Destroy;
var
  Kind: TPackageGroupKind;
begin
  for Kind := pkFirst to pkLast do
  begin
    FItems[False, Kind].Free;
    FItems[True, Kind].Free;
  end;
  inherited Destroy;
end;

function TJVCLFrameworks.GetCount: Integer;
begin
  Result := Length(FItems);
end;

{ TProjectGroup }

function TProjectGroup.Add(const TargetName, SourceName: string): TPackageTarget;
begin
  Result := nil;
  if FileExists(TargetConfig.JVCLPackagesXmlDir + '\' + BplNameToGenericName(TargetName) + '.xml') then // do not localize
  begin
    try
      Result := TPackageTarget.Create(Self, TargetName, SourceName)
    except
      on E: EFOpenError do
        FreeAndNil(Result);
    end;
    if Result <> nil then
      FPackages.Add(Result);
  end;
end;

procedure TProjectGroup.AddPackage(Pkg: TPackageTarget);
begin
  if Pkg <> nil then
    FPackages.Add(Pkg);
end;

constructor TProjectGroup.Create(ATargetConfig: ITargetConfig; const AFilename: string);
begin
  inherited Create;
  FFilename := AFilename;
  FPackages := TObjectList.Create(Filename <> '');
  FTargetConfig := ATargetConfig;
  if Filename <> '' then
    LoadFile;
end;

destructor TProjectGroup.Destroy;
begin
  FPackages.Free;
  inherited Destroy;
end;

procedure TProjectGroup.DoInstallChange;
begin
  if Assigned(FOnCompileChange) then
    FOnCompileChange(Self);
end;

function TProjectGroup.FindPackageByXmlName(const XmlName: string): TPackageTarget;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Packages[i];
    if CompareText(Result.Info.Name, XmlName) = 0 then
      Exit;
  end;
  Result := nil;
end;

function TProjectGroup.GetBpgName: string;
begin
  Result := ExtractFileName(Filename);
end;

function TProjectGroup.GetBplNameOf(Package: TRequiredPackage): string;
var
  Pkg: TPackageTarget;
begin
  if StartsWith(Package.Name, 'Jv', True) then
  begin
    Pkg := FindPackagebyXmlName(Package.Name);
    if Pkg <> nil then
      Result := Pkg.TargetName
    else
      Result := Package.Name;
  end
  else
    Result := Package.Name;
end;

function TProjectGroup.GetCount: Integer;
begin
  Result := FPackages.Count;
end;

function TProjectGroup.GetIsVCLX: Boolean;
begin
  Result := Pos('clx', LowerCase(BpgName)) > 0; 
end;

function TProjectGroup.GetPackages(Index: Integer): TPackageTarget;
begin
  Result := TPackageTarget(FPackages[Index]);
end;

function TProjectGroup.GetTarget: TCompileTarget;
begin
  Result := TargetConfig.Target;
end;

function SortProc_PackageTarget(Item1, Item2: Pointer): Integer;
var
  p1, p2: TPackageTarget;
begin
  p1 := Item1;
  p2 := Item2;
  Result := CompareText(p1.Info.DisplayName, p2.Info.DisplayName);
  if Result = 0 then
  begin
    if p1.Info.IsDesign and not p2.Info.IsDesign then
      Result := 1
    else if not p1.Info.IsDesign and p2.Info.IsDesign then
      Result := -1;
  end;
end;

procedure TProjectGroup.LoadFile;
var
  Lines: TStrings;
  i, ps: Integer;
  S: string;
  TgName: string;
begin
  Lines := TStringList.Create;
  try
    Lines.LoadFromFile(FileName);
    i := 0;

   // find "default:" target
    while i < Lines.Count do
    begin
      if StartsWith(Lines[I], 'default:', True) then // do not localize
        Break;
      Inc(i);
    end;
    Inc(i, 2);

   // now read the available targets
    while i < Lines.Count do
    begin
      S := Lines[i];
     // find targets
      if S <> '' then
      begin
        if S[1] > #32 then
        begin
          ps := Pos(':', S);
          if ps > 0 then
          begin
            TgName := TrimRight(Copy(S, 1, ps - 1));
           // does the .xml file exists for this target? <-> is it a vaild target?
            Add(TgName, Trim(Copy(S, ps + 1, MaxInt)));
          end;
        end;
      end;
      Inc(i);
    end;
  finally
    Lines.Free;
  end;

 // we use dependecies so the order if irrelevant and we can sort sort alpha.
  FPackages.Sort(SortProc_PackageTarget);

 // update dependencies after all package targets are created
  for i := 0 to Count - 1 do
    Packages[i].GetDependencies;
end;

function TProjectGroup._AddRef: Integer;
begin
  Result := 1;
end;

function TProjectGroup._Release: Integer;
begin
  Result := 1;
end;

{ TPackageTarget }

constructor TPackageTarget.Create(AOwner: TProjectGroup; const ATargetName,
  ASourceName: string);
begin
  inherited Create;
  FOwner := AOwner;
  FTargetName := ATargetName;
  FSourceName := ASourceName;
  FInfo := TPackageInfo.Create(Self, AOwner.TargetConfig.JVCLPackagesXmlDir);
  FJvDependencies := TStringList.Create;
  FJvDependencies.Sorted := True;
  FJclDependencies := TStringList.Create;
  FJclDependencies.Sorted := True;
  FCompile := True;

  FRequireList := TList.Create;
  FContaineList := TList.Create;
end;

destructor TPackageTarget.Destroy;
begin
  FRequireList.Free;
  FContaineList.Free;
  FJvDependencies.Free;
  FJclDependencies.Free;
  // FInfo is buffered and is destroyed by XmlFileCache
  inherited Destroy;
end;

function TPackageTarget.FindRuntimePackage: TPackageTarget;
begin
  Result := Owner.FindPackagebyXmlName(Copy(Info.Name, 1, Length(Info.Name) - 1) + 'R'); // do not localize
end;

function TPackageTarget.GetContainCount: Integer;
begin
  UpdateContainList;
  Result := FContaineList.Count;
end;

function TPackageTarget.GetContains(Index: Integer): TContainedFile;
begin
  UpdateContainList;
  Result := TContainedFile(FContaineList[Index]);
end;

/// <summary>
/// GetDependencies obtains the JVCL (JvXxx) and JCL ([D|C]JCLxx) dependencies
/// from the PackageInfo data. Only the JvXxx packages that are for this target
/// are added to the JvDependencies list. And only the [D|C]JCLxxx packages are
/// added to the JclDependencies list that are for this target. All items in
/// JvDependencies are physical files and are a valid JVCL target. All items in
/// JclDependencies must not be physical files.
/// </summary>
procedure TPackageTarget.GetDependencies;
var
  i: Integer;
begin
  FJvDependencies.Clear;
  for i := 0 to Info.RequireCount - 1 do
  begin
    // JVCL dependencies
    if StartsWith(Info.Requires[i].Name, 'Jv', True) then // do not localize
    begin
      if FileExists(Info.FXmlDir + '\' + Info.Requires[i].Name + '.xml') and // do not localize
         (Owner.FindPackagebyXmlName(Info.Requires[i].Name) <> nil) and
         Info.Requires[i].IsRequiredByTarget(Owner.TargetConfig.TargetSymbol) then
      begin
        FJvDependencies.AddObject(Info.Requires[i].Name, Info.Requires[i]);
      end;
    end
    else
    // is it a JCL dependency
    if StartsWith(Info.Requires[i].Name, 'DJcl', True) or // do not localize
       StartsWith(Info.Requires[i].Name, 'CJcl', True) then // do not localize
    begin
      if Info.Requires[i].IsRequiredByTarget(Owner.TargetConfig.TargetSymbol) then
        FJclDependencies.AddObject(Info.Requires[i].Name, Info.Requires[i]);
    end;
  end;
end;

function TPackageTarget.GetJclDependenciesReqPkg(Index: Integer): TRequiredPackage;
begin
  Result := TRequiredPackage(JclDependencies.Objects[Index]);
end;

function TPackageTarget.GetJvDependenciesReqPkg(Index: Integer): TRequiredPackage;
begin
  Result := TRequiredPackage(JvDependencies.Objects[Index]);
end;

function TPackageTarget.GetRelSourceDir: string;
begin
  Result := ExtractFileDir(FSourceName);
end;

function TPackageTarget.GetRequireCount: Integer;
begin
  UpdateRequireList;
  Result := FRequireList.Count;
end;

function TPackageTarget.GetRequires(Index: Integer): TRequiredPackage;
begin
  UpdateRequireList;
  Result := TRequiredPackage(FRequireList[Index]);
end;

function TPackageTarget.GetSourceDir: string;
begin
  Result := FollowRelativeFilename(ExtractFileDir(Owner.Filename), RelSourceDir);
end;

procedure TPackageTarget.SetCompile(Value: Boolean);
var
  i: Integer;
  Pkg: TPackageTarget;
begin
  if Value <> FCompile then
  begin
    FCompile := Value;
    if not FCompile then
      FInstall := False;

    Inc(FLockInstallChange);
    try
      if FCompile then
      begin
       // activate packages on which this package depend on
        for i := 0 to JvDependencies.Count - 1 do
        begin
          Pkg := Owner.FindPackagebyXmlName(JvDependencies[i]);
          if Pkg <> nil then
            Pkg.SetCompile(True);
        end;
      end
      else
      begin
       // deactivate all packages which depend on this package
        for i := 0 to Owner.Count - 1 do
        begin
          Pkg := Owner.Packages[i];
          if Pkg <> Self then
          begin
            if Pkg.JvDependencies.IndexOf(Info.Name) <> -1 then
              Pkg.Compile := False;
          end;
        end;
      end;
    finally
      Dec(FLockInstallChange);
    end;
    if FLockInstallChange = 0 then
      Owner.DoInstallChange;
  end;
end;

procedure TPackageTarget.SetInstall(const Value: Boolean);
begin
  if Info.IsDesign then
    FInstall := Value
  else
    FInstall := False; // runtime packages are not installable.
  if Value then
    Compile := True;
end;

procedure TPackageTarget.UpdateContainList;
var
  i: Integer;
begin
  if FContaineList.Count <> 0 then
    Exit;
  for i := 0 to Info.ContainCount - 1 do
  begin
    if Info.Contains[i].IsUsedByTarget(Owner.TargetConfig.TargetSymbol) then
      FContaineList.Add(Info.Contains[i]);
  end;
end;

procedure TPackageTarget.UpdateRequireList;
var
  i: Integer;
begin
  if FRequireList.Count <> 0 then
    Exit;
  for i := 0 to Info.RequireCount - 1 do
  begin
    if Info.Requires[i].IsRequiredByTarget(Owner.TargetConfig.TargetSymbol) then
      FRequireList.Add(Info.Requires[i]);
  end;
end;

{ TPackageInfo }

constructor TPackageInfo.Create(AOwner: TPackageTarget; const AXmlDir: string);
begin
  inherited Create;
  FOwner := AOwner;
  FXmlDir := AXmlDir;
  FXmlInfo := GetPackageXmlInfo(Owner.TargetName, AXmlDir);
end;

function TPackageInfo.GetBplName: string;
begin
  Result := Owner.TargetName;
end;

function TPackageInfo.GetTarget: TCompileTarget;
begin
  Result := Owner.Owner.TargetConfig.Target;
end;

function TPackageInfo.GetContainCount: Integer;
begin
  Result := FXmlInfo.ContainCount;
end;

function TPackageInfo.GetContains(Index: Integer): TContainedFile;
begin
  Result := FXmlInfo.Contains[Index];
end;

function TPackageInfo.GetRequireCount: Integer;
begin
  Result := FXmlInfo.RequireCount;
end;

function TPackageInfo.GetRequires(Index: Integer): TRequiredPackage;
begin
  Result := FXmlInfo.Requires[Index];
end;

function TPackageInfo.GetDescription: string;
begin
  Result := FXmlInfo.Description;
end;

function TPackageInfo.GetDisplayName: string;
begin
  Result := FXmlInfo.DisplayName;
end;

function TPackageInfo.GetIsDesign: Boolean;
begin
  Result := FXmlInfo.IsDesign;
end;

function TPackageInfo.GetName: string;
begin
  Result := FXmlInfo.Name;
end;

function TPackageInfo.GetRequiresDB: Boolean;
begin
  Result := FXmlInfo.RequiresDB;
end;

initialization
  BplNameToGenericNameHook := BplNameToGenericName;
  ExpandPackageTargets := ExpandTargets;

end.

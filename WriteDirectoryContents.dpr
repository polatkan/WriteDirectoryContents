program WriteDirectoryContents;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  System.Types,
  System.IOUtils;

const
  ROOT_TEXT = 'root';
  FORMATTED_DIRECTORY = '[%s]';
  INDENTATION_SPACE_SMALL = ' ';
  INDENTATION_SPACE_BIG = '   ';
  INDENTATION_LINE = '──' + INDENTATION_SPACE_SMALL;
  INDENTATION_START = '├';
  INDENTATION_FINISH = '└';
  INDENTATION_CONTINUE = '│';
  INDENTATION_TREE = INDENTATION_SPACE_SMALL + INDENTATION_START + INDENTATION_LINE;
  INDENTATION_FILE: TStringDynArray = [INDENTATION_SPACE_SMALL + INDENTATION_START, INDENTATION_SPACE_SMALL + INDENTATION_FINISH];
  INDENTATION_DIRECTORY: TStringDynArray = [INDENTATION_CONTINUE, INDENTATION_SPACE_SMALL];

procedure DoWriteLine(const Value: string; const IsWriteConsole: Boolean; var OutputFile: TStreamWriter);
begin
  OutputFile.WriteLine(Value);
  If IsWriteConsole then Writeln(Value);
end;

procedure DoWriteDirectoryContents(const Directory, Indent: string; const IsWriteConsole: Boolean; var OutputFile: TStreamWriter);
var
  i: Integer;
  LastDir: Integer;
  Files: TStringDynArray;
  SubDirs: TStringDynArray;
  SubDir: string;
begin
  Files := TDirectory.GetFiles(Directory);
  for i := 0 to High(Files) - 1 do
    DoWriteLine(Indent + INDENTATION_TREE + ExtractFileName(Files[i]), IsWriteConsole, OutputFile);
  SubDirs := TDirectory.GetDirectories(Directory);
  if Length(Files) > 0 then
    DoWriteLine(Indent + INDENTATION_FILE[Ord(Length(SubDirs) = 0)] + INDENTATION_LINE + ExtractFileName(Files[High(Files)]),
      IsWriteConsole, OutputFile);
  for i := 0 to High(SubDirs) do
  begin
    SubDir := SubDirs[i];
    LastDir := Ord(i = High(SubDirs));
    DoWriteLine(Indent + INDENTATION_FILE[LastDir] + INDENTATION_LINE + Format(FORMATTED_DIRECTORY, [ExtractFileName(SubDir)]),
      IsWriteConsole, OutputFile);
    DoWriteDirectoryContents(SubDir, Indent + INDENTATION_SPACE_SMALL + INDENTATION_DIRECTORY[LastDir] + INDENTATION_SPACE_BIG,
      IsWriteConsole, OutputFile);
  end;
end;

procedure SaveDirectoryTreeToFile();
var
  OutputFileName: string;
  IsWriteConsole: Boolean;
  OutputFile: TStreamWriter;
begin
  OutputFileName := ChangeFileExt(ParamStr(0), '.txt');
  OutputFile := TStreamWriter.Create(OutputFileName, False, TEncoding.UTF8);
  try
    IsWriteConsole := SameText(ParamStr(1), '-c');
    DoWriteLine(Format(FORMATTED_DIRECTORY, [ROOT_TEXT]), IsWriteConsole, OutputFile);
    DoWriteDirectoryContents(ExtractFileDir(ParamStr(0)), EmptyStr, IsWriteConsole, OutputFile);
    WriteLn('Directory tree has been written to ', OutputFileName);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  OutputFile.Free;
end;

begin
  try
    SaveDirectoryTreeToFile();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  ReadLn;

end.

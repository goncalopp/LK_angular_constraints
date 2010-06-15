unit mydebugger_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
mydebugger = class
	myfile: textfile;
    constructor create(filename: String);
    procedure write(s:String);
    procedure close();
	end;

var
dbg: mydebugger;

implementation

constructor mydebugger.create(filename: String);
	begin
    AssignFile(myfile, filename);
    rewrite(myfile);
    end;

procedure mydebugger.write(s: String);
	begin
    writeln(myfile, s);
    end;

procedure mydebugger.close();
	begin
    closefile(myfile);
    end;

end.


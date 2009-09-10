unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  domain_unit, region_unit, point3d_unit, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
   ToggleBox1: TToggleBox;
    procedure FormCreate(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  region1: Region;

implementation

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;




procedure TForm1.ToggleBox1Change(Sender: TObject);
var point1, point2: Point3d; i: integer;
begin
point1:= Point3d.create(0,0,0);
point2:= Point3d.create(50,50,0);


for i:=0 to 99999 do begin
canvas.clear;
canvas.Ellipse(trunc(point1.x+100), trunc(-point1.y+100), trunc(point1.x+110), trunc(-point1.y+110));
canvas.Ellipse(trunc(point2.x+100), trunc(-point2.y+100), trunc(point2.x+110), trunc(-point2.y+110));

point2.rotateOver('z', point1, pi/100000);
canvas.textout(30,30, floattostr(point2.x)+' '+floattostr(point2.y)+' '+floattostr(point2.z));
application.processmessages;
//sleep(0);
end;

end;

initialization
  {$I unit1.lrs}

end.


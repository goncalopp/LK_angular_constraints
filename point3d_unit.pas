unit point3d_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;


type
  Point3d = class
  private
    { private declarations }
  public
    x,y,z: integer;
    constructor create(x_,y_,z_: integer);
  end;

implementation

constructor Point3d.create(x_,y_,z_: integer);
begin
x:=x_;
y:=y_;
z:=z_;
end;

end.


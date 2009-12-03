unit region_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, point3d_unit, math;

type
  Region = class
  private
  public
  	point1, point2: Point3D;
    constructor create(bound1, bound2: Point3D);
  end;

implementation

constructor Region.create(bound1, bound2: Point3D);
	begin
	point1:= Point3D.create( min(bound1.x, bound2.x), min(bound1.y, bound2.y), min(bound1.z, bound2.z));
	point2:= Point3D.create( max(bound1.x, bound2.x), max(bound1.y, bound2.y), max(bound1.z, bound2.z));
	bound1.Destroy();
    bound2.Destroy();
 	end;

end.


unit domain_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, region_unit;

type
  Domain = class
  private
  public
    goodregion: TRegion;
    nogoodregions: array of TRegion;
    constructor create(good_region: TRegion);
    procedure add_no_good_region(no_good_region: TRegion);
  end;

implementation
constructor Domain.create(good_region: TRegion);
	begin
	goodregion:= good_region;
	setlength(nogoodregions,0);
	end;

procedure Domain.add_no_good_region(no_good_region: TRegion);
	begin

	end;

end.


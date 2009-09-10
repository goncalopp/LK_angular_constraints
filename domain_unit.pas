unit domain_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, region_unit;

type
  Domain = class
  private
    goodregion: Region;
    nogoodregions: array of Region;
  public
    constructor create(good_region: Region);
    procedure add_no_good_region(no_good_region: Region);
  end;

implementation
constructor Domain.create(good_region: Region);
	begin
	goodregion:= good_region;
	setlength(nogoodregions,0);
	end;

procedure Domain.add_no_good_region(no_good_region: Region);
	begin

	end;

end.


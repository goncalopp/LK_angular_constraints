unit sinewaveinregion_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sinewave_unit, region_unit;

type
  SineWaveInRegion = class
    sine: sinewave;
   	region: Region;
    constructor create(sine_: sinewave; region_: Region);
    end;

implementation

constructor SineWaveInRegion.create(sine_: sinewave; region_: Region);
	begin
    sine:=sine_;
    region:=region_;
    end;

end.
                                                   

unit sineWave_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  sineWave = class
  private
  public
    amplitude, phase: double;
    constructor create(amplitude_, phase_: double);
    procedure invert();                           
    function addWave(wave: sineWave):sineWave;
    function valueat(x: double): double;
    end;

implementation

constructor sineWave.create(amplitude_, phase_: double);
	begin
    amplitude:= amplitude_;
    phase:= phase_;
    end;

procedure sineWave.invert();
	begin
    phase:= phase + pi;
    if (phase>=2*pi)
    	then phase:=phase - 2*pi;
    end;

function sineWave.addWave(wave: sineWave):sineWave;
	begin
    result:= sineWave.create
    	(

    	sqrt
    		(
    		sqr(amplitude*sin(phase)+wave.amplitude*sin(wave.phase))+
    		sqr(amplitude*cos(phase)+wave.amplitude*cos(wave.phase))
    		)

      	,
    	arctan
     		(
            (amplitude*sin(phase)+wave.amplitude*sin(wave.phase))
            /
            (amplitude*cos(phase)+wave.amplitude*cos(wave.phase))
            )
    	);
    end;

function sineWave.valueat(x: double): double;
	begin
    result:= amplitude*sin(x+phase);
    end;

end.


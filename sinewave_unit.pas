unit sineWave_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
  sineWave = class
  private
  	procedure simplifyPhase();
  public
    amplitude, phase: double;
    constructor create(amplitude_, phase_: double);
    procedure invert();                           
    function addWave(wave: sineWave):sineWave;
    function valueat(x: double): double;
    function firstZero():double;
    end;

implementation

constructor sineWave.create(amplitude_, phase_: double);
	begin
    amplitude:= amplitude_;
    phase:= phase_;
    end;


procedure sineWave.simplifyPhase();
	begin
    if ((phase>=2*pi) or (phase<0)) then
        phase:= phase - trunc(phase / (2*pi))*2*pi;
    end;

procedure sineWave.invert();
	begin
    phase:= phase + pi;
    simplifyPhase();
    end;

function sineWave.addWave(wave: sineWave):sineWave;
var x,y,newphase:double;
    begin
    y:= amplitude*sin(phase)+wave.amplitude*sin(wave.phase);
    x:= amplitude*cos(phase)+wave.amplitude*cos(wave.phase);
    newphase:=ArcTan2(y,x);
    result:= sineWave.create(sqrt(sqr(x)+sqr(y)), newphase);
    result.simplifyPhase();
    end;

function sineWave.valueat(x: double): double;
	begin
    result:= amplitude*sin(x+phase);
    end;

function sineWave.firstZero():double;
	begin
    simplifyPhase();
    result:=pi-phase;
    if (result<0) then
    	result:=2*pi - phase;
    end;

end.


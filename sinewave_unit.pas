unit sineWave_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, Graphics;      	//debug remove graphics

type
  sineWave = class
  private
  	procedure simplifyPhase();
  public
    amplitude, phase, y_deslocation: double;
    color: TColor;         //debug
    constructor create(amplitude_, phase_, y_deslocation_: double);
    procedure invert();                           
    function addWave(wave: sineWave):sineWave;
    function valueat(x: double): double;
    function firstZero():double;
    function secondZero():double;
    end;

implementation

constructor sineWave.create(amplitude_, phase_, y_deslocation_:double);
	begin
    amplitude:= amplitude_;
    phase:= phase_;
    y_deslocation:= y_deslocation_;
    end;


procedure sineWave.simplifyPhase();
	begin
    if ((phase>=2*pi) or (phase<0)) then
        phase:= phase - floor(phase / (2*pi))*2*pi;
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
    result:= sineWave.create(sqrt(sqr(x)+sqr(y)), newphase, wave.y_deslocation+y_deslocation);
    result.simplifyPhase();
    end;

function sineWave.valueat(x: double): double;
	begin
    result:= amplitude*sin(x+phase)+y_deslocation;
    end;

function sineWave.firstZero():double;
	begin
    simplifyPhase();
    result:=pi+arcsin(y_deslocation/amplitude)-phase;
    if (result<0) then
    	result:=result+2*pi;
    end;

function sineWave.secondZero():double;
	begin
    simplifyPhase();
    result:=2*pi-arcsin(y_deslocation/amplitude)-phase;
    if (result<0) then
    	result:=result+2*pi;
    end;

end.


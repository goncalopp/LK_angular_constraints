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
    zeros: array[0..1] of double;
    color: TColor;         //debug
    constructor create(amplitude_, phase_, y_deslocation_: double);
    procedure invert();                           
    function addWave(wave: sineWave):sineWave;
    function intersectWave(wave: sineWave):sineWave;
    function valueat(x: double): double;
    procedure calculateZeros();
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
    result:= sineWave.create(sqrt(sqr(x)+sqr(y)), newphase, -wave.y_deslocation+y_deslocation);
    result.simplifyPhase();
    end;

function sineWave.intersectWave(wave: sineWave):sineWave;
	begin
    wave.invert();
    result:= addwave(wave);
    wave.invert();
    end;

function sineWave.valueat(x: double): double;
	begin
    result:= amplitude*sin(x+phase)+y_deslocation;
    end;

procedure sineWave.calculateZeros();
	var tmp:double;
 	begin
    simplifyPhase();
    try
    	tmp:=arcsin(y_deslocation/amplitude);
    except
        zeros[0]:=-1;
        zeros[1]:=-1;
        exit;
        end;
    zeros[0]:=pi+tmp-phase;
    zeros[1]:=2*pi-tmp-phase;
    if (zeros[0]<0) then
    	zeros[0]:=zeros[0]+2*pi;
    if (zeros[1]<0) then
    	zeros[1]:=zeros[1]+2*pi;
    if (zeros[0]>zeros[1]) then
    	begin
        tmp:=zeros[0];
        zeros[0]:=zeros[1];
        zeros[1]:=tmp;
        end;
    end;

end.


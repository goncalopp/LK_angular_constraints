unit sineWave_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, Graphics, PointND_unit;      	//debug remove graphics

type

  sineWave = class
  private
  	procedure simplifyPhase();
  public
    amplitude, phase, y_deslocation: double;
    zeros_calculated: boolean;
    zeros: array of PointND;
    color: TColor;         //debug
    constructor create(amplitude_, phase_, y_deslocation_: double);
    procedure invert();
    function addWave(wave: sineWave):sineWave;
    function intersectWave(wave: sineWave):sineWave;
    function valueat(x: double): double;
    function getZeros():TPointNDArray;
    end;

implementation


constructor sineWave.create(amplitude_, phase_, y_deslocation_:double);
	begin
    amplitude:= amplitude_;
    phase:= phase_;
    y_deslocation:= y_deslocation_;
    zeros_calculated:= false;
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

function sineWave.getZeros():TPointNDArray;
var tmp, z0, z1:double;
 	begin
    if not zeros_calculated then
    	begin
        simplifyPhase();
        try
        	tmp:=arcsin(y_deslocation/amplitude);
        except
            setlength(zeros,0);
            exit;
            end;
         z0:=pi+tmp-phase;
         z1:=2*pi-tmp-phase;
         if (z0<0) then
         	z0:=z0+2*pi;
         if (z1<0) then
         	z1:=z1+2*pi;
         if (z0>z1) then         //swap
         	begin
             tmp:=z0;
             z0:=z1;
             z1:=tmp;
             end;

         setlength(zeros,2);
         zeros[0]:=PointND.create(z0);
         zeros[1]:=PointND.create(z1);
         zeros_calculated:=true;
       	 end;
    result:=zeros;
 	end;

end.


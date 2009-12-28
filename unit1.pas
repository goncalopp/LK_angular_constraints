unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  domain_unit, region_unit, atom_unit, point3d_unit, rigidgroup_unit, sinewave_unit, StdCtrls,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    frontview: TImage;
    sineview: TImage;
    sideview: TImage;
    perspectiveview: TImage;    
    topview: TImage;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure drawPoint(p:point3d; size: integer);
    procedure drawCenterDomainCalculation();
    procedure drawSine(sine: sinewave);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  rigid: rigidgroup;

implementation

{ TForm1 }


function xtransformation(x: double): integer;
	begin
    result:= trunc(x+120);
	end;

function ytransformation(y: double): integer;
	begin
    result:= trunc(240- (y+120) );
    end;

procedure TForm1.drawCenterDomainCalculation();
var i: integer; p: point3d;
 	begin
    frontview.Canvas.Clear();
	sideview.Canvas.Clear();
	topview.Canvas.Clear();
	perspectiveview.Canvas.Clear();

    for i:=0 to 9 do
		begin
        drawPoint(rigid.atoms[i].position, 2);
		end;

    perspectiveview.canvas.moveto(160,120);
    perspectiveview.canvas.lineto(160,0);
    perspectiveview.canvas.moveto(160,120);
    perspectiveview.canvas.lineto(800,120);
    perspectiveview.canvas.moveto(160,120);
    perspectiveview.canvas.lineto(40,240);
    application.processmessages();
    end;

procedure TForm1.drawPoint(p:point3d; size: integer);
var x1,x2,y1,y2,z1,z2: integer;
	begin
    frontview.Canvas.Rectangle(
    					xtransformation(p.x)-size, ytransformation(p.y)-size,
        				xtransformation(p.x)+size, ytransformation(p.y)+size
						);
	sideview.Canvas.Rectangle(
    					xtransformation(p.z)-size, ytransformation(p.y)-size,
        				xtransformation(p.z)+size, ytransformation(p.y)+size
						);
	topview.Canvas.Rectangle(
    					xtransformation(p.x)-size, ytransformation(p.z)-size,
        				xtransformation(p.x)+size, ytransformation(p.z)+size
						);
    perspectiveview.Canvas.Rectangle(
    					xtransformation(p.x/1+p.z*1.41/5)-size, ytransformation(p.y/1+p.z*1.41/5)-size,
        				xtransformation(p.x/1+p.z*1.41/5)+size, ytransformation(p.y/1+p.z*1.41/5)+size
						);

	perspectiveview.canvas.moveto(160,120);
    perspectiveview.canvas.lineto(xtransformation(p.x/1+p.z*1.41/5) ,ytransformation(p.y/1+p.z*1.41/5));
	end;

procedure TForm1.drawSine(sine: sinewave);
var i: integer;
	begin
    sineview.Canvas.moveto(0, (sineview.height div 2) - trunc(50*sine.valueat(0)));
    for i:=1 to sineview.width do
    	begin
        sineview.Canvas.lineto(i, (sineview.height div 2) - trunc(50*sine.valueat(i/sineview.Width*  2*pi)));
        end;
    end;


procedure TForm1.Timer1Timer(Sender: TObject);
	begin
    drawCenterDomainCalculation();

	end;



procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
	begin
    rigid:= rigidgroup.Create();
    for i:=0 to 9 do
		rigid.addAtom(random()*120 , random()*120, random()*120, 0, 0, 0, 0, 0, 0);
    rigid.recalculateCenter();
    timer1.enabled:=true;

    rigid.calculateCenterDomain(pi/8, pi/16, application);
	end;


initialization
  {$I unit1.lrs}

end.


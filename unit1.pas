unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  domain_unit, region_unit, atom_unit, point3d_unit, rigidgroup_unit, StdCtrls,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    frontview: TImage;
    sideview: TImage;
    perspectiveview: TImage;
    topview: TImage;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure drawPoint(p:point3d; size: integer);
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

procedure TForm1.FormCreate(Sender: TObject);
	begin

	end;

function xtransformation(x: double): integer;
	begin
    result:= trunc(x+120);
	end;

function ytransformation(y: double): integer;
	begin
    result:= trunc(240- (y+120) );
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

	perspectiveview.canvas.moveto(160,120);
    perspectiveview.canvas.lineto(160,0);
    perspectiveview.canvas.moveto(160,120);
    perspectiveview.canvas.lineto(800,120);
    perspectiveview.canvas.moveto(160,120);
    perspectiveview.canvas.lineto(40,240);



	end;


procedure TForm1.Timer1Timer(Sender: TObject);
var i:integer; p: point3d;
	begin
    frontview.Canvas.Clear();
	sideview.Canvas.Clear();
	topview.Canvas.Clear();
	perspectiveview.Canvas.Clear();

    for i:=0 to 9 do
		begin
        drawPoint(rigid.atoms[i].position, 2);
		end;
    application.processmessages();
	end;



procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
	begin
    rigid:= rigidgroup.Create();
    for i:=0 to 9 do
		rigid.addAtom(random()*240-120 , random()*240 -120, random()*240 -120, 0, 0, 0, 0, 0, 0);
    //rigid.recalculateCenter();
    timer1.enabled:=true;
    rigid.calculateCenterDomain(pi/8, pi/16, application);
	end;


initialization
  {$I unit1.lrs}

end.


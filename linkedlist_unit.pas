unit linkedList_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  LinkedNode = class
  	private
 	public
    next: LinkedNode;
    previous: LinkedNode;
    element: TObject;
    constructor create(element_: TObject);
    procedure setNext(node: LinkedNode);
    procedure setPrevious(node: LinkedNode);
  end;

  LinkedList = class
  	private
 	public
    head: LinkedNode;
    tail: LinkedNode;
    position: LinkedNode;
    counter: integer;
    constructor create();
    procedure addElementAfter(node: LinkedNode; element: TObject);
    procedure addElement(element: TObject);
    procedure removeElement(node: LinkedNode);
    function advance(): LinkedNode;

  end;

implementation
constructor LinkedNode.create(element_: TObject);
	begin
    element:=element_;
    end;

procedure LinkedNode.setNext(node: LinkedNode);
   	begin
    next:=node;
    if (next<>nil) then
    	next.previous:=self;
    end;

procedure LinkedNode.setPrevious(node: LinkedNode);
   	begin
    previous:=node;
    if (previous<>nil) then
    	previous.next:=self;
    end;

constructor LinkedList.create();
	begin
    counter:=0;
    end;

procedure LinkedList.addElementAfter(node: LinkedNode; element: TObject);
var newnode: LinkedNode;
	begin
    newnode:= LinkedNode.create(element);
    if (counter=0) then
        begin
        head:=newnode;
        position:=head;
        end
	else
    	if (counter=1) then
    		begin
        	tail:=newnode;
        	tail.setPrevious(head);
        	end
        else
        	begin
            if (node.next<>nil) then
            	node.next.setPrevious(newnode)
            else
            	tail:=newnode;
            node.setNext(newnode);
            end;
    counter:=counter+1;
    end;


procedure LinkedList.removeElement(node: LinkedNode);
	begin
    if (counter=1) then
    	begin
       	head:=nil;
        tail:=nil;
        node.free;
        counter:=0;
        end;

    if (counter>1) then
    	begin
        if (node.previous<>nil) then
        	node.previous.setNext(node.next)
        else
        	begin
            if (position=head) then
            	position:=head.next;
        	head:=node.next;
            end;

        if (node.next<>nil) then
        	node.next.setPrevious(nil)
        else
        	begin
            if (position=tail) then
            	position:=tail.previous;
            tail:=node.previous;
            end;
        node.free();
        counter:=counter-1;
        end;
    end;

function LinkedList.advance(): LinkedNode;
	begin
    result:=position;
    if (position.next<>nil) then
     	position:=position.next;
    end;

procedure LinkedList.addElement(element: TObject);
	begin
    addElementAfter(tail, element);
    end;

end.



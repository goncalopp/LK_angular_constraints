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
    length: integer;
    constructor create();
    procedure addAfter(node: LinkedNode; element: TObject);
    procedure add(element: TObject);
    function remove(node: LinkedNode): TObject;
    function remove(): TObject;
    function advance(): LinkedNode;
    procedure rewind();

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
    length:=0;
    end;

procedure LinkedList.addAfter(node: LinkedNode; element: TObject);
var newnode: LinkedNode;
	begin
    newnode:= LinkedNode.create(element);
    if (length=0) then
        begin
        head:=newnode;
        tail:=head;
        position:=head;
        end
	else
    	if (length=1) then
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
    length:=length+1;
    end;

function LinkedList.remove(): TObject;
	begin
    result:= remove(position);
    end;

function LinkedList.remove(node: LinkedNode): TObject;
	begin
    result:= node.element;
    if position=node then
    	position:=node.next;


    if (length=1) then
    	begin
       	head:=nil;
        tail:=nil;
        node.free;
        length:=0;
        end;

    if (length>1) then
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
        length:=length-1;
        end;
    end;

function LinkedList.advance(): LinkedNode;
	begin
    result:=nil;
    if (position<>nil) then
    	begin
    	result:=position;
    	if (position.next<>nil) then
    	 	position:=position.next;
        end;
    end;

procedure LinkedList.add(element: TObject);
	begin
    addAfter(tail, element);
    end;

procedure LinkedList.rewind();
	begin
    position:=head;
    end;

end.



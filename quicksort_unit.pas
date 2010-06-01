unit quicksort_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

    TYPE
  	QSarray = ARRAY OF TObject;
  	QSPointer = ^TObject;
  	QSMapping = double;
  	QSFunction = Function(obj: TObject): QSMapping;

	PROCEDURE Quicksort(arr: QSArray; f: QSFunction; size: Integer);

implementation


procedure swap(a,b: QSPointer);
var t: TObject;
	BEGIN
    t :=  a^;
    a^ := b^;
    b^ := t
    END;

function Split(arr: QSarray; f: QSfunction; start, stop: integer): integer;
var left, right: integer;
    pivot: QSMapping;
    BEGIN
	pivot := f(arr[start]);
    left := start + 1;
    right := stop;
    WHILE left <= right DO
    	BEGIN
    	WHILE (left <= stop) AND (f(arr[left]) < pivot) DO
        	left := left + 1;
        WHILE (right > start) AND (f(arr[right]) >= pivot) DO
        	right := right - 1;
        IF left < right THEN
        	swap(@arr[left], @arr[right]);
        END;

    swap(@arr[start], @arr[right]);
    result := right
    END;


PROCEDURE QuicksortRecur(arr: QSarray; f: QSfunction; start, stop: integer);
VAR
splitpt: integer;
    BEGIN
    IF start < stop THEN
    	BEGIN
        splitpt := Split(arr, f, start, stop);
        QuicksortRecur(arr, f, start, splitpt-1);
        QuicksortRecur(arr, f, splitpt+1, stop);
        END
    END;

PROCEDURE Quicksort(arr: QSArray; f: QSFunction; size: Integer);
	BEGIN
	QuicksortRecur(arr, f, 0, size-1)
    END;
END.




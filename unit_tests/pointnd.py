a= PointND([0,1,2])
b= PointND(a)
assert b[0]==0
assert b[1]==1
assert b[2]==2

b+1
assert b[0]==0
assert b[1]==1
assert b[2]==2
b+=1
assert b[0]==1
assert b[1]==2
assert b[2]==3

assert b.norm()== sqrt(1+2*2+3*3)
assert len(a)==len(b)==3
b_copy= PointND(b)
assert b==b_copy
b_copy[1]+=1
assert b_copy[1]==3
assert b<>b_copy

try:
	a= b>b_copy
	raise Exception("comparing PointNDs of multiple dimentions should raise a exception")
except:
	pass

a=PointND([2])
b=PointND([5])
assert a<b

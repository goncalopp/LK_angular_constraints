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


#ROTATION TESTS--------------------------
a= PointND([1,0])
a.rotate2D(pi/4)
assert equal(a[0],a[1])
assert equal(a[0], 0.70710678118654757)	#sqrt(2)
a.rotate2D(pi/4)
assert equal(a[0], 0)
assert equal(a[1],1)
a= PointND([5,5])
a.rotate2D(pi/4)
assert equal(a[1], 7.07106781187) #sqrt(50)

a= PointND([0,6])
b= PointND([0,3])
a.rotateOver2D(b, pi/2)
assert equal(a[0], -3)
assert equal(a[1], 3)

a= PointND([3,4,5])
b= PointND([2,1,4])
a.rotateOver3D(b, 0, pi)
assert equal(a[0], 3)
assert equal(a[1], -2)
assert equal(a[2], 3)





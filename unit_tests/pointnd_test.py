from itertools import combinations

#AUXILIARY FUNCTIONS --------------------------------------
def copy_test(point):
	assert isinstance(point, PointND)
	copy= PointND(point)
	assert len(point)==len(copy)
	for i in range(len(point)):
		assert point[i]==copy[i]

def point_operations_test(p1,p2):
	assert isinstance(p1, PointND) and isinstance(p2, PointND)
	if len(p1)!=len(p2):
		raise Exception("testing two points of different dimention number")

	def test():
		for i in range(len(p1)):
			assert sum_p[i]== p1[i]+p2[i]
			assert dif1_p[i]== p1[i]-p2[i]
			assert dif2_p[i]== p2[i]-p1[i]

	sum_p= p1+p2
	dif1_p= p1-p2
	dif2_p= p2-p1
	test()
	
	sum_p= PointND(p1)
	sum_p+=p2
	dif1_p= PointND(p1)
	dif1_p-=p2
	dif2_p= PointND(p2)
	dif2_p-=p1
	test()

	assert PointND(p1)==p1

def scalar_operations_test(p1,s):
	assert isinstance(p1, PointND) and (type(s)==type(0) or type(s)==type(0.0))

	def test():
		for i in range(len(p1)):
			assert sum_p[i]== p1[i]+s
			assert dif1_p[i]== p1[i]-s

	sum_p= p1+s
	dif1_p= p1-s
	test()
	
	sum_p= PointND(p1)
	sum_p+=s
	dif1_p= PointND(p1)
	dif1_p-=s
	test()

#AUXILIARY FUNCTIONS END--------------------------------------


scalars= [0,1,3,4,6,8,2.5,6.7,9.3]

l= [PointND([1,7,4]), PointND([9,5,4]), PointND([3,4,7]), PointND([7,4,1])]
for p1,p2 in combinations(l, 2):
	point_operations_test(p1,p2)

for p1 in l:
	copy_test(p1)
	for s in scalars:
		scalar_operations_test(p1,s)

#MISC TESTS-------------------------------------------

a= PointND([0,1,2])
assert a.norm()== sqrt(0*0+1*1+2*2)
assert len(a)==3
a_copy= PointND(a)
assert a==a_copy
a_copy[1]+=1
assert a_copy[1]==2
assert a[1]==1
assert a<>a_copy

try:
	a= b>b_copy
	raise Exception("comparing PointNDs of multiple dimentions should raise a exception")
except:
	pass

a=PointND([2])
b=PointND([5])
assert a<b

#MISC TESTS END----------------------------------------

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

#ROTATIONS TESTS END--------------------------





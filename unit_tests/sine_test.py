s1= Sine(2,3*pi+2, 0)
assert s1.a==2
assert s1.y==0
assert s1.p==pi+2	#phase should be simplified
assert s1.getMaximizant()==3*pi/2-2
assert s1.getMinimizant()==3*pi/2-2+pi
s1.invert()
assert s1.a==2
assert s1.p==2
assert s1.y==0
assert equal(s1.valueat(2), -1.5136049906)
assert s1.getMaximizant()==5*pi/2-2
assert s1.getMinimizant()==3*pi/2-2

a= PointND([2,2,2])
b= PointND([3,4,5])
s1.fromPoint(a, b, 0)
s2= Sine()
s2.fromPoint(a, b, 1)
s3= Sine()
s3.fromPoint(a, b, 2)
assert s1.p == atan2(3,2)
assert s2.p == atan2(1,3)
assert s3.p == atan2(2,1)

assert equal_list( [p[0] for p in s1.calculateZeros()], [2.158798930342464, 5.3003915839322575])
si= s1-s2
assert equal_list( [p[0] for p in si.calculateZeros()], [1.1071487177940909, 4.2487413713838844])
s1.y=1
s1.zeros_calculated=False
assert equal_list( [p[0] for p in s1.calculateZeros()], [2.4398338318452777, 5.0193566824294438])

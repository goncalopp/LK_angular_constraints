a= PointND([2,2,2])
b= PointND([3,4,5])
s1= Sine.fromPoint(a, b, 0)
s2= Sine.fromPoint(a, b, 1)
s3= Sine.fromPoint(a, b, 2)
assert s1.p == atan2(3,2)
assert s2.p == atan2(1,3)
assert s3.p == atan2(2,1)

assert [p[0] for p in s1.calculateZeros()] == [2.158798930342464, 5.3003915839322575]
si= s1.intersectWave(s2)
assert  [p[0] for p in si.calculateZeros()] == [1.1071487177940913, 4.2487413713838844]
s1.y=1
s1.zeros_calculated=False
assert [p[0] for p in s1.calculateZeros()] == [2.4398338318452781, 5.0193566824294438]

a1= AngularDomain()
a2= AngularDomain()

r1= Region(PointND([0]), PointND([1]))
r2= Region(PointND([1]), PointND([2]))
r3= Region(PointND([2]), PointND([3]))

r4= Region(PointND([0]), PointND([1.5]))
r5= Region(PointND([1.5]), PointND([2.5]))
r6= Region(PointND([2.5]), PointND([3]))


a1.insertRegion(r1)
a1.insertRegion(r3)
a1.insertRegion(r2)
assert a1[0]==r1
assert a1[1]==r3
assert a1[2]==r2

a1= AngularDomain()
a1.insertRegion(r1)
a1.insertRegion(r2)
a1.insertRegion(r3)

a2.insertRegion(r4)
a2.insertRegion(r5)
a2.insertRegion(r6)

assert a1.lookup(PointND([2.3]))==2
assert a1.lookup(PointND([2]))==1		#returns *first* region which has "2"

a1.cutRegionOnPoint(2, PointND([2.3]))	#REMEMBER THIS FOR LATER TESTS
assert a1[2][0][0]==2
assert a1[2][1][0]==2.3
assert a1[3][0][0]==2.3
assert a1[3][1][0]==3

a1.doubleCut(a2)
for i in range(6):
	assert a1[i]==a2[i]

assert a1[0]== Region(PointND([0]),PointND([1]))
assert a1[1]== Region(PointND([1]),PointND([1.5]))
assert a1[2]== Region(PointND([1.5]),PointND([2]))
assert a1[3]== Region(PointND([2]),PointND([2.3]))
assert a1[4]== Region(PointND([2.3]),PointND([2.5]))
assert a1[5]== Region(PointND([2.5]),PointND([3]))

a1.mergeAdjacentRegions()
assert len(a1)==1
assert a1[0]== Region(PointND([0]),PointND([3]))

a2[2][0]=PointND([1.6])
a2.mergeAdjacentRegions()
assert len(a2)==2
assert a2[0]== Region(PointND([0]),PointND([1.5]))
assert a2[1]== Region(PointND([1.6]),PointND([3]))

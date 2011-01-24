l= [PointND([i/10.0]) for i in range(32)]

a1= AngularDomain()
a2= AngularDomain()
a1.insertRegion( Region(l[ 0], l[10]) )
a1.insertRegion( Region(l[10], l[20]) )
a1.insertRegion( Region(l[20], l[30]) )
a2.insertRegion( Region(l[ 0], l[15]) )
a2.insertRegion( Region(l[15], l[25]) )
a2.insertRegion( Region(l[25], l[30]) )

assert a1.lookup(l[23])==2
assert a1.lookup(l[20])==1		#returns *first* region which has "2"

a1.cutRegionOnPoint(2, l[23])	#REMEMBER THIS FOR LATER TESTS
assert a1[2][0]==l[20]
assert a1[2][1]==l[23]
assert a1[3][0]==l[23]
assert a1[3][1]==l[30]

a1.doubleCut(a2)

for i in range(6):
	assert a1[i][0]==a2[i][0]
	assert a1[i][1]==a2[i][1]
assert a1[0]== Region(l[ 0], l[10])
assert a1[1]== Region(l[10], l[15])
assert a1[2]== Region(l[15], l[20])
assert a1[3]== Region(l[20], l[23])
assert a1[4]== Region(l[23], l[25])
assert a1[5]== Region(l[25], l[30])

a1.mergeAdjacentRegions()
assert len(a1)==1
assert a1[0]== Region(l[ 0],l[30])
a2[2][0]= l[16]
a2.mergeAdjacentRegions()
assert len(a2)==2
assert a2[0]== Region(l[ 0], l[15])
assert a2[1]== Region(l[16], l[30])


#---------------------------------------------

a1= AngularDomain()
a2= AngularDomain()
a1.insertRegion( Region(l[ 0], l[ 5]) )
a1.insertRegion( Region(l[10], l[20]) )
a1.insertRegion( Region(l[25], l[30]) )
a2.insertRegion( Region(l[00], l[15]) )
a2.insertRegion( Region(l[20], l[30]) )

a1.doubleCut(a2)
assert len(a1)==4
assert len(a2)==5
assert a1[0]== Region(l[ 0], l[ 5])
assert a1[1]== Region(l[10], l[15])
assert a1[2]== Region(l[15], l[20])
assert a1[3]== Region(l[25], l[30])
assert a2[0]== Region(l[ 0], l[ 5])
assert a2[1]== Region(l[ 5], l[10])
assert a2[2]== Region(l[10], l[15])
assert a2[3]== Region(l[20], l[25])
assert a2[4]== Region(l[25], l[30])

a1.intersect(a2, bothways=True)
assert len(a1)==3
assert len(a2)==3
assert a1[0]== a2[0]== Region(l[ 0], l[ 5])
assert a1[1]== a2[1]== Region(l[10], l[15])
assert a1[2]== a2[2]== Region(l[25], l[30])

#---------------------------------------------

a1= AngularDomain()
a2= AngularDomain()
a1.insertRegion( Region(l[ 0], l[ 2]) )
a1.insertRegion( Region(l[ 3], l[ 5]) )
a1.insertRegion( Region(l[ 7], l[10]) )
a1.insertRegion( Region(l[11], l[15]) )
a1.insertRegion( Region(l[17], l[19]) )
a1.insertRegion( Region(l[21], l[24]) )
a1.insertRegion( Region(l[26], l[28]) )
a2.insertRegion( Region(l[ 0], l[ 2]) )
a2.insertRegion( Region(l[ 3], l[ 6]) )
a2.insertRegion( Region(l[ 7], l[ 9]) )
a2.insertRegion( Region(l[12], l[14]) )
a2.insertRegion( Region(l[16], l[20]) )
a2.insertRegion( Region(l[22], l[24]) )
a2.insertRegion( Region(l[25], l[28]) )


a1.doubleCut(a2)
assert len(a1)==11
assert len(a2)==11
assert a1[0]== Region(l[ 0], l[ 2])
assert a1[1]== Region(l[ 3], l[ 5])
assert a1[2]== Region(l[ 7], l[ 9])
assert a1[3]== Region(l[ 9], l[10])
assert a1[4]== Region(l[11], l[12])
assert a1[5]== Region(l[12], l[14])
assert a1[6]== Region(l[14], l[15])
assert a1[7]== Region(l[17], l[19])
assert a1[8]== Region(l[21], l[22])
assert a1[9]== Region(l[22], l[24])
assert a1[10]== Region(l[26], l[28])
assert a2[0]== Region(l[ 0], l[ 2])
assert a2[1]== Region(l[ 3], l[ 5])
assert a2[2]== Region(l[ 5], l[ 6])
assert a2[3]== Region(l[ 7], l[ 9])
assert a2[4]== Region(l[12], l[14])
assert a2[5]== Region(l[16], l[17])
assert a2[6]== Region(l[17], l[19])
assert a2[7]== Region(l[19], l[20])
assert a2[8]== Region(l[22], l[24])
assert a2[9]== Region(l[25], l[26])
assert a2[10]== Region(l[26], l[28])

a1.intersect(a2, bothways=True)
assert len(a1)==7
assert len(a2)==7
assert a1[0]== a2[0]== Region(l[ 0], l[ 2])
assert a1[1]== a2[1]== Region(l[ 3], l[ 5])
assert a1[2]== a2[2]== Region(l[ 7], l[ 9])
assert a1[3]== a2[3]== Region(l[12], l[14])
assert a1[4]== a2[4]== Region(l[17], l[19])
assert a1[5]== a2[5]== Region(l[22], l[24])
assert a1[6]== a2[6]== Region(l[26], l[28])

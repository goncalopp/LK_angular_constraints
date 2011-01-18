l= [PointND([i]) for i in range(20)]

a= l[3]
b= l[10]


r= Region(a,b)
c= l[5]
d= PointND(l[10])
e= l[11]
assert r.pointInside(a)
assert r.pointInside(b)
assert r.pointInside(c)
assert r.pointInside(d)
assert not r.pointInside(e)


d+=0.0
assert r.pointInside(d)
d+=0.001
assert not r.pointInside(d)
d-=0.1
assert r.pointInside(d)

#------------------------

r1= Region(l[0], l[1])
r2= Region(l[5], l[6])
assert r1.relativePosition(r2)==1
assert r2.relativePosition(r1)==2

r1= Region(l[0], l[5])
r2= Region(l[3], l[7])
assert r1.relativePosition(r2)==3
assert r2.relativePosition(r1)==4

r1= Region(l[0], l[5])
r2= Region(l[1], l[4])
assert r1.relativePosition(r2)==5
assert r2.relativePosition(r1)==6


a= PointND([3])
b= PointND([5])


r= Region(a,b)
c= PointND([5])
d= PointND([4.3])
e= PointND([2.1])
assert r.pointInside(a)
assert r.pointInside(b)
assert r.pointInside(c)
assert r.pointInside(d)
assert not r.pointInside(e)


c+=0.0
assert r.pointInside(c)
c+=0.001
assert not r.pointInside(c)
c-=0.1
assert r.pointInside(c)

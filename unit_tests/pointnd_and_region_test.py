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

r= Region(a,b)
c= PointND(b)
assert r.pointInside(a)
assert r.pointInside(b)
assert r.pointInside(c)

c+=0.0
assert r.pointInside(c)
c+=0.1
assert not r.pointInside(c)
c-=0.1
assert r.pointInside(c)

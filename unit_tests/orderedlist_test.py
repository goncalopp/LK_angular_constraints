a= OrderedList([1,2,2,3,3,4,4,4,5])

assert a.peekMinimum()==1
assert a.peekMinimums()==[1]
assert a.peekMaximum()==5

assert a.popMinimums()==[1]

assert a.peekMinimum()==2
assert a.peekMinimums()==[2,2]
assert a.peekMaximum()==5

assert a.popMaximum()==5

assert a.peekMinimum()==2
assert a.peekMinimums()==[2,2]
assert a.peekMaximum()==4

assert a.popMaximum()==4

assert a.peekMinimum()==2
assert a.peekMinimums()==[2,2]
assert a.peekMaximum()==4

assert a.popMinimums()==[2,2]

assert a.peekMinimum()==3
assert a.peekMinimums()==[3,3]
assert a.peekMaximum()==4




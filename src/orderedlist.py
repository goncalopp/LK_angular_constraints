class OrderedList:
	'''Ordered list, linear insert time'''
	
	def __init__(self, list, key= lambda x:x, alreadyordered=False):
		if not alreadyordered:
			self.list= sorted(list, key=key)
		self.keyfunction= key

	def __len__(self):
		return len(self.list)

	def popMaximum(self):
		'''returns and deletes maximum value from list'''
		return self.list.pop()
		
	def popMinimum(self):
		'''returns and deletes minimum value from list'''
		return self.list.pop(0)

	def peekMinimum(self):
		'''returns minimum value from list'''
		return self.list[0]

	def peekMaximum(self):
		'''returns maximum value from list'''
		return self.list[-1]

	def popMinimums(self):
		'''returns and deletes minimum *values* from list,
		i.e.: all the elements whose value is equal to the minimum'''
		if len(self.list)==0:
			return []
		k= self.keyfunction
		ret= [self.list[0]]
		self.list.pop(0)
		while len(self.list) and k (self.list[0])==k(ret[0]):
			ret.append(self.list[0])
			self.list.pop(0)
		return ret

	def peekMinimums(self):
		'''returns  minimum *values* from list,
		i.e.: all the elements whose value is equal to the minimum'''
		if len(self.list)==0:
			return []
		k= self.keyfunction
		ret= [self.list[0]]
		i=1
		while i<len(self.list) and k(self.list[i])==k(ret[0]):
			ret.append(self.list[i])
			i+=1
		return ret

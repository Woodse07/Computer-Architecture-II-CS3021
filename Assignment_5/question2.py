import math
import time

class Cache(object):
	L = 0
	K = 0
	N = 0
	Offset = 4
	set_selector_bits_length = 0
	size = 0
	tag_bits_length = 0
	cache_matrix = []

	def __init__(self, L, K, N):
		self.L = L
		self.K = K
		self.N = N
		self.size = L * K * N 
		self.set_selector_bits_length = math.log(N, 2)
		self.tag_bits_length = L - self.Offset - self.set_selector_bits_length
		for i in range(0, N):
			self.cache_matrix.append([bin(i)[2:].zfill(int(self.set_selector_bits_length)),0])
			for j in range(0, K):
				self.cache_matrix[i].append([0,"",time.time()])


	def print_stats(self):
		print("L: " + str(self.L))
		print("K: " + str(self.K))
		print("N: " + str(self.N))
		print("Size: " + str(self.size))
		print("Offest: " + str(self.Offset))
		print("Set selector bits length: " + str(self.set_selector_bits_length))
		print("tag bits length: " + str(self.tag_bits_length))

	def hex_to_binary(self, hex):
		binary = bin(int(hex, 16))[2:].zfill(16)
		return binary

	def disect_binary(self, binary):
		binary_minus_offset = binary[:12]
		bit_selector_bits = binary_minus_offset[-int(self.set_selector_bits_length):]
		tag_bits = binary_minus_offset[:-int(self.set_selector_bits_length)]
		if self.N is 1:
			tag_bits = bit_selector_bits
			bit_selector_bits = "0"
		return bit_selector_bits, tag_bits

	def find_lru(self, timestamps):
		oldest = min(timestamps)
		index = timestamps.index(oldest)
		return index

	def hit_or_miss(self, bit_selector_bits, tag_bits):
		for row in self.cache_matrix:
			if bit_selector_bits == row[0]:
				if self.K is 1:
					if row[2][0] == 0:
						row[2][1] = tag_bits
						row[2][0] = 1
						return("miss:(")
					elif row[2][0] == 1:
						if row[2][1] == tag_bits:
							return("hit!")
						else:
							row[2][1] = tag_bits
							return("miss:(")

				elif self.N is 1:
					timestamps = []
					#print("Least recently used: " + str(lru))
					for index in range(0, self.K):
						timestamps.append(row[2+index][2])
						if row[2+index][0] == 1:
							if row[2+index][1] == tag_bits:
								row[2+index][2] = time.time()
								return("hit!")

					row[1] = self.find_lru(timestamps)
					lru = row[1]

					if row[2+lru][0] == 0:
						row[2+lru][1] = tag_bits
						row[2+lru][0] = 1
						row[2+lru][2] = time.time()
						return("miss:(")

					elif row[2+lru][0] == 1:
						row[2+lru][1] = tag_bits
						row[2+lru][2] = time.time()
						return("miss:(")

				else:
					timestamps = []
					#print("Least recently used: " + str(lru))
					for index in range(0, self.K):
						timestamps.append(row[2+index][2])
						if row[2+index][0] == 1:
							if row[2+index][1] == tag_bits:
								row[2+index][2] = time.time()
								return("hit!")

					row[1] = self.find_lru(timestamps)
					lru = row[1]

					if row[2+lru][0] == 0:
						row[2+lru][1] = tag_bits
						row[2+lru][0] = 1
						row[2+lru][2] = time.time()
						return("miss:(")

					elif row[2+lru][0] == 1:
						row[2+lru][1] = tag_bits
						row[2+lru][2] = time.time()
						return("miss:(")
		


		
		
	

def make_cache(L, K, N):
	cache = Cache(L, K, N)
	return cache



myCache = Cache(16,8,1)

input = ["0000","0004","000c","2200","00d0","00e0","1130","0028",
		 "113c","2204","0010","0020","0004","0040","2208","0008",
		 "00a0","0004","1104","0028","000c","0084","000c","3390",
		 "00b0","1100","0028","0064","0070","00d0","0008","3394"]


myCache.print_stats()
print("")
print(myCache.cache_matrix)
print("")
hits = 0
misses = 0
for hex in input:
	binary = myCache.hex_to_binary(hex)
	disected_bits = myCache.disect_binary(binary)
	bit_selector_bits = disected_bits[0]
	tag_bits = disected_bits[1]
	hit_or_miss = myCache.hit_or_miss(bit_selector_bits, tag_bits)
	if hit_or_miss == "hit!":
		hits += 1
	else:
		misses += 1
	print(hex + " " + bit_selector_bits + " was a " + str(hit_or_miss))
	#print("binary: " + binary)
	#print("tag_bits: " + tag_bits)

	#print(myCache.cache_matrix)
	#print("")
print("Hits: " + str(hits))
print("Misses: " + str(misses))






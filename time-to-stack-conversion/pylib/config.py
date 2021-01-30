import math



linear_list = range(0,int((5E6)/4)+1)
#g_time_distance_range_list = [ ( 4000*a, 4000*b) for (a,b) in list(zip(linear_list, linear_list[1:]))[0:int(5E6)]]

pseudo_linear_list = [0] + list(range(4, 10))
scale = 10
while scale < 5E6:
	pseudo_linear_list += [ i * scale for i in range(1, 10)]
	scale *= 10


M = 2097152
N = 100
A = 4
## we would like to keep A*(x^(N-1)) = M
x = math.pow(M/A, 1/(N-1))

'''
my_list = [0]
for i in range(0, N):
	num = int(round(A* math.pow(x, i)))
	if num != my_list[-1]:
		my_list.append(num)
'''
exp_list = [0] + [ 2**i for i in range(2, 100)]
D = 2
my_list = [0]
for i in range(0, len(exp_list)-1):
	cur,nex = exp_list[i], exp_list[i+1]
	delta = (nex - cur)/D
	for j in range(0, D):
		should_add = int(round(cur + j*delta))
		if my_list[-1] < should_add:
			my_list.append(should_add)


#print(my_list)

def get_exp_list(start_val, end_val, steps):
	## assume the multiplier factor is a
	## start_val * ( a ^ steps ) = end_val
	## the length of generated list is steps + 1
	a = math.pow(end_val / start_val, 1/steps)
	ret_list = [start_val]
	for i in range(1, steps+1):
		cur_val = int(round(start_val * math.pow(a, i)))
		if ret_list[-1] < cur_val:
			ret_list.append(cur_val)
	assert(ret_list[-1] == end_val)
	return ret_list


def time_distance_range_list(plan = "L3"):
	#return [ (1000 *a, 1000*b) for (a, b) in list(zip(my_list, my_list[1:])) ]
	assert(plan in ["L1", "L2", "L3", "L11", "L30", "L40",])
	#plan = "L40"
	if plan == "L1":
		exp_list = [0] + [ 2**i for i in range(0, 100)]
	elif plan == "L2":
		exp_list = [0] + [ 2**i for i in range(1, 100)]
	elif plan == "L11":
		exp_list = [ x for x in range(0, 1000)]
	elif plan == "L40":
		exp_list = [0] + get_exp_list(4, 2097152, 39)
		#exp_list = [0] + get_exp_list(4, 2097152, 99)
		#assert(len(exp_list) == 101)
		#print("len", len(exp_list))
		return [ (1000 *a, 1000*b) for (a, b) in zip(exp_list, exp_list[1:])]

	else: # L3
		exp_list = [0] + [ 2**i for i in range(2, 100)]

	#middle_list = [ (a+b)//2 for (a,b) in zip(exp_list, exp_list[1:])]
	#exp_list = [ val for pair in zip(exp_list, middle_list) for val in pair ]
	#print(exp_list)

	#exp_list = [0] + [int(3**i) for i in range(2, 100)]
	if plan == "L30":
		return [ (1000 *a, 1000*b) for (a, b) in list(zip(exp_list, exp_list[1:]))[0:25] ]

	#return [ (1000 *a, 1000*b) for (a, b) in list(zip(exp_list, exp_list[1:]))[0:40] ]
	return [ (1000 *a, 1000*b) for (a, b) in list(zip(exp_list, exp_list[1:]))[0:20] ]

def stack_distance_range_list(plan="L3"):
	#linear_list = list(range(int(1E6), int(4.1E6), int(1.5E5)))
	#return [(a,b) for (a,b) in list(zip(linear_list, linear_list[1:])) ]
	#exp_list = [0] + [ 2**i for i in range(2, 100)]
	#return [ (1000 *a, 1000*b) for (a, b) in list(zip(exp_list, exp_list[1:]))[0:20] ]

	#exp_list = [0] + get_exp_list(4, 2097152, 9)
	#assert(len(exp_list) == 11)
	#return [ (1000 *a, 1000*b) for (a, b) in zip(exp_list, exp_list[1:])]
	return time_distance_range_list(plan)



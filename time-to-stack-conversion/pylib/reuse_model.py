import sys
if sys.version_info[0] < 3:
    raise "Must be using Python 3"

import bisect
import collections
import math
#import scipy.misc
import scipy.special
import scipy.stats
import numpy

class Histogram:
    def __init__(self, histo, intervals:list, first_item, common_ratio):
        # specify intervals OR (first_item and common_ratio)
        if isinstance(histo, dict):
            if intervals is None and (first_item is not None and common_ratio is not None):
                ## generate intervals
                max_key = max(histo.keys())

                intervals = [0, int(round(first_item))]
                last_val = first_item
                while intervals[-1] < max_key:
                    last_val *= common_ratio
                    val_to_add = int(round(last_val))
                    if intervals[-1] < val_to_add:
                        intervals.append(val_to_add)

            assert(intervals)
            assert(len(intervals) >= 2)

            self.count_list = [0] * (len(intervals)-1)
            self.sum = 0
            for k in histo:
                self.sum += histo[k]
                ## find the bin number
                index = bisect.bisect_right(intervals, k) - 1
                if index < len(intervals) - 1:
                    self.count_list[index] += histo[k]
                elif index > len(intervals) - 1:
                    assert(False) ## something wrong here
                ## it is ok if index == len(intervals), the value will not be recorded into the bin
        elif isinstance(histo, list): ##
            assert(len(histo) + 1 == len(intervals))
            self.count_list = list(histo)
            self.sum = sum(self.count_list)
        else:
            assert(False) # not supported

        self.fraction_list = list(map(lambda x:x/self.sum, self.count_list))
        self.intervals = list(intervals)

    def __iter__(self):
        for i in range(0, len(self.count_list)):
            yield (self.intervals[i],self.intervals[i+1]), self.count_list[i], self.fraction_list[i]

    def __len__(self):
        return len(self.count_list)

    def getFraction(self, index : int):
        return self.fraction_list[index]
    def getFractions(self):
        return list(self.fraction_list)
    def getCount(self, index: int):
        return self.count_list[index]
    def getCounts(self):
        return list(self.count_list)
    def getRange(self, index: int):
        return self.intervals[i],self.intervals[i+1]
    def getRanges(self):
        return list(zip(self.intervals, self.intervals[1:]))


#nCr = scipy.misc.comb
nCr = scipy.special.comb

#Time distance histogram to reuse distance histogram Model
class Tdh2RdhModel:
    #Refer to the paper [Locality Approximation using time] for theory.
    def __init__(self, tdh: dict, N, T):
        #N: the total number of distinct data, i.e., footprint
        #T: the total time-points in an execution, i.e., the number of accesses
        self._N = N
        self._T = T
        self._tdh_sum = numpy.sum(tdh.values())
        self._tdh = tdh
        print(tdh, N, T)

        self._P2_memo = collections.defaultdict()
        self._P3_memo = collections.defaultdict()
        self._P4_memo = collections.defaultdict()

    def Pt(self, k):
        ## return the fraction of references having time distance of k.
        if k in self._tdh:
            return self._tdh[k] / self._tdh_sum
        else:
            return 0.0

    def P1(self, delta):
        ## given a random time-point [t], if we pick a data [v] at random from those that are not accssed at time [t],
        ## return the probability that [t] is in one of [v]'s reuse intervals of length [delta]
        return (delta - 1)/(self._N - 1) * self.Pt(delta)


    def P2(self, tau):
        ## given a random time-point [t], if we pick a data [v] at random from those that are not accessed at time [t],
        ## return the probability that [v]'s last access prior to [t] is at time [t] - [tau]
        if tau in self._P2_memo:
            return self._P2_memo[tau]
        '''
        res = sum(( self.P1(delta) / (delta - 1)  for delta in range(tau + 1, self._T +1)) )
        '''

        res = sum(( self.Pt(delta) for delta in range(tau+1, self._T + 1)))
        res /= (self._N - 1)
        self._P2_memo[tau] = res
        return res

    def P3(self, DELTA):
        if DELTA in self._P3_memo:
            return self._P3_memo[DELTA]
        ## given a random time-point [t], if we pick a data [v] at random from those that are not accessed at time [t],
        ## return the probability that [v]'s last access prior to [t] is after [t] - [DELTA] - 1
        '''
        res = sum(( self.P2(tau) for tau in range(1, DELTA+1 )))
        '''

        #res = sum(( self.Pt(delta)* (delta - 1)   for  delta in range(2, DELTA+1 )))
        #res += sum(( self.Pt(delta) * DELTA   for delta in range(DELTA+1, self._T+1)))

        res = 0.0
        delta = 2
        while delta <= DELTA:
            res += self.Pt(delta)* (delta - 1)
            delta += 1
        while delta <= self._T:
            res += self.Pt(delta) * DELTA
            delta += 1

        res /= (self._N -1)

        self._P3_memo[DELTA] = res
        return res

    def P4(self, k, DELTA):
        ## in paper, it is P(k,DELTA)
        ## return the probability of having [k] distinct elements in a [DELTA] long interval
        ## it is acutally a binomial distribution
        if (k,DELTA) in self._P4_memo:
                return self._P4_memo[k,DELTA]
        p3 = self.P3(DELTA)
        #res = nCr(self._N, k)* numpy.power( p3, k) * numpy.power(1-p3, self._N - k)
        ## When n is large, B(n,p) can be estimated by N(np, np(1-p))
        res = scipy.stats.norm(self._N * p3, self._N * p3 * (1-p3)).pdf(DELTA)
        #print(res)
        self._P4_memo[k,DELTA] = res
        return res

    def Pr(self, k):
        ## return the fraction of references that having reuse distance of [k]

        #return sum(( self.P4(k, DELTA)* self.Pt(DELTA) if self.Pt(DELTA)!= 0 else 0 for DELTA in range(0, self._T) ))
        res, DELTA = 0, 0
        while DELTA < self._T:
            pt = self.Pt(DELTA)
            if pt != 0:
                res += (self.P4(k, DELTA) * pt)
            DELTA += 1
        return res


    def getRdh(self):
        ret_dict = collections.defaultdict(float)
        for k in range(0, self._N): ##[ 0, self._N - 1]
            ret_dict[k] = self.Pr(k)
        return ret_dict



#Time distance histogram to reuse distance histogram Model (extended)
class Tdh2RdhModelExt:
    #Refer to the paper [Accurate Approximation of Locality from Time Distance Histograms] for theory.
    def __init__(self, tdh: Histogram, N, T):
        #N: the total number of distinct data, i.e., footprint
        #T: the total time-points in an execution, i.e., the number of accesses
        self._N = N
        self._T = T

        assert(isinstance(tdh, Histogram))
        self._time_ranges = tdh.getRanges()  ## the bars in time histogram
        if self._time_ranges[0][0] <= 0:
            self._time_ranges[0] = (1, self._time_ranges[0][1])
        print(self._time_ranges)
        self._bin_histo = tdh.getFractions()
        print("total fraction included :", sum(self._bin_histo))

        self._P2_memo = collections.defaultdict()

    def Pt(self, i: int):
        ## i: index of time ranges
        ## return the fraction of references having time distances within the range time_ranges[i]
        return self._bin_histo[i]

    def P1(self, i: int):
        ## i: index of time ranges
        ## bi_range = time_ranges[i]
        ## given a random time-point [t], if we pick a data [v] at random from those that are not accssed at time [t],
        ## return the probability that [t] is in one of [v]'s reuse intervals whose time distance is in range [bi_range[0], bi_range[1])
        bi_range = self._time_ranges[i]
        return 0.5*(bi_range[0] + bi_range[1] - 3)/(self._N - 1) * self.Pt(i)


    def P2(self, i : int):
        ## i : index of time_ranges
        ## bi_range  = time_ranges[i]
        ## given a random time-point [t], if we pick a data [v] at random from those that are not accessed at time [t],
        ## return the probability that [v]'s last access prior to [t] in time range (t- bi_range[1], t-bi_range[0]
        if i in self._P2_memo:
                return self._P2_memo[i]

        time_ranges = self._time_ranges

        res = numpy.sum( (
                self.P1( j )
                        * (time_ranges[i][1] - time_ranges[i][0])/(time_ranges[j][1] - time_ranges[j][0])
                        * numpy.log((time_ranges[j][1] -1.5)/(time_ranges[j][0]-1.5))
                for j in range(i+1, len(time_ranges))
                ))

        res += ( self.P1(i) /(time_ranges[i][1] - time_ranges[i][0])
                * ( time_ranges[i][1] - time_ranges[i][0] - 2 - (time_ranges[i][0] - 1) * numpy.log( (time_ranges[i][1] - 1.5 )/( time_ranges[i][0] - 0.5) ) ) )

        self._P2_memo[i] = res
        return res

    def P3(self, i: int):
        ## i : index of time_ranges
        ## bi_range = time_ranges[i]
        ## For P3(l)
        ## given a random time-point [t], if we pick a data [v] at random from those that are not accessed at time [t],
        ## P3(l) the probability that [v]'s last access prior to [t] is after [t] - [l] - 1

        ## P3(bi_range) is the mean of P3(l) for [l] inside [bi_range]
        res = self.P2(i)/2
        res += numpy.sum( (self.P2(j) for j in range(0, i) ) )
        return res

    def P4(self, k, i:int):
        ## i : index of time_ranges
        ## bi_range = time_ranges[i]
        ## in paper, it is P(k,bi_range)
        ## return the probability of having [k] distinct elements in a reuse interval bi_range
        ## it is acutally a binomial distribution


        p3 = self.P3(i)

        #res = nCr(self._N, k)* numpy.power( p3, k) * numpy.power(1-p3, self._N - k)
        ## When n is large, B(n,p) can be estimated by N(np, np(1-p))
        norm_distribution = scipy.stats.norm(loc = self._N * p3, scale = math.sqrt(self._N * p3 * (1-p3)))
        res = norm_distribution.cdf(k+0.5) - norm_distribution.cdf(k-0.5)
        #print(res)
        return res
    def P4_range(self, k_range, i:int):
        ## return sum(P4(k,i)) for k inside the range
        p3 = self.P3(i)
        p3 = min(p3,0.999999) ## sometimes p3 will be larger than 1
        norm_distribution = scipy.stats.norm(loc = self._N * p3, scale = math.sqrt(self._N * p3 * (1-p3)))
        res = norm_distribution.cdf(k_range[1] - 0.5) - norm_distribution.cdf(k_range[0]-0.5)
        return res

    def Pr_value(self, k):
        ## return the fraction of references that having reuse distance of [k]
        return numpy.sum((self.P4(k,i)*self.Pt(i) for i in range(0, len(self._time_ranges))))
    def Pr_range(self, r):
        #return numpy.sum( ( self.Pr_value(k)  for k in range(r[0], r[1]) )   )
        return numpy.sum( (self.Pt(i) * self.P4_range( r, i) for i in range(0, len(self._time_ranges))))


    def getRdh(self, rdh_range_list):
        ret_list = []
        for r in rdh_range_list:
            ret_list.append(self.Pr_range(r))
        return ret_list

def mergeHisto(histo_list, window_size):
    new_histo_list = []

    for i in range(0, len(histo_list) - window_size + 1):
        new_histo_list.append(sum( histo_list[i:i+window_size])/3)

    total = sum(new_histo_list)
    new_histo_list = list(map(lambda x :x/total, new_histo_list )  )
    print(sum(new_histo_list))
    assert(len(new_histo_list) + window_size - 1 == len(histo_list))

    '''
    half = window_size // 2;
    for i in range(0, len(histo_list)):
        left = max(0, i-half)
        right = min(len(histo_list)-1, i+half) + 1
        new_histo_list.append( sum(histo_list[left:right] )/window_size  )
    print(sum(new_histo_list))
    '''
    return new_histo_list


def histoDifference( histo_list_1, histo_list_2, window_size):
    import itertools
    #histo_list_1 = mergeHisto(histo_list_1, window_size)
    #histo_list_2 = mergeHisto(histo_list_2, window_size)
    return numpy.sum( ( abs(a -b) for a, b in  itertools.zip_longest(histo_list_1, histo_list_2, fillvalue = 0) )) / 2

def histoAccuracy( histo_list_1, histo_list_2, plan="Manhattan"):
    if plan == "Manhattan":
            return 1 - histoDifference( histo_list_1, histo_list_2, window_size = 3)
    else:
            assert(False)


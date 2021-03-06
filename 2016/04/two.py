# v >= 3.6 for f-strings

#
# constants
#
class C():
    def alpha():
        return "abcdefghijklmnopqrstuvwxyz"

#
# subprograms
#
# not used, but useful for comparison to fortran and C;
# the python built-in .count is likely recursive
def counter ( ch, string ):
    return sum( [ x is ch for x in string ] )

# checksum ruleset
def sumcheck ( x, y ):
    counts = [ x.count(ch) for ch in y ]
    if 0 in counts: return False
    for k in range( len(counts)-1 ):
        if ( ( counts[k] > counts[k+1] )
                or
                ( ( counts[k] == counts[k+1] )
                    and
                    ( ( C.alpha().index(y[k]) < C.alpha().index(y[k+1]) ) )
                ) 
            ): continue
        else: return False
    return True

# decryption ruleset
def caesar ( r ):
    s = ""
    rotate = r[0] % len( C.alpha() )
    for i in range( len( r[1] ) ):
        if r[1][i] == '-': s = s + ' '
        else:
            m = C.alpha().index(r[1][i])
            if m + rotate < len( C.alpha() ): s = s + C.alpha()[m+rotate]
            else: s = s + C.alpha()[ m+rotate-len(C.alpha()) ] 
    return s

#
# main program
#
listing = []
sector_id = []
encrypted = []
decrypted = []
checksum = []
is_real = []

# read file; n is Nrooms (total, including decoys)
n = 0
with open("input.txt") as fo:
 while True:
  line = fo.readline()
  if not line: break
  listing.append(line)
  n = n + 1
#fo.close()

# populate lists...each independently since no structs
[ checksum.append( x[ x.index('[')+1 : x.index(']') ] ) for x in listing ]
[ encrypted.append( x[ :x.index('[')-3 ] ) for x in listing ]
[ is_real.append( sumcheck(encrypted[i],checksum[i]) ) for i in range(n) ]

for i in range(n):
    s = listing[i]
    nums = [ ch.isdigit() for ch in s ]
    sub = ""
    for j in range(len(s)):
        if ( nums[j] ):
            sub = sub + s[j]
    sector_id.append( int( sub ) )

[ decrypted.append( caesar([sector_id[i],encrypted[i]]) ) for i in range(n) ]

# output answers
[ print( sector_id[i], decrypted[i] ) for i in range(n) if is_real[i] ]
print( f" total of real sector ids = {sum( [ sector_id[i] for i in range(n) if is_real[i] ] ):d}" )


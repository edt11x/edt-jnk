import time
print('Find Primes')
listOfPrimes = []
checkList = [ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199 ]
startTime = time.clock()
i = 3
while i < 1000000: # test every odd number, there is only one even prime
    isprime = True
    for thisPrime in listOfPrimes:
        if ((thisPrime * thisPrime) <= i) and ((int(i/thisPrime)*thisPrime) == i):
            isprime = False
    if isprime:
        listOfPrimes.append(i)
    i = i + 2
listOfPrimes.insert(0, 2) # put 2 at the front of the list
endTime = time.clock() # measure the time it took
for thisPrime in listOfPrimes:
    print(thisPrime)
i = 0
for check in checkList:
    if check != listOfPrimes[i]:
        print('Failure - ', check, listOfPrimes[i])
    i = i + 1
print('Calculations Took ', endTime - startTime, ' seconds')

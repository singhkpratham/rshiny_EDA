import os
import time
os.chdir(r'C:\Users\kumar.singh\Desktop\shiny\shin')


database = open('test.csv')
##
for i in range(1,100):
    f = open('realTime.csv', 'a')
    a = database.readline()
    print(a)
    f.write(str(a))
    time.sleep(5)
    print(i)
    f.close()

database.close()


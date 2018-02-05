"""
author: Luke Brandl
project: Implementation of a Newton-Raphson algorithm for maximizing Dirichlet log likelihood
file description: This file is a python script which generates 1000 samples from the Dirichlet distribution with alpha parameter (10,5,15,20,50), then performs a Newton-Raphson algorithm to recover the alpha parameters from the data.
"""

#from future import division
import numpy as np
from scipy import special
import matplotlib.pyplot as plt
N = 1000
alpha = np.array([10,5,15,20,50])
P = np.random.dirichlet(alpha,N)
cap1=0
cap2=0
cap3=0
cap4=0
cap5=0
alphaest=np.matrix([1,1,1,1,1]).reshape((5,1))
grad=np.empty([5,1])
h=np.empty([5,5])
iteration=[]
alllikelihood=[]
for i in range(1000):
    cap1=cap1+np.log(P[i,0])/float(N)
    cap2=cap2+np.log(P[i,1])/float(N)
    cap3=cap3+np.log(P[i,2])/float(N)
    cap4=cap4+np.log (P[i,3])/float(N)
    cap5=cap5+np.log (P[i,4])/float(N)
logp=np.matrix([cap1,cap2,cap3,cap4,cap5]).reshape((5,1))
# Note: You can invert 'h' more efficiently using a much more complicated formula.
# I performed the inversion manually here, but I should mention a better method exists.

for count in range(1,50):
    alphasum=0
    for k in range(5):
        #Compute Gradient
        grad[k]=N*(special.psi(alphaest.sum())-special.psi(alphaest[k])+logp[k])
        #Preparehessianmatrix
        for j in range(5):
            if j == k:
                h[k,j]=N*(special.polygamma(1,alphaest.sum())-special.polygamma(1,alphaest[k]))
            else:
                h[k,j]=N*(special.polygamma(1,alphaest.sum()))
    #Updatealphaestimates
    update=(np.dot(np.linalg.inv(h),grad))
    alphaest=alphaest-update
    gammasum=0
    nuTsum=0
    for k in range(5):
        gammasum+=special.gammaln(alphaest[k])
        nuTsum+=(alphaest[k]-1)*logp[k]
    likelyhood=N*(special.gammaln(alphaest.sum())-gammasum+nuTsum)
    iteration.append(count)
    alllikelihood.append(likelyhood)

# Done with the hard stuff
print(alphaest)
gammasum=0
nuTsum=0
for k in range(5):
    gammasum+=special.gammaln(alpha[k])
    nuTsum+=(alpha[k]-1)*logp[k]
true=np.array(N*(special.gammaln(alpha.sum())-gammasum+nuTsum)).flatten()
true=np.repeat(true,count)

'''results of one run: 
[[  9.97613728]
 [  4.86237135]
 [ 14.98662968]
 [ 20.08879937]
 [ 49.34687743]]
'''
loglike=np.array(alllikelihood).flatten()

plt.plot(loglike,label='Gradient Descent')
plt.plot(iteration,true,'r',label='True Value')
plt.xlabel('Number of iteations')
plt.ylabel('Dirichlet Log Likelihood')
plt.legend()
plt.ylim([5500,9000])
plt.xlim([1,10])
plt.title('Progress Over 10 Iterations')
fig=plt.gcf()
fig.set_size_inches(3, 1.5)
fig.savefig('dirichlet.png', dpi=100)
plt.show()

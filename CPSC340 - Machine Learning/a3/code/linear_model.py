import numpy as np
from numpy.linalg import solve
from findMin import findMin
from scipy.optimize import approx_fprime
import utils

# Ordinary Least Squares
class LeastSquares:
    def fit(self,X,y):
        self.w = solve(X.T@X, X.T@y)

    def predict(self, X):
        return X@self.w

# Least squares where each sample point X has a weight associated with it.
class WeightedLeastSquares(LeastSquares): # inherits the predict() function from LeastSquares
    def fit(self,X,y,z):
        #z is vector of weights
        Z = np.diag(z)
        self.w = solve(X.T@Z@X, X.T@Z@y)




class LinearModelGradient(LeastSquares):

    def fit(self,X,y):
        n, d = X.shape

        # Initial guess
        self.w = np.zeros((d, 1))

        # check the gradient
        estimated_gradient = approx_fprime(self.w, lambda w: self.funObj(w,X,y)[0], epsilon=1e-6)
        implemented_gradient = self.funObj(self.w,X,y)[1]
        if np.max(np.abs(estimated_gradient - implemented_gradient) > 1e-4):
            print('User and numerical derivatives differ: %s vs. %s' % (estimated_gradient, implemented_gradient));
        else:
            print('User and numerical derivatives agree.')

        self.w, f = findMin(self.funObj, self.w, 100, X, y)

    def funObj(self,w,X,y):

        # Calculate the function value
        f = np.sum(np.log(np.exp((X@w.T - y)) + np.exp(y - X@w.T)))

        # Calculate the gradient value
        g= X.T@((np.exp(X@w.T - y) - np.exp(y - X@w.T)) / (np.exp(X@w.T - y) + np.exp(y - X@w.T)))


        return (f,g)


# Least Squares with a bias added
class LeastSquaresBias:

    def fit(self,X,y):
        n, d = X.shape

        #create a column of ones for the bias
        bias = np.ones((n,1))

        X_b = np.c_[X,bias]
        self.w = solve(X_b.T@X_b, X_b.T@y)



    def predict(self, X):
        n, d = X.shape

        #create a column of ones for the bias
        bias = np.ones((n,1))

        X_b = np.c_[X,bias]

        return X_b@self.w


# Least Squares with polynomial basis
class LeastSquaresPoly:
    def __init__(self, p):
        self.leastSquares = LeastSquares()
        self.p = p

    def fit(self,X,y):
        Z = self.__polyBasis(X)
        self.w = solve(Z.T@Z, Z.T@y)


    def predict(self, X):
        Z = self.__polyBasis(X)
        return Z@self.w


    # A private helper function to transform any matrix X into
    # the polynomial basis defined by this class at initialization
    # Returns the matrix Z that is the polynomial basis of X.
    def __polyBasis(self, X):
        n, d = X.shape

        # create first column with ones
        Z = np.ones((n,1))

        for i in range(0,self.p):
            p_x = X**(i+1)
            Z = np.c_[Z,p_x]
        return Z







import numpy as np
import utils

def predict(X):
    '''Hard coded predict function'''

    M, D = X.shape

    #create vector of zeroes for prediction
    y_hat = np.zeros(M)

    # loop over data and predict class
    for i in range(M):
        point = X[i, ]
        #check lon
        if point[0]>= -80.248086:
            #check lat
            if point[1] >=36.813883:
                y_hat[i] = 0
            else:
                y_hat = 1
        elif point[1] >=37.695206:
            y_hat[i] = 1
        else:
            y_hat[i] = 0

    return y_hat





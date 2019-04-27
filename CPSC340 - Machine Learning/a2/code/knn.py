"""
c

"""

import numpy as np
from scipy import stats
import utils

class KNN:

    def __init__(self, k):
        self.k = k

    def fit(self, X, y):
        self.X = X  # just memorize the trianing data
        self.y = y
        self.predicted = False

    def predict_helper(self, col):
        #Helper function that predicts the class for a given column of distances

        idx = np.argpartition(col, self.k)
        num_zero = (self.y[idx[:self.k]] == 0).sum()
        num_one = (self.y[idx[:self.k]] == 1).sum()

        if num_one > num_zero:
            return 1
        else:
            return 0

    def predict(self, Xtest):
        # create an empty array of predictions:
        self.y_pred = np.empty([len(Xtest)])

        # get an array of distance for each point
        distance = np.sqrt(utils.euclidean_dist_squared(self.X, Xtest))
        # get the index of the k-smallest points
        for i in range(0, len(Xtest)):
            self.y_pred[i] = self.predict_helper(distance[:, i])
        self.predicted = True

        return self.y_pred

    def classification_error(self, ytest):
        if (self.predicted == False):
            print("No predictions have been made yet")
        else:
            print(1-sum(self.y_pred == ytest) / len(ytest))


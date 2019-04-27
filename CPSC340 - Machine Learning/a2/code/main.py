# basics
import os
import pickle
import argparse
import matplotlib.pyplot as plt
import numpy as np

from scipy import stats

# sklearn imports
from sklearn.naive_bayes import BernoulliNB
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier


# our code
import utils

from knn import KNN

from naive_bayes import NaiveBayes

from decision_stump import DecisionStumpErrorRate, DecisionStumpEquality, DecisionStumpInfoGain
from decision_tree import DecisionTree
from random_tree import RandomTree
from random_forest import RandomForest

from kmeans import Kmeans
from sklearn.cluster import DBSCAN

def load_dataset(filename):
    with open(os.path.join('..','data',filename), 'rb') as f:
        return pickle.load(f)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-q','--question', required=True)

    io_args = parser.parse_args()
    question = io_args.question


    if question == "1":
        with open(os.path.join('..','data','citiesSmall.pkl'), 'rb') as f:
            dataset = pickle.load(f)

        X, y = dataset["X"], dataset["y"]
        X_test, y_test = dataset["Xtest"], dataset["ytest"]        
        model = DecisionTreeClassifier(max_depth=2, criterion='entropy', random_state=1)
        model.fit(X, y)

        y_pred = model.predict(X)
        tr_error = np.mean(y_pred != y)

        y_pred = model.predict(X_test)
        te_error = np.mean(y_pred != y_test)
        print("Training error: %.3f" % tr_error)
        print("Testing error: %.3f" % te_error)

    elif question == "1.1":
        with open(os.path.join('..','data','citiesSmall.pkl'), 'rb') as f:
            dataset = pickle.load(f)

        X, y = dataset["X"], dataset["y"]
        X_test, y_test = dataset["Xtest"], dataset["ytest"]

        tr_error_arr = np.zeros(15)
        te_error_arr = np.zeros(15)
        for i in range(1, 16):
            model = DecisionTreeClassifier(max_depth=i, criterion='entropy', random_state=1)
            model.fit(X, y)

            y_pred = model.predict(X)
            tr_error = np.mean(y_pred != y)

            y_pred = model.predict(X_test)
            te_error = np.mean(y_pred != y_test)

            tr_error_arr[i - 1] = tr_error
            te_error_arr[i - 1] = te_error

        depth = np.linspace(1, 15, 15)
        plt.plot(depth, tr_error_arr, color='blue', linestyle='solid', label='Training Error');
        plt.plot(depth, te_error_arr, color='red', linestyle='dashed', label='Test Error');
        plt.title('Training and Test Error Rate of a Decison-Tree Clasifer of Varying Depth');
        plt.ylabel('Classification Error rate');
        plt.xlabel('Tree Depth');
        plt.legend();
        plt.xticks(np.arange(min(depth), max(depth) + 1, 1.0));
        plt.savefig(fname='/Users/akshdeepsandhu/Desktop/UBC/CPSC 340/cpsc 340/Assignments/Assignment 2/a2/figs/q1_error_plot.png')
        print('Figure save to figs directory')





    elif question == '1.2':
        with open(os.path.join('..','data','citiesSmall.pkl'), 'rb') as f:
            dataset = pickle.load(f)

        X, y = dataset["X"], dataset["y"]
        n, d = X.shape



    elif question == '2.2':
        dataset = load_dataset("newsgroups.pkl")

        X = dataset["X"]
        y = dataset["y"]
        X_valid = dataset["Xvalidate"]
        y_valid = dataset["yvalidate"]
        groupnames = dataset["groupnames"]
        wordlist = dataset["wordlist"]




    elif question == '2.3':
        dataset = load_dataset("newsgroups.pkl")

        X = dataset["X"]
        y = dataset["y"]
        X_valid = dataset["Xvalidate"]
        y_valid = dataset["yvalidate"]

        print("d = %d" % X.shape[1])
        print("n = %d" % X.shape[0])
        print("t = %d" % X_valid.shape[0])
        print("Num classes = %d" % len(np.unique(y)))

        model = NaiveBayes(num_classes=4)
        model.fit(X, y)
        y_pred = model.predict(X_valid)
        v_error = np.mean(y_pred != y_valid)
        print("Naive Bayes (ours) validation error: %.3f" % v_error)

    

    elif question == '3':
        with open(os.path.join('..','data','citiesSmall.pkl'), 'rb') as f:
            dataset = pickle.load(f)

        X = dataset['X']
        y = dataset['y']
        Xtest = dataset['Xtest']
        ytest = dataset['ytest']

        k_vals = [1,3,10]

        for i in range(0,3):
            k = k_vals[i]
            model = KNN(k)
            model.fit(X,y)
            y_pred = model.predict(Xtest)
            print("Test error:")
            error_test = model.classification_error(ytest)


            y_pred_train = model.predict(X)
            print("Training error:")
            error_train = model.classification_error(y)


        model = KNN(1)
        model.fit(X, y)
        utils.plotClassifier(model,X,y)

    elif question == '4':
        dataset = load_dataset('vowel.pkl')
        X = dataset['X']
        y = dataset['y']
        X_test = dataset['Xtest']
        y_test = dataset['ytest']
        print("\nn = %d, d = %d\n" % X.shape)

        def evaluate_model(model):
            model.fit(X,y)

            y_pred = model.predict(X)
            tr_error = np.mean(y_pred != y)

            y_pred = model.predict(X_test)
            te_error = np.mean(y_pred != y_test)
            print("    Training error: %.3f" % tr_error)
            print("    Testing error: %.3f" % te_error)


        print("Random forest:")
        evaluate_model(RandomForest(max_depth=np.inf, num_trees=50))

        print("Decsion tree:")
        evaluate_model(DecisionTree(max_depth=np.inf))

        print("Random tree:")
        evaluate_model(RandomTree(max_depth=np.inf))




    elif question == '5':
        X = load_dataset('clusterData.pkl')['X']


        model = Kmeans(k=4)
        model.fit(X)
        y = model.predict(X)
        plt.scatter(X[:,0], X[:,1], c=y, cmap="jet")

        fname = os.path.join("..", "figs", "kmeans_basic.png")
        plt.savefig(fname)
        print("\nFigure saved as '%s'" % fname)

    elif question == '5.1':
        X = load_dataset('clusterData.pkl')['X']

        error = np.inf
        means = None
        for i in range(0,50):
            model = Kmeans(k=4)
            model.fit(X)
            model_err = model.error(X)
            if(model_err < error):
                error = model_err
                means = model.means
        model.means = means
        y = model.predict(X)
        plt.scatter(X[:, 0], X[:, 1], c=y, cmap="jet")

        fname = os.path.join("..", "figs", "kmeans_50_restarts.png")
        plt.savefig(fname)
        print("\nFigure saved as '%s'" % fname)





    elif question == '5.2':
        X = load_dataset('clusterData.pkl')['X']

        k_vals = np.arange(1, 11)
        err_array = np.ones(10)
        for j in range(0, 10):
            error = np.inf
            means = None
            k = k_vals[j]
            for i in range(0, 50):
                model = Kmeans(k)
                model.fit(X)
                model_err = model.error(X)
                if (model_err < error):
                    error = model_err
                    means = model.means
            err_array[j] = error

        fig1 = plt.figure(figsize=(10, 6))
        plt.plot(k_vals, err_array, '-or')
        plt.xlabel('K')
        plt.ylabel('Error')

        fname = os.path.join("..", "figs", "kmeans_best_k.png")
        plt.savefig(fname)




    elif question == '5.3':
        X = load_dataset('clusterData2.pkl')['X']

        model = DBSCAN(eps=15, min_samples=5)
        y = model.fit_predict(X)

        print("Labels (-1 is unassigned):", np.unique(model.labels_))
        
        plt.scatter(X[:,0], X[:,1], c=y, cmap="jet", s=5)
        fname = os.path.join("..", "figs", "density.png")
        plt.savefig(fname)
        print("\nFigure saved as '%s'" % fname)
        
        plt.xlim(-25,25)
        plt.ylim(-15,30)
        fname = os.path.join("..", "figs", "density2.png")
        plt.savefig(fname)
        print("Figure saved as '%s'" % fname)
        
    else:
        print("Unknown question: %s" % question)

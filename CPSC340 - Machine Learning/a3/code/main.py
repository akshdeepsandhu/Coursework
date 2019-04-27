
# basics
import argparse
import os
import pickle
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np


# sklearn imports
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.neighbors import NearestNeighbors
from sklearn.preprocessing import normalize

# our code
import linear_model
import utils

url_amazon = "https://www.amazon.com/dp/%s"

def load_dataset(filename):
    with open(os.path.join('..','data',filename), 'rb') as f:
        return pickle.load(f)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-q','--question', required=True)
    io_args = parser.parse_args()
    question = io_args.question

    if question == "1":

        filename = "ratings_Patio_Lawn_and_Garden.csv"
        with open(os.path.join("..", "data", filename), "rb") as f:
            ratings = pd.read_csv(f,names=("user","item","rating","timestamp"))

        print("Number of ratings:", len(ratings))
        print("The average rating:", np.mean(ratings["rating"]))

        n = len(set(ratings["user"]))
        d = len(set(ratings["item"]))
        print("Number of users:", n)
        print("Number of items:", d)
        print("Fraction nonzero:", len(ratings)/(n*d))

        X, user_mapper, item_mapper, user_inverse_mapper, item_inverse_mapper, user_ind, item_ind = utils.create_user_item_matrix(ratings)
        print(type(X))
        print("Dimensions of X:", X.shape)

    elif question == "1.1":
        filename = "ratings_Patio_Lawn_and_Garden.csv"
        with open(os.path.join("..", "data", filename), "rb") as f:
            ratings = pd.read_csv(f,names=("user","item","rating","timestamp"))
        X, user_mapper, item_mapper, user_inverse_mapper, item_inverse_mapper, user_ind, item_ind = utils.create_user_item_matrix(ratings)
        X_binary = X != 0

        # YOUR CODE HERE FOR Q1.1.1
        items_groups = ratings.groupby(['item']).sum()
        items_groups['rating'].idxmax()
        items_groups.sort_values(by='rating',ascending=False)[0:5]

        # YOUR CODE HERE FOR Q1.1.2
        user_groups = ratings.groupby(['user']).size().reset_index(name='count')
        user_groups.sort_values(by='count',ascending=False)[0:5]

        # YOUR CODE HERE FOR Q1.1.3
        plt.hist(user_groups['count'], bins=45)
        plt.yscale('log', nonposy='clip')
        plt.xlabel('Number of ratings per user')
        plt.ylabel('log(Frequency)')
        plt.savefig('user_hist.png')

        items_groups = ratings.groupby(['item']).sum()
        plt.hist(items_groups['rating'],bins=40)
        plt.yscale('log', nonposy='clip')
        plt.xlabel('Number of ratings per item')
        plt.ylabel('log(Frequency)')
        plt.savefig('item_hist.png')

        plt.hist(ratings['rating'], bins=5)
        plt.xlabel('Rating out of 5 stars')
        plt.ylabel('rating_hist.png')

    elif question == "1.2":
        filename = "ratings_Patio_Lawn_and_Garden.csv"
        with open(os.path.join("..", "data", filename), "rb") as f:
            ratings = pd.read_csv(f,names=("user","item","rating","timestamp"))
        X, user_mapper, item_mapper, user_inverse_mapper, item_inverse_mapper, user_ind, item_ind = utils.create_user_item_matrix(ratings)
        X_binary = X != 0

        grill_brush = "B00CFM0P7Y"
        grill_brush_ind = item_mapper[grill_brush]
        grill_brush_vec = X[:,grill_brush_ind]

        print(url_amazon % grill_brush)

        # YOUR CODE HERE FOR Q1.2

        def nearest_ids(nbrs_list):
            nearest_id = np.empty(len(nbrs_list), dtype='S15')
            for key,value in item_inverse_mapper.items():
                    for i in range(0,len(nbrs_list)):
                        if key == nbrs_list[i]:
                            nearest_id[i] = value
            return nearest_id

        #Transpose so KNN iterates over columns not rows
        X_train = np.transpose(X)
        print(X_train.shape);print(X.shape)

        #Fit model
        model = NearestNeighbors(n_neighbors=6)
        model.fit(X_train)

        #Apply knn to get the index of the nearest items
        nbrs = model.kneighbors(np.transpose(grill_brush_vec), n_neighbors=6, return_distance=False)

        #get the item id's of the nearest items
        nbrs_idx = nbrs[0]
        nearest_id = nearest_ids(nbrs_idx)
        item_list = nearest_id[1:]
        print(item_list)

        #Normalize data and train model
        X_train_norm = normalize(X_train)
        model_norm = NearestNeighbors(n_neighbors=6)
        model_norm.fit(X_train_norm)

        #Knn to get nearest items from normned data
        nbrs_normed = model_norm.kneighbors(np.transpose(grill_brush_vec), n_neighbors=6, return_distance=False)

        #Get item id's of nearest items
        nbrs_idx_norm = nbrs_normed[0]
        nearest_norm_id = nearest_ids(nbrs_idx_norm)
        norm_item_list = nearest_norm_id[1:]
        print(norm_item_list)

        #Fit model based on cosine similarity
        model_cosine = NearestNeighbors(n_neighbors=6,metric='cosine')
        model_cosine.fit(X_train)

        #Knn to get nearest items
        nbrs_cosine = model_cosine.kneighbors(np.transpose(grill_brush_vec), n_neighbors=6, return_distance=False)

        #Get item id's of nearest items
        nbrs_idx_cosine = nbrs_cosine[0]
        nearest_cosine_id = nearest_ids(nbrs_idx_cosine)
        cosine_item_list = nearest_cosine_id[1:]
        print(cosine_item_list)

        #Are both lists actually the same
        print(cosine_item_list == norm_item_list)



        # YOUR CODE HERE FOR Q1.3


        list1 = [xi.decode() for xi in item_list]
        list2 = [xi.decode() for xi in cosine_item_list]
        list3 = [xi.decode() for xi in norm_item_list]
        print(list1);print(list2);print(list3)

        items_groups = ratings.groupby(['item']).size().reset_index(name='count')
        items_groups.sort_values(by='count',ascending=False)[0:5]

        count_L1 = [items_groups.loc[items_groups['item'] == xi] for xi in list1]
        count_L2 = [items_groups.loc[items_groups['item'] == xi] for xi in list2]
        print(count_L1);print(count_L2)


    elif question == "3":
        data = load_dataset("outliersData.pkl")
        X = data['X']
        y = data['y']

        # Fit least-squares estimator
        model = linear_model.LeastSquares()
        model.fit(X,y)
        print(model.w)

        utils.test_and_plot(model,X,y,title="Least Squares",filename="least_squares_outliers.pdf")


        #model2 =linear_model.WeightedLeastSquares()
        #z = np.ones(500)
        #model2.fit(X,y,z)
        #print(model2.w)


    elif question == "3.1":
        data = load_dataset("outliersData.pkl")
        X = data['X']
        y = data['y']

        z1 = np.ones(400)
        z2 = np.full((100),0.1)
        z = np.r_[z1,z2]

        # Fit weighted least-squares estimator
        model2 = linear_model.WeightedLeastSquares()
        model2.fit(X,y,z)
        print(model2.w)

        utils.test_and_plot(model2,X,y,title="Weighted Least Squares",filename="weighted_least_squares_outliers.png")





    elif question == "3.3":
        # loads the data in the form of dictionary
        data = load_dataset("outliersData.pkl")
        X = data['X']
        y = data['y']

        # Fit least-squares estimator
        model = linear_model.LinearModelGradient()
        model.fit(X,y)
        print(model.w)

        utils.test_and_plot(model,X,y,title="Robust (L1) Linear Regression",filename="least_squares_robust.pdf")

    elif question == "4":
        data = load_dataset("basisData.pkl")
        X = data['X']
        y = data['y']
        Xtest = data['Xtest']
        ytest = data['ytest']

        # Fit least-squares model
        model = linear_model.LeastSquares()
        model.fit(X,y)

        utils.test_and_plot(model,X,y,Xtest,ytest,title="Least Squares, no bias",filename="least_squares_no_bias.pdf")

    elif question == "4.1":
        data = load_dataset("basisData.pkl")
        X = data['X']
        y = data['y']
        Xtest = data['Xtest']
        ytest = data['ytest']

        #Linear regression with bias
        model = linear_model.LeastSquaresBias()
        model.fit(X,y)

        utils.test_and_plot(model,X,y,Xtest,ytest,title="Least Squares, bias",filename="least_squares_bias.pdf")

    elif question == "4.2":
        data = load_dataset("basisData.pkl")
        X = data['X']
        y = data['y']
        Xtest = data['Xtest']
        ytest = data['ytest']

        for p in range(11):
            print("p=%d" % p)
            model = linear_model.LeastSquaresPoly(p)
            model.fit(X,y)
            utils.test_and_plot(model,X,y,Xtest,ytest)

        #model = linear_model.LeastSquaresPoly(5)
        #model.fit(X,y)
        #utils.test_and_plot(model,X,y,Xtest,ytest,title="Poly fit",filename="poly_fit.pdf")






    else:
        print("Unknown question: %s" % question)


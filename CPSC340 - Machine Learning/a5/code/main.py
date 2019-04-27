import os
import pickle
import argparse
import matplotlib.pyplot as plt
import numpy as np
from numpy.linalg import norm
from sklearn.model_selection import train_test_split

import utils
import logReg
from logReg import logRegL2, kernelLogRegL2
from pca import PCA, AlternativePCA, RobustPCA

def load_dataset(filename):
    with open(os.path.join('..','data',filename), 'rb') as f:
        return pickle.load(f)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-q','--question', required=True)

    io_args = parser.parse_args()
    question = io_args.question

    if question == "1":
        dataset = load_dataset('nonLinearData.pkl')
        X = dataset['X']
        y = dataset['y']

        Xtrain, Xtest, ytrain, ytest = train_test_split(X,y,random_state=0)

        # standard logistic regression
        lr = logRegL2(lammy=1)
        lr.fit(Xtrain, ytrain)

        print("Training error %.3f" % np.mean(lr.predict(Xtrain) != ytrain))
        print("Validation error %.3f" % np.mean(lr.predict(Xtest) != ytest))

        utils.plotClassifier(lr, Xtrain, ytrain)
        utils.savefig("logReg.png")

        # kernel logistic regression with a linear kernel
        lr_kernel = kernelLogRegL2(kernel_fun=logReg.kernel_linear, lammy=1)
        lr_kernel.fit(Xtrain, ytrain)

        print("Training error %.3f" % np.mean(lr_kernel.predict(Xtrain) != ytrain))
        print("Validation error %.3f" % np.mean(lr_kernel.predict(Xtest) != ytest))

        utils.plotClassifier(lr_kernel, Xtrain, ytrain)
        utils.savefig("logRegLinearKernel.png")

    elif question == "1.1":
        dataset = load_dataset('nonLinearData.pkl')
        X = dataset['X']
        y = dataset['y']

        Xtrain, Xtest, ytrain, ytest = train_test_split(X,y,random_state=0)

        #Train and test polynomial kernel. Plot classifier
        polyKer = kernelLogRegL2(kernel_fun=logReg.kernel_poly,lammy=0.001,p=2)
        polyKer.fit(Xtrain,ytrain)

        print("Poly-Training error %.3f" % np.mean(polyKer.predict(Xtrain) != ytrain))
        print("Poly-Validation error %.3f" % np.mean(polyKer.predict(Xtest) != ytest))
        utils.plotClassifier(polyKer, Xtrain, ytrain)
        utils.savefig("logRegPolyKernel.png")

        #Train and test rbf. Plot classifier
        rbfKer =  kernelLogRegL2(kernel_fun=logReg.kernel_RBF,lammy=0.001,sigma=0.5)
        rbfKer.fit(Xtrain,ytrain)
        print("RBF-Training error %.3f" % np.mean(rbfKer.predict(Xtrain) != ytrain))
        print("RBF-validation error %.3f" % np.mean(rbfKer.predict(Xtest) != ytest))

        utils.plotClassifier(rbfKer, Xtrain, ytrain)
        utils.savefig("logRegRbfKernel.png")




    elif question == "1.2":
        dataset = load_dataset('nonLinearData.pkl')
        X = dataset['X']
        y = dataset['y']

        Xtrain, Xtest, ytrain, ytest = train_test_split(X,y,random_state=0)

        #create a range of hyperparameter values
        lammy_range = np.linspace(start=-4,stop=0,num=5)
        sigma_range = np.linspace(start=-2,stop=2,num=5)

        #create empty arrays for training and test error
        train_error, test_error = np.zeros((5,5)),np.zeros((5,5))

        min_train_er = np.inf
        min_val_er = np.inf

        opt_sigma_tr = np.nan
        opt_sigma_val = np.nan

        opt_lambda_tr = np.nan
        opt_lambda_val = np.nan

        for i in range(0,5):

            lammy_temp = 10**lammy_range[i]

            for j in range(0,5):

                sigma_temp = 10**sigma_range[j]

                #train and test
                rbfKer =  kernelLogRegL2(kernel_fun=logReg.kernel_RBF,lammy=lammy_temp,sigma=sigma_temp)
                rbfKer.fit(Xtrain,ytrain)


                train_error = np.mean(rbfKer.predict(Xtrain) != ytrain)
                #add to test error array
                test_error = np.mean(rbfKer.predict(Xtest) != ytest)

                if(train_error < min_train_er):
                    min_train_er  = train_error
                    opt_sigma_tr = sigma_temp
                    opt_lambda_tr = lammy_temp

                if(test_error < min_val_er):
                    min_val_er = test_error
                    opt_sigma_val = sigma_temp
                    opt_lambda_val = lammy_temp

        print("Best tr lambda " +  str(opt_lambda_tr));print("Best tr sigma " + str(opt_sigma_tr))
        print("Best val lambda " + str(opt_lambda_val));print("Best val sigma " + str(opt_sigma_val));

        #plot best tr model
        best_tr_model = kernelLogRegL2(kernel_fun=logReg.kernel_RBF,lammy=opt_lambda_tr,sigma=opt_sigma_tr)
        best_tr_model.fit(Xtrain,ytrain)

        utils.plotClassifier(best_tr_model, Xtrain, ytrain)
        utils.savefig("logRegRbfKernel_bestTr.png")

        #plot best val model
        best_val_model = kernelLogRegL2(kernel_fun=logReg.kernel_RBF,lammy=opt_lambda_val,sigma=opt_sigma_val)
        best_val_model.fit(Xtrain,ytrain)

        utils.plotClassifier(best_val_model, Xtrain, ytrain)
        utils.savefig("logRegRbfKernel_bestVal.png")
    elif question == '4.1':
        X = load_dataset('highway.pkl')['X'].astype(float)/255
        n,d = X.shape
        print(n,d)
        h,w = 64,64      # height and width of each image

        k = 5            # number of PCs
        threshold = 0.1  # threshold for being considered "foreground"

        model = AlternativePCA(k=k)
        model.fit(X)
        Z = model.compress(X)
        Xhat_pca = model.expand(Z)

        model = RobustPCA(k=k)
        model.fit(X)
        Z = model.compress(X)
        Xhat_robust = model.expand(Z)

        fig, ax = plt.subplots(2,3)
        for i in range(10):
            ax[0,0].set_title('$X$')
            ax[0,0].imshow(X[i].reshape(h,w).T, cmap='gray')

            ax[0,1].set_title('$\hat{X}$ (L2)')
            ax[0,1].imshow(Xhat_pca[i].reshape(h,w).T, cmap='gray')

            ax[0,2].set_title('$|x_i-\hat{x_i}|$>threshold (L2)')
            ax[0,2].imshow((np.abs(X[i] - Xhat_pca[i])<threshold).reshape(h,w).T, cmap='gray', vmin=0, vmax=1)

            ax[1,0].set_title('$X$')
            ax[1,0].imshow(X[i].reshape(h,w).T, cmap='gray')

            ax[1,1].set_title('$\hat{X}$ (L1)')
            ax[1,1].imshow(Xhat_robust[i].reshape(h,w).T, cmap='gray')

            ax[1,2].set_title('$|x_i-\hat{x_i}|$>threshold (L1)')
            ax[1,2].imshow((np.abs(X[i] - Xhat_robust[i])<threshold).reshape(h,w).T, cmap='gray', vmin=0, vmax=1)

            utils.savefig('highway_{:03d}.jpg'.format(i))

    else:
        print("Unknown question: %s" % question)

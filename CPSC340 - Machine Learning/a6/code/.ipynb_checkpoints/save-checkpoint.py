""" alpha = 0.001
    batch_size = 500
    n_epochs = 10
    #must run SGD n/batch_size times for each epoch
    num_iter = int(n/batch_size)


    #shuffle data
    np.random.shuffle(X)
    np.random.shuffle(y)


    for i in range(0,n_epochs):
        #preform SGD for one epoch

        #shuffle data again
        np.random.shuffle(X)
        np.random.shuffle(y)


        for j in range(0,n,batch_size):
            #iterate over batch of data

            #get index for batch
            start_idx = j * batch_size
            end_idx =  start_idx + batch_size

            #get batch of data
            X_batch = X[start_idx:end_idx,:]
            y_batch = y[start_idx:end_idx]

            #evaluate the f, g using current w
            f_new, g_new = funObj(w, X_batch,y_batch)


            #compute new weights
            w_new = w - alpha * g


            # Print progress
            if verbose > 0:
                #print("%d - loss: %.3f" % (j, f_new))


            # Update parameters/function/gradient
            w = w_new
            f = f_new
            g = g_new"""

alpha = 0.001
        batch_size = 500
        n_epochs = 10
        w = weights_flat
        n = X.shape[0]
        
        for i in range(0,2):
            X,y = shuffle(X,y)
            for j in range(0,n,batch_size):
                X_batch = X[j:batch_size,:]
                y_batch = y[j:batch_size,:]
                f,g = self.funObj(w,X_batch,y_batch)
                w  = w - alpha*g
                print("%d - loss: %.3f" % (int(j/500), f))
            
                
        weights_flat_new = w
        



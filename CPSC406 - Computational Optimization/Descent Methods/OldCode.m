%% OLD CODE
%b_hat is predicted class


b_hat = zeros(m,1);

for i=1:m
    %loop over rows and classifiy as 1 or -1
    if A(i,:)*xls > 0
        b_hat(i)= 1;
    else
        b_hat(i)= -1;
    end
end


%compute training missclassfication rate
train_miss_class_rate = miss_class(b',b_hat);

b_hat_test = zeros(mtest,1);

%get b_hat test
for i=1:mtest
    %loop over rows and classifiy as 1 or -1
    if Atest(i,:)*xls > 0
        b_hat_test(i)= 1;
    else
        b_hat_test(i)= -1;
    end
end

% get training and test for logistic regression with gradient descent
b_hat_train = zeros(m,1);

for i=1:m
    %loop over rows and classifiy as 1 or 0
    if A(i,:)*x_logreg > 0.5
        b_hat_train(i)= 1;
    else
        b_hat_train(i)= 0;
    end
end

%train_miss_class_rate
log_train_miss_class = miss_class(b',b_hat_train);

b_hat_test = zeros(size(btest,2),1);

%test error
for i=1:size(b_hat_test,1)
    %loop over rows and classifiy as 1 or 0
    if Atest(i,:)*x_logreg > 0.5
        b_hat_test(i)= 1;
    else
        b_hat_test(i)= 0;
    end
end

log_test_miss_class = miss_class(btest',b_hat_test);

b_hat_train_search = zeros(m,1);

for i=1:m
    %loop over rows and classifiy as 1 or 0
    if A(i,:)*x_logreg > 0.5
        b_hat_train_search(i)= 1;
    else
        b_hat_train_search(i)= 0;
    end
end

%train_miss_class_rate
log_train_miss_class_search = miss_class(b',b_hat_train_search);

b_hat_test_search = zeros(size(btest,2),1);

%test error
for i=1:size(b_hat_test_search,1)
    %loop over rows and classifiy as 1 or 0
    if Atest(i,:)*x_logreg > 0.5
        b_hat_test_search(i)= 1;
    else
        b_hat_test_search(i)= 0;
    end
end

log_test_miss_class_search = miss_class(btest',b_hat_test_search);

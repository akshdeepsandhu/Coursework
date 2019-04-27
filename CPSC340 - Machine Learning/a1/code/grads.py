import numpy as np

def example(x):
    return np.sum(x**2)


def example_grad(x):
    return 2*x

def foo(x):
    result = 1
    λ = 4 # this is here to make sure you're using Python 3
    for x_i in x:
        result += x_i**λ
    return result

def foo_grad(x):
    grad = x
    for i in range(0,len(x)):
        grad[i] = x[i]**3
    return 4*grad

def bar(x):
    return np.prod(x)

def bar_grad(x):
    grad = x
    for i in range(0, x.size):
        temp = np.delete(x, i)
        grad[i] = np.prod(temp)

    return grad





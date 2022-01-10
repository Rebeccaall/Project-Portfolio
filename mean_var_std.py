import numpy as np

def calculate(list):
  if len(list)!=9:
    raise ValueError("List must contain nine numbers.")
  else:
    #convert the input list into a 3x3 Numpy array
    new_ay=np.array(list).reshape(3,3)
    #perform the operations on the 3x3 array
    #transform the cal result into a list
    calculations={
      'mean':[new_ay.mean(axis=0).tolist(),
              new_ay.mean(axis=1).tolist(),
              new_ay.mean()],
      'variance':[new_ay.var(axis=0).tolist(),
              new_ay.var(axis=1).tolist(),
              new_ay.var()],
      'standard deviation':[new_ay.std(axis=0).tolist(),
              new_ay.std(axis=1).tolist(),
              new_ay.std()],
      'max':[new_ay.max(axis=0).tolist(),
              new_ay.max(axis=1).tolist(),
              new_ay.max()],
      'min':[new_ay.min(axis=0).tolist(),
              new_ay.min(axis=1).tolist(),
              new_ay.min()],
      'sum':[new_ay.sum(axis=0).tolist(),
              new_ay.sum(axis=1).tolist(),
              new_ay.sum()]}
      

    return calculations
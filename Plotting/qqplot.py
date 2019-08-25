#written by Lars Fritsche

import math
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from itertools import product, cycle
from six.moves import zip
from six import iterkeys, iteritems
from collections import OrderedDict
from scipy import stats

def qqplot(series,thin=True,already_transformed=False):
  """
  Create a QQ plot for p-values. P-values and expected quantiles are transformed to the -log10 scale. 
  
  :param series: A dictionary of label --> p-value arrays (can be numpy array or pandas series). 
  :param thin: Should we thin points down before plotting? 
  :param already_transformed: Are the p-values already transformed to -log10 scale? 
  """
  
  QQ_COLORS = ["dodgerblue","red","forestgreen","deeppink","indigo","orange"]
  QQ_SYMBS = ["o","s","d","v","<","^",">","x","+"]
  
  def log10_quantiles(x):
    return -np.log10((stats.rankdata(x,method="ordinal")) / len(x))
  
  color_iter = cycle(QQ_COLORS)
  symb_iter = cycle(QQ_SYMBS)
  
  attrs = OrderedDict()
  for x in iterkeys(series):
    attrs[x] = {}
    
  log_obs_max = float("-inf")
  log_exp_max = float("-inf")
  
  for label, data in iteritems(series):    
    # Drop NaNs
    if isinstance(data,np.ndarray):
      data = data[~np.isnan(data)]
      #data = np.sort(data)
    elif isinstance(data,pd.Series):
      data = data.dropna()
      #data = data.sort(inplace=False)
    else:
      raise ValueError("Must pass either numpy array or pandas series")
      
    if already_transformed:
      log_data = data
      log_expd = log10_quantiles(10 ** -data)
    else:
      log_data = -np.log10(data)
      log_expd = log10_quantiles(data)
    
    attrs[label]['xlim'] = (
      0 - 0.05 * max(log_expd),
      max(log_expd) + 0.05 * max(log_expd)
    )
    
    attrs[label]['ylim'] = (
      0 - 0.05 * max(log_data),
      max(log_data) + 0.05 * max(log_data)
    )
    
    if thin:
      tmpdf = pd.DataFrame({
        "x" : log_expd,
        "y" : log_data
      })
      
      for col in tmpdf:
        tmpdf[col] = tmpdf[col].round(2)
        
      tmpdf.drop_duplicates(inplace=True)
      
      xval = tmpdf["x"]
      yval = tmpdf["y"]
      
#       rounder = lambda x: round(x,2)
      
#       # Remove duplicates, but keep array items in the same order. 
#       points = OrderedDict.fromkeys(zip(map(rounder,log_expd),map(rounder,log_data)))
      
#       xval = np.fromiter((x[0] for x in points),dtype=np.float32)
#       yval = np.fromiter((x[1] for x in points),dtype=np.float32)
      
#       # Free
#       points = None
    else:
      xval = log_expd
      yval = log_data
    
    attrs[label]['logx'] = xval
    attrs[label]['logy'] = yval
    
    log_obs_max = max(log_obs_max,attrs[label]['ylim'][1])
    log_exp_max = max(log_exp_max,attrs[label]['xlim'][1])
    
  fig, ax = plt.subplots()
  
  xmin = 0 - 0.05 * log_exp_max
  xmax = log_exp_max + 0.05 * log_exp_max
  ymin = 0 - 0.05 * log_obs_max
  ymax = log_obs_max + 0.05 * log_obs_max
  
  plt.xlim(xmin,xmax)
  plt.ylim(ymin,ymax)
  
  plt.title("QQ Plot")
  ax.set_xlabel(r'Expected $-log_{10}(p-value)$')
  ax.set_ylabel(r'Observed $-log_{10}(p-value)$')
  
  for label in attrs:
    plt.scatter(
      attrs[label]['logx'],
      attrs[label]['logy'],
      label=label,
      c=next(color_iter),
      marker=next(symb_iter),
      s=60
    )

  leg = plt.legend(loc='upper left',frameon=True)
  leg.get_frame().set_color("white")
  max_max = max(xmax,ymax)
  diag_line = ax.plot([-1,max_max],[-1,max_max],ls="--",c="0.3")

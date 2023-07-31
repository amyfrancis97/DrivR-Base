import pandas as pd
import os
import re
from textwrap import wrap
import numpy as np
import sys
from Bio import SeqIO
from Bio.Seq import Seq
from sklearn.svm import SVC
from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_curve, auc, precision_recall_curve, average_precision_score
from sklearn.metrics import classification_report  # classification summary
import matplotlib.pyplot as plt
from multiprocessing import Pool
import requests
from urllib import request
import gzip
import shutil
from multiprocessing.pool import ThreadPool


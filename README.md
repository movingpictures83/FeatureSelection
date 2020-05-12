# FeatureDetection
# Language: R
# Input: TXT (parameters)
# Output: CSV (optimal parameters)
# Tested with: PluMA 1.0, R 3.2.5

PluMA plugin that takes two datasets (training and test),
each of which have case and control samples.

It then will output the most important features when 
distinguishing case vs. control. 

Its input file is a TXT file of tab-delineated keyword-value pairs:

training (training data set)
clinical (testing data set)

It will then output the features that most distinguish each group,
in CSV format.

Note the input TSV and CSV files in the example/ directory are not publically available.
A future goal is to make a synthetic data set.  In the meantime however, one may
use it on their own tab-separated input data.


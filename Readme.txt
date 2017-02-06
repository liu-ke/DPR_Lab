memory requirment: at least 8GB.

Remarks about the cancer cell recognition code:

All subfunctions and libsvm package need to be added into path (functions (libsvmtrain, libsvmpredict) are used in Lib_Svm.)

In line 3, change the path of medical dataset. 

In line 10, features.mat is extracted data in order to speed up, which contains normal features and cancer features
(line 7-line 9 can be uncommented, and line 10 can be comment.)

In line 15, default normalization_method can be changed among 1,2,3.

In line 20, defualt outlier detection_method is 2 using robust distance, which can be changed to 1 using Mahalanobis Distance.


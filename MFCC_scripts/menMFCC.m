load MFCCExpTest
men=MFCC{3};
clear MFCC;
load MFFCTrainingSampled


output =DynamicTimeWarp(men(289:end),MFCC);
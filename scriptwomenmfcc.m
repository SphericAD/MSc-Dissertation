load MFCCExpTest
women=MFCC{4};
clear MFCC
load MFFCTrainingSampled
output =DynamicTimeWarp(women,MFCC);

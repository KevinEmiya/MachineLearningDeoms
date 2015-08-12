function [datan, norm_para] = normalizeDataTansig(dataIn)
%This function converts input data into normalized data between [-1, 1];
%Input:
% - dataIn : 1D data vector
%Output:
% - datan : normalized data
% - norm_para: normalization parameter for reconstructin
%              (norm_para.scale, norm_para.offset)

norm_para.scale = 2/(max(dataIn) - min(dataIn));
norm_para.offset = 1 - norm_para.scale * max(dataIn);

datan = norm_para.scale * dataIn + norm_para.offset;
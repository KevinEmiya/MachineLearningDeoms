function dataOut = reconstrcutNormalizedData(datan, norm_para)
%This function reconstructs normalized data using normalization parameters
%Input:
% - datan : 1D normalized data vector
% - norm_para: normalization parameter for reconstructin
%              (norm_para.scale, norm_para.offset)
%Output:
% - dataOut : reconstructed data

dataOut = 1 / norm_para.scale * (datan - norm_para.offset);
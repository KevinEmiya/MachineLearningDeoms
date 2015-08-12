clear all;
close all;
clc;

%% Simulate data
input = 0.01 : 0.01 : 20;
output = input .^ 2 + log(input + 1);

% Select 90% random data as trainning data, the rest as test data.
trainSampleRate = 0.9;
trainSampleCnt = floor(trainSampleRate * length(input));
testSampleCnt = length(input) - trainSampleCnt;

k = rand(1, length(input));
[m, n] = sort(k);

input_train = input(n(1:trainSampleCnt));
output_train = output(n(1:trainSampleCnt));

input_test = input(n(trainSampleCnt + 1: length(input)));
output_test = output(n(trainSampleCnt + 1: length(input)));
%% Trainning
%Normalize trainning data
[inputn_train, norm_para_in] = normalizeDataTansig(input_train);
[outputn_train, norm_para_out] = normalizeDataTansig(output_train);

%Generate network
net = newff(inputn_train , outputn_train, 10, { 'tansig' 'purelin' } , 'trainlm' ) ; 

net.trainparam.epochs = 200 ;
net.trainparam.goal = 1e-8 ;
net.trainParam.lr = 0.01 ;

%Start trainning
net = train(net, inputn_train, outputn_train);
%% Test trainning reslut using sim function
%Normalize test data
inputn_test = norm_para_in.offset + norm_para_in.scale * input_test;
%Simulate output data
outputn_sim = sim(net, inputn_test);
output_sim = reconstrcutNormalizedData(outputn_sim, norm_para_out);
%Visualize differences between simulated and real test data
figure(1);
hold on;
grid on;
plot(output_sim, '-r*');
plot(output_test, '-go');
legend('simulated value','real value','Location', 'best');
figure(2);
grid on;
test_error = output_test - output_sim;
plot(test_error, '-b*');
title('Difference between simulated and real data.');

%% Test trainning result using forward propagation
%Get weight and offset values from network
w1 = net.IW{1,1};
b1 = net.b{1};
w2 = net.LW{2,1};
b2 = net.b{2};
%Calculate value via forward propagation through network
test_x = 3.1415926;
testn_x = norm_para_in.offset + norm_para_in.scale * test_x;

Hn = tansig(w1 * testn_x + b1);
On = w2 * Hn + b2;

O = reconstrcutNormalizedData(On, norm_para_out);
%Test: compare the result from forward propagation and the result via sim
%function
On_sim = sim(net, testn_x);
O_sim = reconstrcutNormalizedData(On_sim, norm_para_out);

fprintf('O_sim - O = %f\n', O_sim - O);
%Difference between result from forward propagation and correct result
test_y = test_x ^ 2 + log(test_x + 1);

fprintf('test_y - O = %f\n', test_y - O);



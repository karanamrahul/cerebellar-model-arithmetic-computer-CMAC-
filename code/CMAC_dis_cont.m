clear all;
close all;
clc;
% This File will explain about the implementation of CMAC using a
% 1-D Discrete and Coninuous Function y = exp(x)

x = (linspace(-5,5))';
y = abs(x);
N = randperm(100);  % Creating a vector of 100 random points.
% Splitting data to 70% train and 30% test data.
train_data = [x(N(1:70)),y(N(1:70))]; 
test_data = [x(N(71:100)),y(N(71:100))];

%Iterating for 25 steps
for i=1:25
        CMAC = gen_map(x,35,i); % Creates a CMAC map using 35 Weights
        figure
        plot(x,y,'LineStyle','--',Color='#D95319');
        xlabel("Input Data -->")
        ylabel("Function f(x) = abs(x) -->")
        hold on
        [map,iterator(1,i),~,Time(1,i)] = CMAC_train(CMAC,train_data,0,0); % Trains Discrete CMAC
        accuracy(1,i) = CMAC_test(map,test_data,0);  %Tests Discrete CMAC
        hold off
        legend('Function f(x) = abs(x)','Output from Discrete CMAC');
        title(['CMAC Overlap Area = ' num2str(i)]);
        figure
        plot(x,y,'-x',color='r');
        hold on
        [map,iterator(2,i),~,Time(2,i)] = CMAC_train(CMAC,train_data,0,1);  % Trains Continuous CMAC
        accuracy(2,i) = CMAC_test(map,test_data,1);  % Tests Continuous CMAC
        hold off
        legend('Function f(x) = abs(x)','Continuous Output');
        title(['CMAC Continuous Iteration = ' num2str(i)]);
end

t = 1:25;
figure()  % Plot Convergence Time of both CMAC
plot(t, Time(1,:),'--' ,t, Time(2,:),':')
title('Convergence Time')
xlabel('No. of Iterations')
ylabel('Time')
legend('Discrete','Continuous')

figure()  % Plot Accuracy of both CMAC
plot(t, accuracy(1,:),'b--o', t, accuracy(2,:),'c*')
title('Accuracy')
xlabel('No. of Iterations')
ylabel('Perentage')
legend('Discrete Accuracy', 'Continuous Accuracy')
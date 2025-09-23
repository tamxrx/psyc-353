%% intro to plotting
clear, clc % clear bg processes + command window
figure(1), clf % ope clean figure 1 window

% plot(x(coords of plots),y,customizations)
plot([1 2], [1 1], 'Color','red','LineWidth',2)
hold on % addition of plot
plot([1,2],[0,2], 'Color', 'green', 'LineWidth', 3)

%% loops
clear, clc
n = 10; % index range
numbers = 1:n;% array

for i = numbers
    disp(['The square of ' num2str(i) ' is ' num2str(i^2)])
    pause(.5)
end

%% 

clear, clc
n = 10;
figure(1), clf % inititate figure
set(gca, 'ylim', [0 n], 'Color', [0 0 0])
hold on

for i = 1:n
    plot([i 0], [n i], 'LineWidth', 2, 'Color', 'green')
    pause(1)
end





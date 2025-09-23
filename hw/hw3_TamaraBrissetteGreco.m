name = "Tamara Brissette Greco";
student_id = 261182266;

clear, clc
n = 12;
figure(1), clf % inititate figure
set(gca, 'ylim', [0 n], 'Color', [1 1 1])
hold on

plot(0, 'LineWidth', 2, 'Color', 'green')

%%
for i = 1:n
    plot([i i], [0 n], 'LineWidth', 2, 'Color', 'green')
    pause(.5)
    plot([0 12],[i i], 'LineWidth', 2, 'Color', 'blue')
    pause(.5)
end
   
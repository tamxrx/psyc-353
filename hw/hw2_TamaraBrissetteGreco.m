
% % % % % % % % % % % % %
% % WEEK 2 - HOMEWORK % %
% % % % % % % % % % % % %

%% your information

name = "Tamara Brissette Greco";
student_id = 261182266;


%% Part 1
% Write a script that captures some information about a user or
% participant. Come up with three or four questions and use input() to
% collect the user's responses. You can be creative about the questions you
% ask (they don't necesarily have to be things you would ask in an actual
% experiment). But do NOT repeat any of the questions we used in class.

major = input("What major are you in?: ","s");
future = input("Are you graduating this semester? (Yes/No): ","s");
years = input("How many semesters do you have left till graduation?: ");
graduate = input("Do you plan to pursue graduate school?(Yes/No): ","s");


%% Part 2
% Now concatenate and integrate the responses in a character array like we
% did in class, such that it forms a readable sentence or paragraph (for
% example, in class we had an output that said, e.g., "The participant with
% ID 42 is male and 25 years old. Their first language is English"). Have
% the string be saved in a variable called 'output'. Kudos if you include a
% conditional statement (if/else), but this is not required.

if future == "Yes" 
    future_ans = 'is graduating this semester';
    if graduate == "Yes"
        graduate_ans = 'They are planning to attend graduate school.';
    else
        graduate_ans = 'They will pursue other non academic opportunities.';
    end
else 
    future_ans = 'is not graduating this semester';
    graduate_ans = ['They have ' num2str(years) ' credits left.'];

end

output = ['The participant is a ' major ' major and ' future_ans ' .' graduate_ans];
disp(output)
% MATLAB Tutorial 1

%% Capturing demographics info of participants

id = input("Enter participant id: ");
age = input("What is your age?: ");
gender = input("What is your gender: ", "s");
lang = input("Is English your first language? (True or False): ", "s");
country = input("What is your country of residence?: ","s");
city = input("What is your city of residence?: ","s");

%% Display the collected info

demo_inf = ['Participant ' num2str(id) ' is ' gender ' and ' num2str(age) ' years old.'];
disp(demo_inf);

%% Conditions

lang2 = input('What is your first language: ','s');

if lang2 == "English"
    language = 'English';
else 
    language = 'other';
end

lang_sentence = ['Participant speaks ' language];
disp(lang_sentence)
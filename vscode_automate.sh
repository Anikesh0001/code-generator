#!/bin/bash

# Prompt for the file extension to use for file creation
read -p "Which language extension do you want to use for file creation (C, C++, Python, Java, Ruby, PHP, Go, Rust)? " user_language

# Prompt for the problem statement, including the language context
read -p "Write your problem mentioning the language (e.g., 'add two numbers in C'): " user_problem

# Extract the first 5 to 6 letters from the problem for the file name
file_name_prefix=$(echo "$user_problem" | tr -d ' ' | cut -c 1-6 | tr '[:upper:]' '[:lower:]')  # Convert to lowercase

# Determine the file extension and name based on the language mentioned in the prompt
if [[ "$user_language" == "C" || "$user_language" == "c" ]]; then
    file_extension="c"
    file_name="${file_name_prefix}.c"
    run_command="gcc $file_name -o ${file_name_prefix} && ./${file_name_prefix}"
elif [[ "$user_language" == "C++" || "$user_language" == "c++" ]]; then
    file_extension="cpp"
    file_name="${file_name_prefix}.cpp"
    run_command="g++ $file_name -o ${file_name_prefix} && ./${file_name_prefix}"
elif [[ "$user_language" == "Python" || "$user_language" == "python" ]]; then
    file_extension="py"
    file_name="${file_name_prefix}.py"
    run_command="python3 $file_name"
elif [[ "$user_language" == "Java" || "$user_language" == "java" ]]; then
    file_extension="java"
    file_name="${file_name_prefix}.java"
    run_command="javac $file_name && java ${file_name_prefix}"
elif [[ "$user_language" == "Ruby" || "$user_language" == "ruby" ]]; then
    file_extension="rb"
    file_name="${file_name_prefix}.rb"
    run_command="ruby $file_name"
elif [[ "$user_language" == "PHP" || "$user_language" == "php" ]]; then
    file_extension="php"
    file_name="${file_name_prefix}.php"
    run_command="php $file_name"
elif [[ "$user_language" == "Go" || "$user_language" == "go" ]]; then
    file_extension="go"
    file_name="${file_name_prefix}.go"
    run_command="go run $file_name"
elif [[ "$user_language" == "Rust" || "$user_language" == "rust" ]]; then
    file_extension="rs"
    file_name="${file_name_prefix}.rs"
    run_command="rustc $file_name && ./${file_name_prefix}"
else
    echo "Unsupported language. Defaulting to Python."
    file_extension="py"
    file_name="${file_name_prefix}.py"
    run_command="python3 $file_name"
fi

# Create or truncate the file to ensure it's empty
> "$file_name"

# Open VS Code and create a new file
code "$file_name"

# Wait for a moment to ensure the file is open
sleep 2

# Use AppleScript to input the prompt into VS Code
osascript -e "tell application \"Visual Studio Code\"
    activate
    tell application \"System Events\"
        keystroke \"l\" using {command down}  # Simulate Command + L to trigger Blackbox AI
        delay 0.5  # Wait for the input field to be focused
        keystroke \"$user_problem\"  # Paste the user problem
        keystroke return  # Press Enter
        delay 5  # Wait for Blackbox AI to generate the code
        keystroke \"s\" using {command down}  # Simulate Command + S to save the file
        delay 0.5  # Wait for the save dialog to open
        keystroke return  # Press Enter to confirm saving
        delay 1  # Wait for the save to complete
        keystroke \"n\" using {control down, option down}  # Simulate Control + Option + N to run the code
    end tell
end tell"

# Run the generated code and suppress output
eval $run_command > /dev/null 2>&1

#!/bin/bash
# Script that automates the creation of a workspace, configures settings via the command line, and handles system signals gracefully

# This allows the user to name the project directory
read -p "Name your directory: attendance_tracker_" input

# Here, I defined variables for the project directory and archive functionality
directory=attendance_tracker_$input
archive_folder=attendance_tracker_${input}_archive
mkdir -p $directory

if ! mkdir -p "$directory"; then
	echo "Error: Failed to create directory. Check permissions."
	exit 1
fi

# This is the cleanup function for when the signal is interrupted
cleanup() {
	echo
	echo "Script interrupted. Cleaning up..."

	# If the project directory exists, archive it before deletion
	if [ -d "$directory" ]; then
		tar -czf "${archive_folder}.tar.gz" "$directory"
		rm -rf "$directory"
		echo "Project archived as ${archive_folder}.tar.gz"
	fi

	echo "Incomplete setup removed. Exiting."
	exit 1
}

# This invokes the cleanup function above
trap cleanup SIGINT

# This creates subdirectories
mkdir -p $directory/Helpers
mkdir -p $directory/reports

# This code validates the existence of the required source files
required_files=("attendance_checker.py" "assets.csv" "config.json" "reports.log")

for file in "${required_files[@]}"; do
	if [ -f "$file" ]; then
		# Checking if the base directory exists and is a directory and copying the right contents into it
		if [ -d "$directory" ]; then
			cp attendance_checker.py $directory
			cp assets.csv $directory/Helpers/
			cp config.json $directory/Helpers/
			cp reports.log $directory/reports/
		fi
	else
		echo "Error: Required file $file not found"
		exit 1
	fi
done

# Interactive attendance threshold update that does not terminate unless the user selects a valid value or uses Ctrl+C
while true; do
	read -p "Do you want to update attendance thresholds? (yes or no)" answer

	case "${answer,,}" in
		yes|y)

			# Prompt the user to input warning and failure thresholds
			read -p "Enter warning threshold (default 75): " warning
			read -p "Enter failure threshold (default 50): " failure

			warning=${warning:-75}
			failure=${failure:-50}

			config_file=$directory/Helpers/config.json
      
      if ! [[ "$warning" =~ ^[0-9]+$ ]] || ! [[ "$failure" =~ ^[0-9]+$ ]]; then
			  echo "Error: Thresholds must be numeric values."
			  exit 1
		  fi

			# Updates the config file with the selected warning and failure thresholds using sed
			sed -i "s/\"warning\"[[:space:]]*:[[:space:]]*[0-9]\+/\"warning\": $warning/" "$config_file"
			sed -i "s/\"failure\"[[:space:]]*:[[:space:]]*[0-9]\+/\"failure\": $failure/" "$config_file"

			# Success message
			echo "Attendance thresholds updated in config.json"
			break
			;;
		no|n)
			echo "Using default thresholds"
			break
			;;
		*)
			# Handles all invalid inputs by prompting the user to input the right values
			echo "Invalid input, please enter yes or no."
			;;
	esac
done


# Checks if Python3 is installed without outputing the long format on the user's screen
if python3 --version > /dev/null 2>&1; then
	python_version=$(python3 --version 2>&1)
	echo "Python found: $python_version"
else
	echo "Warning: python is not installed"
fi

# Checking directory structure
if [ -d $directory/Helpers ] && [ -d $directory/reports ]; then
	echo "Directory structure validated"
fi

# Ensuring that all files and folders were created successfully
if [ -d $directory/Helpers ] && [ -f $directory/attendance_checker.py ]; then
	echo "Project setup completed successfully!"
else
	echo "Project setup not completed"
fi

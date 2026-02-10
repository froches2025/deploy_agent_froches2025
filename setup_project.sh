#!/bin/bash
# Script that automates the creation of a workspace, configures settings via the command line, and handles system signals gracefully

read -p "Name your directory: attendance_tracker_" input

directory=attendance_tracker_$input
archive_folder=attendance_tracker_${input}_archive
echo "$archive_folder"
mkdir -p $directory

cleanup() {
	echo
	echo "Script interrupted. Cleaning up..."

	if [ -d "$directory" ]; then
		tar -czf "${directory}_archive.tar.gz" "$directory"
		rm -rf "$directory"
		echo "Project archived as ${directory}_archive.tar.gz"
	fi

	echo "Incomplete setup removed. Exiting."
	exit 1
}

trap cleanup SIGINT

mkdir -p $directory/Helpers
mkdir -p $directory/reports

cp attendance_checker.py $directory
cp assets.csv $directory/Helpers/
cp config.json $directory/Helpers/
cp reports.log $directory/reports/

read -p "Do you want to update attendance thresholds? (yes or no)" answer

if [ $answer = "yes" ]; then
	read -p "Enter warning threshold (default 75): " warning
	read -p "Enter failure threshold (default 50): " failure

	warning=${warning:-75}
	failure=${failure:-50}

	config_file=$directory/Helpers/config.json

	sed -i "s/\"warning\"[[:space:]]*:[[:space:]]*[0-9]\+/\"warning\": $warning/" "$config_file"
	sed -i "s/\"failure\"[[:space:]]*:[[:space:]]*[0-9]\+/\"failure\": $failure/" "$config_file"

	echo "Attendance thresholds updated in config.json"
else
	echo "Using default thresholds"
fi


if python3 --version > /dev/null 2>&1; then
	python_version=$(python3 --version 2>&1)
	echo "Python found: $python_version"
else
	echo "Warning: python is not installed"
fi

if [ -d $directory/Helpers ] && [ -d $directory/reports ]; then
	echo "Directory structure validated"
fi

echo "Project setup completed successfully!"

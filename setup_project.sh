#!/bin/bash
# Script that automates the creation of a workspace, configures settings via the command line, and handles system signals gracefully

read -p "Name your directory: attendance_tracker_" input

directory=attendance_tracker_$input
archive_folder=attendance_tracker_${input}_archive
mkdir -p $directory

cleanup() {
	echo
	echo "Script interrupted. Cleaning up..."

	if [ -d "$directory" ]; then
		tar -czf "${archive_folder}.tar.gz" "$directory"
		rm -rf "$directory"
		echo "Project archived as ${archive_folder}.tar.gz"
	fi

	echo "Incomplete setup removed. Exiting."
	exit 1
}

trap cleanup SIGINT

mkdir -p $directory/Helpers
mkdir -p $directory/reports

required_files=("attendance_checker.py" "assets.csv" "config.json" "reports.log")

for file in "${required_files[@]}"; do
	if [ -f "$file" ]; then
		if [ -d "$directory" ]; then
			cp attendance_checker.py $directory
			cp assets.csv $directory/Helpers/
			cp config.json $directory/Helpers/
			cp reports.log $directory/reports/
		fi
	else
		echo "Error: Required file $file not found"
	fi
done

read -p "Do you want to update attendance thresholds? (yes or no)" answer

case "${answer,,}" in
	yes|y)

		read -p "Enter warning threshold (default 75): " warning
		read -p "Enter failure threshold (default 50): " failure

		warning=${warning:-75}
		failure=${failure:-50}

		config_file=$directory/Helpers/config.json

		sed -i "s/\"warning\"[[:space:]]*:[[:space:]]*[0-9]\+/\"warning\": $warning/" "$config_file"
		sed -i "s/\"failure\"[[:space:]]*:[[:space:]]*[0-9]\+/\"failure\": $failure/" "$config_file"

		echo "Attendance thresholds updated in config.json"
		;;
	*)
		echo "Using default thresholds"
		;;
esac


if python3 --version > /dev/null 2>&1; then
	python_version=$(python3 --version 2>&1)
	echo "Python found: $python_version"
else
	echo "Warning: python is not installed"
fi

if [ -d $directory/Helpers ] && [ -d $directory/reports ]; then
	echo "Directory structure validated"
fi

if [ -d $directory/Helpers ] && [ -f $directory/attendance_checker.py ]; then
	echo "Project setup completed successfully!"
else
	echo "Project setup not completed"
fi

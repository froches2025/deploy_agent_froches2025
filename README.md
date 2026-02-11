# Attendance Tracker – Automated Workspace Setup

## Project Overview
This project is an automated **Bash-based setup system** for an Attendance Tracker application.  
The script creates a structured workspace, validates required files, updates configuration values interactively, and handles interruptions gracefully using signal trapping.

The project demonstrates:
- Automated environment creation
- Interactive shell scripting
- Configuration editing with `sed`
- Signal handling using `SIGINT`
- Proper version control workflow with feature branches

---

## Directory Structure
After running the script, the following structure is created:

attendance_tracker_<name>/
├── attendance_checker.py
├── Helpers/
│ ├── assets.csv
│ └── config.json
├── reports/
│ └── reports.log


If the script is interrupted, the directory is archived and safely cleaned up.

---

## How to Run
From the project root:

```bash
chmod +x setup.sh
./setup.sh

You will be prompted to:

Name your project directory

Optionally update attendance warning and failure thresholds

Features Implemented
Environment Creation

Automatically creates all required directories

Copies required files into the correct locations

Validates directory structure after setup

Configuration Management

Uses sed to update values inside config.json

Supports default values when user input is skipped

Ensures updates happen only when requested

Signal Handling

Captures CTRL+C (SIGINT)

Archives the partially created project

Cleans up incomplete files before exiting

Dependency Checking

Detects whether Python 3 is installed

Suppresses standard output using redirection

Version Control Workflow

This project uses a structured Git workflow:

main
Contains only finalized, submission-ready files

setup_branch
Development of the automation and setup logic

documentation
README writing and code commenting

All development work was done in feature branches and merged into main.

Error Handling

Missing required files are detected and reported

Script exits gracefully on interruption

Clear messages guide the user at each step

Notes

This project was designed to be readable and beginner-friendly, with clear structure and logical flow.


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

```text
attendance_tracker_<name>/
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
├── reports/
│   └── reports.log
```

If the script is interrupted, the directory is archived and safely cleaned up.
**Please DO NOT DELETE any of the required files from the root of the project.**
**They are directly copied to the required locations during setup**

---

## How to Run
From the project root:

```bash
chmod u+x setup_project.sh
./setup_project.sh
```
### You will be prompted to:

- Name your project directory

- Optionally update attendance warning and failure thresholds
### Archive Trigger
If at any point during the execution of this script, you press `Ctrl+C`, the current state of the project will be archived and the project, deleted.
However, you can always unzip the file by running:
```
tar -xvzf filename.tar.gz
```

#### Watch walkthrough video here:
[Walkthrough Video](https://www.loom.com/share/81cfaaa276414e03af02b6f5726b22dc "Walkthrough video showing how to setup and use the project")

## Features Implemented
**Environment Creation**

* Automatically creates all required directories

* Copies required files into the correct locations

* Validates directory structure after setup

**Configuration Management**

* Uses sed to update values inside config.json

* Supports default values when user input is skipped

* Ensures updates happen only when requested

**Signal Handling**

* Captures CTRL+C (SIGINT)

* Archives the partially created project

* Cleans up incomplete files before exiting

**Dependency Checking**

* Detects whether Python 3 is installed

* Suppresses standard output using redirection

* Version Control Workflow

**Error Handling**

* Missing required files are detected and reported

* Script exits gracefully on interruption

* Clear messages guide the user at each step

### This project uses a structured Git workflow:

1. **main**: Contains only finalized, submission-ready files

2. **setup_branch**: Development of the automation and setup logic

3. **documentation**: README writing and code commenting

#### All development work was done in feature branches and merged into main.

## Notes

This project was designed to be readable and beginner-friendly, with a clear structure and logical flow.


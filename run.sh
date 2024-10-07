#!/bin/bash

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the Python program
python src/your_program.py

# Deactivate the virtual environment
deactivate

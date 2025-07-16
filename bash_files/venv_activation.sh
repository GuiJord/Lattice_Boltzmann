#!/bin/bash

ENV_NAME=".venv"

# Check if the script is being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "❌ Please source this script instead: 'source $0'"
    exit 1
fi

# Step 1: Create virtual environment if missing
if [ ! -d "$ENV_NAME" ]; then
    echo "📦 Creating virtual environment '$ENV_NAME'..."
    if ! python3 -m venv "$ENV_NAME"; then
        echo "❌ Failed to create virtual environment. Aborting."
        return 1
    fi
fi

# Step 2: Activate the virtual environment
if [ -f "$ENV_NAME/bin/activate" ]; then
    echo "⚡ Activating the virtual environment..."
    source "$ENV_NAME/bin/activate"
else
    echo "❌ Activation script not found at $ENV_NAME/bin/activate. Aborting."
    return 1
fi

# Step 3: Install numpy if missing
if ! python -c "import numpy" &>/dev/null; then
    echo "⬇️ Installing numpy..."
    pip install numpy &>/dev/null
fi

# Step 4: Install requirements.txt if present
if [ -f "requirements.txt" ]; then
    echo "⬇️ Installing packages from requirements.txt..."
    pip install -r requirements.txt &>/dev/null
else
    echo "⚠️ No requirements.txt found. Skipping."
fi

# Step 5: Final message
echo "✅ Environment ready and activated!"
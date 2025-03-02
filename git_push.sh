#!/bin/bash

# Set repository URL (Replace with your actual GitHub repo URL)
REPO_URL="https://github.com/AtomicPositron/MyNvimSetup.git"
BRANCH="main"

# Initialize Git if not already initialized
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    git branch -M $BRANCH
    git remote add origin $REPO_URL
fi

# Add all files
echo "Adding files..."
git add .

# Commit changes
echo "Committing changes..."
read -p "Enter commit message: " COMMIT_MSG
git commit -m "$COMMIT_MSG"

# Push to GitHub
echo "Pushing to GitHub..."
git push -u origin $BRANCH

echo "✅ Push complete!"



#!/bin/bash

# Metabase Helm Chart Version Update Script
# This script checks for the latest Metabase version and updates the chart accordingly

set -e

CHART_DIR="metabase"
CHART_YAML="$CHART_DIR/Chart.yaml"
VALUES_YAML="$CHART_DIR/values.yaml"
README_MD="$CHART_DIR/README.md"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Metabase Helm Chart Version Updater${NC}"
echo "============================================="

# Check if required files exist
if [[ ! -f "$CHART_YAML" ]]; then
    echo -e "${RED}❌ Chart.yaml not found in $CHART_DIR${NC}"
    exit 1
fi

if [[ ! -f "$VALUES_YAML" ]]; then
    echo -e "${RED}❌ values.yaml not found in $CHART_DIR${NC}"
    exit 1
fi

# Get current version from Chart.yaml
CURRENT_VERSION=$(grep 'appVersion:' "$CHART_YAML" | sed 's/.*"\(.*\)".*/\1/')
echo -e "${YELLOW}📋 Current Metabase version: $CURRENT_VERSION${NC}"

# Get latest version from GitHub API
echo -e "${BLUE}🔍 Checking for latest Metabase version...${NC}"
LATEST_VERSION=$(curl -s "https://api.github.com/repos/metabase/metabase/releases/latest" | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)

if [[ -z "$LATEST_VERSION" ]]; then
    echo -e "${RED}❌ Failed to fetch latest version from GitHub${NC}"
    exit 1
fi

echo -e "${GREEN}📦 Latest Metabase version: $LATEST_VERSION${NC}"

# Compare versions
if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    echo -e "${GREEN}✅ Already up to date!${NC}"
    exit 0
fi

echo -e "${YELLOW}🔄 Update available: $CURRENT_VERSION → $LATEST_VERSION${NC}"

# Ask for confirmation unless --auto flag is provided
if [[ "$1" != "--auto" ]]; then
    read -p "Do you want to update the chart? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}⏸️  Update cancelled${NC}"
        exit 0
    fi
fi

echo -e "${BLUE}🔨 Updating chart files...${NC}"

# Get current chart version and increment it
CURRENT_CHART_VERSION=$(grep '^version:' "$CHART_YAML" | sed 's/version: //')
NEW_CHART_VERSION=$(echo "$CURRENT_CHART_VERSION" | awk -F. '{$NF = $NF + 1;} 1' | sed 's/ /./g')

# Update Chart.yaml
echo -e "${BLUE}📝 Updating Chart.yaml...${NC}"
sed -i.bak "s/^version: .*/version: $NEW_CHART_VERSION/" "$CHART_YAML"
sed -i.bak "s/^appVersion: .*/appVersion: \"$LATEST_VERSION\"/" "$CHART_YAML"

# Update values.yaml
echo -e "${BLUE}📝 Updating values.yaml...${NC}"
sed -i.bak "s/tag: \".*\"/tag: \"$LATEST_VERSION\"/" "$VALUES_YAML"

# Update README.md
echo -e "${BLUE}📝 Updating README.md...${NC}"
sed -i.bak "s/\*\*Current Metabase Version:\*\* .*/\*\*Current Metabase Version:\*\* $LATEST_VERSION/" "$README_MD"

# Clean up backup files
rm -f "$CHART_YAML.bak" "$VALUES_YAML.bak" "$README_MD.bak"

echo -e "${GREEN}✅ Chart updated successfully!${NC}"
echo -e "${BLUE}📊 Summary:${NC}"
echo "  • Chart version: $CURRENT_CHART_VERSION → $NEW_CHART_VERSION"
echo "  • Metabase version: $CURRENT_VERSION → $LATEST_VERSION"
echo ""
echo -e "${YELLOW}🔍 Next steps:${NC}"
echo "  1. Review the changes:"
echo "     git diff"
echo "  2. Test the chart:"
echo "     helm template ./metabase"
echo "  3. Install/upgrade:"
echo "     helm upgrade --install metabase ./metabase"
echo "  4. Commit changes:"
echo "     git add . && git commit -m 'Update Metabase to $LATEST_VERSION'"

# Create a changelog entry
CHANGELOG_FILE="CHANGELOG.md"
if [[ ! -f "$CHANGELOG_FILE" ]]; then
    echo "# Changelog" > "$CHANGELOG_FILE"
    echo "" >> "$CHANGELOG_FILE"
fi

DATE=$(date +"%Y-%m-%d")
{
    echo "## [$NEW_CHART_VERSION] - $DATE"
    echo ""
    echo "### Changed"
    echo "- Updated Metabase to version $LATEST_VERSION"
    echo ""
} | cat - "$CHANGELOG_FILE" > temp && mv temp "$CHANGELOG_FILE"

echo -e "${GREEN}📋 Changelog updated${NC}" 
#!/bin/bash
# claude-init.sh - Project bootstrap with beautiful terminal UI
# Creates: folder structure, git, README, .gitignore, placeholder .agent.md

set -e

# Colors & Styles
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
UNDERLINE='\033[4m'
 
# Colors
BLACK='\033[30m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'
 
# Bright Colors
BRIGHT_BLUE='\033[94m'
BRIGHT_CYAN='\033[96m'
BRIGHT_GREEN='\033[92m'
BRIGHT_MAGENTA='\033[95m'
 
# Reset
NC='\033[0m'

# Helper function
clear_screen() {
    clear
}

# Animated header
show_header() {
  echo -e "${BRIGHT_CYAN}"
  echo "╔════════════════════════════════════════════════════════╗"
  echo "║                                                        ║"
  echo "║         ${BOLD}🚀 Claude Project Bootstrap${NC}${BRIGHT_CYAN}               ║"
  echo "║                                                        ║"
  echo "║    ${DIM}Create a new project with AI-powered guidance${NC}${BRIGHT_CYAN}  ║"
  echo "║                                                        ║"
  echo "╚════════════════════════════════════════════════════════╝"
  echo -e "${NC}"
  echo ""
}

# Section divider
section_divider() {
  echo -e "${BRIGHT_CYAN}─────────────────────────────────────────────────────────${NC}"
  echo ""
}

# Success message
success() {
  echo -e "${BRIGHT_GREEN}✓${NC} ${BOLD}$1${NC}"
}
 
# Info message
info() {
  echo -e "${BRIGHT_BLUE}ℹ${NC} ${DIM}$1${NC}"
}

# Loading animation
loading() {
  local text="$1"
  echo -ne "${BRIGHT_CYAN}⟳${NC} ${text}..."
  sleep 0.3
  echo -ne "\r${BRIGHT_GREEN}✓${NC} ${text}... ${BRIGHT_GREEN}done${NC}\n"
}

# Input prompt with style
prompt_input() {
  local prompt_text="$1"
  echo -e "${BOLD}${prompt_text}${NC}"
  echo -ne "${BRIGHT_CYAN}▶${NC} "
  read input
  echo "$input"
}

# Get input
get_project_name() {
  echo -e "${BOLD}What's your project name?${NC}"
  echo -e "${DIM}(letters, numbers, hyphens, underscores)${NC}"
  echo ""
  local name=$(prompt_input "Project name")
  
  if [ -z "$name" ]; then
    echo -e "${RED}✗ Project name required${NC}"
    exit 1
  fi
  
  echo "$name"
}

# Animated progress
show_progress() {
  local step=$1
  local total=5
  local percent=$((step * 100 / total))
  
  echo -ne "\r${BRIGHT_CYAN}["
  for ((i=0; i<step; i++)); do
    echo -ne "●"
  done
  for ((i=step; i<total; i++)); do
    echo -ne "○"
  done
  echo -ne "]${NC} ${DIM}${percent}%${NC}"
}

create_gitignore() {
    # Create .gitignore
    cat > .gitignore <<- 'EOF'
	# OS
	.DS_Store
	Thumbs.db

	# IDEs
	.vscode/
	.idea/
	*.swp
	*.swo
	*.iml

	# Languages
	__pycache__/
	*.pyc
	*.pyo
	node_modules/
	.npm
	package-lock.json
	.env
	.env.local

	# Build outputs
	target/
	build/
	dist/
	out/

	# Logs
	*.log
	logs/

	# Dependencies
	.gradle/
	.maven/
	EOF
}

create_readme() {
    # Create README.md
    cat > README.md <<- EOF
	# ${PROJECT_NAME}

	This project was bootstrapped with the Claude Project Bootstrap script.

	## Description

	Add a brief description of your project here.

	## Setup

	Instructions to set up the project environment.

	## Usage

	How to use the project.

	## License

	Specify the license for your project.
	EOF
}

create_placeholder_agent() {
    # Create placeholder .agent.md
    cat > .agent.md <<- EOF
	# ${PROJECT_NAME} Agent

	This is a placeholder for the agent configuration.

	## Description

	Provide details about the agent's purpose and functionality.

	## Configuration

	Instructions on how to configure the agent.

	## Usage

	How to use the agent within the project.
	EOF
}

main() {
    clear_screen
    show_header

    # Get project name
    section_divider
    PROJECT_NAME=$(get_project_name)
    
    echo ""
    success "Project name: ${BOLD}${PROJECT_NAME}${NC}"
    echo ""

    # Create project folder
    section_divider
    echo -e "${BOLD}Setting up project structure...${NC}"
    echo ""

    show_progress 1
    sleep 0.5

    if [ ! -d "$PROJECT_NAME" ]; then
        mkdir "$PROJECT_NAME"
        success "Created project folder: ${BOLD}${PROJECT_NAME}${NC}"
    else
        echo -e "${YELLOW}⚠ Project folder already exists. Skipping creation.${NC}"
    fi

    cd "$PROJECT_NAME"
    show_progress 2
    sleep 0.3

    create_gitignore
    success "Created .gitignore"
    show_progress 3
    sleep 0.3
    create_readme
    success "Created README.md"
    show_progress 4
    sleep 0.3
    create_placeholder_agent
    success "Created placeholder .agent.md"
    show_progress 5
    sleep 0.3

    # Initial commit
    git add .gitignore README.md .agent.md .vscode/settings.json > /dev/null 2>&1
    git commit -m "chore: bootstrap Claude project" > /dev/null 2>&1 || true

    # Success screen
    echo -e "${BRIGHT_GREEN}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║                                                        ║"
    echo "║              ${BOLD}✨ Project Ready!${NC}${BRIGHT_GREEN}                   ║"
    echo "║                                                        ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    
    # Created files summary
    echo -e "${BOLD}Created Files:${NC}"
    echo -e "${BRIGHT_GREEN}✓${NC} ${DIM}.gitignore${NC}              ${BRIGHT_CYAN}(Git configuration)${NC}"
    echo -e "${BRIGHT_GREEN}✓${NC} ${DIM}README.md${NC}               ${BRIGHT_CYAN}(Project documentation)${NC}"
    echo -e "${BRIGHT_GREEN}✓${NC} ${DIM}.agent.md${NC}               ${BRIGHT_CYAN}(Claude instructions)${NC}"
    echo -e "${BRIGHT_GREEN}✓${NC} ${DIM}.vscode/settings.json${NC}   ${BRIGHT_CYAN}(VS Code configuration)${NC}"
    echo -e "${BRIGHT_GREEN}✓${NC} ${DIM}.git/${NC}                   ${BRIGHT_CYAN}(Git repository)${NC}"
    echo ""
    
    # Next steps
    section_divider
    echo -e "${BOLD}Next Steps:${NC}"
    echo ""
    echo -e "  ${BRIGHT_CYAN}1.${NC} Open your project"
    echo -e "     ${DIM}$ cd ${BOLD}$PROJECT_NAME${NC}${DIM}${NC}"
    echo ""
    echo -e "  ${BRIGHT_CYAN}2.${NC} Launch VS Code"
    echo -e "     ${DIM}$ code .${NC}"
    echo ""
    echo -e "  ${BRIGHT_CYAN}3.${NC} Generate agent in Claude Code"
    echo -e "     ${DIM}Type: ${BOLD}/claude-generate-agent${NC}${DIM}${NC}"
    echo ""
    echo -e "  ${BRIGHT_CYAN}4.${NC} Describe your project"
    echo -e "     ${DIM}\"I'm building a Quarkus microservice...\"${NC}"
    echo ""
    echo -e "  ${BRIGHT_CYAN}5.${NC} Start coding!"
    echo -e "     ${DIM}Claude will guide you${NC}"
    echo ""
    
    # Final message
    echo -e "${BRIGHT_MAGENTA}─────────────────────────────────────────────────────────${NC}"
    echo -e "${DIM}💡 Tip: Edit .agent.md anytime to customize Claude's behavior${NC}"
    echo ""
}

# Run main
main
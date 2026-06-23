#!/bin/bash

if [ "$1" == "--help" ]; then
    echo "Usage: ./project_setup.sh <project_name> <language> [directories]"
    echo ""
    echo "Arguments:"
    echo "  1: Project Name (Required)"
    echo "  2: Language [python, js, go] (Required)"
    echo "  3: Custom directories separated by comma (Optional)"
    exit 0
fi

if [ $# -eq 0 ]; then
    read -p "Enter project name: " PROJECT_NAME
    read -p "Enter language (python/js/go): " LANGUAGE
    read -p "Enter directories (comma separated, e.g. src,tests or leave empty): " DIRECTORY
else
    # Jeśli podał argumenty normalnie, przypisujemy je po staremu
    PROJECT_NAME=$1
    LANGUAGE=$2
    DIRECTORY=$3
fi

if [ -z "$PROJECT_NAME" ] || [ -z "$LANGUAGE" ]; then
    echo "Error: Missing required arguments."
    echo "Usage: ./project_setup.sh <project_name> <language> [directories]"
    exit 1

    fi

log_action() {
    local MESSAGE=$1
    # Logujemy do pliku tylko wtedy, gdy katalog projektu już istnieje
    if [ -d "$PROJECT_NAME" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $MESSAGE" >> "$PROJECT_NAME/setup.log"
    fi
    echo "$MESSAGE"
}

SUPPORTED_LANGUAGES=("python" "js" "go")
VALID_LANGUAGE=false

for LANG in "${SUPPORTED_LANGUAGES[@]}"; do
    if [ "$LANGUAGE" == "$LANG" ]; then
        VALID_LANGUAGE=true
        break
    fi
done

if [ "$VALID_LANGUAGE" == false ]; then
    echo "Error: Language '$LANGUAGE' is unsupported."
    echo "Please choose one of: ${SUPPORTED_LANGUAGES[*]}"
    exit 1
fi

if [ -d "$PROJECT_NAME" ]; then
    echo "Error: Directory '$PROJECT_NAME' already exists!"
    exit 1
fi

if [ -z "$DIRECTORY" ]; then
    DIRECTORY="src,tests,docs"
fi

mkdir -p "$PROJECT_NAME"
log_action "INFO: Created main project directory: $PROJECT_NAME"

IFS=',' read -r -a DIRECTORIES_ARRAY <<< "$DIRECTORY"

for DIRS in "${DIRECTORIES_ARRAY[@]}"; do
    mkdir -p "$PROJECT_NAME/$DIRS"
    log_action "INFO: Created directory: $PROJECT_NAME/$DIRS"
done

case "$LANGUAGE" in
    "python")
        log_action "INFO: Configuring Python project structure."
        echo "__pycache__/" > "$PROJECT_NAME/.gitignore"
        touch "$PROJECT_NAME/main.py"
        log_action "INFO: Python files created successfully."
        ;;
    "js")
        log_action "INFO: Configuring JavaScript project structure."
        echo "node_modules/" > "$PROJECT_NAME/.gitignore"
        touch "$PROJECT_NAME/index.js"
        log_action "INFO: JavaScript files created successfully."
        ;;
    "go")
        log_action "INFO: Configuring Go project structure."
        echo ".exe" > "$PROJECT_NAME/.gitignore"
        echo ".bin" >> "$PROJECT_NAME/.gitignore"
        touch "$PROJECT_NAME/main.go"
        log_action "INFO: Go files created successfully."
        ;;
esac

log_action "SUCCESS: Project $PROJECT_NAME setup finished."

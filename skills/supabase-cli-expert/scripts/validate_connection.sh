#!/bin/bash
# Supabase Connection Validator
# Validates Supabase CLI setup and diagnoses common connection issues
#
# Usage: ./validate_connection.sh [--project-ref REF] [--connection-string URL]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
PROJECT_REF=""
CONNECTION_STRING=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --project-ref)
            PROJECT_REF="$2"
            shift 2
            ;;
        --connection-string)
            CONNECTION_STRING="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Supabase Connection Validator${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

ERRORS=0
WARNINGS=0

# Function to print status
print_status() {
    local status=$1
    local message=$2
    case $status in
        "pass")
            echo -e "${GREEN}[PASS]${NC} $message"
            ;;
        "fail")
            echo -e "${RED}[FAIL]${NC} $message"
            ((ERRORS++))
            ;;
        "warn")
            echo -e "${YELLOW}[WARN]${NC} $message"
            ((WARNINGS++))
            ;;
        "info")
            echo -e "${BLUE}[INFO]${NC} $message"
            ;;
    esac
}

# Check 1: Supabase CLI installed
echo -e "\n${BLUE}1. Checking Supabase CLI installation...${NC}"
if command -v supabase &> /dev/null; then
    VERSION=$(supabase --version 2>/dev/null || echo "unknown")
    print_status "pass" "Supabase CLI installed: $VERSION"
else
    print_status "fail" "Supabase CLI not found"
    echo "   Install with: brew install supabase/tap/supabase"
    echo "   Or: npm install -g supabase"
fi

# Check 2: CLI authentication
echo -e "\n${BLUE}2. Checking CLI authentication...${NC}"
if supabase projects list &> /dev/null; then
    print_status "pass" "CLI is authenticated"
else
    print_status "fail" "CLI not authenticated"
    echo "   Run: supabase login"
fi

# Check 3: Project linking (if project ref provided)
echo -e "\n${BLUE}3. Checking project linking...${NC}"
if [ -f "supabase/.temp/project-ref" ]; then
    LINKED_REF=$(cat supabase/.temp/project-ref 2>/dev/null || echo "")
    if [ -n "$LINKED_REF" ]; then
        print_status "pass" "Project linked: $LINKED_REF"
    else
        print_status "warn" "Project link file exists but is empty"
    fi
elif [ -n "$PROJECT_REF" ]; then
    print_status "info" "No linked project found. Link with:"
    echo "   supabase link --project-ref $PROJECT_REF"
else
    print_status "warn" "No project linked"
    echo "   Run: supabase link --project-ref YOUR_PROJECT_REF"
fi

# Check 4: Docker (for local development)
echo -e "\n${BLUE}4. Checking Docker status...${NC}"
if command -v docker &> /dev/null; then
    if docker info &> /dev/null; then
        print_status "pass" "Docker is running"
    else
        print_status "warn" "Docker installed but not running"
        echo "   Start Docker Desktop to use local development"
    fi
else
    print_status "warn" "Docker not installed"
    echo "   Required for local development (supabase start)"
fi

# Check 5: Local Supabase status
echo -e "\n${BLUE}5. Checking local Supabase status...${NC}"
if [ -f "supabase/config.toml" ]; then
    print_status "pass" "Supabase project initialized (config.toml found)"

    # Check if local is running
    if supabase status &> /dev/null 2>&1; then
        STATUS=$(supabase status 2>/dev/null | head -5)
        if echo "$STATUS" | grep -q "API URL"; then
            print_status "pass" "Local Supabase is running"
        else
            print_status "info" "Local Supabase not running"
            echo "   Start with: supabase start"
        fi
    fi
else
    print_status "info" "Not a Supabase project (no config.toml)"
    echo "   Initialize with: supabase init"
fi

# Check 6: IPv6 connectivity (important for direct connections)
echo -e "\n${BLUE}6. Checking network connectivity...${NC}"
if ping6 -c 1 google.com &> /dev/null 2>&1; then
    print_status "pass" "IPv6 connectivity available"
else
    print_status "warn" "IPv6 not available"
    echo "   Use session pooler (port 5432) or transaction pooler (port 6543)"
    echo "   Or enable IPv4 add-on in Dashboard"
fi

# Check 7: Connection string validation (if provided)
if [ -n "$CONNECTION_STRING" ]; then
    echo -e "\n${BLUE}7. Validating connection string...${NC}"

    # Parse connection string
    if [[ "$CONNECTION_STRING" =~ ^postgres(ql)?:// ]]; then
        print_status "pass" "Valid PostgreSQL URL format"

        # Check for common issues
        if [[ "$CONNECTION_STRING" =~ pooler\.supabase\.com ]]; then
            if [[ "$CONNECTION_STRING" =~ :6543 ]]; then
                print_status "info" "Using transaction pooler (port 6543)"
                echo "   Note: Prepared statements not supported"
            elif [[ "$CONNECTION_STRING" =~ :5432 ]]; then
                print_status "info" "Using session pooler (port 5432)"
            fi
        elif [[ "$CONNECTION_STRING" =~ db\..*\.supabase\.co ]]; then
            print_status "info" "Using direct connection"
            echo "   Requires IPv6 (or IPv4 add-on)"
        fi

        # Test connection if psql available
        if command -v psql &> /dev/null; then
            echo -e "\n${BLUE}Testing database connection...${NC}"
            if psql "$CONNECTION_STRING" -c "SELECT 1" &> /dev/null; then
                print_status "pass" "Database connection successful"
            else
                print_status "fail" "Database connection failed"
                echo "   Check password and network connectivity"
            fi
        else
            print_status "info" "psql not installed - skipping connection test"
        fi
    else
        print_status "fail" "Invalid connection string format"
        echo "   Expected: postgresql://user:pass@host:port/database"
    fi
fi

# Check 8: Migration files
echo -e "\n${BLUE}8. Checking migrations...${NC}"
if [ -d "supabase/migrations" ]; then
    MIGRATION_COUNT=$(find supabase/migrations -name "*.sql" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$MIGRATION_COUNT" -gt 0 ]; then
        print_status "pass" "Found $MIGRATION_COUNT migration file(s)"
    else
        print_status "info" "No migration files found"
    fi
else
    print_status "info" "No migrations directory"
fi

# Summary
echo -e "\n${BLUE}========================================${NC}"
echo -e "${BLUE}  Summary${NC}"
echo -e "${BLUE}========================================${NC}"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}All checks passed!${NC}"
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}$WARNINGS warning(s), no errors${NC}"
else
    echo -e "${RED}$ERRORS error(s), $WARNINGS warning(s)${NC}"
fi

echo ""
echo "Common next steps:"
echo "  - supabase login          # Authenticate CLI"
echo "  - supabase link           # Link to remote project"
echo "  - supabase start          # Start local development"
echo "  - supabase db push        # Push migrations to remote"

exit $ERRORS

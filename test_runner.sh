#!/bin/sh
# Stanford Pascal Test Runner for FreeBSD/POSIX

PASCAL_ROOT="$(pwd)"
PCOMP="$PASCAL_ROOT/script_ix/pp"
PRUN="$PASCAL_ROOT/script_ix/prun"

# Target directories
TEST_DIRS="srctest testpgm"

echo "=== Stanford Pascal Test Runner ==="
echo "Working Directory: $PASCAL_ROOT"
echo ""

PASSED=0
FAILED=0

for dir in $TEST_DIRS; do
    echo "--- Testing directory: $dir ---"
    if [ ! -d "$dir" ]; then
        echo "Skip: $dir not found"
        continue
    fi
    
    for pas in "$dir"/*.pas; do
        [ -e "$pas" ] || continue
        name=$(basename "$pas" .pas)
        
        echo -n "Test $name: "
        
        # Compile
        $PCOMP "$pas" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "COMPILE FAILED"
            FAILED=$((FAILED + 1))
            continue
        fi
        
        # Run
        $PRUN "$dir/$name.pcode" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "RUN FAILED"
            FAILED=$((FAILED + 1))
        else
            echo "OK"
            PASSED=$((PASSED + 1))
        fi
        
        # Cleanup temporary test files
        rm -f "$dir/$name.pcode" "$dir/$name.lis" "$dir/$name.listing" "$dir/$name.runlisting"
    done
done

echo ""
echo "=== Summary ==="
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [ $FAILED -eq 0 ]; then
    exit 0
else
    exit 1
fi

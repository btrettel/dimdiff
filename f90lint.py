#!/usr/bin/env -S python3 -Werror
# -*- coding: utf-8 -*-

# Bash: `./f90lint.py app/*.f90 src/*.f90 test/*.f90`

import os
import argparse

ASSERTION_DENSITY_LOWER_LIMIT = 2.0
TEST_RATIO_LOWER_LIMIT        = 1.0

# These files won't have any assertions, so they should be ignored.
ignore_files = [os.path.join("src", "debug.f90"), os.path.join("src", "release.f90"), os.path.join("src", "units.f90")]

class file_stats_class:
    def __init__(self, filename, assertion_density, lines):
        self.filename          = filename
        self.assertion_density = assertion_density
        self.lines             = lines
        self.test_ratio        = 0.0

def is_empty_or_comment(line):
    line_clean = line.split("!")[0].strip()
    
    return not len(line_clean) > 0

parser = argparse.ArgumentParser(description="A linter for Fortran 90 and later intended for Ben Trettel's use.")
parser.add_argument('file', nargs='+')
args = parser.parse_args()

exit_code = 0

global_num_lines_code  = 0
global_num_lines_tests = 0
global_num_assertions  = 0
file_stats = []
for filename in args.file:
    if filename in ignore_files:
        continue
    
    with open(filename, "r") as file_handler:
        contains_executable_code = False
        for line in file_handler.readlines():
            if line.strip().startswith("program ") or line.strip().startswith("contains"):
                contains_executable_code = True
                break
        
        # Ignore files that don't contain executable code.
        if contains_executable_code:
            file_handler.seek(0)
            local_num_lines_code_or_tests = 0
            local_num_lines_tests         = 0
            local_num_assertions          = 0
            for line in file_handler.readlines():
                # If the line isn't empty or only comments.
                if not is_empty_or_comment(line):
                    local_num_lines_code_or_tests = local_num_lines_code_or_tests + 1
                    
                    # Tests don't have assertions, so they shouldn't count towards the assertion count.
                    if not filename.startswith("test"):
                        global_num_lines_code = global_num_lines_code + 1
                        
                        if line.strip().startswith("call assert"):
                            global_num_assertions = global_num_assertions + 1
                            local_num_assertions  = local_num_assertions + 1
                    else:
                        global_num_lines_tests = global_num_lines_tests + 1
            
            file_stats.append(file_stats_class(filename, 100.0 * local_num_assertions / local_num_lines_code_or_tests, local_num_lines_code_or_tests))

# Calculate `test_ratio`s.
for file_stat in file_stats:
    if not file_stat.filename.startswith("test"):
        for sub_file_stat in file_stats:
            if sub_file_stat.filename.startswith("test"):
                if os.path.basename(sub_file_stat.filename) == "test_" + os.path.basename(file_stat.filename):
                    file_stat.test_ratio = sub_file_stat.lines / file_stat.lines
                    #print(file_stat.filename, sub_file_stat.filename, file_stat.test_ratio)
                    break

for file_stat in file_stats:
    if (file_stat.assertion_density < ASSERTION_DENSITY_LOWER_LIMIT) and (not file_stat.filename.startswith("test")):
        print("WARNING: Assertion density for {} is {:.2f}%, which is below the lower limit of {:.2f}%.".format(file_stat.filename, file_stat.assertion_density, ASSERTION_DENSITY_LOWER_LIMIT))
        exit_code = 1
    
    if (file_stat.test_ratio < TEST_RATIO_LOWER_LIMIT) and file_stat.filename.startswith("src"):
        print("WARNING: Lines-of-tests to lines-of-code ratio for module {} is {:.2f}, which is below the lower limit of {:.2f}.".format(file_stat.filename, file_stat.test_ratio, TEST_RATIO_LOWER_LIMIT))
        exit_code = 1

global_assertion_density = 100.0 * global_num_assertions / global_num_lines_code
if (global_assertion_density < ASSERTION_DENSITY_LOWER_LIMIT):
    print("WARNING: Global assertion density is {:.2f}%, which is below the lower limit of {:.2f}%.".format(global_assertion_density, ASSERTION_DENSITY_LOWER_LIMIT))
    exit_code = 1

global_test_ratio = global_num_lines_tests / global_num_lines_code
if (global_test_ratio < TEST_RATIO_LOWER_LIMIT):
    print("WARNING: Global lines-of-tests to lines-of-code ratio is {:.2f}, which is below the lower limit of {:.2f}.".format(global_test_ratio, TEST_RATIO_LOWER_LIMIT))
    exit_code = 1

exit(exit_code)

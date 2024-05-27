#!/usr/bin/env -S python3 -Werror
# -*- coding: utf-8 -*-

import os
import argparse
import configparser

class dependency_structure:
    def __init__(self, filename, program, module, name, dependencies):
        self.filename     = filename
        self.program      = program
        self.module       = module
        self.name         = name
        self.dependencies = dependencies

def get_program_name_from_program(line):
    start_index = line.find("program") + 8
    end_index   = line.find(",")
    
    return line[start_index:end_index]

def get_module_name_from_module(line):
    start_index = line.find("module") + 7
    end_index   = line.find(",")
    
    return line[start_index:end_index]

def get_module_name_from_use(line):
    start_index = line.find("use") + 4
    end_index   = line.find(",")
    
    return line[start_index:end_index]

def canonicalize_path(path):
    path_split = path.split("/")
    return os.path.join(*path_split)

parser = argparse.ArgumentParser(description="Generates a Makefile fragment describing the dependencies of a Fortran project.")
parser.add_argument("file", help="input file to read")
args = parser.parse_args()

config = configparser.ConfigParser()
config.read(args.file)

directories        = config['depends']['directories'].split(' ')
no_existence_check = config['depends']['no_existence_check'].split(' ')

skip_indexing_raw = config['depends']['skip_indexing'].split(' ')
# Canonicalize `skip_indexing`
skip_indexing = []
for skip_indexing_i in skip_indexing_raw:
    skip_indexing.append(canonicalize_path(skip_indexing_i))

depends_file = canonicalize_path(config['depends']['depends_file'])
testnml_file = canonicalize_path(config['depends']['testnml_file'])

fail = False

filepaths = []
for directory in sorted(directories):
    # Canonicalize the filepath, so that (for example), this works if `.\` is in front of the path, like PowerShell does.
    directory = os.path.relpath(directory)
    
    if not os.path.isdir(directory):
        print("{} is not a directory.")
        fail = True
    else:
        for filename in sorted(os.listdir(directory)):
            if filename.endswith(".f90"):
                filepaths.append(os.path.join(directory, filename))

if fail:
    print("Error(s) encountered, stopping.")
    exit(1)

depstructs = [dependency_structure(os.path.join("src", "$(BUILD)"), False, True, "build", set())]
all_dependencies = set()
for filepath in sorted(filepaths):
    if filepath in skip_indexing:
        continue
    
    with open(filepath, "r") as file_handler:
        program      = False
        module       = False
        name         = None
        dependencies = set()
        
        for line in file_handler.readlines():
            if line.strip().startswith("program "):
                program = True
                
                name = get_program_name_from_program(line)
            
            if line.strip().startswith("module "):
                if not line.strip().startswith("module procedure "):
                    module = True
                    
                    name = get_module_name_from_module(line)
            
            if line.strip().startswith("use "):
                if get_module_name_from_use(line) == name:
                    print("{} can't depend on itself.".format(filepath))
                    fail = True
                
                dependencies.add(get_module_name_from_use(line))
                all_dependencies.add(get_module_name_from_use(line))
        
        print("{} program={} module={} name={} dependencies={}".format(filepath, program, module, name, dependencies))
        
        if (program and module):
            print("{} contains both a program and a module. depends.py assumes that a file contains one or the other, not both.".format(filepath))
            fail = True
        
        if os.path.basename(filepath) != name + ".f90":
            print("{} contains module or program {}, when I require that the two have the same name.".format(filepath, name))
            fail = True
        
        if module:
            if os.path.split(filepath)[0] != "src":
                print("{} contains a module which is not in the src directory. All modules must be in the src directory.".format(filepath))
                fail = True
        
        depstructs.append(dependency_structure(filepath, program, module, name, dependencies))

for dependency in sorted(all_dependencies):
    if dependency in no_existence_check:
        continue
    
    if not os.path.exists(os.path.join("src", dependency+".f90")):
        print("Module dependency {} does not exist.".format(dependency))
        fail = True

if fail:
    print("Error(s) encountered, stopping.")
    exit(1)

for depstruct in depstructs:
    # For programs, I need the entire recursive dependency structure.
    if depstruct.program:
        num_dependencies_prev = 0
        num_dependencies      = len(depstruct.dependencies)
        
        #print("Before:", depstruct.name, depstruct.dependencies)
        
        while (num_dependencies > num_dependencies_prev):
            for sub_depstruct in depstructs:
                if sub_depstruct.name in depstruct.dependencies:
                    #print("here", sub_depstruct.name, sub_depstruct.dependencies)
                    depstruct.dependencies = depstruct.dependencies.union(sub_depstruct.dependencies)
            
            num_dependencies_prev = num_dependencies
            num_dependencies      = len(depstruct.dependencies)
        
        print("Complete {} program dependencies: {}".format(depstruct.name, depstruct.dependencies))

with open(depends_file, "w") as output_handler:
    output_handler.write("# Automatically generated by depends.py.\n\n")
    
    # Write module dependencies.
    
    output_handler.write("#######################\n")
    output_handler.write("# Module dependencies #\n")
    output_handler.write("#######################\n\n")
    for depstruct in depstructs:
        if depstruct.module:
            if depstruct.name == "build":
                continue
            
            directory = os.path.split(depstruct.filename)[0]
            
            print("Writing module dependencies: {}".format(depstruct.name))
            
            output_handler.write("{}$(DIR_SEP){}.$(OBJEXT):".format(directory, depstruct.name))
            
            for dependency in sorted(depstruct.dependencies):
                if dependency != "build":
                    output_handler.write(" src$(DIR_SEP){}.$(OBJEXT)".format(dependency))
                else:
                    output_handler.write(" src$(DIR_SEP)$(BUILD).$(OBJEXT)")
            
            output_handler.write(" {}$(DIR_SEP){}.f90\n\n".format(directory, depstruct.name))
    
    # Write program dependencies.
    
    test_nmls = []
    output_handler.write("########################\n")
    output_handler.write("# Program dependencies #\n")
    output_handler.write("########################\n\n")
    for depstruct in depstructs:
        if depstruct.program:
            directory = os.path.split(depstruct.filename)[0]
            
            print("Writing program dependencies: {}".format(depstruct.name))
            
            output_handler.write("{}$(BINEXT):".format(depstruct.name))
            
            dependency_string = ""
            for dependency in sorted(depstruct.dependencies):
                if dependency != "build":
                    dependency_string = dependency_string + " src$(DIR_SEP){}.$(OBJEXT)".format(dependency)
                else:
                    dependency_string = dependency_string + " src$(DIR_SEP)$(BUILD).$(OBJEXT)"
            
            output_handler.write(dependency_string)
            output_handler.write(" {}$(DIR_SEP){}.f90\n".format(directory, depstruct.name))
            output_handler.write("\t$(FC) $(OFLAG) $@ $(FFLAGS) {} {}$(DIR_SEP){}.f90\n\n".format(dependency_string.strip(), directory, depstruct.name))
            
            # For programs starting with `test_`, write code to run test too.
            if depstruct.name.startswith("test_") and (depstruct.name[5:] in depstruct.dependencies):
                output_handler.write("{}.nml: {}$(BINEXT)\n".format(depstruct.name[5:], depstruct.name))
                output_handler.write("\t$(RUN){}$(BINEXT)\n\n".format(depstruct.name))
                test_nmls.append(depstruct.name[5:]+".nml")

with open(testnml_file, "w") as output_handler:
    output_handler.write("# Automatically generated by depends.py.\n\n")
    
    # Generate `TESTNML`
    print("Writing TESTNML...")
    output_handler.write("##################\n")
    output_handler.write("# Test namelists #\n")
    output_handler.write("##################\n\nTESTNML =")
    for test_nml in sorted(test_nmls):
        output_handler.write(" {}".format(test_nml))
    
    output_handler.write("\n.PRECIOUS: $(TESTNML)")

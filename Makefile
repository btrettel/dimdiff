# # Makefile
# 
# Summary: Makefile for all components of flt, including tests
# Standard: POSIX (tested on GNU Make and bmake)
# Preprocessor: none
# Author: Ben Trettel (<http://trettel.us/>)
# Project: [flt](https://github.com/btrettel/flt)
# License: [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html)

# TODO: Figure out how to automate parts like `test/test_ga.f90` in `test_ga$(BINEXT):`
# TODO: Check other Makefiles to see which flags you use there.

.POSIX:

# non-POSIX
# <https://innolitics.com/articles/make-delete-on-error/>
.DELETE_ON_ERROR:
MAKEFLAGS = --warn-undefined-variables

# Add later: dimmod.nml ga.nml
NML = autodiff.nml checks.nml genunits_io.nml nmllog.nml genunits_data.nml prec.nml purerng.nml timer.nml unittest.nml
.PRECIOUS: $(NML)

#############
# Compilers #
#############

# gfortran

FC        = gfortran
FFLAGS    = -Wall -Wextra -Werror -pedantic-errors -Wno-maybe-uninitialized -std=f2018 -Wconversion -Wconversion-extra -fimplicit-none -fmax-errors=1 -fno-unsafe-math-optimizations -finit-real=snan -finit-integer=-2147483647 -finit-logical=true -finit-derived -Wimplicit-interface -Wunused -ffree-line-length-132
DBGFLAGS  = -Og -g -fcheck=all -fbacktrace -ffpe-trap=invalid,zero,overflow,underflow,denormal --coverage
# --coverage
# -fsanitize=leak doesn't work on trident for some reason. It does work on bison.
BINEXT    = 
RUN       = ./
RM        = rm -rfv
OFLAG     = -o
OBJEXT    = o
OBJFLAGS  = -c -o
DBGOBJEXT = -dbg.$(OBJEXT)
COV       = lcov_tests.info

###############
# Boilerplate #
###############

# Why run `make valgrind` here? As it uses gfortran and is more strict.
.PHONY: all
all:
	$(MAKE) lint
	$(MAKE) valgrind # gfortran
	$(MAKE) clean
	$(MAKE) ifx
	$(MAKE) clean
	$(MAKE) ifort
	$(MAKE) clean
	$(MAKE) nvfortran
	$(MAKE) clean
	@echo "***************************************"
	@echo "* All tests passed for all compilers. *"
	@echo "***************************************"

.SUFFIXES:
.SUFFIXES: .f90 .$(OBJEXT) $(DBGOBJEXT)

.PHONY: clean
clean:
	$(RM) *.nml *.mod *.gcda *.gcno test_* src/*.$(OBJEXT) src/*$(DBGOBJEXT) *.dbg src/*.gcda src/*.gcno $(COV) html-cov/ src/pdim_types.f90 pdim_gen

# TODO: `.f90$(OBJEXT):`

.f90$(DBGOBJEXT):
	$(FC) $(OBJFLAGS) $@ $(FFLAGS) $(DBGFLAGS) $<

.PHONY: test
test: $(NML)
	@echo "*********************"
	@echo "* All tests passed. *"
	@echo "*********************"
	@echo "Compiler: $(FC)"

.PHONY: valgrind
valgrind:
	$(MAKE) test RUN='valgrind --leak-check=full --show-leak-kinds=all --error-exitcode=1 --show-reachable=no ./'

# TODO: <https://github.com/camfort/camfort/wiki/Sanity-Checks>
lint:
	$(RUN)lint-wrapper.py src/*.f90 test/*.f90

# TODO: Make depend on *.gcda files?
html-cov/index.html: $(NML)
	lcov --directory . --directory src/ --capture --output-file $(COV)
	genhtml -t "flt" -o html-cov $(COV)

coverage: html-cov/index.html

###################
# Other compilers #
###################

# `-check uninit` has false positives with namelists for the moment.
# <https://community.intel.com/t5/Intel-Fortran-Compiler/Known-bug-with-check-all-or-check-uninit-in-ifx-2024-0-0-for/m-p/1545825>
.PHONY: ifx
ifx:
	$(MAKE) test FC=ifx FFLAGS='-warn errors -warn all -diag-error=remark,warn,error -fltconsistency -stand:f18 -diag-error-limit=1 -init=snan,arrays' DBGFLAGS='-O0 -g -traceback -debug full -check all,nouninit -fpe0'

# ifort is here due to possible performance benefits on x86.
# `-init=snan,arrays` seems to lead to false positives with ifort.
.PHONY: ifort
ifort:
	$(MAKE) test FC=ifort FFLAGS='-diag-disable=10448 -warn errors -warn all -diag-error=remark,warn,error -fltconsistency -stand f18 -diag-error-limit=1' DBGFLAGS='-O0 -g -traceback -debug full -check all -fpe0'

.PHONY: nvfortran
nvfortran:
	$(MAKE) test FC=nvfortran FFLAGS='-Minform=inform -Werror' DBGFLAGS='-g'

# LATER: lfortran, particularly for the style suggestions
#.PHONY: lfortran
#lfortran:
#	$(MAKE) test FC=lfortran FFLAGS='--link-with-gcc' DBGFLAGS=''

################
# Dependencies #
################

src/autodiff$(DBGOBJEXT): src/prec$(DBGOBJEXT)

src/checks$(DBGOBJEXT): src/prec$(DBGOBJEXT)

src/nmllog$(DBGOBJEXT): src/prec$(DBGOBJEXT)

src/prec$(DBGOBJEXT):

src/pdim_mod$(DBGOBJEXT): src/checks$(DBGOBJEXT) src/nmllog$(DBGOBJEXT) src/prec$(DBGOBJEXT)

src/genunits_io$(DBGOBJEXT): src/checks$(DBGOBJEXT) src/nmllog$(DBGOBJEXT) src/prec$(DBGOBJEXT) src/genunits_data$(DBGOBJEXT)

src/pdim_types$(DBGOBJEXT): src/prec$(DBGOBJEXT)

src/purerng$(DBGOBJEXT): src/checks$(DBGOBJEXT) src/prec$(DBGOBJEXT)

src/timer$(DBGOBJEXT): src/checks$(DBGOBJEXT) src/prec$(DBGOBJEXT)

src/unittest$(DBGOBJEXT): src/checks$(DBGOBJEXT) src/nmllog$(DBGOBJEXT) src/prec$(DBGOBJEXT) src/timer$(DBGOBJEXT)

src/genunits_data$(DBGOBJEXT): src/checks$(DBGOBJEXT) src/prec$(DBGOBJEXT)

############
# autodiff #
############

test_autodiff$(BINEXT): src/autodiff$(DBGOBJEXT) src/nmllog$(DBGOBJEXT) src/unittest$(DBGOBJEXT) test/test_autodiff.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) test/test_autodiff.f90

autodiff.nml: test_autodiff$(BINEXT)
	$(RUN)test_autodiff$(BINEXT)
	test ! -e fort.*

##########
# checks #
##########

test_assert_false$(BINEXT): src/checks$(DBGOBJEXT) test/test_assert_false.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) test/test_assert_false.f90

test_assert_false_message$(BINEXT): src/checks$(DBGOBJEXT) test/test_assert_false_message.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) test/test_assert_false_message.f90

test_checks$(BINEXT): src/checks$(DBGOBJEXT) src/unittest$(DBGOBJEXT) test/test_checks.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) test/test_checks.f90

checks.nml: test_checks$(BINEXT) test_assert_false$(BINEXT) test_assert_false_message$(BINEXT)
	$(RUN)test_checks$(BINEXT)
	test ! -e fort.*

###############
# genunits_io #
###############

test_genunits_io$(BINEXT): src/checks$(DBGOBJEXT) src/prec$(DBGOBJEXT) src/genunits_data$(DBGOBJEXT) src/genunits_io$(DBGOBJEXT) src/unittest$(DBGOBJEXT) test/test_genunits_io.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) test/test_genunits_io.f90

genunits_io.nml: test_genunits_io$(BINEXT)
	$(RUN)test_genunits_io$(BINEXT)
	test ! -e fort.*

##########
# nmllog #
##########

test_nmllog$(BINEXT): src/nmllog$(DBGOBJEXT) src/unittest$(DBGOBJEXT) test/test_nmllog.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) test/test_nmllog.f90

nmllog.nml: test_nmllog$(BINEXT)
	$(RUN)test_nmllog$(BINEXT)
	test ! -e fort.*

############
# pdim_mod #
############

test_pdim_mod$(BINEXT): src/pdim_mod$(DBGOBJEXT) src/prec$(DBGOBJEXT) src/nmllog$(DBGOBJEXT) src/unittest$(DBGOBJEXT) test/test_pdim_mod.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) test/test_pdim_mod.f90

pdim_mod.nml: test_pdim_mod$(BINEXT)
	$(RUN)test_pdim_mod$(BINEXT)
	test ! -e fort.*
	test ! -e fort.*

##############
# pdim_types #
##############

test_pdim_types$(BINEXT): src/pdim_types$(DBGOBJEXT) src/prec$(DBGOBJEXT) src/nmllog$(DBGOBJEXT) src/unittest$(DBGOBJEXT) test/test_pdim_types.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) test/test_pdim_types.f90

test_pdim_types_fail_1$(BINEXT): src/prec$(DBGOBJEXT) src/pdim_types$(DBGOBJEXT) test/test_pdim_types_fail_1.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) test/test_pdim_types_fail_1.f90

test_pdim_types_fail_2$(BINEXT): src/prec$(DBGOBJEXT) src/pdim_types$(DBGOBJEXT) test/test_pdim_types_fail_2.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) test/test_pdim_types_fail_2.f90

pdim_types.nml: test_pdim_types$(BINEXT) test/test_pdim_types_fail_1.f90 test/test_pdim_types_fail_2.f90
	$(RUN)test_pdim_types$(BINEXT)
	test ! -e fort.*
	test ! -e fort.*

############
# pdim_gen #
############

pdim_gen$(BINEXT): src/pdim_mod$(DBGOBJEXT) src/prec$(DBGOBJEXT) src/nmllog$(DBGOBJEXT) src/unittest$(DBGOBJEXT) app/pdim_gen.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) app/pdim_gen.f90

src/pdim_types.f90: pdim_gen$(BINEXT) test/pdim_test.nml
	$(RUN)pdim_gen$(BINEXT) test/pdim_test.nml
	test ! -e fort.*
	test ! -e fort.*

########
# prec #
########

test_prec$(BINEXT): src/prec$(DBGOBJEXT) src/nmllog$(DBGOBJEXT) src/unittest$(DBGOBJEXT) test/test_prec.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) test/test_prec.f90

prec.nml: test_prec$(BINEXT)
	$(RUN)test_prec$(BINEXT)
	test ! -e fort.*
	test ! -e fort.*

###########
# purerng #
###########

test_purerng$(BINEXT): src/prec$(DBGOBJEXT) src/nmllog$(DBGOBJEXT) src/purerng$(DBGOBJEXT) src/unittest$(DBGOBJEXT) test/test_purerng.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) test/test_purerng.f90

purerng.nml: test_purerng$(BINEXT)
	$(RUN)test_purerng$(BINEXT)
	test ! -e fort.*

#########
# timer #
#########

test_timer$(BINEXT): src/checks$(DBGOBJEXT) src/prec$(DBGOBJEXT) src/timer$(DBGOBJEXT) src/unittest$(DBGOBJEXT) test/test_timer.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) test/test_timer.f90

timer.nml: test_timer$(BINEXT)
	$(RUN)test_timer$(BINEXT)
	test ! -e fort.*

#################
# genunits_data #
#################

test_genunits_data$(BINEXT): src/checks$(DBGOBJEXT) src/prec$(DBGOBJEXT) src/genunits_data$(DBGOBJEXT) src/unittest$(DBGOBJEXT) test/test_genunits_data.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) test/test_genunits_data.f90

genunits_data.nml: test_genunits_data$(BINEXT)
	$(RUN)test_genunits_data$(BINEXT)
	test ! -e fort.*
	test ! -e fort.*

############
# unittest #
############

test_unittest$(BINEXT): src/checks$(DBGOBJEXT) src/timer$(DBGOBJEXT) src/unittest$(DBGOBJEXT) test/test_unittest.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) $(DBGFLAGS) src/*$(DBGOBJEXT) test/test_unittest.f90

unittest.nml: test_unittest$(BINEXT) prec.nml
	$(RUN)test_unittest$(BINEXT)
	test ! -e fort.*

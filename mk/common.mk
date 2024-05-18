# Summary: Common Makefile for all components of flt, including tests
# Standard: POSIX (tested on GNU Make and bmake)
# Preprocessor: none
# Author: Ben Trettel (<http://trettel.us/>)
# Project: [flt](https://github.com/btrettel/flt)
# License: [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html)

# Add later: dimmod.nml ga.nml
TESTNML = autodiff.nml checks.nml genunits_data.nml genunits_io.nml nmllog.nml prec.nml purerng.nml timer.nml units.nml unittest.nml
.PRECIOUS: $(TESTNML)

###############
# Boilerplate #
###############

.SUFFIXES:
.SUFFIXES: .f90 .$(OBJEXT)

.f90.$(OBJEXT):
	$(FC) $(OBJFLAGS) $@ $(FFLAGS) $<

.PHONY: test
test: $(TESTNML)
	@echo =====================
	@echo = All tests passed. =
	@echo =====================
	@echo Compiler: $(FC)

.PHONY: clean
clean:
	$(RM) *.nml *.mod *.gcda *.gcno test_* src$(DIR_SEP)*.$(OBJEXT) *.dbg src$(DIR_SEP)*.gcda src$(DIR_SEP)*.gcno $(COV) html-cov$(DIR_SEP) src$(DIR_SEP)units.f90 genunits$(BINEXT)

#######################
# Manual dependencies #
#######################

# Needs to be manually present as this is autogenerated and not available for depends.py to find.
src$(DIR_SEP)units.f90: genunits$(BINEXT) test$(DIR_SEP)genunits_input.nml
	$(RUN)genunits$(BINEXT) test$(DIR_SEP)genunits_input.nml

src$(DIR_SEP)units.$(OBJEXT): src$(DIR_SEP)prec.$(OBJEXT)

# Additional dependencies beyond the autogenerated dependencies.
checks.nml: test_assert_false$(BINEXT) test_assert_false_message$(BINEXT)

genunits_io.nml: test$(DIR_SEP)genunits_input.nml

units.nml: test$(DIR_SEP)test_units_fail_1.f90 test$(DIR_SEP)test_units_fail_2.f90

unittest.nml: prec.nml

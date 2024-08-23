#######################
# Manual dependencies #
#######################

src$(DIR_SEP)rev.f90: $(ALLSRC)
	$(PYTHON) py$(DIR_SEP)gitrev.py

depends: src$(DIR_SEP)units.f90 src$(DIR_SEP)units_ad.f90

# Needs to be manually present as this is autogenerated and not available for depends.py to find.
src$(DIR_SEP)units.f90: genunits$(BINEXT) test$(DIR_SEP)genunits_input.nml
	$(RUN)genunits$(BINEXT) test$(DIR_SEP)genunits_input.nml

src$(DIR_SEP)units_ad.f90: genunits$(BINEXT) test$(DIR_SEP)genunits_input_ad.nml
	$(RUN)genunits$(BINEXT) test$(DIR_SEP)genunits_input_ad.nml

# Additional dependencies beyond the autogenerated dependencies.
checks.nml: test_assert_false_1$(BINEXT) test_assert_false_2$(BINEXT) test_assert_dimension_false_1$(BINEXT) test_assert_dimension_false_2$(BINEXT) test_assert_dimension_false_3$(BINEXT)

genunits_io.nml: test$(DIR_SEP)genunits_input.nml

units.nml: test$(DIR_SEP)test_units_fail_1.f90 test$(DIR_SEP)test_units_fail_2.f90 test$(DIR_SEP)test_units_fail_3.f90 test$(DIR_SEP)test_units_fail_4.f90

unittest.nml: prec.nml

###########################
# Files to manually clean #
###########################

CLEAN_MANUAL = src$(DIR_SEP)units.f90 src$(DIR_SEP)units_ad.f90

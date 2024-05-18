# Automatically generated by depends.py.

#######################
# Module dependencies #
#######################

src$(DIR_SEP)autodiff.$(OBJEXT): src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)autodiff.f90

src$(DIR_SEP)checks.$(OBJEXT): src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.f90

src$(DIR_SEP)genunits_data.$(OBJEXT): src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)genunits_data.f90

src$(DIR_SEP)genunits_io.$(OBJEXT): src$(DIR_SEP)genunits_data.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)genunits_io.f90

src$(DIR_SEP)nmllog.$(OBJEXT): src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)nmllog.f90

src$(DIR_SEP)prec.$(OBJEXT): src$(DIR_SEP)prec.f90

src$(DIR_SEP)purerng.$(OBJEXT): src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)purerng.f90

src$(DIR_SEP)timer.$(OBJEXT): src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)timer.f90

src$(DIR_SEP)unittest.$(OBJEXT): src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)unittest.f90

########################
# Program dependencies #
########################

genunits$(BINEXT): src$(DIR_SEP)genunits_io.$(OBJEXT) src$(DIR_SEP)genunits_data.$(OBJEXT) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) app$(DIR_SEP)genunits.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) src$(DIR_SEP)genunits_io.$(OBJEXT) src$(DIR_SEP)genunits_data.$(OBJEXT) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) app$(DIR_SEP)genunits.f90

test_assert_false$(BINEXT): src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) test$(DIR_SEP)test_assert_false.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) test$(DIR_SEP)test_assert_false.f90

assert_false.nml: test_assert_false$(BINEXT)
	$(RUN)test_assert_false$(BINEXT)

test_assert_false_message$(BINEXT): src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) test$(DIR_SEP)test_assert_false_message.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) test$(DIR_SEP)test_assert_false_message.f90

assert_false_message.nml: test_assert_false_message$(BINEXT)
	$(RUN)test_assert_false_message$(BINEXT)

test_autodiff$(BINEXT): src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)autodiff.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_autodiff.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)autodiff.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_autodiff.f90

autodiff.nml: test_autodiff$(BINEXT)
	$(RUN)test_autodiff$(BINEXT)

test_checks$(BINEXT): src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_checks.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_checks.f90

checks.nml: test_checks$(BINEXT)
	$(RUN)test_checks$(BINEXT)

test_genunits_data$(BINEXT): src$(DIR_SEP)genunits_data.$(OBJEXT) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_genunits_data.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) src$(DIR_SEP)genunits_data.$(OBJEXT) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_genunits_data.f90

genunits_data.nml: test_genunits_data$(BINEXT)
	$(RUN)test_genunits_data$(BINEXT)

test_genunits_io$(BINEXT): src$(DIR_SEP)genunits_io.$(OBJEXT) src$(DIR_SEP)genunits_data.$(OBJEXT) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_genunits_io.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) src$(DIR_SEP)genunits_io.$(OBJEXT) src$(DIR_SEP)genunits_data.$(OBJEXT) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_genunits_io.f90

genunits_io.nml: test_genunits_io$(BINEXT)
	$(RUN)test_genunits_io$(BINEXT)

test_nmllog$(BINEXT): src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_nmllog.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_nmllog.f90

nmllog.nml: test_nmllog$(BINEXT)
	$(RUN)test_nmllog$(BINEXT)

test_prec$(BINEXT): src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_prec.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_prec.f90

prec.nml: test_prec$(BINEXT)
	$(RUN)test_prec$(BINEXT)

test_purerng$(BINEXT): src$(DIR_SEP)purerng.$(OBJEXT) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_purerng.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) src$(DIR_SEP)purerng.$(OBJEXT) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_purerng.f90

purerng.nml: test_purerng$(BINEXT)
	$(RUN)test_purerng$(BINEXT)

test_timer$(BINEXT): src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_timer.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_timer.f90

timer.nml: test_timer$(BINEXT)
	$(RUN)test_timer$(BINEXT)

test_units$(BINEXT): src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)units.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_units.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)units.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_units.f90

units.nml: test_units$(BINEXT)
	$(RUN)test_units$(BINEXT)

test_units_fail_1$(BINEXT): src$(DIR_SEP)units.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) test$(DIR_SEP)test_units_fail_1.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) src$(DIR_SEP)units.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) test$(DIR_SEP)test_units_fail_1.f90

units_fail_1.nml: test_units_fail_1$(BINEXT)
	$(RUN)test_units_fail_1$(BINEXT)

test_units_fail_2$(BINEXT): src$(DIR_SEP)units.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) test$(DIR_SEP)test_units_fail_2.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) src$(DIR_SEP)units.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) test$(DIR_SEP)test_units_fail_2.f90

units_fail_2.nml: test_units_fail_2$(BINEXT)
	$(RUN)test_units_fail_2$(BINEXT)

test_unittest$(BINEXT): src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_unittest.f90
	$(FC) $(OFLAG) $@ $(FFLAGS) src$(DIR_SEP)nmllog.$(OBJEXT) src$(DIR_SEP)timer.$(OBJEXT) src$(DIR_SEP)prec.$(OBJEXT) src$(DIR_SEP)checks.$(OBJEXT) src$(DIR_SEP)unittest.$(OBJEXT) test$(DIR_SEP)test_unittest.f90

unittest.nml: test_unittest$(BINEXT)
	$(RUN)test_unittest$(BINEXT)


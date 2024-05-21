# default compiler
FC = gfortran

BINEXT   = 
RUN      = ./
RM       = rm -rfv
OFLAG    = -o
OBJEXT   = o
OBJFLAGS = -c -o
DIR_SEP  = /
COV      = lcov_tests.info
MISSED   = missed.txt
CLEAN    = *.nml *.mod src$(DIR_SEP)*.$(OBJEXT) $(MISSED) src$(DIR_SEP)units.f90 *.gcda *.gcno test_* *.dbg src$(DIR_SEP)*.gcda src$(DIR_SEP)*.gcno src$(DIR_SEP)*.optrpt *.optrpt *.opt.yaml $(COV) html-cov$(DIR_SEP) genunits$(BINEXT)
CMP      = cmp
PYTHON   = python3

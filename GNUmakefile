# Summary: Makefile for GNU Make
# Standard: POSIX (tested on GNU Make, BSD Make, pdpmake, and Microsoft NMAKE)
# Author: Ben Trettel (<http://trettel.us/>)
# Project: [flt](https://github.com/btrettel/flt)
# License: [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html)

# Tested with GNU Make on Linux. Works with `make` on Ubuntu.

.POSIX:

# non-POSIX
# <https://innolitics.com/articles/make-delete-on-error/>
.DELETE_ON_ERROR:
MAKEFLAGS = --warn-undefined-variables

# defaults
ifdef F90
FC=$(F90)
else
ifndef FC
FC = gfortran
# fort77 is GNU Make's default, which I'm overriding.
else ifeq ($(FC),fort77)
FC = gfortran
endif
endif
BUILD = debug
include mk/linux_defaults.mk

#############
# Compilers #
#############

ifeq ($(FC),gfortran)
include mk/gfortran.mk
else ifeq ($(FC),ifx)
include mk/ifx_linux.mk
else ifeq ($(FC),ifort)
include mk/ifort_linux.mk
else ifeq ($(FC),nvfortran)
include mk/nvfortran.mk
else ifeq ($(FC),lfortran)
include mk/lfortran.mk
else ifeq ($(FC),crayftn)
include mk/crayftn.mk
#else
#$(error Invalid FC: $(FC))
endif

ifeq ($(BUILD),debug)
FFLAGS += $(DFLAGS)
else ifeq ($(BUILD),release)
FFLAGS += $(RFLAGS)
else
$(error Set BUILD to either debug or release. BUILD=$(BUILD))
endif

include mk/testnml.mk
include mk/common.mk
include mk/depends.mk
include mk/linux_2.mk
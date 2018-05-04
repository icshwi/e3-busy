#
#  Copyright (c) 2017 - Present  Jeong Han Lee
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# Author  : Jeong Han Lee
# email   : han.lee@esss.se
# Date    : Sunday, November 19 22:14:22 CET 2017
# version : 0.0.1

# Get where_am_I before include driver.makefile.
# After driver.makefile, where_am_I is the epics base,
# so we cannot use it


where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(E3_REQUIRE_TOOLS)/driver.makefile

ifneq ($(strip $(ASYN_DEP_VERSION)),)
asyn_VERSION=$(ASYN_DEP_VERSION)
endif

BUSYAPP:=busyApp
BUSYAPPDB:=$(BUSYAPP)/Db
BUSYAPPSRC:=$(BUSYAPP)/src


USR_INCLUDES += -I$(where_am_I)/$(BUSYAPPSRC)


TEMPLATES += $(BUSYAPPDB)/busyRecord.db
TEMPLATES += $(BUSYAPPDB)/testBusyAsyn.db

# Community has the following DBD files
# busySupport.dbd and busyRecord.dbd
# They are actually the same as busy.dbd
# Anyway, we have to tell driver.makefile
# the following dbd files, but we don't need to
# tell driver.makefile where busyRecord.dbd is

DBDS      += $(BUSYAPPSRC)/busySupport_LOCAL.dbd
DBDS      += $(BUSYAPPSRC)/busySupport_withASYN.dbd

SOURCES   += $(BUSYAPPSRC)/devBusyAsyn.c
SOURCES   += $(BUSYAPPSRC)/devBusySoftRaw.c
SOURCES   += $(BUSYAPPSRC)/devBusySoft.c

# DBINC should be defined in the first compiling order
# with the following rules
SOURCES   += $(BUSYAPPSRC)/busyRecord.c


# driver.makefile doesn't use -MM -MF option in order to
# create dependency files, so we need to create busyRecord.h
# first in order to compile all others sources.
# driver.makefile actually create busyRecord.h at the end of
# compilation.
# 
busyRecord$(DEP): ../$(BUSYAPPSRC)/busyRecord.h

ifdef T_A

USR_DBDFLAGS += -I . -I ..

.SECONDARY: ../$(BUSYAPPSRC)/busyRecord.c

%.h %.c: %.dbd
#	@echo "@ $@"
#	@echo "% $%"
#	@echo "< $<"
#	@echo "? $?"
#	@echo "^ $^"
#	@echo "+ $+"
#	@echo "| $|"
#	@echo "* $*"
#	@echo "EPICS MSI $(MSI3_15)"
#	@echo "EPICS PERL $(PERL)"
#	@echo "$(DBTORECORDTYPEH)"
	$(DBTORECORDTYPEH)  $(USR_DBDFLAGS)  -o $@ $<

endif

# db rule is the default in RULES_E3, so add the empty one

db:

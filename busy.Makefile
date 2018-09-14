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
# Date    : Monday, September 10 09:27:43 CEST 2018
# version : 0.0.3


where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(where_am_I)/../configure/DECOUPLE_FLAGS


ifneq ($(strip $(ASYN_DEP_VERSION)),)
asyn_VERSION=$(ASYN_DEP_VERSION)
endif



APP:=busyApp
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src

USR_INCLUDES += -I$(where_am_I)$(APPSRC)

TEMPLATES += $(APPDB)/busyRecord.db
TEMPLATES += $(APPDB)/testBusyAsyn.db


DBDINC_SRCS = $(APPSRC)/busyRecord.c
DBDINC_DBDS = $(subst .c,.dbd,   $(DBDINC_SRCS:$(APPSRC)/%=%))
DBDINC_HDRS = $(subst .c,.h,     $(DBDINC_SRCS:$(APPSRC)/%=%))
DBDINC_DEPS = $(subst .c,$(DEP), $(DBDINC_SRCS:$(APPSRC)/%=%))



# Community has the following DBD files
# busySupport.dbd and busyRecord.dbd
# They are actually the same as busy.dbd
# Anyway, we have to tell driver.makefile
# the following dbd files, but we don't need to
# tell driver.makefile where busyRecord.dbd is


SOURCES   += $(APPSRC)/devBusyAsyn.c

SOURCES   += $(APPSRC)/devBusySoftRaw.c
SOURCES   += $(APPSRC)/devBusySoft.c


DBDS      += $(APPSRC)/busySupport_LOCAL.dbd
DBDS      += $(APPSRC)/busySupport_withASYN.dbd


HEADERS += $(DBDINC_HDRS)
SOURCES += $(DBDINC_SRCS)


$(DBDINC_DEPS): $(DBDINC_HDRS)

.dbd.h:
	$(DBTORECORDTYPEH)  $(USR_DBDFLAGS) -o $@ $<

.PHONY: $(DBDINC_DEPS) .dbd.h


# db rule is the default in RULES_E3, so add the empty one

db:

.PHONY: db 

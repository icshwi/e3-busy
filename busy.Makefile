where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(REQUIRE_TOOLS)/driver.makefile


BUSYAPP:=busyApp
BUSYAPPDB:=$(BUSYAPP)/Db
BUSYAPPSRC:=$(BUSYAPP)/src


USR_INCLUDES += -I$(where_am_I)/$(BUSYAPPSRC)

# Community has the following DBD files
# busySupport.dbd and busyRecord.dbd
# They are actually the same as busy.dbd
# However, we have to tell driver.makefile
# the following dbd files

DBDS    += $(BUSYAPPSRC)/busySupport_LOCAL.dbd
DBDS    += $(BUSYAPPSRC)/busySupport_withASYN.dbd

SOURCES += $(BUSYAPPSRC)/devBusyAsyn.c
SOURCES += $(BUSYAPPSRC)/devBusySoftRaw.c
SOURCES += $(BUSYAPPSRC)/devBusySoft.c


SOURCES += $(BUSYAPPSRC)/busyRecord.c


# driver.makefile doens't use -MM -MF option in order to
# create dependency files, so we need to create header files
# before driver.makefile actually creates busyRecord.h
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

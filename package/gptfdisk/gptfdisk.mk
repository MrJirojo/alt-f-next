#############################################################
#
# gptfdisk
#
#############################################################

#GPTFDISK_VERSION:=0.8.2
GPTFDISK_VERSION:=0.8.5
GPTFDISK_SOURCE:=gptfdisk-$(GPTFDISK_VERSION).tar.gz
GPTFDISK_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/gptfdisk
GPTFDISK_DIR:=$(BUILD_DIR)/gptfdisk-$(GPTFDISK_VERSION)
GPTFDISK_INSTALL_STAGING = NO
GPTFDISK_LIBTOOL_PATCH = NO

GPTFDISK_DEPENDENCIES = popt

ifeq ($(BR2_PACKAGE_GPTFDISK_CGDISK),y)
	GPTFDISK_DEPENDENCIES += ncurses
endif

ifeq ($(BR2_PACKAGE_GPTFDISK_SGDISK),y)
GPTFDISK_MAKE_OPT = sgdisk
endif
ifeq ($(BR2_PACKAGE_GPTFDISK_GDISK),y)
GPTFDISK_MAKE_OPT += gdisk
endif
ifeq ($(BR2_PACKAGE_GPTFDISK_CGDISK),y)
GPTFDISK_MAKE_OPT += cgdisk
endif
ifeq ($(BR2_PACKAGE_GPTFDISK_FIXPARTS),y)
GPTFDISK_MAKE_OPT += fixparts
endif

$(eval $(call AUTOTARGETS,package,gptfdisk))

$(GPTFDISK_HOOK_POST_EXTRACT):
	echo -e "#!/bin/bash\necho \"\
CC = \$$CC\\n\
CXX = \$$CXX\\n\
CFLAGS = \$$CFLAGS\\n\
CXXFLAGS = \$$CXXFLAGS\\n\" >> Makefile" > $(GPTFDISK_DIR)/configure
	chmod +x $(GPTFDISK_DIR)/configure
	touch $@

$(GPTFDISK_TARGET_INSTALL_TARGET):
ifeq ($(BR2_PACKAGE_GPTFDISK_SGDISK),y)
	cp $(GPTFDISK_DIR)/sgdisk $(TARGET_DIR)/usr/sbin
endif
ifeq ($(BR2_PACKAGE_GPTFDISK_GDISK),y)
	cp $(GPTFDISK_DIR)/gdisk $(TARGET_DIR)/usr/sbin
endif
ifeq ($(BR2_PACKAGE_GPTFDISK_FIXPARTS),y)
	cp $(GPTFDISK_DIR)/fixparts $(TARGET_DIR)/usr/sbin
endif
ifeq ($(BR2_PACKAGE_GPTFDISK_CGDISK),y)
	cp $(GPTFDISK_DIR)/cgdisk $(TARGET_DIR)/usr/sbin
endif
	touch $@

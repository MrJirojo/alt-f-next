#############################################################
#
# libgd
#
#############################################################

LIBGD_VERSION:=2.3.2
LIBGD_SITE:=https://bitbucket.org/libgd/gd-libgd/get
LIBGD_SOURCE=GD_$(subst .,_,$(LIBGD_VERSION)).tar.bz2
LIBGD_SUBDIR = src

LIBGD_LIBTOOL_PATCH = NO
LIBGD_INSTALL_STAGING = YES

LIBGD_CONF_OPTS = --disable-rpath --without-freetype --without-fontconfig --without-xpm

$(eval $(autotools-package))

# configure leak, CPPFLAGS points to /usr/include, remove it
$(LIBGD_HOOK_POST_CONFIGURE):
	sed -i 's|^CPPFLAGS.*||' $(LIBGD_DIR)/$(LIBGD_SUBDIR)/Makefile
	touch $@

$(LIBGD_HOOK_POST_INSTALL):
	sed -i "s|^prefix=/usr|prefix=$(STAGING_DIR)/usr|" $(STAGING_DIR)/usr/bin/gdlib-config
	rm -f $(TARGET_DIR)/usr/bin/gdlib-config
	touch $@

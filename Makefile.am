#/****************************************************************************
#* Copyright by The HDF Group.                                               *
#* Copyright by the Board of Trustees of the University of Illinois.         *
#* All rights reserved.                                                      *
#*                                                                           *
#* This file is part of HDF Java Products. The full HDF Java copyright       *
#* notice, including terms governing use, modification, and redistribution,  *
#* is contained in the file, COPYING.  COPYING can be found at the root of   *
#* the source code distribution tree. You can also access it online  at      *
#* http://www.hdfgroup.org/products/licenses.html.  If you do not have       *
#* access to the file, you may request a copy from help@hdfgroup.org.        *
#****************************************************************************/
##
## Makefile.am
## Run automake to generate a Makefile.in from this file.
##
# 
# This makefile mostly just reinvokes make in the various subdirectories
# but does so in the correct order.  You can alternatively invoke make from
# each subdirectory manually.
#
# Top-level HDFJava Makefile(.in)

# pmake has issues if variables are undefined.  Solve this problem in
# top-level Makefile by defining .MAKEFLAGS target to -V before pmake can
# encounter any undefined variables.
# Automake resists putting anything but variable definitions first in
# a Makefile.in, so we'll put a placebo comment here and use sed in
# bin/reconfigure to turn it into the .MAKEFLAGS target.  Sigh.  -JL 2005
# Configure should set AM_MAKEFLAGS to -V to solve this problem in
# subdirectories.
# NOTE: This means that invoking pmake in a subdirectory will not work.
#xxx.MAKEFLAGS:@AM_MAKEFLAGS@
#xxx    $(MAKE) all
#xxx

SUBDIRS = native ncsa test examples
DIST_SUBDIRS = native ncsa test examples

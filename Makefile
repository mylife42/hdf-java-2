# Generated automatically from Makefile.in by configure.
#****************************************************************************
#* NCSA HDF                                                                 *
#* National Comptational Science Alliance                                   *
#* University of Illinois at Urbana-Champaign                               *
#* 605 E. Springfield, Champaign IL 61820                                   *
#*                                                                          *
#* For conditions of distribution and use, see the accompanying             *
#* java-hdf5/COPYING file.                                                  *
#*                                                                          *
#****************************************************************************/

#@VERSION@

JAVAC           = /usr/local/jdk1.3.1/bin/javac
JAVADOC         = /usr/local/jdk1.3.1/bin/javadoc
JAR         	= /usr/local/jdk1.3.1/bin/jar
FIND            = /usr/bin/find
JAVADOC_FLAGS   = -1.1 -version -author
SLEXT=so

CLASSPATH=/usr/local/jdk1.3.1/jre/lib/rt.jar:/afs/ncsa/user/mcgrath/javaproj/java6/mcgrath/eirene/hdf-java:/afs/ncsa.uiuc.edu/projects/hdf/java/java6/mcgrath/eirene/New/lib/jhdf.jar:/afs/ncsa.uiuc.edu/projects/hdf/java/java6/mcgrath/eirene/New/lib/jhdf5.jar
JH45INSTALLDIR=/afs/ncsa.uiuc.edu/projects/hdf/java/java6/mcgrath/eirene/New/

#make this relative to the source root...
LIBDIR=$(JH45INSTALLDIR)/lib
BINDIR=$(JH45INSTALLDIR)/bin
ETCDIR=$(JH45INSTALLDIR)/etc
DOCDIR= $(JH45INSTALLDIR)/docs

JH45IDISTFILES=./VERSION ./COPYING ./Makefile.in win32make.bat \
	./configure.in ./Config/config* ./Config/install-sh \
	./configure native/Makefile.in native/h4toh5lib/Makefile.in \
	./native/h4toh5lib/*.c ./native/h4toh5lib/*.h \
	./ncsa/hdf/h4toh5lib/*.java  \
	./ncsa/hdf/h4toh5lib/exceptions/*.java

JHIDISTFILES=./VERSION ./COPYING ./Makefile.in win32make.bat \
	./configure.in ./Config/config* ./Config/install-sh \
	./configure native/Makefile.in native/hdflib/Makefile.in \
	./ncsa/hdf/hdflib/*.java  \
	./glguerin/io/*.java ./glguerin/mac/io/*.java ./glguerin/util/*.java   
JHI5DISTFILES=./VERSION ./COPYING ./Makefile.in win32make.bat \
        ./configure.in ./Config/config* ./Config/install-sh \
        ./configure native/Makefile.in native/hdf5lib/Makefile.in \
        ./etc/H5Constants-needed ./etc/Makefile.in \
        ./etc/scr etc/TestHDF5Link.java etc/testlink.in \
        ./native/hdf5lib/*.c ./native/hdf5lib/*.h \
        ./ncsa/hdf/hdf5lib/*.java  \
        ./ncsa/hdf/hdf5lib/exceptions/*.java 

JH45PACKAGES = \
	ncsa.hdf.h4toh5lib.exceptions \
	ncsa.hdf.h4toh5lib 

JHIPACKAGES = \
	ncsa.hdf.hdflib \
	glguerin.io \
	glguerin.mac.io \
	glguerin.util

JHI5PACKAGES = \
	ncsa.hdf.hdf5lib.exceptions \
	ncsa.hdf.hdf5lib 

.SUFFIXES: .java .class

.java.class:
	$(JAVAC) -classpath $(CLASSPATH) $<

all: natives packages

# samples, docs, etc

packages: jhdf-packages jhdf5-packages jh4toh5-packages

jh4toh5-packages: $(JH45PACKAGES)  
	$(JAR) cf ./lib/jh4toh5.jar $(JH45CLASSES)

jhdf-packages: $(JHIPACKAGES)  
	$(JAR) cf ./lib/jhdf.jar $(JHICLASSES)

jhdf5-packages: $(JHI5PACKAGES)  
	$(JAR) cf ./lib/jhdf5.jar $(JHI5CLASSES)

classes: packages

natives: FORCE
	cd native; \
	$(MAKE) 

hdflib: FORCE
	cd native; \
	$(MAKE) hdflib

hdf5lib: FORCE
	cd native; \
	$(MAKE) hdf5lib

h4to5lib: FORCE
	cd native; \
	$(MAKE) h4to5lib

FORCE:

## revise arrangement of docs, java docs.
DOCPACKAGES = $(JH45PACKAGES) $(JHIPACKAGES) $(JHI5PACKAGES)

docs: javadocs

javadocs:
	$(JAVADOC) -sourcepath $(CLASSPATH) -d ./docs/javadocs $(JAVADOC_FLAGS) $(DOCPACKAGES)

tests:
	cd test; \
	$(MAKE);

clean-test:
	cd test; \
	$(MAKE) clean;

clean: clean-natives clean-classes clean-test

clean-classes:
	$(FIND) ./ncsa \( -name '#*' -o -name '*~' -o -name '*.class' \) -exec rm -f {} \; ;\
	rm -f ./lib/jh4toh5.jar
	rm -f ./lib/jhdf.jar
	rm -f ./lib/jhdf5.jar

clean-packages: clean-classes

clean-natives:
	cd native; \
	$(MAKE) clean;

clean-hdflib:
	cd native; \
	$(MAKE) clean-hdflib;

clean-hdf5lib:
	cd native; \
	$(MAKE) clean-hdf5lib;

clean-h4toh5lib:
	cd native; \
	$(MAKE) clean-h4toh5lib;

clean-docs:
	cd docs; \
	rm *.html

check: install
	cd test; \
	$(MAKE) check;

install: install-lib install-jhdf install-jhdf5 install-jh4toh5 
	@echo "Install complete"

uninstall: uninstall-lib uninstall-jh45

install-lib: natives
	-mkdir -p $(LIBDIR);
	-mkdir -p $(LIBDIR)/linux
	cp ./lib/linux/libjh4toh5.$(SLEXT) $(LIBDIR)/linux
	cp ./lib/linux/libjhdf.$(SLEXT) $(LIBDIR)/linux
	cp ./lib/linux/libjhdf5.$(SLEXT) $(LIBDIR)/linux
	@echo "Install Natives complete"

install-libhdf: libhdf
	-mkdir -p $(LIBDIR);
	-mkdir -p $(LIBDIR)/linux
	cp ./lib/linux/libjhdf.$(SLEXT) $(LIBDIR)/linux
	@echo "Install Native HDF complete"

install-libhdf5: libhdf5
	-mkdir -p $(LIBDIR);
	-mkdir -p $(LIBDIR)/linux
	cp ./lib/linux/libjhdf5.$(SLEXT) $(LIBDIR)/linux
	@echo "Install Native HDF5 complete"

install-libh4to5: h4toh5lib
	-mkdir -p $(LIBDIR);
	-mkdir -p $(LIBDIR)/linux
	cp ./lib/linux/libjh4toh5.$(SLEXT) $(LIBDIR)/linux
	@echo "Install Native HDF4 to 5 complete"

uninstall-lib:
	rm -f $(LIBDIR)/linux/libjh4toh5.$(SLEXT)

install-jars: install-jhdf install-jhdf5 install-jh45

install-jh4toh5: jh4toh5-packages
	-mkdir -p $(LIBDIR);
	$(JAR) cf $(JH45INSTALLDIR)/lib/jh4toh5.jar $(JH45CLASSES)
	@echo "Install JH45 complete"

install-jhdf: jhdf-packages
	-mkdir -p $(LIBDIR);
	$(JAR) cf $(JH45INSTALLDIR)/lib/jhdf.jar $(JHICLASSES)
	@echo "Install JHI complete"

install-jhdf5: jhdf5-packages
	-mkdir -p $(LIBDIR);
	$(JAR) cf $(JH45INSTALLDIR)/lib/jhdf5.jar $(JHI5CLASSES)
	@echo "Install JHI5 complete"

uninstall-jhi5: 
	rm -f $(JH45INSTALLDIR)/lib/jh4toh5.jar

install-docs: install-javadocs 

install-javadocs:
	-mkdir -p $(DOCDIR);
	$(JAVADOC) -sourcepath $(CLASSPATH) -d $(DOCDIR) $(JAVADOC_FLAGS) $(DOCPACKAGES)
	-mkdir -p $(DOCDIR)/images;
	cp docs/images/*.gif $(DOCDIR)/images;

uninstall-javadocs:
	rm -rf $(DOCDIR)/*.html

#install-ug:
#	-mkdir -p $(DOCDIR);
#	-mkdir -p $(DOCDIR)/H5View/UsersGuide;
#	cp java-hdf5-html/H5View/UsersGuide/*.html $(DOCDIR)/H5View/UsersGuide;
#	-mkdir -p $(DOCDIR)/H5View/UsersGuide/images;
#	cp java-hdf5-html/H5View/UsersGuide/images/*.gif $(DOCDIR)/H5View/UsersGuide/images;
#
#uninstall-ug:
##	rm -rf $(DOCDIR)/H5View/UsersGuide/*

distclean: clean-natives clean-classes clean-test
	rm config.cache config.status config.log 
	rm -rf ./lib/linux
	rm -rf ./lib/*.jar
	rm -f ./native/Makefile
	rm -rf ./native/h4toh5lib/Makefile
	rm -rf ./native/libhdf/Makefile
	rm -rf ./native/libhdf5/Makefile
	rm -rf ./test/Makefile
	rm -rf ./test/h4toh5/Makefile
	rm -rf ./test/h4toh5/*.sh
	rm -rf ./Makefile

#build_package:
#	./build/JDK/builddist linux
#	./build/JRE/buildjre linux


# --------
# Packages
# --------

ncsa.hdf.h4toh5lib: \
	ncsa/hdf/h4toh5lib/h4toh5.class

ncsa.hdf.h4toh5lib.exceptions: \
	ncsa/hdf/h4toh5lib/exceptions/H45Exception.class \
	ncsa/hdf/h4toh5lib/exceptions/H45LibraryException.class

ncsa.hdf.hdf5lib: \
	ncsa/hdf/hdf5lib/H5.class \
	ncsa/hdf/hdf5lib/HDF5CDataTypes.class \
	ncsa/hdf/hdf5lib/HDF5Constants.class \
	ncsa/hdf/hdf5lib/HDF5GroupInfo.class \
	ncsa/hdf/hdf5lib/HDFArray.class \
	ncsa/hdf/hdf5lib/HDFNativeData.class 

ncsa.hdf.hdf5lib.exceptions: \
	ncsa/hdf/hdf5lib/exceptions/HDF5AtomException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5AttributeException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5BtreeException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5DataFiltersException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5DataStorageException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5DatasetInterfaceException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5DataspaceInterfaceException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5DatatypeInterfaceException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5Exception.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5ExternalFileListException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5FileInterfaceException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5FunctionArgumentException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5FunctionEntryExitException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5HeapException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5InternalErrorException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5JavaException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5LibraryException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5LowLevelIOException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5MetaDataCacheException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5ObjectHeaderException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5PropertyListInterfaceException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5ReferenceException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5ResourceUnavailableException.class \
	ncsa/hdf/hdf5lib/exceptions/HDF5SymbolTableException.class 

glguerin.io: glguerin/io/FilePathname.class glguerin/io/Path.class

glguerin.mac.io: glguerin/mac/io/MacEscaping.class  \
	glguerin/mac/io/MacFilePathname.class

glguerin.util: glguerin/util/MacPlatform.class

ncsa.hdf.hdflib: \
	ncsa/hdf/hdflib/HDFArray.class \
	ncsa/hdf/hdflib/HDFChunkInfo.class \
	ncsa/hdf/hdflib/HDFCompChunkInfo.class \
	ncsa/hdf/hdflib/HDFCompInfo.class \
	ncsa/hdf/hdflib/HDFCompModel.class \
	ncsa/hdf/hdflib/HDFConstants.class \
	ncsa/hdf/hdflib/HDFDeflateCompInfo.class \
	ncsa/hdf/hdflib/HDFDeprecated.class \
	ncsa/hdf/hdflib/HDFException.class \
	ncsa/hdf/hdflib/HDFIMCOMPCompInfo.class \
	ncsa/hdf/hdflib/HDFJPEGCompInfo.class \
	ncsa/hdf/hdflib/HDFJavaException.class \
	ncsa/hdf/hdflib/HDFLibrary.class \
	ncsa/hdf/hdflib/Native.class \
	ncsa/hdf/hdflib/HDFLibraryException.class \
	ncsa/hdf/hdflib/HDFNBITChunkInfo.class \
	ncsa/hdf/hdflib/HDFNBITCompInfo.class \
	ncsa/hdf/hdflib/HDFNativeData.class \
	ncsa/hdf/hdflib/HDFNewCompInfo.class \
	ncsa/hdf/hdflib/HDFNotImplementedException.class \
	ncsa/hdf/hdflib/HDFOldCompInfo.class \
	ncsa/hdf/hdflib/HDFOldRLECompInfo.class \
	ncsa/hdf/hdflib/HDFOnlyChunkInfo.class \
	ncsa/hdf/hdflib/HDFRLECompInfo.class \
	ncsa/hdf/hdflib/HDFSKPHUFFCompInfo.class \
	ncsa/hdf/hdflib/HDFTable.class 

# --------------
# Single targets
# --------------

h4toh5:	ncsa/hdf/h4toh5lib/h4toh5.class
H45Exception:	ncsa/hdf/h4toh5lib/exceptions/H45Exception.class 
H45LibraryException:	ncsa/hdf/h4toh5lib/exceptions/H45LibraryException.class 
H5:	ncsa/hdf/hdf5lib/H5.class
HDF5CDataTypes:	ncsa/hdf/hdf5lib/HDF5CDataTypes.class
HDF5Constants:	ncsa/hdf/hdf5lib/HDF5Constants.class
HDF5GroupInfo:	ncsa/hdf/hdf5lib/HDF5GroupInfo.class
HDFArray:	ncsa/hdf/hdf5lib/HDFArray.class
HDFNativeData:	ncsa/hdf/hdf5lib/HDFNativeData.class
HDF5AtomException:	ncsa/hdf/hdf5lib/exceptions/HDF5AtomException.class
HDF5AttributeException:	ncsa/hdf/hdf5lib/exceptions/HDF5AttributeException.class
HDF5BtreeException:	ncsa/hdf/hdf5lib/exceptions/HDF5BtreeException.class
HDF5DataFiltersException:	ncsa/hdf/hdf5lib/exceptions/HDF5DataFiltersException.class
HDF5DataStorageException:	ncsa/hdf/hdf5lib/exceptions/HDF5DataStorageException.class
HDF5DatasetInterfaceException:	ncsa/hdf/hdf5lib/exceptions/HDF5DatasetInterfaceException.class
HDF5DataspaceInterfaceException:	ncsa/hdf/hdf5lib/exceptions/HDF5DataspaceInterfaceException.class
HDF5DatatypeInterfaceException:	ncsa/hdf/hdf5lib/exceptions/HDF5DatatypeInterfaceException.class
HDF5Exception:	ncsa/hdf/hdf5lib/exceptions/HDF5Exception.class
HDF5ExternalFileListException:	ncsa/hdf/hdf5lib/exceptions/HDF5ExternalFileListException.class
HDF5FileInterfaceException:	ncsa/hdf/hdf5lib/exceptions/HDF5FileInterfaceException.class
HDF5FunctionArgumentException:	ncsa/hdf/hdf5lib/exceptions/HDF5FunctionArgumentException.class
HDF5FunctionEntryExitException:	ncsa/hdf/hdf5lib/exceptions/HDF5FunctionEntryExitException.class
HDF5HeapException:	ncsa/hdf/hdf5lib/exceptions/HDF5HeapException.class
HDF5InternalErrorException:	ncsa/hdf/hdf5lib/exceptions/HDF5InternalErrorException.class
HDF5JavaException:	ncsa/hdf/hdf5lib/exceptions/HDF5JavaException.class
HDF5LibraryException:	ncsa/hdf/hdf5lib/exceptions/HDF5LibraryException.class
HDF5LowLevelIOException:	ncsa/hdf/hdf5lib/exceptions/HDF5LowLevelIOException.class
HDF5MetaDataCacheException:	ncsa/hdf/hdf5lib/exceptions/HDF5MetaDataCacheException.class
HDF5ObjectHeaderException:	ncsa/hdf/hdf5lib/exceptions/HDF5ObjectHeaderException.class
HDF5PropertyListInterfaceException:	ncsa/hdf/hdf5lib/exceptions/HDF5PropertyListInterfaceException.class
HDF5ReferenceException:	ncsa/hdf/hdf5lib/exceptions/HDF5ReferenceException.class
HDF5ResourceUnavailableException:	ncsa/hdf/hdf5lib/exceptions/HDF5ResourceUnavailableException.class
HDF5SymbolTableException:	ncsa/hdf/hdf5lib/exceptions/HDF5SymbolTableException.class
HDFArray:	ncsa/hdf/hdflib/HDFArray.class
HDFChunkInfo:	ncsa/hdf/hdflib/HDFChunkInfo.class
HDFCompChunkInfo:	ncsa/hdf/hdflib/HDFCompChunkInfo.class
HDFCompInfo:	ncsa/hdf/hdflib/HDFCompInfo.class
HDFCompModel:	ncsa/hdf/hdflib/HDFCompModel.class
HDFConstants:	ncsa/hdf/hdflib/HDFConstants.class
HDFDeflateCompInfo:	ncsa/hdf/hdflib/HDFDeflateCompInfo.class
HDFDeprecated:	ncsa/hdf/hdflib/HDFDeprecated.class
HDFException:	ncsa/hdf/hdflib/HDFException.class
HDFIMCOMPCompInfo:	ncsa/hdf/hdflib/HDFIMCOMPCompInfo.class
HDFJPEGCompInfo:	ncsa/hdf/hdflib/HDFJPEGCompInfo.class
HDFJavaException:	ncsa/hdf/hdflib/HDFJavaException.class
HDFLibrary:	ncsa/hdf/hdflib/HDFLibrary.class
Native:	ncsa/hdf/hdflib/Native.class
HDFLibraryException:	ncsa/hdf/hdflib/HDFLibraryException.class
HDFNBITChunkInfo:	ncsa/hdf/hdflib/HDFNBITChunkInfo.class
HDFNBITCompInfo:	ncsa/hdf/hdflib/HDFNBITCompInfo.class
HDFNativeData:	ncsa/hdf/hdflib/HDFNativeData.class
HDFNewCompInfo:	ncsa/hdf/hdflib/HDFNewCompInfo.class
HDFNotImplementedException:	ncsa/hdf/hdflib/HDFNotImplementedException.class
HDFOldCompInfo:	ncsa/hdf/hdflib/HDFOldCompInfo.class
HDFOldRLECompInfo:	ncsa/hdf/hdflib/HDFOldRLECompInfo.class
HDFOnlyChunkInfo:	ncsa/hdf/hdflib/HDFOnlyChunkInfo.class
HDFRLECompInfo:	ncsa/hdf/hdflib/HDFRLECompInfo.class
HDFSKPHUFFCompInfo:	ncsa/hdf/hdflib/HDFSKPHUFFCompInfo.class
HDFTable:	ncsa/hdf/hdflib/HDFTable.class
FilePathname: glguerin/io/FilePathname.class 
Path: glguerin/io/Path.class
MacEscaping:	glguerin/mac/io/MacEscaping.class 
MacFilePathname:	glguerin/mac/io/MacFilePathname.class 
MacPlatform:	glguerin/util/MacPlatform.class



#  All classes that are built, including private classes:
#     This is what is loaded into the 'jar' file.
#

JH45CLASSES= ./ncsa/hdf/h4toh5lib/h4toh5.class \
	./ncsa/hdf/h4toh5lib/exceptions/H45Exception.class \
	./ncsa/hdf/h4toh5lib/exceptions/H45LibraryException.class


JHI5CLASSES= ./ncsa/hdf/hdf5lib/ArrayDescriptor.class \
	./ncsa/hdf/hdf5lib/HDF5Constants.class \
	./ncsa/hdf/hdf5lib/HDF5CDataTypes.class \
	./ncsa/hdf/hdf5lib/HDF5GroupInfo.class \
	./ncsa/hdf/hdf5lib/H5.class \
	./ncsa/hdf/hdf5lib/HDFArray.class \
	./ncsa/hdf/hdf5lib/HDFNativeData.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5Exception.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5JavaException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5AtomException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5AttributeException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5BtreeException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5DataFiltersException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5DataStorageException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5DatasetInterfaceException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5DataspaceInterfaceException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5DatatypeInterfaceException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5ExternalFileListException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5FileInterfaceException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5FunctionArgumentException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5FunctionEntryExitException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5HeapException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5InternalErrorException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5LibraryException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5LowLevelIOException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5MetaDataCacheException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5ObjectHeaderException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5PropertyListInterfaceException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5ReferenceException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5ResourceUnavailableException.class \
	./ncsa/hdf/hdf5lib/exceptions/HDF5SymbolTableException.class


JHICLASSES= ./ncsa/hdf/hdflib/HDFArray.class \
	./ncsa/hdf/hdflib/HDFChunkInfo.class \
	./ncsa/hdf/hdflib/HDFCompChunkInfo.class \
	./ncsa/hdf/hdflib/HDFCompInfo.class \
	./ncsa/hdf/hdflib/HDFCompModel.class \
	./ncsa/hdf/hdflib/HDFConstants.class \
	./ncsa/hdf/hdflib/HDFDeflateCompInfo.class \
	./ncsa/hdf/hdflib/HDFDeprecated.class \
	./ncsa/hdf/hdflib/HDFException.class \
	./ncsa/hdf/hdflib/HDFIMCOMPCompInfo.class \
	./ncsa/hdf/hdflib/HDFJPEGCompInfo.class \
	./ncsa/hdf/hdflib/HDFJavaException.class \
	./ncsa/hdf/hdflib/Native.class \
	./ncsa/hdf/hdflib/HDFLibrary.class \
	./ncsa/hdf/hdflib/HDFLibraryException.class \
	./ncsa/hdf/hdflib/HDFNBITChunkInfo.class \
	./ncsa/hdf/hdflib/HDFNBITCompInfo.class \
	./ncsa/hdf/hdflib/HDFNativeData.class \
	./ncsa/hdf/hdflib/HDFNewCompInfo.class \
	./ncsa/hdf/hdflib/HDFNotImplementedException.class \
	./ncsa/hdf/hdflib/HDFOldCompInfo.class \
	./ncsa/hdf/hdflib/HDFOldRLECompInfo.class \
	./ncsa/hdf/hdflib/HDFOnlyChunkInfo.class \
	./ncsa/hdf/hdflib/HDFRLECompInfo.class \
	./ncsa/hdf/hdflib/HDFSKPHUFFCompInfo.class \
	./ncsa/hdf/hdflib/HDFTable.class \
	./ncsa/hdf/hdflib/ArrayDescriptor.class \
	./ncsa/hdf/hdflib/TabDescriptor.class \
	./glguerin/io/FilePathname.class \
	./glguerin/io/Path.class \
	./glguerin/mac/io/MacEscaping.class  \
	./glguerin/mac/io/MacFilePathname.class \
	./glguerin/util/MacPlatform.class 

#****************************************************************************
#* NCSA HDF                                                                 *
#* National Comptational Science Alliance                                   *
#* University of Illinois at Urbana-Champaign                               *
#* 605 E. Springfield, Champaign IL 61820                                   *
#*                                                                          *
#* For conditions of distribution and use, see the accompanying             *
#* COPYING file.                                                            *
#*                                                                          *
#****************************************************************************/


VERSION=hdf-java-2.7

JAVAC           = /usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64/bin/javac
JAVADOC         = /usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64/bin/javadoc
JAR         	= /usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64/bin/jar
FIND            = /usr/bin/find
RM            = /bin/rm
JAVADOC_FLAGS   = -version -author
SLEXT=so
JSLEXT=so

CLASSPATH=/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64/jre/lib/rt.jar:/home/abyrne/HDF_Projects/HDFJava-J-Trunk:lib/fits.jar:lib/netcdf.jar
JH45INSTALLDIR=/home/abyrne/HDF_Projects/HDFJava-J-Trunk/bin
H45INC=
H4INC=/usr/local/bin/hdf4/include
H5INC=/usr/local/bin/hdf5.1.8/include

#make this relative to the source root...
LIBDIR=$(JH45INSTALLDIR)/lib
BINDIR=$(JH45INSTALLDIR)/bin
DOCDIR= $(JH45INSTALLDIR)/docs
UGDIR= $(JH45INSTALLDIR)/UsersGuide

HDFVIEWDISTFILES= ./ncsa/hdf/view/*.java $(HDFVIEWICONS)

HDFOBJDISTFILES= ./ncsa/hdf/object/*.java 

H4OBJDISTFILES= ./ncsa/hdf/object/h4/*.java 

H5OBJDISTFILES= ./ncsa/hdf/object/h5/*.java 

FITSDISTJARFILE = ./lib/fits.jar
NC2SDISTJARFILE = ./lib/netcdf.jar
JUNITSDISTJARFILE = ./lib/junit.jar

NC2OBJDISTFILES= ./ncsa/hdf/object/nc2/*.java ./lib/netcdf.jar 

NPOESSDISTFILES= ./ext/npoess/*.java 

FITSOBJDISTFILES= ./ncsa/hdf/object/fits/*.java ./lib/fits.jar 

TOPDIST=./VERSION ./COPYING ./Makefile.in \
	./Readme_binary_jre.txt ./Readme_binary.txt ./Readme.txt \
	./bin/hdfview.sh.in ./bin/hdfview.bat  \
	./runconfig-example.sh \
	./configure.in ./Config/config* ./Config/install-sh \
	./samples/* \
	./configure ./native/Makefile.in 

JHIDISTFILES=./native/hdflib/Makefile.in \
	./native/hdflib/*.c \
	./ncsa/hdf/hdflib/*.java

JHI5DISTFILES= ./native/hdf5lib/Makefile.in \
        ./native/hdf5lib/*.c ./native/hdf5lib/*.h \
        ./ncsa/hdf/hdf5lib/*.java  \
        ./ncsa/hdf/hdf5lib/callbacks/*.java \
        ./ncsa/hdf/hdf5lib/exceptions/*.java \
        ./ncsa/hdf/hdf5lib/structs/*.java 

EXAMPLESFILES=./examples/*.in ./examples/intro/*.java ./examples/intro/*.in ./examples/groups/*.java ./examples/groups/*.in ./examples/groups/*.h5 ./examples/datasets/*.java ./examples/datasets/*.in ./examples/datatypes/*.java ./examples/datatypes/*.in ./examples/testfiles/*.txt

TESTFILES=./test/Makefile.in ./test/object/misc/*.java ./test/object/misc/*.in \
          ./test/object/*.in ./test/object/*.java ./test/hdf5lib/*.in ./test/hd5lib/*.java

DOCFILES=./docs/*.html ./docs/*.gif ./docs/*.js ./docs/hdfview/*.html \
         ./docs/hdfview/*.gif ./docs/hdfview/ModularGuide/*.html \
         ./docs/hdfview/ModularGuide/*.gif ./docs/hdfview/UsersGuide/images/*.gif \
         ./docs/hdfview/UsersGuide/images/*.jpg ./docs/hdfview/UsersGuide/*.html

WINDOWSFILES=./windows/hdfview.bat ./windows/copy_hdf.bat ./windows/javabuild.bat  \
	./windows/javacheck.bat ./windows/javainstall.bat ./windows/jnibuild.bat \
	./windows/proj/all/hdfjava.sln ./windows/proj/jhdf/jhdf.vcproj ./windows/proj/jhdf5/jhdf5.vcproj
 

DISTFILES= $(TOPDIST) $(JHI5DISTFILES) $(JHIDISTFILES) $(HDFDISTFILES) $(HDFVIEWDISTFILES) $(HDFOBJDISTFILES) $(H4OBJDISTFILES) $(H5OBJDISTFILES) $(NC2OBJDISTFILES) $(FITSOBJDISTFILES) $(TESTFILES) $(DOCFILES) $(FITSDISTJARFILE) $(NC2DISTJARFILE) $(JUNITSDISTJARFILE) $(EXAMPLESFILES) $(WINDOWSFILES)


JHIPACKAGES = \
	ncsa.hdf.hdflib

JHI5PACKAGES = \
	ncsa.hdf.hdf5lib.callbacks \
	ncsa.hdf.hdf5lib.exceptions \
	ncsa.hdf.hdf5lib.structs \
	ncsa.hdf.hdf5lib 

HDFOBJPACKAGES = ncsa.hdf.object

H4OBJPACKAGES = ncsa.hdf.object.h4

H5OBJPACKAGES = ncsa.hdf.object.h5

NC2OBJPACKAGES = ncsa.hdf.object.nc2

FITSOBJPACKAGES = ncsa.hdf.object.fits

HDFVIEWPACKAGES= ncsa.hdf.view

TESTPACKAGES = test.object

NPOESSPACKAGES = ext.npoess


.SUFFIXES: .java .class

.java.class:
	$(JAVAC) -source 5 -classpath $(CLASSPATH) $<

all: natives packages do-examples

just-hdf4: hdflib jhdf-packages

just-hdf5: hdf5lib jhdf5-packages

install-just-hdf4: install-hdflib install-jhdf

install-just-hdf5: install-hdf5lib install-jhdf5

packages: jhdf-packages jhdf5-packages nc2-packages fits-packages jhdfobj-packages jhdfview-packages

jhdf-packages: 
	@if test -n "$(H4INC)" ; then $(MAKE) do-jhdf-packages; fi

do-jhdf-packages: $(JHIPACKAGES)  
	$(JAR) cf ./lib/jhdf.jar $(JHICLASSES)

jhdf5-packages: $(JHI5PACKAGES)  
	$(JAR) cf ./lib/jhdf5.jar $(JHI5CLASSES)

nc2-packages: $(NC2OBJPACKAGES)
	-mkdir -p ./lib/ext 
	$(JAR) cf ./lib/ext/nc2obj.jar $(NC2OBJCLASSES)

fits-packages: $(FITSOBJPACKAGES)
	-mkdir -p ./lib/ext 
	$(JAR) cf ./lib/ext/fitsobj.jar $(FITSOBJCLASSES)

jhdfobj-packages: $(HDFOBJPACKAGES)  
	$(JAR) cf ./lib/jhdfobj.jar $(HDFOBJCLASSES)
	@if test -n "$(H4INC)" ; then $(MAKE) do-jh4obj-packages ; fi
	@if test -n "$(H5INC)" ; then $(MAKE) do-jh5obj-packages ; fi

do-jh4obj-packages: $(H4OBJPACKAGES)  
	$(JAR) cf ./lib/jhdf4obj.jar $(H4OBJCLASSES)

do-jh5obj-packages: $(H5OBJPACKAGES)  
	$(JAR) cf ./lib/jhdf5obj.jar $(H5OBJCLASSES)

jhdfview-packages: $(HDFVIEWPACKAGES)  
	$(JAR) cf ./lib/jhdfview.jar $(HDFVIEWCLASSES) $(HDFVIEWICONS)

npoess-packages: $(NPOESSPACKAGES)
	-mkdir -p ./lib/ext 
	$(JAR) cf ./lib/ext/npoess.jar $(NPOESSCLASSES)

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

FORCE:

## revise arrangement of docs, java docs.

docs: javadocs

javadocs:
	-mkdir -p docs/javadocs;
	@if test -n "$(H45INC)" ; then \
	$(JAVADOC) -sourcepath $(CLASSPATH) -d ./docs/javadocs $(JAVADOC_FLAGS) $(JH45PACKAGES) ncsa.hdf.hdflib $(JHI5PACKAGES) $(HDFOBJPACKAGES) $(H4OBJPACKAGES) $(H5OBJPACKAGES); \
	else \
	$(JAVADOC) -sourcepath $(CLASSPATH) -d ./docs/javadocs $(JAVADOC_FLAGS) ncsa.hdf.hdflib $(JHI5PACKAGES) $(HDFOBJPACKAGES) $(H4OBJPACKAGES) $(H5OBJPACKAGES) ; \
	fi

tests:
	@if test -d "test"; then cd test; $(MAKE); fi

do-examples:
	@if test -d "examples"; then cd examples; $(MAKE); fi

clean-examples:
	@if test -d "examples"; then cd examples; $(MAKE) clean; fi

clean-test:
	@if test -d "test"; then  cd test; $(MAKE) clean; fi

clean: clean-natives clean-classes clean-test clean-examples

clean-classes:
	$(FIND) ./ncsa \( -name '#*' -o -name '*~' -o -name '*.class' \) -exec $(RM) -f {} \; ;\
	$(RM) -f ./lib/jhdf.jar
	$(RM) -f ./lib/jhdf5.jar
	$(RM) -f ./lib/jhdfobj.jar
	$(RM) -f ./lib/jhdf4obj.jar
	$(RM) -f ./lib/jhdf5obj.jar
	$(RM) -f ./lib/jhdfview.jar
	$(RM) -f ./lib/ext/nc2obj.jar
	$(RM) -f ./lib/ext/fitsobj.jar
	$(RM) -f ./lib/ext/npoess.jar

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

clean-docs:
	cd docs; \
	$(RM) *.html
	cd docs/javadocs; \
	$(RM) -r *.html

check: install $(TESTPACKAGES)
	cd test; \
	$(MAKE) check;
	cd examples; \
	$(MAKE) check;
	cd test/object/misc; $(MAKE) check-memory-leak;

install: install-lib install-jhdf install-jhdf5 install-jhdfobj install-jhdfview
	@echo "Install complete"

uninstall: uninstall-jhdfview uninstall-jhdfobj uninstall-lib uninstall-jhi uninstall-jhi5 

install-lib: natives
	-mkdir -p $(LIBDIR);
	-mkdir -p $(LIBDIR)/linux
	@if test -n "$(H5INC)" ; then \
	cp ./lib/linux/libjhdf5.$(JSLEXT) $(LIBDIR)/linux ; fi
	@if test -n "$(H4INC)" ; then \
	cp ./lib/linux/libjhdf.$(JSLEXT) $(LIBDIR)/linux ; fi
	@if test -n "$(H45INC)" ; then \
	cp ./lib/linux/libjh4toh5.$(JSLEXT) $(LIBDIR)/linux ; fi
	@echo "Install Natives complete"

install-hdflib: 
	@if test -n "$(H4INC)" ; then $(MAKE) do-install-hdflib ; fi

do-install-hdflib: hdflib
	-mkdir -p $(LIBDIR);
	-mkdir -p $(LIBDIR)/linux
	cp ./lib/linux/libjhdf.$(JSLEXT) $(LIBDIR)/linux
	@echo "Install Native HDF complete"

install-hdf5lib: hdf5lib
	@if test -n "$(H5INC)" ; then $(MAKE) do-install-hdf5lib ; fi

do-install-hdf5lib: hdf5lib
	-mkdir -p $(LIBDIR);
	-mkdir -p $(LIBDIR)/linux
	cp ./lib/linux/libjhdf5.$(JSLEXT) $(LIBDIR)/linux
	echo "Install Native HDF5 complete"

uninstall-lib:
	$(RM) -f $(LIBDIR)/linux/libjhdf.$(JSLEXT)
	$(RM) -f $(LIBDIR)/linux/libjhdf5.$(JSLEXT)

install-jars: install-jhdf install-jhdf5 install-jhdfobject install-jhdfview

install-jhdf: 
	@if test -n "$(H4INC)" ; then $(MAKE) do-install-jhdf ; fi

do-install-jhdf: jhdf-packages
	-mkdir -p $(LIBDIR);
	$(JAR) cf $(JH45INSTALLDIR)/lib/jhdf.jar $(JHICLASSES)
	@echo "Install JHI complete"

install-jhdf5: 
	@if test -n "$(H5INC)" ; then $(MAKE) do-install-jhdf5 ; fi

do-install-jhdf5: jhdf5-packages
	-mkdir -p $(LIBDIR);
	$(JAR) cf $(JH45INSTALLDIR)/lib/jhdf5.jar $(JHI5CLASSES)
	@echo "Install JHI5 complete"

install-jhdfobj: ncsa.hdf.object
	-mkdir -p $(LIBDIR);
	$(JAR) cf $(JH45INSTALLDIR)/lib/jhdfobj.jar $(HDFOBJCLASSES)
	@if test -n "$(H4INC)" ; then $(MAKE) do-install-jhdf4obj ; fi
	@if test -n "$(H5INC)" ; then $(MAKE) do-install-jhdf5obj ; fi
	@echo "Install HDFOBJ complete"

do-install-jhdf4obj: ncsa.hdf.object.h4
	-mkdir -p $(LIBDIR);
	$(JAR) cf $(JH45INSTALLDIR)/lib/jhdf4obj.jar $(H4OBJCLASSES)
	@echo "Install JHDF4 complete"

do-install-jhdf5obj: ncsa.hdf.object.h5
	-mkdir -p $(LIBDIR);
	$(JAR) cf $(JH45INSTALLDIR)/lib/jhdf5obj.jar $(H5OBJCLASSES)
	@echo "Install JHDF4 complete"

install-jhdfview: ncsa.hdf.view
	-mkdir -p $(LIBDIR);
	$(JAR) cf $(JH45INSTALLDIR)/lib/jhdfview.jar $(HDFVIEWCLASSES) $(HDFVIEWICONS)
	-mkdir -p $(LIBDIR)/ext
	$(JAR) cf $(JH45INSTALLDIR)/lib/ext/nc2obj.jar $(NC2OBJCLASSES)
	$(JAR) cf $(JH45INSTALLDIR)/lib/ext/fitsobj.jar $(FITSOBJCLASSES)
	$(RM) -rf $(UGDIR);
	-mkdir -p $(UGDIR);
	cp -R docs/hdfview/UsersGuide/* $(UGDIR);	
	$(RM) -rf $(UGDIR)/.svn
	$(RM) -rf $(UGDIR)/images/.svn
	-mkdir -p $(BINDIR);
	cp lib/netcdf.jar $(LIBDIR)
	cp lib/fits.jar $(LIBDIR)
	cp lib/junit.jar $(LIBDIR)
	cp bin/hdfview.sh $(BINDIR)
	chmod a+x $(BINDIR)/hdfview.sh
	@echo "Install HDFVIEW complete"

uninstall-jhi5: 
	$(RM) -f $(JH45INSTALLDIR)/lib/jhdf5.jar

uninstall-jhi: 
	$(RM) -f $(JH45INSTALLDIR)/lib/jhdf.jar

uninstall-jhdfobj: 
	$(RM) -f $(JH45INSTALLDIR)/lib/jhdfobj.jar
	$(RM) -f $(JH45INSTALLDIR)/lib/jhdf4obj.jar
	$(RM) -f $(JH45INSTALLDIR)/lib/jhdf5obj.jar

uninstall-jhdfview: 
	$(RM) -f $(JH45INSTALLDIR)/lib/jhdfview.jar;
	$(RM) -rf $(UGDIR)

install-docs: install-javadocs install-ug

install-javadocs:
	-mkdir -p $(DOCDIR)/javadocs;
	@if test -n "$(H45INC)" ; then \
	$(JAVADOC) -sourcepath $(CLASSPATH) -d $(DOCDIR)/javadocs $(JAVADOC_FLAGS) $(JH45PACKAGES) ncsa.hdf.hdflib $(JHI5PACKAGES) $(HDFOBJPACKAGES); \
	else \
	$(JAVADOC) -sourcepath $(CLASSPATH) -d $(DOCDIR)/javadocs $(JAVADOC_FLAGS) ncsa.hdf.hdflib $(JHI5PACKAGES) $(HDFOBJPACKAGES); \
	fi
	-mkdir -p $(DOCDIR)/javadocs/images;
	cp docs/javadocs/images/*.gif $(DOCDIR)/javadocs/images;

uninstall-javadocs:
	$(RM) -rf $(DOCDIR)/javadocs/*.html $(DOCDIR)/images

install-ug:
	-mkdir -p $(DOCDIR);
	-mkdir -p $(DOCDIR)/hdfview/UsersGuide;
	cp docs/hdfview/index.html $(DOCDIR)/hdfview/UsersGuide;
	cp docs/hdfview/UsersGuide/*.html $(DOCDIR)/hdfview/UsersGuide;
	-mkdir -p $(DOCDIR)/hdfview/UsersGuide/images;
	cp docs/hdfview/UsersGuide/images/*.gif $(DOCDIR)/hdfview/UsersGuide/images;
	-mkdir -p $(DOCDIR)/hdf-object;
	cp docs/hdf-object/*.html $(DOCDIR)/hdf-object;
	cp docs/hdf-object/*.jpg $(DOCDIR)/hdf-object;
	cp docs/hdf-object/*.h5 $(DOCDIR)/hdf-object;

uninstall-ug:
	$(RM) -rf $(DOCDIR)/hdfview/UsersGuide/*
	$(RM) -rf $(DOCDIR)/hdf-object/*

distclean: clean-natives clean-classes clean-test clean-examples
	$(RM) -f config.cache config.status config.log 
	$(RM) -rf ./lib/linux
	$(RM) -rf ./lib/jhdf.jar
	$(RM) -rf ./lib/jhdf4obj.jar
	$(RM) -rf ./lib/jhdf5.jar
	$(RM) -rf ./lib/jhdf5obj.jar
	$(RM) -rf ./lib/jhdfobj.jar
	$(RM) -rf ./lib/jhdfview.jar
	$(RM) -f ./native/Makefile
	$(RM) -rf ./native/hdflib/Makefile
	$(RM) -rf ./native/hdf5lib/Makefile
	$(RM) -rf ./test/Makefile
	$(RM) -rf ./test/hdf5lib/Makefile
	$(RM) -rf ./test/hdf5lib/*.sh
	$(RM) -rf ./test/object/misc/Makefile
	$(RM) -rf ./test/object/misc/*.sh
	$(RM) -rf ./examples/Makefile
	$(RM) -rf ./examples/intro/Makefile
	$(RM) -rf ./examples/groups/Makefile
	$(RM) -rf ./examples/datasets/Makefile
	$(RM) -rf ./examples/datatypes/Makefile
	$(RM) -rf ./examples/datatypes/runExample.sh
	$(RM) -rf ./Makefile

#build_package:
#	./build/JDK/builddist solaris
#	./build/JRE/buildjre solaris

src-dist: docs
	-mkdir -p hdf-java
	tar cvf $(VERSION)-x.tar $(DISTFILES) ; mv $(VERSION)-x.tar hdf-java/
	cd hdf-java ; tar xf $(VERSION)-x.tar ; $(RM) -f $(VERSION)-x.tar ; find . -name .svn -exec rm -rf {} \;
	cd ..
	tar cvf $(VERSION)-src.tar hdf-java/*
#	$(JAR) cvf $(VERSION)-src.jar hdf-java/*
	$(RM) -rf hdf-java


# --------
# Packages
# --------

ncsa.hdf.hdf5lib: \
	ncsa/hdf/hdf5lib/H5.class \
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

ncsa.hdf.hdf5lib.callbacks: \
	ncsa/hdf/hdf5lib/callbacks/Callbacks.class \
	ncsa/hdf/hdf5lib/callbacks/H5L_iterate_cb.class \
	ncsa/hdf/hdf5lib/callbacks/H5L_iterate_t.class

ncsa.hdf.hdf5lib.structs: \
	ncsa/hdf/hdf5lib/structs/H5_ih_info_t.class \
	ncsa/hdf/hdf5lib/structs/H5A_info_t.class \
	ncsa/hdf/hdf5lib/structs/H5G_info_t.class \
	ncsa/hdf/hdf5lib/structs/H5L_info_t.class \
	ncsa/hdf/hdf5lib/structs/H5O_info_t.class \
	ncsa/hdf/hdf5lib/structs/H5O_hdr_info_t.class

ncsa.hdf.hdflib: \
	ncsa/hdf/hdflib/HDFArray.class \
	ncsa/hdf/hdflib/HDFChunkInfo.class \
	ncsa/hdf/hdflib/HDFCompInfo.class \
	ncsa/hdf/hdflib/HDFConstants.class \
	ncsa/hdf/hdflib/HDFDeflateCompInfo.class \
	ncsa/hdf/hdflib/HDFDeprecated.class \
	ncsa/hdf/hdflib/HDFException.class \
	ncsa/hdf/hdflib/HDFIMCOMPCompInfo.class \
	ncsa/hdf/hdflib/HDFJPEGCompInfo.class \
	ncsa/hdf/hdflib/HDFJavaException.class \
	ncsa/hdf/hdflib/HDFLibrary.class \
	ncsa/hdf/hdflib/HDFLibraryException.class \
	ncsa/hdf/hdflib/HDFNBITChunkInfo.class \
	ncsa/hdf/hdflib/HDFNBITCompInfo.class \
	ncsa/hdf/hdflib/HDFNativeData.class \
	ncsa/hdf/hdflib/HDFNewCompInfo.class \
	ncsa/hdf/hdflib/HDFNotImplementedException.class \
	ncsa/hdf/hdflib/HDFOldCompInfo.class \
	ncsa/hdf/hdflib/HDFOldRLECompInfo.class \
	ncsa/hdf/hdflib/HDFRLECompInfo.class \
	ncsa/hdf/hdflib/HDFSKPHUFFCompInfo.class \
	ncsa/hdf/hdflib/HDFSZIPCompInfo.class \
	ncsa/hdf/hdflib/HDFTable.class 

ncsa.hdf.object: ncsa/hdf/object/Attribute.class \
	ncsa/hdf/object/CompoundDS.class \
	ncsa/hdf/object/DataFormat.class \
	ncsa/hdf/object/Dataset.class \
	ncsa/hdf/object/Group.class \
	ncsa/hdf/object/HObject.class \
	ncsa/hdf/object/ScalarDS.class \
	ncsa/hdf/object/Datatype.class \
	ncsa/hdf/object/FileFormat.class \
	ncsa/hdf/object/Metadata.class 

ncsa.hdf.object.h4:	ncsa/hdf/object/h4/H4GRImage.class \
	ncsa/hdf/object/h4/H4Group.class \
	ncsa/hdf/object/h4/H4SDS.class \
	ncsa/hdf/object/h4/H4Vdata.class \
	ncsa/hdf/object/h4/H4Datatype.class \
	ncsa/hdf/object/h4/H4File.class \

ncsa.hdf.object.h5:	ncsa/hdf/object/h5/H5CompoundDS.class \
	ncsa/hdf/object/h5/H5Group.class \
	ncsa/hdf/object/h5/H5ScalarDS.class \
	ncsa/hdf/object/h5/H5Datatype.class \
	ncsa/hdf/object/h5/H5File.class \

ncsa.hdf.object.nc2:	ncsa/hdf/object/nc2/NC2Dataset.class \
	ncsa/hdf/object/nc2/NC2Datatype.class \
	ncsa/hdf/object/nc2/NC2File.class \
	ncsa/hdf/object/nc2/NC2Group.class

ncsa.hdf.object.fits: ncsa/hdf/object/fits/FitsDataset.class \
	ncsa/hdf/object/fits/FitsDatatype.class \
	ncsa/hdf/object/fits/FitsFile.class \
	ncsa/hdf/object/fits/FitsGroup.class

ext.npoess:	ext/npoess/DataOptionNPOESS.class \
	ext/npoess/TreeViewNPOESS.class

#
# The test files are not included in the preliminary source release
#
test.object: test/object/misc/TestH4File.class \
	test/object/misc/TestH5File.class

#
#  The Hdfviewer
#
ncsa.hdf.view: ./ncsa/hdf/view/TreeView.class \
	./ncsa/hdf/view/FileConversionDialog.class \
	./ncsa/hdf/view/DataOptionDialog.class \
	./ncsa/hdf/view/HDFView.class \
	./ncsa/hdf/view/ImageView.class \
	./ncsa/hdf/view/TableView.class \
	./ncsa/hdf/view/TextView.class \
	./ncsa/hdf/view/ViewProperties.class \
	./ncsa/hdf/view/NewDatasetDialog.class \
	./ncsa/hdf/view/NewDatatypeDialog.class \
	./ncsa/hdf/view/NewLinkDialog.class \
	./ncsa/hdf/view/NewLinkDialog.class \
	./ncsa/hdf/view/NewTableDataDialog.class \
	./ncsa/hdf/view/NewFileDialog.class \
	./ncsa/hdf/view/UserOptionsDialog.class \
	./ncsa/hdf/view/DefaultFileFilter.class \
	./ncsa/hdf/view/MathConversionDialog.class \
	./ncsa/hdf/view/Tools.class \
	./ncsa/hdf/view/DataView.class \
	./ncsa/hdf/view/Chart.class \
	./ncsa/hdf/view/PaletteView.class \
	./ncsa/hdf/view/MetaDataView.class \
	./ncsa/hdf/view/HelpView.class \
	./ncsa/hdf/view/NewImageDialog.class \
	./ncsa/hdf/view/NewGroupDialog.class \
	./ncsa/hdf/view/NewAttributeDialog.class \
	./ncsa/hdf/view/DefaultImageView.class \
	./ncsa/hdf/view/DefaultTableView.class \
	./ncsa/hdf/view/DefaultTreeView.class \
	./ncsa/hdf/view/DefaultMetaDataView.class \
	./ncsa/hdf/view/DefaultTextView.class \
	./ncsa/hdf/view/ViewManager.class \
	./ncsa/hdf/view/DefaultPaletteView.class

# --------------
# Single targets
# --------------

H5:	ncsa/hdf/hdf5lib/H5.class
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
Callbacks:	ncsa/hdf/hdf5lib/callbacks/Callbacks.class
H5L_iterate_t:	ncsa/hdf/hdf5lib/callbacks/H5L_iterate_t.class
H5L_iterate_cb:	ncsa/hdf/hdf5lib/callbacks/H5L_iterate_cb.class
H5_ih_info_t:	ncsa/hdf/hdf5lib/structs/H5_ih_info_t.class
H5A_info_t:	ncsa/hdf/hdf5lib/structs/H5A_info_t.class
H5G_info_t:	ncsa/hdf/hdf5lib/structs/H5G_info_t.class
H5L_info_t:	ncsa/hdf/hdf5lib/structs/H5L_info_t.class
H5O_info_t:	ncsa/hdf/hdf5lib/structs/H5O_info_t.class
H5O_hdr_info_t:	ncsa/hdf/hdf5lib/structs/H5O_hdr_info_t.class
HDFArray:	ncsa/hdf/hdflib/HDFArray.class
HDFChunkInfo:	ncsa/hdf/hdflib/HDFChunkInfo.class
HDFCompInfo:	ncsa/hdf/hdflib/HDFCompInfo.class
HDFConstants:	ncsa/hdf/hdflib/HDFConstants.class
HDFDeflateCompInfo:	ncsa/hdf/hdflib/HDFDeflateCompInfo.class
HDFDeprecated:	ncsa/hdf/hdflib/HDFDeprecated.class
HDFException:	ncsa/hdf/hdflib/HDFException.class
HDFIMCOMPCompInfo:	ncsa/hdf/hdflib/HDFIMCOMPCompInfo.class
HDFJPEGCompInfo:	ncsa/hdf/hdflib/HDFJPEGCompInfo.class
HDFSZIPCompInfo:	ncsa/hdf/hdflib/HDFSZIPCompInfo.class
HDFJavaException:	ncsa/hdf/hdflib/HDFJavaException.class
HDFLibrary:	ncsa/hdf/hdflib/HDFLibrary.class
HDFLibraryException:	ncsa/hdf/hdflib/HDFLibraryException.class
HDFNBITChunkInfo:	ncsa/hdf/hdflib/HDFNBITChunkInfo.class
HDFNBITCompInfo:	ncsa/hdf/hdflib/HDFNBITCompInfo.class
HDFNativeData:	ncsa/hdf/hdflib/HDFNativeData.class
HDFNewCompInfo:	ncsa/hdf/hdflib/HDFNewCompInfo.class
HDFNotImplementedException:	ncsa/hdf/hdflib/HDFNotImplementedException.class
HDFOldCompInfo:	ncsa/hdf/hdflib/HDFOldCompInfo.class
HDFOldRLECompInfo:	ncsa/hdf/hdflib/HDFOldRLECompInfo.class
HDFRLECompInfo:	ncsa/hdf/hdflib/HDFRLECompInfo.class
HDFSKPHUFFCompInfo:	ncsa/hdf/hdflib/HDFSKPHUFFCompInfo.class
HDFTable:	ncsa/hdf/hdflib/HDFTable.class
Attribute: ncsa/hdf/object/Attribute.class
CompoundDS: ncsa/hdf/object/CompoundDS.class 
DataFormat: /ncsa/hdf/object/DataFormat.class 
Dataset: ncsa/hdf/object/Dataset.class 
Group:	ncsa/hdf/object/Group.class 
H4GRImage: ncsa/hdf/object/h4/H4GRImage.class 
H4Group:	ncsa/hdf/object/h4/H4Group.class 
H4SDS: ncsa/hdf/object/h4/H4SDS.class 
H4Vdata: ncsa/hdf/object/h4/H4Vdata.class 
H5Compound: ncsa/hdf/object/h5/H5CompoundDS.class 
H5Group: ncsa/hdf/object/h5/H5Group.class 
H5ScalarDS: ncsa/hdf/object/h5/H5ScalarDS.class 
HObject: ncsa/hdf/object/HObject.class 
ScalarDS: ncsa/hdf/object/ScalarDS.class
Metadata: ncsa/hdf/object/Metadata.class
FileFormat: ncsa/hdf/object/FileFormat.class
H4File: ncsa/hdf/object/h4/H4File.class
H5File: ncsa/hdf/object/h5/H5File.class
TreeView: ncsa/hdf/view/TreeView.class
ViewManager: ncsa/hdf/view/ViewManager.class
DataOptionDialog:	ncsa/hdf/view/DataOptionDialog.class
HDFView:	ncsa/hdf/view/HDFView.class
ImageView:	ncsa/hdf/view/ImageView.class
MetadataDialog:	ncsa/hdf/view/MetadataDialog.class
TableView:	ncsa/hdf/view/TableView.class
TextView:	ncsa/hdf/view/TextView.class
ViewProperties:	ncsa/hdf/view/ViewProperties.class
FileConversionDialog:	ncsa/hdf/view/FileConversionDialog.class
MathConversionDialog:	ncsa/hdf/view/MathConversionDialog.class
Tools:	ncsa/hdf/view/Tools.class
FitsDataset: ncsa/hdf/object/fits/FitsDataset.class
FitsDatatype: ncsa/hdf/object/fits/FitsDatatype.class
FitsFile: ncsa/hdf/object/fits/FitsFile.class
FitsGroup: ncsa/hdf/object/fits/FitsGroup.class
NC2Dataset: ncsa/hdf/object/nc2/NC2Dataset.class
NC2Datatype: ncsa/hdf/object/nc2/NC2Datatype.class
NC2File: ncsa/hdf/object/nc2/NC2File.class
NC2Group: ncsa/hdf/object/nc2/NC2Group.class
TreeViewNPOESS: ext/npoess/TreeViewNPOESS.class
DataOptionNPOESS: ext/npoess/DataOptionNPOESS.class

#  All classes that are built, including private classes:
#     This is what is loaded into the 'jar' file.
#


JHI5CLASSES= ./ncsa/hdf/hdf5lib/*.class \
        ./ncsa/hdf/hdf5lib/callbacks/*.class \
        ./ncsa/hdf/hdf5lib/structs/*.class \
        ./ncsa/hdf/hdf5lib/exceptions/*.class


JHICLASSES= ./ncsa/hdf/hdflib/*.class

HDFOBJCLASSES= ./ncsa/hdf/object/*.class

H4OBJCLASSES= ./ncsa/hdf/object/h4/*.class

H5OBJCLASSES= ./ncsa/hdf/object/h5/*.class

NC2OBJCLASSES= ./ncsa/hdf/object/nc2/*.class

NPOESSCLASSES= ./ext/npoess/*.class

FITSOBJCLASSES= ./ncsa/hdf/object/fits/*.class

HDFVIEWCLASSES=./ncsa/hdf/view/*.class

HDFVIEWICONS= ./ncsa/hdf/view/icons/*.gif \
        ./ncsa/hdf/view/*.html

##
#  Source to pack for distribution
##
JAVASRCS= \
./ncsa/hdf/hdf5lib/H5.java  \
./ncsa/hdf/hdf5lib/HDF5Constants.java  \
./ncsa/hdf/hdf5lib/HDF5GroupInfo.java  \
./ncsa/hdf/hdf5lib/HDFArray.java  \
./ncsa/hdf/hdf5lib/HDFNativeData.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5AtomException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5AttributeException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5BtreeException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5DataFiltersException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5DataStorageException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5DatasetInterfaceException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5DataspaceInterfaceException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5DatatypeInterfaceException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5Exception.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5ExternalFileListException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5FileInterfaceException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5FunctionArgumentException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5FunctionEntryExitException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5HeapException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5InternalErrorException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5JavaException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5LibraryException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5LowLevelIOException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5MetaDataCacheException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5ObjectHeaderException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5PropertyListInterfaceException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5ReferenceException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5ResourceUnavailableException.java  \
./ncsa/hdf/hdf5lib/exceptions/HDF5SymbolTableException.java  \
./ncsa/hdf/hdf5lib/callbacks/Callbacks.java \
./ncsa/hdf/hdf5lib/callbacks/H5L_iterate_cb.java \
./ncsa/hdf/hdf5lib/callbacks/H5L_iterate_t.java \
./ncsa/hdf/hdf5lib/structs/H5_ih_info_t.java \
./ncsa/hdf/hdf5lib/structs/H5A_info_t.java \
./ncsa/hdf/hdf5lib/structs/H5G_info_t.java \
./ncsa/hdf/hdf5lib/structs/H5L_info_t.java \
./ncsa/hdf/hdf5lib/structs/H5O_info_t.java \
./ncsa/hdf/hdf5lib/structs/H5O_hdr_info_t.java \
./ncsa/hdf/hdflib/HDFArray.java  \
./ncsa/hdf/hdflib/HDFChunkInfo.java  \
./ncsa/hdf/hdflib/HDFCompInfo.java  \
./ncsa/hdf/hdflib/HDFConstants.java  \
./ncsa/hdf/hdflib/HDFDeflateCompInfo.java  \
./ncsa/hdf/hdflib/HDFDeprecated.java  \
./ncsa/hdf/hdflib/HDFException.java  \
./ncsa/hdf/hdflib/HDFIMCOMPCompInfo.java  \
./ncsa/hdf/hdflib/HDFJPEGCompInfo.java  \
./ncsa/hdf/hdflib/HDFSZIPCompInfo.java  \
./ncsa/hdf/hdflib/HDFJavaException.java  \
./ncsa/hdf/hdflib/HDFLibrary.java  \
./ncsa/hdf/hdflib/HDFLibraryException.java  \
./ncsa/hdf/hdflib/HDFNBITChunkInfo.java  \
./ncsa/hdf/hdflib/HDFNBITCompInfo.java  \
./ncsa/hdf/hdflib/HDFNativeData.java  \
./ncsa/hdf/hdflib/HDFNewCompInfo.java  \
./ncsa/hdf/hdflib/HDFNotImplementedException.java  \
./ncsa/hdf/hdflib/HDFOldCompInfo.java  \
./ncsa/hdf/hdflib/HDFOldRLECompInfo.java  \
./ncsa/hdf/hdflib/HDFRLECompInfo.java  \
./ncsa/hdf/hdflib/HDFSKPHUFFCompInfo.java  \
./ncsa/hdf/hdflib/HDFTable.java  \
./ncsa/hdf/object/Attribute.java  \
./ncsa/hdf/object/CompoundDS.java  \
./ncsa/hdf/object/DataFormat.java  \
./ncsa/hdf/object/Dataset.java  \
./ncsa/hdf/object/Group.java  \
./ncsa/hdf/object/h4/H4GRImage.java  \
./ncsa/hdf/object/h4/H4Group.java  \
./ncsa/hdf/object/h4/H4SDS.java  \
./ncsa/hdf/object/h4/H4Vdata.java  \
./ncsa/hdf/object/h5/H5CompoundDS.java  \
./ncsa/hdf/object/h5/H5Group.java  \
./ncsa/hdf/object/h5/H5ScalarDS.java  \
./ncsa/hdf/object/HObject.java  \
./ncsa/hdf/object/ScalarDS.java \
./ncsa/hdf/object/Metadata.java \
./ncsa/hdf/object/FileFormat.java \
./ncsa/hdf/object/h4/H4File.java \
./ncsa/hdf/object/h5/H5File.java \
./ncsa/hdf/object/Datatype.java \
./ncsa/hdf/object/h4/H4Datatype.java \
./ncsa/hdf/object/h5/H5Datatype.java \
./ncsa/hdf/view/DataOptionDialog.java \
./ncsa/hdf/view/HDFView.java \
./ncsa/hdf/view/ImageView.java \
./ncsa/hdf/view/TableView.java \
./ncsa/hdf/view/TextView.java \
./ncsa/hdf/view/TreeView.java \
./ncsa/hdf/view/ViewManager.java \
./ncsa/hdf/view/ViewProperties.java \
./ncsa/hdf/view/NewAttributeDialog.java \
./ncsa/hdf/view/NewDatasetDialog.java \
./ncsa/hdf/view/NewDatatypeDialog.java \
./ncsa/hdf/view/NewLinkDialog.java \
./ncsa/hdf/view/NewTableDataDialog.java \
./ncsa/hdf/view/NewFileDialog.java \
./ncsa/hdf/view/NewGroupDialog.java \
./ncsa/hdf/view/DefaultFileFilter.java \
./ncsa/hdf/view/FileConversionDialog.java \
./ncsa/hdf/view/MathConversionDialog.java \
./ncsa/hdf/view/NewImageDialog.java \
./ncsa/hdf/view/UserOptionsDialog.java \
./ncsa/hdf/view/Tools.java \
./ncsa/hdf/view/Chart.java \
./ncsa/hdf/view/DataView.java \
./ncsa/hdf/view/DefaultImageView.java \
./ncsa/hdf/view/DefaultMetaDataView.java \
./ncsa/hdf/view/DefaultPaletteView.java \
./ncsa/hdf/view/DefaultTableView.java \
./ncsa/hdf/view/DefaultTextView.java \
./ncsa/hdf/view/DefaultTreeView.java \
./ncsa/hdf/view/MetaDataView.java \
./ncsa/hdf/view/HelpView.java \
./ncsa/hdf/view/PaletteView.java \
./test/object/misc/TestH4File.java \
./test/object/misc/TestH5File.java \
./ncsa/hdf/object/nc2/*.java \
./ncsa/hdf/object/fits/*.java \
./ext/npoess/*.java \


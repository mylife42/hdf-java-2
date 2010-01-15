package test.junit;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.File;

import ncsa.hdf.hdf5lib.H5;
import ncsa.hdf.hdf5lib.HDF5Constants;
import ncsa.hdf.hdf5lib.exceptions.HDF5LibraryException;
import ncsa.hdf.hdf5lib.structs.H5G_info_t;

import org.junit.After;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;

public class TestH5Giterate {
    private static final boolean is16 = H5.isAPI16;
    private static final String H5_FILE = "test/junit/h5ex_g_iterate.h5";
    int H5fid = -1;

    private final int _openGroup(int fid, String name) {
        int gid = -1;
        try {
            if (is16)
                gid = H5.H5Gopen(fid, name);
            else
                gid = H5.H5Gopen2(fid, name, HDF5Constants.H5P_DEFAULT);
        }
        catch (Throwable err) {
            gid = -1;
            err.printStackTrace();
            fail("H5.H5Gcreate: " + err);
        }

        return gid;
    }

    @Before
    public void openH5file()
            throws HDF5LibraryException, NullPointerException {
        H5fid = H5.H5Fopen(H5_FILE, HDF5Constants.H5F_ACC_RDONLY,
                HDF5Constants.H5P_DEFAULT);
    }

    @After
    public void deleteH5file() throws HDF5LibraryException {
        if (H5fid > 0) {
            H5.H5Fclose(H5fid);
        }
    }

    @Test
    public void testH5Gget_obj_info_all() {
        H5G_info_t info = null;

        int gid = _openGroup(H5fid, "/");

        try {
            info = H5.H5Gget_info(gid);
        }
        catch (Throwable err) {
            err.printStackTrace();
            fail("H5.H5Gget_info: " + err);
        }
        try {
            H5.H5Gclose(gid);
        }
        catch (Exception ex) {
        }
        assertNotNull(info);
        assertTrue("number of links is empty", info.nlinks > 0);
        String objNames[] = new String[(int) info.nlinks];
        int objTypes[] = new int[(int) info.nlinks];
        int lnkTypes[] = new int[(int) info.nlinks];
        long objRefs[] = new long[(int) info.nlinks];

        int names_found = 0;
        try {
            names_found = H5.H5Gget_obj_info_all(H5fid, "/", objNames,
                    objTypes, lnkTypes, objRefs);
        }
        catch (Throwable err) {
            err.printStackTrace();
            fail("H5.H5Gget_obj_info_all: " + err);
        }

        assertTrue("number found[" + names_found + "] different than expected["
                + objNames.length + "]", names_found == objNames.length);
        for (int i = 0; i < objNames.length; i++) {
            assertNotNull("name #" + i + " does not exist", objNames[i]);
            assertTrue(objNames[i].length() > 0);
            if (objTypes[i]==HDF5Constants.H5O_TYPE_GROUP) {
                assertTrue("Group is index: "+i + " ",i==2);
                assertTrue("Group is : "+objNames[i] + " ",objNames[i].compareToIgnoreCase("G1")==0);
            }
            else if (objTypes[i]==HDF5Constants.H5O_TYPE_DATASET) {
                assertTrue("Dataset is index: "+i + " ",(i==0)||(i==3));
                if(i==0)
                    assertTrue("Dataset is : "+objNames[i] + " ",objNames[i].compareToIgnoreCase("DS1")==0);
                else
                    assertTrue("Dataset is : "+objNames[i] + " ",objNames[i].compareToIgnoreCase("L1")==0);
            }
            else if (objTypes[i]==HDF5Constants.H5O_TYPE_NAMED_DATATYPE) {
                assertTrue("Datatype is index: "+i + " ",i==1);
                assertTrue("Datatype is : "+objNames[i] + " ",objNames[i].compareToIgnoreCase("DT1")==0);
            }
            else {
                fail("  Unknown at index: " + i + " " + objNames[i]);
            }
        }
    }

}
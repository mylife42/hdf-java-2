package test.junit;

import java.io.File;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import ncsa.hdf.hdf5lib.H5;
import ncsa.hdf.hdf5lib.exceptions.HDF5LibraryException;
import ncsa.hdf.hdf5lib.structs.H5G_info_t;
import ncsa.hdf.hdf5lib.HDF5Constants;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class TestH5Gbasic {
    private static final boolean is16 = H5.isAPI16;
    private static final String H5_FILE = "test.h5";
    int H5fid = -1;

    private final int _createGroup(int fid, String name) {
        int gid = -1;
        try {
            if (is16)
                gid = H5.H5Gcreate(fid, name, 0);
            else
                gid = H5.H5Gcreate2(fid, name, HDF5Constants.H5P_DEFAULT,
                        HDF5Constants.H5P_DEFAULT, HDF5Constants.H5P_DEFAULT);
        }
        catch (Throwable err) {
            err.printStackTrace();
            fail("H5.H5Gcreate: " + err);
        }

        return gid;
    }

    private final void _deleteFile(String filename) {
        File file = new File(filename);

        if (file.exists()) {
            try {
                file.delete();
            }
            catch (SecurityException e) {
                ;// e.printStackTrace();
            }
        }
    }

    @Before
    public void createH5file()
            throws HDF5LibraryException, NullPointerException {
        H5fid = H5.H5Fcreate(H5_FILE, HDF5Constants.H5F_ACC_TRUNC,
                HDF5Constants.H5P_DEFAULT, HDF5Constants.H5P_DEFAULT);
        H5.H5Fflush(H5fid, HDF5Constants.H5F_SCOPE_LOCAL);
    }

    @After
    public void deleteH5file() throws HDF5LibraryException {
        if (H5fid > 0) {
            H5.H5Fclose(H5fid);
        }
        _deleteFile(H5_FILE);
    }

    @Test(expected = HDF5LibraryException.class)
    public void testH5Gclose_invalid() throws Throwable, HDF5LibraryException {
        H5.H5Gclose(-1);
    }

    @Test(expected = NullPointerException.class)
    public void testH5Gcreate_null()
            throws Throwable, HDF5LibraryException, NullPointerException {
        int gid = -1;

        // it should fail because the group name is null
        if (is16)
            gid = H5.H5Gcreate(H5fid, null, 0);
        else
            gid = H5.H5Gcreate2(H5fid, null, HDF5Constants.H5P_DEFAULT,
                    HDF5Constants.H5P_DEFAULT, HDF5Constants.H5P_DEFAULT);

        try {
            H5.H5Gclose(gid);
        }
        catch (Exception ex) {
        }
    }

    @Test(expected = HDF5LibraryException.class)
    public void testH5Gcreate_invalid()
            throws Throwable, HDF5LibraryException, NullPointerException {
        if (is16)
            H5.H5Gcreate(-1, "Invalid ID", 0);
        else
            H5.H5Gcreate2(-1, "Invalid ID", HDF5Constants.H5P_DEFAULT,
                    HDF5Constants.H5P_DEFAULT, HDF5Constants.H5P_DEFAULT);
    }

    @Test
    public void testH5Gcreate() {
        int gid = -1;
        try {
            if (is16)
                gid = H5.H5Gcreate(H5fid, "/testH5Gcreate", 0);
            else
                gid = H5.H5Gcreate2(H5fid, "/testH5Gcreate",
                        HDF5Constants.H5P_DEFAULT, HDF5Constants.H5P_DEFAULT,
                        HDF5Constants.H5P_DEFAULT);
        }
        catch (Throwable err) {
            err.printStackTrace();
            fail("H5.H5Gcreate: " + err);
        }
        assertTrue(gid > 0);

        try {
            H5.H5Gclose(gid);
        }
        catch (Exception ex) {
        }
    }

    @Test
    public void testH5Gclose() {
        int gid = _createGroup(H5fid, "/testH5Gcreate");
        assertTrue(gid > 0);

        try {
            H5.H5Gclose(gid);
        }
        catch (Throwable err) {
            fail("H5Gclose: " + err);
        }
    }

    @Test(expected = HDF5LibraryException.class)
    public void testH5Gcreate_exists()
            throws Throwable, HDF5LibraryException, NullPointerException {
        int gid = _createGroup(H5fid, "/testH5Gcreate");
        assertTrue(gid > 0);

        try {
            H5.H5Gclose(gid);
        }
        catch (Exception ex) {
        }

        // it should failed now because the group already exists in file
        if (is16)
            gid = H5.H5Gcreate(H5fid, "/testH5Gcreate", 0);
        else
            gid = H5.H5Gcreate2(H5fid, "/testH5Gcreate",
                    HDF5Constants.H5P_DEFAULT, HDF5Constants.H5P_DEFAULT,
                    HDF5Constants.H5P_DEFAULT);
    }

    @Test
    public void testH5Gcreate_anon() {
        int gid = -1;
        try {
            gid = H5.H5Gcreate_anon(H5fid, HDF5Constants.H5P_DEFAULT,
                    HDF5Constants.H5P_DEFAULT);
        }
        catch (Throwable err) {
            err.printStackTrace();
            fail("H5.H5Gcreate_anon: " + err);
        }
        assertTrue(gid > 0);

        try {
            H5.H5Gclose(gid);
        }
        catch (Exception ex) {
        }
    }

    @Test(expected = NullPointerException.class)
    public void testH5Gopen_null()
            throws Throwable, HDF5LibraryException, NullPointerException {
        int gid = -1;

        if (is16)
            gid = H5.H5Gopen(H5fid, null);
        else
            gid = H5.H5Gopen2(H5fid, null, HDF5Constants.H5P_DEFAULT);
        ;

        try {
            H5.H5Gclose(gid);
        }
        catch (Exception ex) {
        }
    }

    @Test(expected = HDF5LibraryException.class)
    public void testH5Gopen_invalid()
            throws Throwable, HDF5LibraryException, NullPointerException {
        if (is16)
            H5.H5Gopen(-1, "Invalid ID");
        else
            H5.H5Gopen2(-1, "Invalid ID", HDF5Constants.H5P_DEFAULT);
        ;
    }

    @Test(expected = HDF5LibraryException.class)
    public void testH5Gopen_not_exists()
            throws Throwable, HDF5LibraryException, NullPointerException {
        int gid = -1;

        if (is16)
            gid = H5.H5Gopen(H5fid, "Never_created");
        else
            gid = H5
                    .H5Gopen2(H5fid, "Never_created", HDF5Constants.H5P_DEFAULT);
        ;

        try {
            H5.H5Gclose(gid);
        }
        catch (Exception ex) {
        }
    }

    @Test
    public void testH5Gopen() {
        int gid = _createGroup(H5fid, "/testH5Gcreate");
        assertTrue(gid > 0);

        try {
            if (is16)
                gid = H5.H5Gopen(H5fid, "/testH5Gcreate");
            else
                gid = H5.H5Gopen2(H5fid, "/testH5Gcreate",
                        HDF5Constants.H5P_DEFAULT);
            ;
        }
        catch (Throwable err) {
            err.printStackTrace();
            fail("H5.H5Gopen: " + err);
        }
        assertTrue(gid > 0);

        try {
            H5.H5Gclose(gid);
        }
        catch (Exception ex) {
        }
    }

    @Test(expected = HDF5LibraryException.class)
    public void testH5Gget_create_plist_invalid()
            throws Throwable, HDF5LibraryException {
        H5.H5Gget_create_plist(-1);
    }

    @Test
    public void testH5Gget_create_plist() {
        int pid = -1;
        int gid = _createGroup(H5fid, "/testH5Gcreate");
        assertTrue(gid > 0);

        try {
            pid = H5.H5Gget_create_plist(gid);
        }
        catch (Throwable err) {
            try {
                H5.H5Gclose(gid);
            }
            catch (Exception ex) {
            }
            err.printStackTrace();
            fail("H5.H5Gget_create_plist: " + err);
        }
        assertTrue(pid > 0);

        try {
            H5.H5Pclose(pid);
        }
        catch (Exception ex) {
        }

        try {
            H5.H5Gclose(gid);
        }
        catch (Exception ex) {
        }
    }

    @Test(expected = HDF5LibraryException.class)
    public void testH5Gget_info_invalid()
            throws Throwable, HDF5LibraryException {
        H5.H5Gget_info(-1);
    }

    @Test
    public void testH5Gget_info() {
        H5G_info_t info = null;
        int gid = _createGroup(H5fid, "/testH5Gcreate");
        assertTrue(gid > 0);

        try {
            info = H5.H5Gget_info(gid);
        }
        catch (Throwable err) {
            try {
                H5.H5Gclose(gid);
            }
            catch (Exception ex) {
            }
            err.printStackTrace();
            fail("H5.H5Gget_info: " + err);
        }
        assertNotNull(info);

        try {
            H5.H5Gclose(gid);
        }
        catch (Exception ex) {
        }
    }

    @Test(expected = NullPointerException.class)
    public void testH5Gget_info_by_name_null()
            throws Throwable, HDF5LibraryException, NullPointerException {
        H5.H5Gget_info_by_name(-1, null, HDF5Constants.H5P_DEFAULT);
    }

    @Test(expected = HDF5LibraryException.class)
    public void testH5Gget_info_by_name_invalid()
            throws Throwable, HDF5LibraryException, NullPointerException {
        H5.H5Gget_info_by_name(-1, "/testH5Gcreate", HDF5Constants.H5P_DEFAULT);
    }

    @Test(expected = HDF5LibraryException.class)
    public void testH5Gget_info_by_name_not_exists()
            throws Throwable, HDF5LibraryException, NullPointerException {
        H5.H5Gget_info_by_name(H5fid, "/testH5Gcreate",
                HDF5Constants.H5P_DEFAULT);
    }

    @Test
    public void testH5Gget_info_by_name() {
        H5G_info_t info = null;
        int gid = _createGroup(H5fid, "/testH5Gcreate");
        assertTrue(gid > 0);

        try {
            info = H5.H5Gget_info_by_name(gid, "/testH5Gcreate",
                    HDF5Constants.H5P_DEFAULT);
        }
        catch (Throwable err) {
            try {
                H5.H5Gclose(gid);
            }
            catch (Exception ex) {
            }
            err.printStackTrace();
            fail("H5.H5Gget_info_by_name: " + err);
        }
        assertNotNull(info);

        try {
            H5.H5Gclose(gid);
        }
        catch (Exception ex) {
        }
    }

    @Test
    public void testH5Gget_info_by_name_fileid() {
        H5G_info_t info = null;
        int gid = _createGroup(H5fid, "/testH5Gcreate");
        assertTrue(gid > 0);
        try {
            H5.H5Gclose(gid);
        }
        catch (Exception ex) {
        }

        try {
            info = H5.H5Gget_info_by_name(H5fid, "/testH5Gcreate",
                    HDF5Constants.H5P_DEFAULT);
        }
        catch (Throwable err) {
            try {
                H5.H5Gclose(gid);
            }
            catch (Exception ex) {
            }
            err.printStackTrace();
            fail("H5.H5Gget_info_by_name: " + err);
        }
        assertNotNull(info);

        try {
            H5.H5Gclose(gid);
        }
        catch (Exception ex) {
        }
    }

    @Test(expected = NullPointerException.class)
    public void testH5Gget_info_by_idx_null()
            throws Throwable, HDF5LibraryException, NullPointerException {
        H5.H5Gget_info_by_idx(-1, null, HDF5Constants.H5P_DEFAULT,
                HDF5Constants.H5_ITER_INC, 1, HDF5Constants.H5P_DEFAULT);
    }

    @Test(expected = HDF5LibraryException.class)
    public void testH5Gget_info_by_idx_invalid()
            throws Throwable, HDF5LibraryException, NullPointerException {
        H5.H5Gget_info_by_idx(-1, "/testH5Gcreate", HDF5Constants.H5P_DEFAULT,
                HDF5Constants.H5_ITER_INC, 1, HDF5Constants.H5P_DEFAULT);
    }

    @Test(expected = HDF5LibraryException.class)
    public void testH5Gget_info_by_idx_not_exists()
            throws Throwable, HDF5LibraryException, NullPointerException {
        H5.H5Gget_info_by_idx(H5fid, "/testH5Gcreate",
                HDF5Constants.H5_INDEX_NAME, HDF5Constants.H5_ITER_INC, 1,
                HDF5Constants.H5P_DEFAULT);
    }

    @Test
    public void testH5Gget_info_by_idx() {
        H5G_info_t info = null;
        int gid = _createGroup(H5fid, "/testH5Gcreate");
        assertTrue(gid > 0);

        try {
            info = H5.H5Gget_info_by_idx(gid, "/", HDF5Constants.H5_INDEX_NAME,
                    HDF5Constants.H5_ITER_INC, 0, HDF5Constants.H5P_DEFAULT);
        }
        catch (Throwable err) {
            err.printStackTrace();
            fail("H5.H5Gget_info_by_idx: " + err);
        }
        assertNotNull(info);

        try {
            H5.H5Gclose(gid);
        }
        catch (Exception ex) {
        }
    }

    @Test
    public void testH5Gget_info_by_idx_fileid() {
        H5G_info_t info = null;
        int gid = _createGroup(H5fid, "/testH5Gcreate");
        assertTrue(gid > 0);
        try {
            H5.H5Gclose(gid);
        }
        catch (Exception ex) {
        }

        try {
            info = H5.H5Gget_info_by_idx(H5fid, "/",
                    HDF5Constants.H5_INDEX_NAME, HDF5Constants.H5_ITER_INC, 0,
                    HDF5Constants.H5P_DEFAULT);
        }
        catch (Throwable err) {
            err.printStackTrace();
            fail("H5.H5Gget_info_by_idx: " + err);
        }
        assertNotNull(info);
    }

}
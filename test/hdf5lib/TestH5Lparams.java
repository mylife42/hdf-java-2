package test.hdf5lib;

import ncsa.hdf.hdf5lib.H5;
import ncsa.hdf.hdf5lib.exceptions.HDF5LibraryException;

import org.junit.Test;

public class TestH5Lparams {

    @Test(expected = HDF5LibraryException.class)
    public void testH5Lget_val_invalid() throws Throwable, HDF5LibraryException {
        H5.H5Lget_val(-1, "Bogus", -1);
    }

    @Test(expected = NullPointerException.class)
    public void testH5Lget_val_null() throws Throwable, HDF5LibraryException, NullPointerException {
        H5.H5Lget_val(-1, null, 0);
    }

    @Test(expected = HDF5LibraryException.class)
    public void testH5Lexists_invalid() throws Throwable, HDF5LibraryException {
        H5.H5Lexists(-1, "Bogus", -1);
    }

    @Test(expected = NullPointerException.class)
    public void testH5Lexists_null() throws Throwable, HDF5LibraryException, NullPointerException {
        H5.H5Lexists(-1, null, 0);
    }

    @Test(expected = HDF5LibraryException.class)
    public void testH5Lget_info_invalid() throws Throwable, HDF5LibraryException {
        H5.H5Lget_info(-1, "Bogus", -1);
    }

    @Test(expected = NullPointerException.class)
    public void testH5Lget_info_null() throws Throwable, HDF5LibraryException, NullPointerException {
        H5.H5Lget_info(-1, null, 0);
    }

    @Test(expected = HDF5LibraryException.class)
    public void testH5Lget_info_by_idx_invalid() throws Throwable, HDF5LibraryException {
        H5.H5Lget_info_by_idx(-1, "Bogus", -1, -1, -1, -1);
    }

    @Test(expected = NullPointerException.class)
    public void testH5Lget_info_by_idx_null() throws Throwable, HDF5LibraryException, NullPointerException {
        H5.H5Lget_info_by_idx(-1, null, 0, 0, 0, 0);
    }

}

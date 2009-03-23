/****************************************************************************
 * NCSA HDF                                                                 *
 * National Comptational Science Alliance                                   *
 * University of Illinois at Urbana-Champaign                               *
 * 605 E. Springfield, Champaign IL 61820                                   *
 *                                                                          *
 * For conditions of distribution and use, see the accompanying             *
 * hdf-java/COPYING file.                                                   *
 *                                                                          *
 ****************************************************************************/

package hdf.h4;

/**
 * <p>
 *  This class is a container for the parameters to the HDF
 *  DEFLATION compression algorithm.
 * <p>
 * In this case, the only parameter is the ``level'' of deflation.
 * <p>
 *  For details of the HDF libraries, see the HDF Documentation at:
 *     <a href="http://hdf.ncsa.uiuc.edu">http://hdf.ncsa.uiuc.edu</a>
 */


public class HDFDeflateCompInfo extends HDFNewCompInfo {

    public int level;

    public HDFDeflateCompInfo() {
        ctype = HDFConstants.COMP_CODE_DEFLATE;
    } ;
}



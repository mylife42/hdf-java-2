package hdf.h5.enums.H5Z;

import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;

//Filter IDs
public enum H5Z_filter_t {
	H5Z_FILTER_ERROR	      (-1),	//no filter
	H5Z_FILTER_NONE		       (0),	//reserved indefinitely
	H5Z_FILTER_DEFLATE	     (1), //deflation like gzip
	H5Z_FILTER_SHUFFLE       (2), //shuffle the data
	H5Z_FILTER_FLETCHER32    (3), //fletcher32 checksum of EDC
	H5Z_FILTER_SZIP          (4), //szip compression
	H5Z_FILTER_NBIT          (5), //nbit compression
	H5Z_FILTER_SCALEOFFSET   (6), //scale+offset compression
	H5Z_FILTER_RESERVED    (256),	//filter ids below this value are reserved for library use
	H5Z_FILTER_MAX		   (65535);	//maximum filter id
	
	// Special parameters for szip compression
	public static final int H5_SZIP_ALLOW_K13_OPTION_MASK  = 1;
	public static final int H5_SZIP_CHIP_OPTION_MASK       = 2;
	public static final int H5_SZIP_EC_OPTION_MASK         = 4;
	public static final int H5_SZIP_NN_OPTION_MASK         = 32;
	public static final int H5_SZIP_MAX_PIXELS_PER_BLOCK   = 32;

	// for the shuffle filter
	public static final int H5Z_SHUFFLE_USER_NPARMS   = 0; // Number of parameters that users can set
	public static final int H5Z_SHUFFLE_TOTAL_NPARMS  = 1; // Total number of parameters for filter

	// for the szip filter
	public static final int H5Z_SZIP_USER_NPARMS   = 2;    // Number of parameters that users can set
	public static final int H5Z_SZIP_TOTAL_NPARMS  = 4;    // Total number of parameters for filter
	public static final int H5Z_SZIP_PARM_MASK     = 0;    // "User" parameter for option mask
	public static final int H5Z_SZIP_PARM_PPB      = 1;    // "User" parameter for pixels-per-block
	public static final int H5Z_SZIP_PARM_BPP      = 2;    // "Local" parameter for bits-per-pixel
	public static final int H5Z_SZIP_PARM_PPS      = 3;    // "Local" parameter for pixels-per-scanline

	// for the nbit filter
	public static final int H5Z_NBIT_USER_NPARMS   = 0;    // Number of parameters that users can set

	// for the scale offset filter
  public static final int H5Z_SCALEOFFSET_USER_NPARMS = 2;  // Number of parameters that users can set

	private static final Map<Integer, H5Z_filter_t> lookup = new HashMap<Integer, H5Z_filter_t>();

	static {
		for (H5Z_filter_t s : EnumSet.allOf(H5Z_filter_t.class))
			lookup.put(s.getCode(), s);
	}

	private int code;

	H5Z_filter_t(int type) {
		this.code = type;
	}

	public int getCode() {
		return this.code;
	}

	public static H5Z_filter_t get(int code) {
		return lookup.get(code);
	}
}
/*****************************************************************************
 * Copyright by The HDF Group.                                               *
 * Copyright by the Board of Trustees of the University of Illinois.         *
 * All rights reserved.                                                      *
 *                                                                           *
 * This file is part of the HDF Java Products distribution.                  *
 * The full copyright notice, including terms governing use, modification,   *
 * and redistribution, is contained in the files COPYING and Copyright.html. *
 * COPYING can be found at the root of the source code distribution tree.    *
 * Or, see http://hdfgroup.org/products/hdf-java/doc/Copyright.html.         *
 * If you do not have access to either file, you may request a copy from     *
 * help@hdfgroup.org.                                                        *
 ****************************************************************************/

package hdf.h5.enums;

import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;

public enum H5_ITER {
  UNKNOWN (-1),     // Unknown order 
  INC     ( 0),     // Increasing order
  DEC     ( 1),     // Decreasing order
  NATIVE  ( 2),     // No particular order, whatever is fastest
  N	      ( 3);     // Number of iteration orders
	private static final Map<Integer, H5_ITER> lookup = new HashMap<Integer, H5_ITER>();

	static {
		for (H5_ITER s : EnumSet.allOf(H5_ITER.class))
			lookup.put(s.getCode(), s);
	}

	private int code;

	H5_ITER(int iter_order_type) {
		this.code = iter_order_type;
	}

	public int getCode() {
		return this.code;
	}

	public static H5_ITER get(int code) {
		return lookup.get(code);
	}

}

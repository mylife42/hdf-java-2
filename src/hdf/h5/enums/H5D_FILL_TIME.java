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

// Values for time of writing fill value property
public enum H5D_FILL_TIME {
  ERROR	(-1),
  ALLOC ( 0),
  NEVER	( 1),
  IFSET	( 2);
	private static final Map<Integer, H5D_FILL_TIME> lookup = new HashMap<Integer, H5D_FILL_TIME>();

	static {
		for (H5D_FILL_TIME s : EnumSet.allOf(H5D_FILL_TIME.class))
			lookup.put(s.getCode(), s);
	}

	private int code;

	H5D_FILL_TIME(int fill_time_type) {
		this.code = fill_time_type;
	}

	public int getCode() {
		return this.code;
	}

	public static H5D_FILL_TIME get(int code) {
		return lookup.get(code);
	}

}
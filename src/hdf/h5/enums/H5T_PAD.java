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

// Type of padding to use in other atomic types
public enum H5T_PAD {
  ERROR        (-1),   //error 
  ZERO         ( 0),   //always set to zero 
  ONE          ( 1),   //always set to one 
  BACKGROUND   ( 2),   //set to background value  
  NPAD         ( 3);   //THIS MUST BE LAST 
	private static final Map<Integer, H5T_PAD> lookup = new HashMap<Integer, H5T_PAD>();

	static {
		for (H5T_PAD s : EnumSet.allOf(H5T_PAD.class))
			lookup.put(s.getCode(), s);
	}

	private int code;

	H5T_PAD(int pad_type) {
		this.code = pad_type;
	}

	public int getCode() {
		return this.code;
	}

	public static H5T_PAD get(int code) {
		return lookup.get(code);
	}
}

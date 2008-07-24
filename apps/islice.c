/* 
 * islice -- Extract a slice, perpendicular to one of the coordinate axes,
 * from a FLASH output file stored at iRODS server. Selection of a slice is
 * based on the tool, extract_slice_from_chkpnt, developed by Paul Ricker 
 * (UIUC/NCSA).
 *
 * Typical usage from the command line might be:
 *      "islice [options] infile outfile pos var coor", where
 *          infile  -- the name of the FLASH file to read
 *
 * Output is an unformatted file containing the slice data, uniformly
 * sampled at the highest resolution in the dataset.  Blocks at lower
 * levels of refinement are simply injected to the highest level.
 *
 * This program must be linked against the HDF5/iRODS client module. Since
 * all file access is done at the server side, HDF5 library is not needed
 * to compile and run this program.
 *
 * Peter Cao (THG, xcao@hdfgroup.org)
 * Date 7/7/08 
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <math.h>

#include "clH5Handler.h"
#include "h5File.h"
#include "h5Dataset.h"
#include "h5Group.h"

#define JPEG

#ifdef JPEG
#include "jpeglib.h"
#include "jerror.h"
#endif

#define DEBUG
#define NAME_LENGTH 120
#define NCOLOR 256

#define DNAME_REFINE_LEVEL "refine level"
#define DNAME_NODE_TYPE "node type"
#define DNAME_BOUNDING_BOX "bounding box"

#define THROW_ERROR(_msg) { \
    fprintf(stderr, _msg); \
     ret_val = -1; \
     goto done; \
}

/*
 * Name:
 *      help
 *
 * Purpose:
 *      Print a helpful summary of command usage and features.
 */
static void 
help(char *name)
{
    (void) printf("\n\nNAME:\n\tislice -- Extract a slice from a FLASH output file\n\n");

    (void) printf("DESCRIPTION:\n\tislice -- Extract a slice, perpendicular to one of the coordinate axes,\n");
    (void) printf(              "\tfrom a FLASH output file stored at iRODS server. Selection of a slice is\n");
    (void) printf(              "\tbased on the tool, extract_slice_from_chkpnt, developed by Paul Ricker\n");
    (void) printf(              "\t(UIUC/NCSA).\n\n");

    (void) fprintf (stdout, "SYNOPSIS:");
    (void) fprintf (stdout, "\n\t%s -h[elp], OR", name);
    (void) fprintf (stdout, "\n\t%s [options] infile", name);

    (void) fprintf (stdout, "\n\n\t-h[elp]:");
    (void) fprintf (stdout, "\n\t\tPrint this summary of usage, and exit.");

    (void) fprintf (stdout, "\n\n\tinfile:");
    (void) fprintf (stdout, "\n\t\tName of the FLASH file to read");

    (void) fprintf (stdout, "\n\nOPTIONS:");
    (void) fprintf (stdout, "\n\t-o outfile:");
    (void) fprintf (stdout, "\n\t\tName of the output file to create");

    (void) fprintf (stdout, "\n\n\t-p position:");
    (void) fprintf (stdout, "\n\t\tOrientation of the slice (0 = xy, 1 = xz, 2 = yz)");

    (void) fprintf (stdout, "\n\n\t-m mesh_variable:");
    (void) fprintf (stdout, "\n\t\tName of the FLASH mesh variable");

    (void) fprintf (stdout, "\n\n\t-c coordinate:");
    (void) fprintf (stdout, "\n\t\tValue of the coordinate perpendicular to the slice");

    (void) fprintf (stdout, "\n\n\t-j jpegfile:");
    (void) fprintf (stdout, "\n\t\tName of the output jpeg file");

    (void) fprintf (stdout, "\n\n\t-t color_table:");
    (void) fprintf (stdout, "\n\t\tName of the file of the color table. The table must be a 256x3 2D array of RGB values\n\n");
}

/*
 * Name:
 *      usage
 *
 * Purpose:
 *      Print a summary of command usage.
 */
static void 
usage(char *name)
{
    (void) fprintf(stderr, "\nUsage:\t%s -h[elp], OR\n", name);
    (void) fprintf(stderr, "\t%s [options] infile\n", name);
}

/*
 * Name:
 *      trim
 *
 * Purpose:
 *     Trim white spaces in a string.
 */
static char *
trim(char *str, int len)
{
    int idx=0, n=len-1;
    char*  str_idx;

    str_idx = str;
    idx = 0;
    while (((int) *str_idx > 32) && (idx < n)) {
        idx++;
        str_idx++;
    }
    
    *(str+idx) = '\0';

    return str;
}

/*
 * Name:
 *      rodsConnect
 *
 * Purpose:
 *     Make connection to iRODS server.
 */
static rcComm_t *
rodsConnect()
{
    int status = 0;
    rodsEnv env;
    rcComm_t *conn=NULL;
    rErrMsg_t errMsg;

    status = getRodsEnv (&env);

    if (status < 0) {
        rodsLogError (LOG_ERROR, status, "main: getRodsEnv error. ");
        return NULL;
    }

    conn = rcConnect (env.rodsHost, env.rodsPort, env.rodsUserName, env.rodsZone, 1, &errMsg);

    if (conn == NULL) {
        rodsLogError (LOG_ERROR, errMsg.status, "rcConnect failure %s", errMsg.msg);
        return NULL;
    }

    status = clientLogin(conn);
    if (status != 0) {
        rcDisconnect(conn);
        return NULL;
    }

    return conn;
}

/* get default outfile name. */
static void 
get_defualt_outfile_name(const char *infile, char *outfile, int pos, 
    const char *var, float coor, int dims[], const char *ext)
{
    char   infile_cp[NAME_LENGTH];

    if (outfile==NULL || strlen(outfile) > 0)
        return;

    strcpy(infile_cp, infile);

    char *tmpfile = strrchr(infile, '/');
    if (tmpfile == NULL)
        tmpfile = infile_cp;
    else
        tmpfile++;

    switch (pos) {
       case 1:
           sprintf(outfile, "%s_%s_xz_%f_%dx%d.%s", tmpfile, var, coor, dims[0], dims[1], ext);
           break;
       case 2:
           sprintf(outfile, "%s_%s_yz_%f_%dx%d.%s", tmpfile, var, coor, dims[0], dims[1], ext);
           break;
       default:
           sprintf(outfile, "%s_%s_xy_%f_%dx%d.%s", tmpfile, var, coor, dims[0], dims[1], ext);
           break;
    }

    trim(outfile, NAME_LENGTH);
}


#ifdef JPEG
/*
 * Write data into a JPEG file
 */
static void
write_jpeg_file(const char *fname, JSAMPLE *buf, int height, 
     int width, int ncomp, int quality)
{
    /* jpeg file */
    FILE *jpeg_file;

    /* JPEG compression parameters */
    struct jpeg_compress_struct cinfo;

    /* JPEG error handler. */
    struct jpeg_error_mgr jerr;

    /* pointer to JSAMPLE row[s] */
    JSAMPROW row_pointer[1];

    /* physical row width in image buffer */
    int row_stride;
    
    /* allocate and initialize JPEG compression object */
    cinfo.err = jpeg_std_error(&jerr);
    jpeg_create_compress(&cinfo);
    
    /* create a jpeg file */
    if ((jpeg_file = fopen(fname, "wb")) == NULL) {
        fprintf(stderr, "can't open %s\n", fname);
        exit(1);
    }
    jpeg_stdio_dest(&cinfo, jpeg_file);
    
    /* set parameters for compression */
    cinfo.image_width = width;
    cinfo.image_height = height;
    cinfo.input_components = ncomp;
    cinfo.in_color_space = JCS_RGB; 
    jpeg_set_defaults(&cinfo);
    jpeg_set_quality(&cinfo, quality, TRUE);
    
    /* write image by scan lines */
    jpeg_start_compress(&cinfo, TRUE);
    row_stride = width * ncomp;
    
    while (cinfo.next_scanline < cinfo.image_height) {
        row_pointer[0] = & buf[cinfo.next_scanline * row_stride];
        (void) jpeg_write_scanlines(&cinfo, row_pointer, 1);
    }
    jpeg_finish_compress(&cinfo);

    fclose(jpeg_file);
    jpeg_destroy_compress(&cinfo);
}
#endif

static float *
get_slice(const char *infile, int pos, const char *var, 
          float coor, int *sizes)
{
    /* slcice parameter */
    int    c, b, select;
    int    i1, i2, j1, j2, i, j, k, ii, jj;
    int    tot_blocks, lrefmin, lrefmax;
    int    Nx, Ny, N1, N2, Nz, N1b, N2b, N1r, N2r, nxb, nyb, nzb;
    float  dx1, dx2, xm1, xm2;
    float  xmin, xmax, ymin, ymax, zmin, zmax;
    float  dx, dy, dz;
    int    rebin_factor;
    int    *lrefine, *nodetype;
    float  *slice=NULL;
    double *data, *bnd_box;

    size_t *dims, *start, *stride, *count;

    /* iRODS connection */
    rcComm_t *conn = NULL;

    /* HDF5 objects */
    H5File *h5file=NULL;
    H5Dataset *h5dset=NULL;

    int ret_val = 0;

    conn = rodsConnect();
    if (conn == NULL)
        THROW_ERROR("Failed to make connection to iRODS server.");

    /* initialize file object */
    h5file = (H5File*)malloc(sizeof(H5File));
    H5File_ctor(h5file);
    h5file->filename = (char*)malloc(strlen(infile)+1);
    strcpy(h5file->filename, infile);

    /* open the file at the server and get the file structure */
    h5file->opID = H5FILE_OP_OPEN;
    ret_val = h5ObjRequest(conn, h5file, H5OBJECT_FILE);
    if (ret_val < 0 || h5file->fid < 0) 
        THROW_ERROR ("H5FILE_OP_OPEN failed.");

    /* get refine level */
    for (i=0; i<h5file->root->ndatasets; i++) {
        h5dset = (H5Dataset *) &(h5file->root->datasets[i]);
        if (strcmp(h5dset->fullpath+1, DNAME_REFINE_LEVEL) == 0)
            break;
        else 
            h5dset = NULL;
    }
    if (h5dset == NULL)
        THROW_ERROR("Failed to open dataset: REFINE_LEVEL.");

    h5dset->opID = H5DATASET_OP_READ;
    ret_val = h5ObjRequest(conn, h5dset, H5OBJECT_DATASET);
    if (ret_val < 0)
        THROW_ERROR("H5DATASET_OP_READ failed.");

    tot_blocks = h5dset->space.dims[0];
    lrefine   = (int *)h5dset->value;

#ifdef DEBUG
    printf("refine level:\n");
    for (i = 0; i < tot_blocks; i++)
        printf("%d, ", lrefine[i]);
    puts("\n");
#endif

    /* get node type */
    for (i=0; i<h5file->root->ndatasets; i++) {
        h5dset = (H5Dataset *) &(h5file->root->datasets[i]);
        if (strcmp(h5dset->fullpath+1, DNAME_NODE_TYPE) == 0)
            break;
        else 
            h5dset = NULL;
    }
    if (h5dset == NULL)
        THROW_ERROR("Failed to open dataset: NODE_TYPE.");

    h5dset->opID = H5DATASET_OP_READ;
    ret_val = h5ObjRequest(conn, h5dset, H5OBJECT_DATASET);
    if (ret_val < 0)
        THROW_ERROR("H5DATASET_OP_READ failed.");
    nodetype   = (int *)h5dset->value;
    
#ifdef DEBUG
    printf("node type:\n");
    for (i = 0; i < tot_blocks; i++)
        printf("%d, ", nodetype[i]);
    puts("\n");
#endif

    /* get bounding box */
    for (i=0; i<h5file->root->ndatasets; i++) {
        h5dset = (H5Dataset *) &(h5file->root->datasets[i]);
        if (strcmp(h5dset->fullpath+1, DNAME_BOUNDING_BOX) == 0)
            break;
        else 
            h5dset = NULL;
    }
    if (h5dset == NULL)
        THROW_ERROR("Failed to open dataset: BOUNDING_BOX.");

    h5dset->opID = H5DATASET_OP_READ;
    ret_val = h5ObjRequest(conn, h5dset, H5OBJECT_DATASET);
    if (ret_val < 0)
        THROW_ERROR("H5DATASET_OP_READ failed.");
    bnd_box   = (double *)h5dset->value;

    xmin =  1.E99;
    xmax = -1.E99;
    ymin =  1.E99;
    ymax = -1.E99;
    zmin =  1.E99;
    zmax = -1.E99;

    for (i = 0; i < 6*tot_blocks; i += 6) {
        if (bnd_box[i  ] < xmin) { xmin = bnd_box[i  ]; }
        if (bnd_box[i+1] > xmax) { xmax = bnd_box[i+1]; }
        if (bnd_box[i+2] < ymin) { ymin = bnd_box[i+2]; }
        if (bnd_box[i+3] > ymax) { ymax = bnd_box[i+3]; }
        if (bnd_box[i+4] < zmin) { zmin = bnd_box[i+4]; }
        if (bnd_box[i+5] > zmax) { zmax = bnd_box[i+5]; }
    }

#ifdef DEBUG
    printf("bounding box:\n");
    printf("  x = %e ... %e\n", xmin, xmax);
    printf("  y = %e ... %e\n", ymin, ymax);
    printf("  z = %e ... %e\n", zmin, zmax);
#endif

    lrefmin = 100000;
    lrefmax = 0;

    for (i = 0; i < tot_blocks; i++) {
        if (lrefine[i] < lrefmin) { lrefmin = lrefine[i]; }
        if (lrefine[i] > lrefmax) { lrefmax = lrefine[i]; }
    }

    printf("refinement levels: %d ... %d\n", lrefmin, lrefmax);

    for (i=0; i<h5file->root->ndatasets; i++) {
        h5dset = (H5Dataset *) &(h5file->root->datasets[i]);
        if (strcmp(h5dset->fullpath+1, var) == 0)
            break;
        else 
            h5dset = NULL;
    }
    if (h5dset == NULL)
        THROW_ERROR("Failed to open dataset.");

    dims = h5dset->space.dims;
    start = h5dset->space.start;
    stride = h5dset->space.stride;
    count = h5dset->space.count;

    nxb  = (int)dims[3];
    nyb  = (int)dims[2];
    nzb  = (int)dims[1];

    start[0]  = 0;
    start[1]  = 0;
    start[2]  = 0;
    start[3]  = 0;
    stride[0] = 1;
    stride[1] = 1;
    stride[2] = 1;
    stride[3] = 1;
    count[0]  = 1;
    count[1]  = dims[1];
    count[2]  = dims[2];
    count[3]  = dims[3];

    Nx = dims[3];
    Ny = dims[2];
    Nz = dims[1];
    for (i = 0; i < lrefmax-1; i++) {
        Nx *= 2;
        Ny *= 2;
        Nz *= 2;
    }

    if (pos == 0) {
        slice = (float *)malloc(Nx*Ny*sizeof(float));
        N1    = Nx;
        N2    = Ny;
        N1b   = dims[3];
        N2b   = dims[2];
        dx1   = (xmax - xmin) / ((float)N1);
        xm1   = xmin;
        dx2   = (ymax - ymin) / ((float)N2);
        xm2   = ymin;
    } else if (pos == 1) {
        slice = (float *)malloc(Nx*Nz*sizeof(float));
        N1    = Nx;
        N2    = Nz;
        N1b   = dims[3];
        N2b   = dims[1];
        dx1   = (xmax - xmin) / ((float)N1);
        xm1   = xmin;
        dx2   = (zmax - zmin) / ((float)N2);
        xm2   = zmin;
    } else {
        slice = (float *)malloc(Ny*Nz*sizeof(float));
        N1    = Ny;
        N2    = Nz;
        N1b   = dims[2];
        N2b   = dims[1];
        dx1   = (ymax - ymin) / ((float)N1);
        xm1   = ymin;
        dx2   = (zmax - zmin) / ((float)N2);
        xm2   = zmin;
    }

#ifdef DEBUG
    printf("slice grid size:  %d x %d\n", N1, N2);
    printf("min zone spacing: %e x %e\n", dx1, dx2);
#endif

    c = 0;
    for (b = 0; b < tot_blocks; b++) {
        c = 6*b;

        if (nodetype[b] != 1)
            continue;
/*
#ifdef DEBUG
    printf("block %d, level %d\n", b, lrefine[b]);
    printf(" x --> %e  %e\n", bnd_box[c  ], bnd_box[c+1]);
    printf(" y --> %e  %e\n", bnd_box[c+2], bnd_box[c+3]);
    printf(" z --> %e  %e\n", bnd_box[c+4], bnd_box[c+5]);
#endif
*/

        dx = (float)(bnd_box[c+1] - bnd_box[c  ]) / ((float)dims[3]);
        dy = (float)(bnd_box[c+3] - bnd_box[c+2]) / ((float)dims[2]);
        dz = (float)(bnd_box[c+5] - bnd_box[c+4]) / ((float)dims[1]);

        select = 0;
        switch (pos) {
            case 0: 
                if ((bnd_box[c+4] <= coor) && (bnd_box[c+5] > coor)) select = 1;
                break;
            case 1: 
                if ((bnd_box[c+2] <= coor) && (bnd_box[c+3] > coor)) select = 1;
                break;
            case 2: 
                if ((bnd_box[c  ] <= coor) && (bnd_box[c+1] > coor)) select = 1;
                break;
        } /* switch (pos) */

        if (select != 1) 
            continue;

        rebin_factor = 1;
        for (i = 0; i < lrefmax-lrefine[b]; i++) {
            rebin_factor *= 2;
        }
        N1r = N1b * rebin_factor;
        N2r = N2b * rebin_factor;
    
        start[0] = b;
        h5dset->opID = H5DATASET_OP_READ;
        ret_val = h5ObjRequest(conn, h5dset, H5OBJECT_DATASET);
        if (ret_val < 0)
            THROW_ERROR("H5DATASET_OP_READ failed.");
        data = (double *)h5dset->value;
    
        switch (pos) {
            case 0: 
                i1 = (int)((bnd_box[c  ] - xm1)/dx1);
                i2 = (int)((bnd_box[c+1] - xm1)/dx1);
                j1 = (int)((bnd_box[c+2] - xm2)/dx2);
                j2 = (int)((bnd_box[c+3] - xm2)/dx2);
                k  = (int)((coor - bnd_box[c+4])/dz);
    
                for (j = j1; j < j2; j++) {
                    for (i = i1; i < i2; i++) {
                        ii = (i-i1)/rebin_factor;
                        jj = (j-j1)/rebin_factor;
                        slice[i+j*N1] = (float)data[ii+jj*N1b+k*N1b*N2b];
                    }
                }
                break;
            case 1: 
                i1 = (int)((bnd_box[c  ] - xm1)/dx1);
                i2 = (int)((bnd_box[c+1] - xm1)/dx1);
                j1 = (int)((bnd_box[c+4] - xm2)/dx2);
                j2 = (int)((bnd_box[c+5] - xm2)/dx2);
                k  = (int)((coor - bnd_box[c+2])/dy);
                for (j = j1; j < j2; j++) {
                    for (i = i1; i < i2; i++) {
                        ii = (i-i1)/rebin_factor;
                        jj = (j-j1)/rebin_factor;
                        slice[i+j*N1] = (float)data[ii+k*N1b+jj*N1b*N2b];
                    }
                }
                break;
            case 2: 
                i1 = (int)((bnd_box[c+2] - xm1)/dx1);
                i2 = (int)((bnd_box[c+3] - xm1)/dx1);
                j1 = (int)((bnd_box[c+4] - xm2)/dx2);
                j2 = (int)((bnd_box[c+5] - xm2)/dx2);
                k  = (int)((coor - bnd_box[c  ])/dx);
                for (j = j1; j < j2; j++) {
                    for (i = i1; i < i2; i++) {
                        ii = (i-i1)/rebin_factor;
                        jj = (j-j1)/rebin_factor;
                        slice[i+j*N1] = (float)data[k+ii*N1b+jj*N1b*N2b];
                    }
                }
                break;
        } /* switch (pos) */
    } /* for (b = 0; b < tot_blocks; b++) */

    sizes[0] = N1;
    sizes[1] = N2;

#ifdef DEBUG
    puts("slice data:");
    for (i=0; i<10; i++) {
        for (j=0; j<10; j++) {
            printf("%f, ", slice[N2*i+j]);
        }
        printf("\n");
     }
     puts("\n");
#endif

done:

    /* close remote file and clean memeory space held by the file object */
    if (h5file) {
        if (h5file->fid > 0) {
            h5file->opID = H5FILE_OP_CLOSE;
            h5ObjRequest(conn, h5file, H5OBJECT_FILE);
        }
        H5File_dtor(h5file);
        free(h5file);
    }

    if (ret_val<0 && slice) {
        free (slice);
        slice = NULL;
    }

    rcDisconnect(conn);

    return slice;

}

/* write data into raw float data to file */
static void
write_float(const char *infile, char *outfile, int pos, const char *var, 
          float coor, int dims[], float *slice)
{
    FILE*  outfilePtr;

    if (strlen(outfile)<1)
        get_defualt_outfile_name (infile, outfile, pos, var, coor, dims, "out");

    outfilePtr = fopen(outfile, "w");
    fwrite(slice, dims[0]*dims[1]*sizeof(float), 1, outfilePtr);
    fclose(outfilePtr);
}

#ifdef JPEG
/* write data to jpeg file */
static void
write_jpeg(const char *infile, char *outfile, int pos, const char *var,
          float coor, int dims[], float *slice, const char *palfile)
{
    float min, max, ratio;
    int i, idx, npoints;
    unsigned char pal[NCOLOR*3]; /* color table of RGB */
    unsigned char *idx_values=NULL;
    unsigned char *pixel_values=NULL;
    unsigned char is_log_scaling=0;
    unsigned char has_color_table=0;

    if (dims == NULL || slice==NULL || (npoints = dims[0] * dims[1])<1 )
        goto done;

    if (strlen(outfile)<1)
        get_defualt_outfile_name (infile, outfile, pos, var, coor, dims, "jpeg");
 
    /* read R, G, B color table */
    if (palfile) {
        FILE * pFile;
        int r, g, b;

        pFile = fopen (palfile,"r");
        if (pFile != NULL) {
            idx = 0; 
            while (fscanf(pFile, "%d %d %d", &r, &g, &b) == 3) {
                pal[3*idx] = (unsigned char)r;
                pal[3*idx+1] = (unsigned char)g;
                pal[3*idx+2] = (unsigned char)b;
                idx++;
                if (idx > 255)
                    break;
            }
            if (idx > 255)
                has_color_table = 1;

            fclose(pFile);
        }
    }

    /* find min and max */
    min = max = slice[0];
    for (i=0; i<npoints; i++) {
        min = fminf(min, slice[i]);
        max = fmaxf(max, slice[i]);
    }

    if (max < min)
        max = (2.0 * fabs(min)) + 1.0;  // Make something up ...

    /* using log10 scaling */
    if (min>=0) {
        is_log_scaling = 1;
        min = log10f(min);
        max = log10f(max);
    }

    /* convert float value to image data */
    idx_values = (unsigned char*)malloc(npoints);
    pixel_values = (unsigned char*)malloc(npoints*3);
    ratio = (min==max) ? 1.0f : (float)(255.0/(max-min));
    for (i=0; i<npoints; i++) {
        if (is_log_scaling)
            idx_values[i] = idx = (unsigned char) ((log10f(slice[i])-min)*ratio);
        else
            idx_values[i] = idx = (unsigned char) ((slice[i]-min)*ratio);

        if (has_color_table) {
            pixel_values[i*3] = pal[idx*3];
            pixel_values[i*3+1] = pal[idx*3+1];
            pixel_values[i*3+2] = pal[idx*3+2];
        } else {
            /* use defualt grey scale */
            pixel_values[i*3] = pixel_values[i*3+1] = pixel_values[i*3+2] = idx_values[i];
        }
    }

    write_jpeg_file(outfile, (JSAMPLE *)pixel_values, dims[0], dims[1], 3, 100);

done:
    if (idx_values) 
        free(idx_values);

    if (pixel_values)
        free(pixel_values);
}
#endif

int main(int argc, char* argv[])
{
    /* input parameters from commandline */
    char   infile[NAME_LENGTH];
    char   outfile[NAME_LENGTH];
    char   jpgfile[NAME_LENGTH];     /* jpeg output file */
    char   palfile[NAME_LENGTH];     /* palette file     */
    int    i, pos=0, dims[2];
    char   var[5];
    float  coor=0.0, *slice=NULL;
    int ret_val = 0;

    /*
     * validate the number of command line arguments
     */
    if (argc < 2) {
        (void) fprintf(stderr, "Invalid command line arguments.\n");
        usage(argv[0]);
        exit(1);
    }

    outfile[0] = infile[0] = jpgfile[0] = palfile[0] = '\0';
    strcpy(var, "dens");
    for (i=1; i<argc; i++) {
        if (strncmp(argv[i], "-h", 2) == 0) {
            help(argv[0]);
            exit(1);
        } else if (strncmp(argv[i], "-o", 2) == 0) {
            strcpy(outfile, argv[++i]);     
        } else if (strncmp(argv[i], "-p", 2) == 0) {
            pos = atoi(argv[++i]); 
        } else if (strncmp(argv[i], "-m", 2) == 0) {
            strncpy(var, argv[++i], 5);
        } else if (strncmp(argv[i], "-c", 2) == 0) {
            coor = atof(argv[++i]);
        } else if (strncmp(argv[i], "-j", 2) == 0) {
            strcpy(jpgfile, argv[++i]);     
        } else if (strncmp(argv[i], "-t", 2) == 0) {
            strcpy(palfile, argv[++i]);     
        } 
    }
    strcpy(infile, argv[--i]);

    trim(infile, NAME_LENGTH);
    trim(var, 5);

    if ( (slice=get_slice(infile, pos, var, coor, dims)) ) {
        write_float(infile, outfile, pos, var, coor, dims, slice);

        /* write data into an image file */
    }

#ifdef JPEG
    if (slice)
        write_jpeg(infile, jpgfile, pos, var, coor, dims, slice, palfile);
#endif

    if (slice)
        free (slice);

    return ret_val;
}

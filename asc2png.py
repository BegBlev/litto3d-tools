import argparse
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import LightSource
import matplotlib.image

def read_asc(filename):
    with open(filename) as ascfile:
        line = ascfile.readline()

        words = line.split()

        assert words[0] == "ncols"
        ncols = int(words[1])

        line = ascfile.readline()

        words = line.split()

        assert words[0] == "nrows"
        nrows = int(words[1])

        line = ascfile.readline()

        words = line.split()

        assert words[0] == "xllcenter"
        xllcenter = float(words[1])

        line = ascfile.readline()

        words = line.split()

        assert words[0] == "yllcenter"
        yllcenter = float(words[1])

        line = ascfile.readline()

        words = line.split()

        assert words[0] == "cellsize"
        cellsize = float(words[1])

        line = ascfile.readline()

        words = line.split()

        assert words[0] == "nodata_value"
        nodata_value = float(words[1])

        elevation = np.loadtxt(ascfile)
        elevation = np.ma.masked_where(elevation == nodata_value, elevation)

        return elevation

def get_hillshading(elevation, ve=10, vmin=None, vmax=None):
    # Shade from the northwest, with the sun 45 degrees from horizontal
    ls = LightSource(azdeg=180, altdeg=45)
    cmap = plt.cm.gist_earth

    print(vmin)
    print(vmax)
    shade = ls.shade(elevation, cmap=cmap, blend_mode='overlay',
                     vmin=vmin, vmax=vmax, vert_exag=ve)

    return shade

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--emin", type=float, default=None)
    parser.add_argument("--emax", type=float, default=None)
    parser.add_argument("ascfile")
    parser.add_argument("pngfile")
    args = parser.parse_args()

    elevation = read_asc(args.ascfile)

    shade = get_hillshading(elevation, vmin=args.emin, vmax=args.emax)

    matplotlib.image.imsave(args.pngfile, shade)

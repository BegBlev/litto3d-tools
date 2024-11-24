import argparse
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import LightSource
import matplotlib.image

from asc import ASCData

def get_hillshading(elevation, ve=10, vmin=None, vmax=None):
    # Shade from the south, with the sun 45 degrees from horizontal
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

    ascdata = ASCData.from_file(args.ascfile)

    shade = get_hillshading(ascdata.elevation, vmin=args.emin, vmax=args.emax)

    matplotlib.image.imsave(args.pngfile, shade)

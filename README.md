# litto3d-tools

The [SHOM](https://www.shom.fr/), French Navy hydrographic office, delivered Litto3D&reg;, a set of coastal bathymetric data files for several French mainland and overseas areas.
Those data files are delivered as open data as long as the source is quoted.

litto3d-tools provides a Python script to convert those bathymetric data files to charts as PNG images and a set of procedures to put together those PNG files to obtain larger charts.

![Litto3D chart](images/litto3d-tiny.png)

## ASC file format
`.asc` are ASCII files containning a few metadata and the array of elevation.

Metadata are:
* number of data collumns
* number of data rows
* longitude
* latitude
* mesh size

Metadata are followed by (numcols x numrows) elevation values in meter.

```
ncols 1000
nrows 1000
xllcenter 216000.000000
yllcenter 6876001.000000
cellsize 1.000000
nodata_value -99999.000000
-99999.00 -16.71 -16.71 -16.71 -16.71 -16.71 -99999.00 -99999.00 -17.11 [...]
-19.97 -19.80 -19.62 -19.43 -19.31 -19.21 -19.18 -19.10 -19.05 -18.43 -18.43 [...]
[...]
```

The exact specification can be found [here](https://services.data.shom.fr/static/specifications/DC_Litto3D.pdf).

For each area, the shom delivers the data as 1000 x 1000 1m mesh data or 200x200 5m mesh data.

## PNG
PNG image format has been choosed for 3 rationals:
* compressed.
* lossless which is important for charts.
* alpha capabilities allowing to display missing data.

## asc2png principle
`asc2png` is a Python script based on both:
* numpy library for its array manipulation capabilities.
* mathplotlib library for its data manipulation and visualization capabilities.

Convertion from `.asc` to `.png` files is made in 5 steps:
* import `.asc` file into pynum array containing altitudes of points.
* compute mesh shading from both sun direction and mesh orientation.
* compute colors from both altitude and a color map.
* combine colors and shading array to produce a colored shaded map with 3D visual "sensation".
* export this array to a PNG image file.

## asc2png usage
In order to convert a `.asc` file to a `.png` file, just type:
```
python3 asc2png.py inputfile.asc outputfile.png
```

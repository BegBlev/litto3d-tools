import numpy as np

class ASCData:
    def __init__(self, ncols: int, nrows: int, xllcenter: float, yllcenter: float, cellsize: float, nodata_value: float, elevation) -> None:
        self.ncols = ncols
        self.nrows = nrows
        self.xllcenter = xllcenter
        self.yllcenter = yllcenter
        self.cellsize = cellsize
        self.nodata_value = nodata_value
        self.elevation = elevation

    @classmethod
    def from_file(cls, filename):
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

            return cls(
                   ncols = ncols,
                   nrows = nrows,
                   xllcenter = xllcenter,
                   yllcenter = yllcenter,
                   cellsize = cellsize,
                   nodata_value = nodata_value,
                   elevation = elevation
                   )

    def __add__(self, other):
        # Assert both ASC data set have the same cellsize
        assert(self.cellsize == other.cellsize)

        minxll = min(self.xllcenter, other.xllcenter)
        minyll = min(self.yllcenter, other.yllcenter)
        maxxur = max(self.xllcenter+self.ncols*self.cellsize, other.xllcenter+other.ncols*other.cellsize)
        maxyur = max(self.yllcenter+self.nrows*self.cellsize, other.yllcenter+other.nrows*other.cellsize)

        # Compute number of rows and collumns
        ncols = int((maxxur-minxll)/self.cellsize)
        nrows = int((maxyur-minyll)/self.cellsize)
        print(ncols)
        print(nrows)

        elevation = np.full((ncols, nrows), self.nodata_value)

        # Fill elevation array with self elevation
        xinsertion = int((self.xllcenter-minxll)/self.cellsize)
        yinsertion = int((self.yllcenter-minyll)/self.cellsize)
        elevation[xinsertion:xinsertion+self.ncols, yinsertion:yinsertion+self.nrows] = self.elevation

        # Fill elevation array with other elevation
        xinsertion = int((other.xllcenter-minxll)/other.cellsize)
        yinsertion = int((other.yllcenter-minyll)/other.cellsize)
        elevation[xinsertion:xinsertion+other.ncols, yinsertion:yinsertion+other.nrows] = other.elevation

        return ASCData(
                   ncols = ncols,
                   nrows = nrows,
                   xllcenter = minxll,
                   yllcenter = minyll,
                   cellsize = self.cellsize,
                   nodata_value = self.nodata_value,
                   elevation = elevation
               )

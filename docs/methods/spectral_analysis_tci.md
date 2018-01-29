# Triangular Chlorophyll Index (TCI) in Spectral Remote Sensing

The Triangular Chlorophyll Index (TCI) is widely used in remote sensing in the field of agricultural studies.
A typical use case is e.g. the quantification of vegetation in an area for the purpose of land-use classification.

The TCI bases on the absorption maximum and thus a minimum of reflectance of chlorophyll at a wavelength of roughly
670 nm. The stronger the minimum of reflectance is expressed in the spectrum under survey, the higher the TCI value.

The TCI is calculated according to the following formula[^TCI]:

$$
  TCI =
    1.2 \cdot {
      \left( {R_{700nm}-R_{550nm}} \right)
    }
    -1.5 \cdot {
      \left( {R_{670nm}-R_{550nm}} \right)
    }
    \cdot {
      \sqrt{\frac{R_{700nm}}{R_{670nm}}}
    }
$$

Here, $R_{550nm}$, $R_{670nm}$ and $R_{700nm}$ denote the reflectance for the wavelengths 550nm, 670nm and 700nm,
respectively. In order to deduce the reflectance values from the recorded reflected intensities a proper white
balance has to be provided.

[^TCI]: https://www.indexdatabase.de/db/i-single.php?id=392
# Optical Remote Sensing
The starting point for the BOS scenario in the BigGIS frame is the satellite-based emergency management services of Copernicus or the charter “Space and major Disasters”. The idea was to implement similar sensors on an unmanned aerial vehicle (UAV) platform and bring it to smaller incidents like larger fires or CBRN. Therefore, thermal (IR) and hyperspectral cameras was used as well as RGB cameras to do some testing in simulated situations:

*	Detection and following smoke clouds in imageries
*	Detection of “non visible” gas clouds
*	Identification of “chemicals”

## Gas Cloud Detection
To perform the simulations several test scenarios were prepared in two campaigns in Karlsruhe and Dortmund. The smoke of Heptane (UN 1206/Kemmler 33) was recorded as well as a mixture from gasoline (1203/33) and diesel (1202/30). A gas leakage was simulated at the Dortmund Fire Brigade Education Center using Methane ($CH_4$; 1971/23). And a gas cloud containing “chemicals” was simulated by a fog machine which nebulized a 50 % mixture of propylene glycol (propane-1,2-diol) and chlorophyll from the food branch.
First analysis eg. for the “unvisible” Methane gas cloud show quite good results using the IR cameras. On UAVs offered by Sitebots and AI Drones two choices of cameras were used:

*	OPTRIS PI
*	FLIR Vue Pro R

Both cameras give the radiometric signatures and not just “colored pictures”. The Images were spatially referenced by standard procedures. It was found that building differences just show intereferences in the pictures (shown in the first row of Picture 1). Good results were given by a Halcon referencing based on sub pixel accuracy (row two in Picture 1). Using difference analysis on about 25 pictures show a clear signature of the exhaling methane (row three in Picture 1).


Picture 1: Gas cloud detection using thermal imageries

![Gas cloud detection](bos_img/Gas_cloud_detection.JPG)
 
## Spectral Analysis of Gas Clouds
The idea of remotely detecting and identifying chemicals using a hyperspectral sensor is not new. The so called Analytical Task Force (ATF; https://www.bbk.bund.de/DE/AufgabenundAusstattung/CBRNSchutz/TaskForce/ATF_einstieg1.html ) is using the Van-based RAMAN spectroscope SIGIS 2 to detect and identify chemicals in CBRN incidents.

The BigGIS project intended to be more flexible than a SIGIS 2 mounted in a car. Therefore, as a proof-of-concept the implementation of a system allowing for spectral analysis of gas and aerosol clouds mounted on a UAV was subject of study on the level of a proof-of-concept. Due to the fact that multispectral IR-sensors as they are utilized in the SIGIS 2 system require relatively heavy-weight cooling units disqualify these systems for the usage with a UAV. Therefore, within the project a multispectral sensor sensitive in the spectral range of visible light and near IR (450 - 950 nm) was utilized for spectral analyzation. The sensor Cubert 185 UHD Firefly (http://cubert-gmbh.com/uhd-185-firefly/) has a weight of about 500 g and could easily be mounted on a UAV.

Using this sensor “smoke clouds” from a mixture of “Disco fog” and chlorophyll (see below) were recorded. Each pixel in the image contains the spectral information of the reflected light spread over 125 bands ranging from a minimum wavelength of 450nm to a maximum of 950nm.

In a first Analysis the propagating chlorophyll cloud was identified in the recorded image via the calculation of the [Triangular Chlorophyll Index (TCI)](../../methods/spectralAnalysisTCI.md ) for each pixel in the spatially referenced image.

The result is shown in the picture below:
Row one in Picture 2 is showing the chlorophyll cloud propagating from west
to east through spatially referenced pseudo color pictures. Interesting
is the underground partly paved and partly consisted of a grass strip.
In the right picture the cloud covers a small
tree.

The TCI algorithm was applied on the three pictures in the middle row.
Using a reference aerial photograph and building the difference to such
an image (third row) one can find chlorophyll only detected on the
asphalt, not on the green strip or the tree due to the fact that the
method cannot distinguish chlorophyll from the plants from
chlorophyll of the cloud.

!!! TODO
    Wie ist die obige Erklärung zu verstehen? Geht es hier darum die Bereiche mit zeitlich konstant hohem TCI-Wert (= nicht die Chlorophyll-Wolke) auszuschließen?

![Chemical cloud detection](bos_img/Chemical_cloud_detection.JPG)


Picture 3 now shows the composition of the referenced and analyzed
pictures with all three stages of the moving chlorophyll cloud. One now can
see the grass strip and the tree in addition to the gas cloud over the
asphalt.

!!! TODO
    - Picture 3: eingefärbte Elemente besser erklären

![Composition](bos_img/Composition.JPG)
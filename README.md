**# FIJI Mitochondrial Log-Ratio Analysis Macros**



This repository contains three FIJI/ImageJ macros for calculating Log-Ratio images from multichannel microscopy images and quantifying mitochondrial Log-Ratio values in two mitochondrial populations:



1\. **Macro 1 — Log-Ratio Calculator**

&#x20;  Generates the Log-Ratio/GP image, saves the analysis parameters, histogram and results files.



2\. **Macro 2 — All Mitochondria Analysis**

&#x20;  Measures Log-Ratio values in all mitochondria detected from the combined signal of Channel 1 + Channel 2.



3\. **Macro 3 — Polarized Mitochondria Analysis**

&#x20;  Measures Log-Ratio values only in polarized mitochondria detected from Channel 2.



The workflow is intended for microscopy images with at least two channels, where the Log-Ratio image is calculated first and then mitochondrial regions of interest are measured automatically.



***For Educational Purposes Only***

\---



\## **Authors**



* Martin Yanguas
* Pablo Carravilla
* Asier Ramos





Macro-specific authorship is indicated in the header of each macro file.



\---



\## **Requirements**



\* FIJI/ImageJ

\* A multichannel microscopy image with at least two channels

\* A writable image directory, because the macros generate a `Results` folder and save output files automatically



Macro 1 requires FIJI/ImageJ version `1.54f` or later.



\---



\## **Workflow overview**



Run the macros in this order:





Macro 1 → Macro 2 → Macro 3





\### **Step 1** — Run Macro 1: Log-Ratio Calculator



Macro 1 calculates a Log-Ratio image from two selected channels.



\---



\### **Step 2** — Run Macro 2: All Mitochondria Analysis



Macro 2 measures Log-Ratio values in all detected mitochondria.



\---



\### **Step 3** — Run Macro 3: Polarized Mitochondria Analysis



Macro 3 measures Log-Ratio values only in polarized mitochondria.



\---



\## **How to run the macros in FIJI**



1\. Open FIJI.

2\. Open the original multichannel microscopy image.

3\. Run Macro 1:



4\. Select `01\_Log\_Ratio\_Calculator.ijm`.

5\. Choose the channels and thresholding settings.

6\. Make sure the results are saved.

7\. With the original image still open, run Macro 2.

8\. With the original image still open, run Macro 3.



Important: Macros 2 and 3 look for the `Results` folder in the directory of the original image. They also search for a Log-Ratio image whose filename starts with:



*GP\_<original\_image\_title>*



\---



\## **Output measurements**



The macros save measurements including:



\* Area

\* Mean

\* Median

\* Minimum value



Measurements are generated with four decimal places.



\---



\## **Important notes**



\* Macro 1 should always be run before Macros 2 and 3.

\* Macro 2 uses the threshold selected in Macro 1.

\* Macro 3 uses an independent Otsu threshold on Channel 2.



\---

\## **Citation and acknowledgement**



If you use or adapt these macros, please cite or acknowledge the authors of the workflow:



Carravilla P., Ramos A., and Yanguas M.

FIJI/ImageJ macros for mitochondrial Log-Ratio analysis.



\---



\## **Disclaimer**



Users should validate the analysis parameters, thresholding strategy and ROI detection settings for their own microscopy datasets before drawing biological conclusions.

::: 




// v1.1.0 - ALL mito analysis (thresholding like Macro 1)
// Authors: Pablo Carravilla & Martin Yanguas

run("Set Measurements...", "area mean median min redirect=None decimal=4");
run("Clear Results");
roiManager("reset");

// ---- 1. Identify original image ----
origID = getImageID();
origTitle = getTitle();
origDir = getDirectory("image");

// ---- 2. Duplicate channels ----
selectImage(origID);
run("Duplicate...", "duplicate channels=1");
ch1 = getImageID();

selectImage(origID);
run("Duplicate...", "duplicate channels=2");
ch2 = getImageID();

// ---- 3. Create mask from Ch1 + Ch2 (GLOBAL threshold, like Macro 1) ----

// Sum channels
imageCalculator("add create", ch1, ch2);
sumID = getImageID();
// Close individual channels (optional but limpio)
selectImage(ch1); close();
selectImage(ch2); close();

// ---- 3b. Load threshold from Parameters file (Macro 1) ----

// Find Results folder
filelist = getFileList(origDir);
resultsPath = "";

for (i = 0; i < filelist.length; i++) {
    if (startsWith(filelist[i], "Results")) {
        resultsPath = origDir + filelist[i];
        break;
    }
}
if (resultsPath == "") exit("ERROR: Folder 'Results' not found");

// Find Parameters file
paramFiles = getFileList(resultsPath);
paramFile = "";

for (i = 0; i < paramFiles.length; i++) {
    if (startsWith(paramFiles[i], "Parameters_") && endsWith(paramFiles[i], ".csv")) {
        if (indexOf(paramFiles[i], origTitle) != -1) {
            paramFile = resultsPath + paramFiles[i];
            break;
        }
    }
}
if (paramFile == "") exit("ERROR: Parameters file not found");

// Read Parameters file
paramText = File.openAsString(paramFile);
lines = split(paramText, "\n");
// ---- Load mean filter usage ----
colsMean = split(lines[6], ",");
doMean = colsMean[1]; // "Yes" or "No"

// ---- Load mean filter radius ----
colsRadius = split(lines[7], ",");
meanRadius = parseFloat(colsRadius[1]);

print("Using mean filter radius from Macro 1: " + meanRadius);


// Line 10 = index 9 → Lower threshold
cols = split(lines[9], ",");
thrValue = parseFloat(cols[1]);

print("Using threshold from Macro 1: " + thrValue);

// Smooth (loaded from Macro 1)
selectImage(sumID);

if (doMean == "Yes") {
    run("Mean...", "radius=" + meanRadius);
    print("Applying mean filter with radius: " + meanRadius);
} else {
    print("No mean filter applied (as in Macro 1)");
}

// Apply threshold
selectImage(sumID);
setThreshold(thrValue, 1e30);
run("Convert to Mask");

// Detect ROIs = mitochondria (min size px)
run("Analyze Particles...", "size=70-Infinity pixel add");

// ---- 4. Find log-ratio image ----
// GARRANTZITSUA!! Beharrezkoa da GP irudia 'Results' hitzarekin hasten den karpeta batean egotea
filelist = getFileList(origDir);
resultsPath = -1;

for (i = 0; i < filelist.length; i++) {
    if (startsWith(filelist[i], "Results")) {
        resultsPath = origDir + filelist[i];
        break;
    }
}
if (resultsPath == -1) exit("ERROR: Folder 'Results' not found");

lrFiles = getFileList(resultsPath);
logratioFile = "";

for (i = 0; i < lrFiles.length; i++) {
    if (startsWith(lrFiles[i], "GP_" + origTitle)) {
        logratioFile = resultsPath + lrFiles[i];
        break;
    }
}
if (logratioFile == "") exit("ERROR: GP image not found");

// Open log(ratio)
open(logratioFile);
logID = getImageID();

// ---- 5. Measure ----
selectImage(logID);
roiManager("multi-measure measure_all");

// ---- 6. Save results automatically ----
// Save in "Results" folder; GP irudia dagoen karpeta berdinean
saveDir = resultsPath;

// Create unique filename: all_mito_###.txt
existing = getFileList(saveDir);
count = 0;

for (i = 0; i < existing.length; i++) {
    if (endsWith(existing[i], ".txt") && startsWith(existing[i], "all_mito_"))
        count++;
}

index = count + 1;
indexStr = IJ.pad(index, 3);

outName = "all_mito_" + indexStr + ".txt";
outPath = saveDir + outName;

// Save automatically
saveAs("Results", outPath);

print("Saved: " + outPath);

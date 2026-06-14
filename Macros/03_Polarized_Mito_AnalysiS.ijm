// v1.1.0 - POLARIZED mito analysis
// Authors: Pablo Carravilla & Martin Yanguas

run("Set Measurements...", "area mean median min redirect=None decimal=4");
run("Clear Results");
roiManager("reset");

// ---- 1. Identify original image ----
origID = getImageID();
origTitle = getTitle();
origDir = getDirectory("image");

// ---- 2. Create mask from Channel 2 (polarized) ----
// Bakarrik bigarren kanala, hemen soilik mito polarizatuak kontsideratzen baitira.
selectImage(origID);
run("Duplicate...", "duplicate channels=2");
maskID = getImageID();

run("Mean...", "radius=1");
setAutoThreshold("Otsu dark");
run("Convert to Mask");

// ROIs = mitos (min size px)
run("Analyze Particles...", "size=70-Infinity pixel add");


// ---- 3. Find log-ratio image in folder “Results” ----
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

// ---- 4. Measure ----
selectImage(logID);
roiManager("multi-measure measure_all");

// ---- 5. Save results automatically ----
// Folder = same as the GP image folder
saveDir = resultsPath;

// Create unique filename pol_mito_###.txt
existing = getFileList(saveDir);
count = 0;

for (i = 0; i < existing.length; i++) {
    if (endsWith(existing[i], ".txt") && startsWith(existing[i], "pol_mito_"))
        count++;
}

index = count + 1;
indexStr = IJ.pad(index, 3);

outName = "pol_mito_" + indexStr + ".txt";
outPath = saveDir + outName;

// Save results automatically
saveAs("Results", outPath);

print("Saved: " + outPath);

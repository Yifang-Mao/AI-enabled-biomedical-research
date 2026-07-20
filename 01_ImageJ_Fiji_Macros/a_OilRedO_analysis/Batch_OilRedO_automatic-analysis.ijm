// Batch Oil Red O ROI-based Lipid Area Measurement (final version, inverted mask)
// ---------------------------------------------------

inputDir = getDirectory("Choose input folder with .jpg images");
outputDir = getDirectory("Choose output folder for results");
fileList = getFileList(inputDir);

for (i = 0; i < fileList.length; i++) {
    if (endsWith(fileList[i], ".jpg")) {

        // --- Open image ---
        open(inputDir + fileList[i]);
        title = getTitle();

        // --- Convert to RGB ---
        run("RGB Color");

        // --- Apply Colour Deconvolution ---
        run("Colour Deconvolution", "vectors=[H DAB]");
        selectWindow(title + "-(Colour_2)"); // C2 = Oil Red O channel
        run("8-bit");

        // --- Threshold for lipid (stained regions are dark) ---
        setAutoThreshold("Default dark");
        getThreshold(lower, upper);
        run("Convert to Mask");

        // --- Invert mask so lipid-positive regions = white (255) ---
        run("Invert");

        // --- Ask user to draw ROI ---
        waitForUser("Draw ROI on the mask (white = lipid-positive), then click OK.");

        // --- Measure total ROI area ---
        getStatistics(area, mean, min, max, std);
        roiArea = area;

        // --- Measure lipid-positive area (count white pixels) ---
        getRawStatistics(area2, mean2, min2, max2, std2, histogram);
        lipidPixels = 0;
        for (p = 0; p < 256; p++) {
            if (p > 0) lipidPixels += histogram[p]; // white = 255, black = 0
        }
        lipidArea = lipidPixels;
        lipidPercent = (lipidArea / roiArea) * 100;

        // --- Save mask ---
        saveAs("Tiff", outputDir + replace(fileList[i], ".tif", "_mask_inverted.tif"));

        // --- Save results ---
        resultsFile = outputDir + "summary_with_threshold.xls";
        if (!File.exists(resultsFile)) {
            File.append("Filename,ROI_Area,Lipid_Area,Lipid_Percent,ThresholdLower,ThresholdUpper\n", resultsFile);
        }
        File.append(fileList[i] + "," + roiArea + "," + lipidArea + "," + lipidPercent + "," + lower + "," + upper + "\n", resultsFile);

        // --- Cleanup ---
        close("*");
        run("Clear Results");
    }
}

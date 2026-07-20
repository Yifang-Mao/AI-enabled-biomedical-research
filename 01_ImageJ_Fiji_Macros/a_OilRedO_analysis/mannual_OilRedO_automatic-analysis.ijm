// Batch Oil Red O ROI-based Lipid Area Measurement (manual threshold version)
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

        selectWindow(title + "-(Colour_2)");

        // --- Convert to 8-bit ---
        run("8-bit");


        // =====================================================
        // Manual Threshold Selection
        // =====================================================

        run("Threshold...");

        waitForUser(
        "Adjust threshold manually.\n\n" +
        "White regions should represent lipid-positive areas.\n" +
        "Click OK when finished."
        );

        getThreshold(lower, upper);

        // Convert thresholded image to binary mask
        run("Convert to Mask");


        // --- Invert mask so lipid-positive regions = white ---
        run("Invert");


        // =====================================================
        // ROI selection
        // =====================================================

        waitForUser(
        "Draw ROI on the mask (white = lipid-positive), then click OK."
        );


        // --- Measure total ROI area ---
        getStatistics(area, mean, min, max, std);
        roiArea = area;


        // --- Measure lipid-positive area ---
        getRawStatistics(
            area2,
            mean2,
            min2,
            max2,
            std2,
            histogram
        );

        lipidPixels = 0;

        for (p = 0; p < 256; p++) {
            if (p > 0)
                lipidPixels += histogram[p];
        }

        lipidArea = lipidPixels;

        lipidPercent = (lipidArea / roiArea) * 100;


        // =====================================================
        // Save mask
        // =====================================================

        saveName = replace(fileList[i], ".jpg", "_mask_manual_threshold.tif");

        saveAs(
            "Tiff",
            outputDir + saveName
        );


        // =====================================================
        // Save results
        // =====================================================

        resultsFile = outputDir + "summary_manual_threshold.xls";

        if (!File.exists(resultsFile)) {

            File.append(
            "Filename,ROI_Area,Lipid_Area,Lipid_Percent,ThresholdLower,ThresholdUpper\n",
            resultsFile
            );
        }


        File.append(
            fileList[i] + "," +
            roiArea + "," +
            lipidArea + "," +
            lipidPercent + "," +
            lower + "," +
            upper + "\n",
            resultsFile
        );


        // --- Cleanup ---
        close("*");
        run("Clear Results");
    }
}
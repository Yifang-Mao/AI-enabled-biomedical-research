# ImageJ/Fiji Macros for Biomedical Image Analysis

## Overview

This repository contains ImageJ/Fiji macros developed for automated quantitative analysis of biomedical microscopy images.

These workflows aim to improve the reproducibility and efficiency of image-based biological research by enabling standardized image processing and quantification.

## Application

The current macros are designed for quantitative analysis of histological and microscopy images, including automated measurement of staining-positive areas.

## Workflow

### 1. Image Preparation

Before analysis, convert microscopy images into **jgp (.jpg) format**.

Organize all images into a single folder, for example:
Input_images/
│
├── sample_1.jpg
├── sample_2.jpg
└── sample_3.jpg


### 2. Image Analysis Using Fiji

1. Open **Fiji/ImageJ**.
2. Open the corresponding macro (`.ijm` file).
3. Run the macro.
4. Select the folder containing the TIFF images.
5. The macro will automatically process and quantify all images.

## Threshold Selection

Two analysis modes are provided:

### Automated Threshold Mode

The macro named "Bactch_OilRedO_automatic-analysis.ijm" automatically determines the optimal threshold using the built-in ImageJ thresholding algorithm.

This mode is suitable for:

- Large-scale batch analysis
- Consistent image datasets
- Reducing user-dependent bias

### Manual Threshold Mode

A manual threshold selection workflow is also provided. The macro named "mannual_OilRedO_automatic-analysis.ijm"

In this mode, users can manually adjust the threshold according to their experimental requirements.

This mode is useful when:

- Image quality varies between samples
- Background intensity differs between images
- User-defined selection criteria are preferred

## Software Requirements

- Fiji (ImageJ distribution)
- ImageJ Macro Language (IJM)

## Features

- Batch processing of multiple jpg images
- Automated image quantification
- Reproducible analysis workflow
- Flexible threshold selection

## Future Development

Future updates will include additional workflows for:

- Fluorescence microscopy analysis
- Automated image preprocessing
- AI-assisted biomedical image analysis

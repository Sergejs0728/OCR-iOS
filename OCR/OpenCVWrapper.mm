//
//  OpenCVWrapper.m
//  OCR
//
//  Created by Navi on 24/05/2019.
//  Copyright © 2019 Navi. All rights reserved.
//

#import "OpenCVWrapper.h"

// import necessary headers
#import <opencv2/core.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc/imgproc.hpp>

using namespace cv;

@implementation OpenCVWrapper

- (UIImage *) makeGray: (UIImage *) image {
    // Convert UIImage to cv::Mat
    Mat inputImage; UIImageToMat(image, inputImage);
    // If input image has only one channel, then return image.
    if (inputImage.channels() == 1) return image;
    // Convert the default OpenCV's BGR format to GrayScale.
    Mat gray; cvtColor(inputImage, gray, CV_BGR2GRAY);
    // Convert the GrayScale OpenCV Mat to UIImage and return it.
    return MatToUIImage(gray);
}

- (UIImage *) thresholding: (UIImage *) image thres: (int) int_thres{
    // Convert UIImage to cv::Mat
    Mat inputImage; UIImageToMat(image, inputImage);
    // If input image has only one channel, then return image.
    // Convert the default OpenCV's BGR format to GrayScale.
    Mat thres; threshold(inputImage, thres, int_thres, 255, THRESH_BINARY);
    // Convert the GrayScale OpenCV Mat to UIImage and return it.
    return MatToUIImage(thres);
}

@end

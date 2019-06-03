//
//  OpenCVWrapper.h
//  OCR
//
//  Created by Navi on 24/05/2019.
//  Copyright © 2019 Navi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject

- (UIImage *) makeGray: (UIImage *) image;
- (UIImage *) thresholding: (UIImage *) image thres:(int *) int_thres;

@end

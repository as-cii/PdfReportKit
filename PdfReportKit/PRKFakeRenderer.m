//
//  FakeRenderer.m
//  GeneratingPDF
//
//  Created by Antonio Scandurra on 11/6/12.
//  Copyright (c) 2012 Antonio. All rights reserved.
//

#import "PRKFakeRenderer.h"


@implementation PRKFakeRenderer

- (CGRect)paperRect
{
    CGRect r = UIGraphicsGetPDFContextBounds();    
    return CGRectMake(0, 0, r.size.width, 1);
}

- (CGRect)printableRect
{
    return CGRectMake(0, 0, self.paperRect.size.width, 1);
}

- (int)contentHeight
{
    [self prepareForDrawingPages:NSMakeRange(0, 1)];
    return [self numberOfPages] + 20;
}


@end

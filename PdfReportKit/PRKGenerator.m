//
//  PRKGenerator.m
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/21/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import "PRKGenerator.h"
#import "GRMustache.h"

@implementation PRKGenerator

static PRKGenerator * instance = nil;
+ (PRKGenerator *)sharedGenerator
{
    @synchronized(self)
    {
        if (instance == nil)
            instance = [[PRKGenerator alloc] init];
        
        return instance;
    }
}

@end

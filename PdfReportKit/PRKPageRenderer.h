//
//  PRKPageRenderer.h
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/21/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRKPageRenderer : UIPrintPageRenderer
{    
    UIPrintFormatter * headerPrintFormatter;
    UIPrintFormatter * footerPrintFormatter;
}

@property (nonatomic, assign) CGRect pageRect;

- (id)initWithHeaderFormatter:(UIPrintFormatter *)headerFormatter headerHeight:(CGFloat)headerHeight andContentFormatter:(UIPrintFormatter *)contentFormatter andFooterFormatter:(UIPrintFormatter *)footerFormatter footerHeight:(CGFloat)footerHeight;

- (void) addPagesToPdfContext;

@end

//
//  InvoiceItem.h
//  GeneratingPDF
//
//  Created by Antonio Scandurra on 11/5/12.
//  Copyright (c) 2012 Antonio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvoiceItem : NSObject

@property (nonatomic, assign) int number;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * due;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, assign) float originalTotal;
@property (nonatomic, assign) float effectiveTotal;
@property (nonatomic, assign) float receivedTotal;

@end

//
//  ViewController.h
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/21/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRKGeneratorDataSource.h"
#import "PRKGeneratorDelegate.h"

@interface ViewController : UIViewController<PRKGeneratorDataSource, PRKGeneratorDelegate>
{
    NSDictionary * defaultValues;
}
@property(nonatomic,strong) IBOutlet UIWebView *webView;

@end

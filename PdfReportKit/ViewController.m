//
//  ViewController.m
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/21/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import "ViewController.h"
#import "PRKGenerator.h"
#import "PRKRenderHtmlOperation.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    Person * p1 = [[Person alloc] init];
    p1.name = @"Antonio";
    
    Person * p2 = [[Person alloc] init];
    p2.name = @"Marco";
    
    Person * p3 = [[Person alloc] init];
    p3.name = @"Luigi";
    
    Person * p4 = [[Person alloc] init];
    p4.name = @"Andrea";
    
    defaultValues = @{
    @"companyName"  : @"Apex-net s.r.l.",
    @"reportName"   : @"Report Persone",
    @"people"       : @[p1, p2, p3, p4]
    };
    
    PRKGenerator * generator = [PRKGenerator sharedGenerator];
    generator.dataSource = self;
    generator.delegate = self;
    
    NSError * error;
    [generator createReportWithName:@"template1" itemsPerPage:30 error:&error];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)reportsGenerator:(PRKGenerator *)generator templateURLStringForReportName:(NSString *)reportName
{
    return [[NSBundle mainBundle] pathForResource:reportName ofType:@"mustache"];
}

- (id)reportsGenerator:(PRKGenerator *)generator dataForReport:(NSString *)reportName withTag:(NSString *)tagName forPage:(NSUInteger)pageNumber
{
    return [defaultValues valueForKey:tagName];
}

@end

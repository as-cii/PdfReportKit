//
//  NSURLWebViewProtocol.m
//
//  Created by Aaron Wardle on 29/11/2013.
//  http://www.aaronwardle.co.uk
//

#import "NSURLWebViewProtocol.h"

@implementation NSURLWebViewProtocol


+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([request.URL.scheme caseInsensitiveCompare:kDocumentsImageUrl] == NSOrderedSame) {
        return YES;
    }
    
    if ([request.URL.scheme caseInsensitiveCompare:kBundleImageUrl] == NSOrderedSame) {
        return YES;
    }
    
    return NO;
}


+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {

    NSString *fileExtension;
    NSString *fileName;
    NSString *urlPrefix;
    NSString *filePath;
    
    [self extractFileName:&fileName fileExtension:&fileExtension urlPrefix:&urlPrefix];
    
    
    NSURLResponse *response =[[NSURLResponse alloc]initWithURL:self.request.URL
                                                      MIMEType:nil expectedContentLength:-1
                                              textEncodingName:nil];
    
    
    if ([urlPrefix isEqualToString:kBundleImageUrl]) {
        filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
    } else {
        filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, fileExtension]];
    }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:data];
    [[self client] URLProtocolDidFinishLoading:self];
    
}


- (void)extractFileName:(NSString**)fileName fileExtension:(NSString **)extension urlPrefix:(NSString **)urlPrefix {
    
    NSString *urlString = self.request.URL.absoluteString;
    *extension = [urlString pathExtension];
    
    
    NSRange isRange = [urlString rangeOfString:kBundleImageUrl options:NSCaseInsensitiveSearch];
    if (isRange.location == 0) {
        *urlPrefix = kBundleImageUrl;
    } else {
        isRange = [urlString rangeOfString:kDocumentsImageUrl options:NSCaseInsensitiveSearch];
        if (isRange.location == 0) {
            *urlPrefix = kDocumentsImageUrl;
        }
    }
    
    urlString = [urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://", *urlPrefix] withString:@""];
    
    *fileName = [urlString stringByDeletingPathExtension];

}


- (void)stopLoading {
    
}

@end

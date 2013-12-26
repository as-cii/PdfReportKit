/* Copyright 2012 Antonio Scandurra
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License. */

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
    return (int)[self numberOfPages] + 20;
}


@end

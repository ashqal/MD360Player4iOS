//
//  MD360Program.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/6.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MD360Program.h"

@implementation MD360Program
- (void) build {
    
}

- (void) use {
}

- (NSString*) getVertexShader {
    return [[NSBundle mainBundle] pathForResource:@"sphere" ofType:@"obj"];
}
@end

//
//  GLUtil.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/6.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "GLUtil.h"


@implementation GLUtil
+ (void)loadObject3DWithPath:(NSString*)path output:(MDAbsObject3D*)output{

    NSError* error = nil;
    
    NSString *objData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"ERROR while loading from file: %@", error);
    }
    NSArray *lines = [objData componentsSeparatedByString:@"\n"];
    NSMutableArray *vertexs = [[NSMutableArray alloc] init];
    NSMutableArray *textures = [[NSMutableArray alloc] init];
    NSMutableArray *normals = [[NSMutableArray alloc] init];
    NSMutableArray *faces = [[NSMutableArray alloc] init];
    
    for (NSString * line in lines){
        if ([line hasPrefix:@"v "])  [vertexs addObject:[line substringFromIndex:2]];
        if ([line hasPrefix:@"vt "]) [textures addObject:[line substringFromIndex:3]];
        if ([line hasPrefix:@"vn "]) [normals addObject:[line substringFromIndex:3]];
        if ([line hasPrefix:@"f "])  [faces addObject:[line substringFromIndex:2]];
    }
    
    int numVertex = (int)faces.count * 3 * 3;
    int numTexture = (int)faces.count * 3 * 2;
    int numIndex = (int)faces.count * 3;
    
    float* vertexBuffer  = malloc(sizeof(float) * numVertex);
    float* textureBuffer = malloc(sizeof(float) * numTexture);
    float* indexBuffer   = malloc(sizeof(float) * numIndex);
    
    int vertexIndex      = 0;
    int textureIndex     = 0;
    int faceIndex        = 0;
    
    for (NSString* i in faces){
        NSArray* splitResult = [i componentsSeparatedByString:@" "];
        for (NSString* j in splitResult) {
            indexBuffer[faceIndex] = faceIndex;
            faceIndex++;
            NSArray* faceComponent = [j componentsSeparatedByString:@"/"];
            
            NSString* vertex = [vertexs objectAtIndex:([[faceComponent objectAtIndex:0] integerValue] - 1)];
            NSString* texture = [textures objectAtIndex:([[faceComponent objectAtIndex:1] integerValue] - 1)];
            
            NSArray* vertexComp = [vertex componentsSeparatedByString:@" "];
            NSArray* textureComp = [texture componentsSeparatedByString:@" "];
            
            for (NSString* v in vertexComp) vertexBuffer[vertexIndex++] = v.floatValue;
            for (NSString* t in textureComp) textureBuffer[textureIndex++] = t.floatValue;
        }
    }
    
    [output setVertexBuffer:vertexBuffer size:numVertex];
    [output setTextureBuffer:textureBuffer size:numTexture];
    [output setNumIndices:numIndex];
    
    free(vertexBuffer);
    free(textureBuffer);
    free(indexBuffer);
}
@end

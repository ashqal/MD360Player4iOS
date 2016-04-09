//
//  GLUtil.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/6.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "GLUtil.h"
#import <UIKit/UIKit.h>

typedef struct
{
    GLfloat	x;
    GLfloat y;
    GLfloat z;
} Vertex3D;

typedef struct
{
    GLfloat	s;
    GLfloat t;
} TextureCoord;

@implementation GLUtil
+ (void)loadObject3DWithPath:(NSString*)path output:(MDAbsObject3D*)output{
    NSString* objData = [GLUtil readRawText:path];
    assert(objData != nil);
    
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

+ (void) loadObject3DMock:(MDAbsObject3D*)output{
    static const Vertex3D vertices[] =
    {
        {-0.276385, -0.850640, -0.447215},
        {0.000000, 0.000000, -1.000000},
        {0.723600, -0.525720, -0.447215},
        {0.723600, -0.525720, -0.447215},
        {0.000000, 0.000000, -1.000000},
        {0.723600, 0.525720, -0.447215},
        {-0.894425, 0.000000, -0.447215},
        {0.000000, 0.000000, -1.000000},
        {-0.276385, -0.850640, -0.447215},
        {-0.276385, 0.850640, -0.447215},
        {0.000000, 0.000000, -1.000000},
        {-0.894425, 0.000000, -0.447215},
        {0.723600, 0.525720, -0.447215},
        {0.000000, 0.000000, -1.000000},
        {-0.276385, 0.850640, -0.447215},
        {0.723600, -0.525720, -0.447215},
        {0.723600, 0.525720, -0.447215},
        {0.894425, 0.000000, 0.447215},
        {-0.276385, -0.850640, -0.447215},
        {0.723600, -0.525720, -0.447215},
        {0.276385, -0.850640, 0.447215},
        {-0.894425, 0.000000, -0.447215},
        {-0.276385, -0.850640, -0.447215},
        {-0.723600, -0.525720, 0.447215},
        {-0.276385, 0.850640, -0.447215},
        {-0.894425, 0.000000, -0.447215},
        {-0.723600, 0.525720, 0.447215},
        {0.723600, 0.525720, -0.447215},
        {-0.276385, 0.850640, -0.447215},
        {0.276385, 0.850640, 0.447215},
        {0.894425, 0.000000, 0.447215},
        {0.276385, -0.850640, 0.447215},
        {0.723600, -0.525720, -0.447215},
        {0.276385, -0.850640, 0.447215},
        {-0.723600, -0.525720, 0.447215},
        {-0.276385, -0.850640, -0.447215},
        {-0.723600, -0.525720, 0.447215},
        {-0.723600, 0.525720, 0.447215},
        {-0.894425, 0.000000, -0.447215},
        {-0.723600, 0.525720, 0.447215},
        {0.276385, 0.850640, 0.447215},
        {-0.276385, 0.850640, -0.447215},
        {0.276385, 0.850640, 0.447215},
        {0.894425, 0.000000, 0.447215},
        {0.723600, 0.525720, -0.447215},
        {0.276385, -0.850640, 0.447215},
        {0.894425, 0.000000, 0.447215},
        {0.000000, 0.000000, 1.000000},
        {-0.723600, -0.525720, 0.447215},
        {0.276385, -0.850640, 0.447215},
        {0.000000, 0.000000, 1.000000},
        {-0.723600, 0.525720, 0.447215},
        {-0.723600, -0.525720, 0.447215},
        {0.000000, 0.000000, 1.000000},
        {0.276385, 0.850640, 0.447215},
        {-0.723600, 0.525720, 0.447215},
        {0.000000, 0.000000, 1.000000},
        {0.894425, 0.000000, 0.447215},
        {0.276385, 0.850640, 0.447215},
        {0.000000, 0.000000, 1.000000},
    };
    static const TextureCoord textureCoordinates[] =
    {
        {0.648752, 0.445995},
        {0.914415, 0.532311},
        {0.722181, 0.671980},
        {0.722181, 0.671980},
        {0.914415, 0.532311},
        {0.914415, 0.811645},
        {0.254949, 0.204901},
        {0.254949, 0.442518},
        {0.028963, 0.278329},
        {0.480936, 0.278329},
        {0.254949, 0.442518},
        {0.254949, 0.204901},
        {0.838115, 0.247091},
        {0.713611, 0.462739},
        {0.589108, 0.247091},
        {0.722181, 0.671980},
        {0.914415, 0.811645},
        {0.648752, 0.897968},
        {0.648752, 0.445995},
        {0.722181, 0.671980},
        {0.484562, 0.671981},
        {0.254949, 0.204901},
        {0.028963, 0.278329},
        {0.115283, 0.012663},
        {0.480936, 0.278329},
        {0.254949, 0.204901},
        {0.394615, 0.012663},
        {0.838115, 0.247091},
        {0.589108, 0.247091},
        {0.713609, 0.031441},
        {0.648752, 0.897968},
        {0.484562, 0.671981},
        {0.722181, 0.671980},
        {0.644386, 0.947134},
        {0.396380, 0.969437},
        {0.501069, 0.743502},
        {0.115283, 0.012663},
        {0.394615, 0.012663},
        {0.254949, 0.204901},
        {0.464602, 0.031442},
        {0.713609, 0.031441},
        {0.589108, 0.247091},
        {0.713609, 0.031441},
        {0.962618, 0.031441},
        {0.838115, 0.247091},
        {0.028963, 0.613069},
        {0.254949, 0.448877},
        {0.254949, 0.686495},
        {0.115283, 0.878730},
        {0.028963, 0.613069},
        {0.254949, 0.686495},
        {0.394615, 0.878730},
        {0.115283, 0.878730},
        {0.254949, 0.686495},
        {0.480935, 0.613069},
        {0.394615, 0.878730},
        {0.254949, 0.686495},
        {0.254949, 0.448877},
        {0.480935, 0.613069},
        {0.254949, 0.686495},
    };
    
    int numIndices = sizeof(vertices)/sizeof(Vertex3D);
    int numVertex = (int)numIndices * 3;
    int numTexture = (int)numIndices * 2;
    
    float* vertexBuffer  = malloc(sizeof(float) * numVertex);
    float* textureBuffer = malloc(sizeof(float) * numTexture);
    
    for (int i = 0; i < numIndices; i++) {
        vertexBuffer[i * 3 + 0] = vertices[i].x;
        vertexBuffer[i * 3 + 1] = vertices[i].y;
        vertexBuffer[i * 3 + 2] = vertices[i].z;
    }
    
    for (int j = 0; j < numIndices; j++) {
        textureBuffer[j * 2 + 0] = textureCoordinates[j].s;
        textureBuffer[j * 1 + 1] = textureCoordinates[j].t;
    }
    
    [output setVertexBuffer:vertexBuffer size:numVertex];
    [output setTextureBuffer:textureBuffer size:numTexture];
    [output setNumIndices:numIndices];
    
    free(vertexBuffer);
    free(textureBuffer);

}

+ (NSString*)readRawText:(NSString*)path{
    NSError* error = nil;
    
    NSString *objData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"ERROR while loading from file: %@", error);
    }
    return objData;
}

+ (BOOL)compileShader:(GLuint *)shader type:(GLenum)type source:(NSString *)source{
    GLint status;
    const GLchar* data = (GLchar*)[source UTF8String];
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &data, NULL);
    glCompileShader(*shader);
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    return status == GL_TRUE;
}

+ (GLuint)createAndLinkProgramWith:(GLuint)vsHandle fsHandle:(GLuint)fsHandle attrs:(NSArray*)attrs {
    GLuint programHandle = glCreateProgram();
    if (programHandle != 0) {
        glAttachShader(programHandle, vsHandle);
        glAttachShader(programHandle, fsHandle);
        if (attrs != nil) {
            for (int i = 0; i < attrs.count; i++) {
                glBindAttribLocation(programHandle, i, [[attrs objectAtIndex:i] UTF8String]);
            }
        }
        GLint status;
        glLinkProgram(programHandle);
        // glValidateProgram(programHandle);
        glGetProgramiv(programHandle, GL_LINK_STATUS, &status);
        if (status == GL_FALSE){
            if (vsHandle) glDeleteShader(vsHandle);
            if (fsHandle) glDeleteShader(fsHandle);
            programHandle = 0;
        }
    }
    assert(programHandle != 0);
    return programHandle;
}

+ (void)texImage2D:(NSString*)path{
    NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [[UIImage alloc] initWithData:texData];
    assert(image!=nil);
    
    GLuint width = (GLuint)CGImageGetWidth(image.CGImage);
    GLuint height = (GLuint)CGImageGetHeight(image.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc( height * width * 4 );
    CGContextRef context = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    CGContextTranslateCTM (context, 0, height);
    CGContextScaleCTM (context, 1.0, -1.0);
    CGColorSpaceRelease( colorSpace );
    CGContextClearRect( context, CGRectMake( 0, 0, width, height ) );
    CGContextDrawImage( context, CGRectMake( 0, 0, width, height ), image.CGImage );
    
    //glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    [GLUtil glCheck:@"texImage2D"];
    CGContextRelease(context);
    free(imageData);
}

+ (void) glCheck:(NSString*) msg{
    int error;
    while( (error = glGetError()) != GL_NO_ERROR ){
        NSString* desc;
            
        switch(error) {
            case GL_INVALID_OPERATION:      desc = @"INVALID_OPERATION";      break;
            case GL_INVALID_ENUM:           desc = @"INVALID_ENUM";           break;
            case GL_INVALID_VALUE:          desc = @"INVALID_VALUE";          break;
            case GL_OUT_OF_MEMORY:          desc = @"OUT_OF_MEMORY";          break;
            case GL_INVALID_FRAMEBUFFER_OPERATION:  desc = @"INVALID_FRAMEBUFFER_OPERATION";  break;
        }
        NSLog(@"************ glError:%@ *** %@",msg,desc);
    }
}

@end

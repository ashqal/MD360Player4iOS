//
//  GLUtil.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/6.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "GLUtil.h"
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <CoreMotion/CoreMotion.h>

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

+ (void)texImage2DWithPath:(NSString*)path{
    NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [[UIImage alloc] initWithData:texData];
    [GLUtil texImage2D:image];
}

+ (void)texImage2D:(UIImage*)image{
    assert(image!=nil);
    
    GLuint width = (GLuint)CGImageGetWidth(image.CGImage);
    GLuint height = (GLuint)CGImageGetHeight(image.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc( height * width * 4 );
    CGContextRef context = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
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

+ (GLKMatrix4) calculateMatrixFromQuaternion:(CMQuaternion*)quaternion orientation:(UIInterfaceOrientation) orientation{
    GLKMatrix4 sensor = [GLUtil getRotationMatrixFromQuaternion:quaternion];
    switch (orientation) {
        case UIDeviceOrientationLandscapeRight:
            sensor = [GLUtil remapCoordinateSystem:sensor.m X:AXIS_MINUS_Y Y:AXIS_X];
            break;
        case UIDeviceOrientationLandscapeLeft:
            sensor = [GLUtil remapCoordinateSystem:sensor.m X:AXIS_Y Y:AXIS_MINUS_X];
            break;
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown://not support now
        default:
            break;
    }
    return sensor;
}
/** Helper function to convert a rotation vector to a rotation matrix.
 *  Given a rotation vector (presumably from a ROTATION_VECTOR sensor), returns a
 *  9  or 16 element rotation matrix in the array R.  R must have length 9 or 16.
 *  If R.length == 9, the following matrix is returned:
 * <pre>
 *   /  R[ 0]   R[ 1]   R[ 2]   \
 *   |  R[ 3]   R[ 4]   R[ 5]   |
 *   \  R[ 6]   R[ 7]   R[ 8]   /
 *</pre>
 * If R.length == 16, the following matrix is returned:
 * <pre>
 *   /  R[ 0]   R[ 1]   R[ 2]   0  \
 *   |  R[ 4]   R[ 5]   R[ 6]   0  |
 *   |  R[ 8]   R[ 9]   R[10]   0  |
 *   \  0       0       0       1  /
 *</pre>
 *  @param rotationVector the rotation vector to convert
 *  @param R an array of floats in which to store the rotation matrix
*/
+ (GLKMatrix4) getRotationMatrixFromQuaternion:(CMQuaternion*)quaternion{
    
    float q0 = quaternion->w;
    float q1 = quaternion->x;
    float q2 = quaternion->y;
    float q3 = quaternion->z;
    
    float sq_q1 = 2 * q1 * q1;
    float sq_q2 = 2 * q2 * q2;
    float sq_q3 = 2 * q3 * q3;
    float q1_q2 = 2 * q1 * q2;
    float q3_q0 = 2 * q3 * q0;
    float q1_q3 = 2 * q1 * q3;
    float q2_q0 = 2 * q2 * q0;
    float q2_q3 = 2 * q2 * q3;
    float q1_q0 = 2 * q1 * q0;

    float r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15;
    r0 = 1 - sq_q2 - sq_q3;
    r1 = q1_q2 - q3_q0;
    r2 = q1_q3 + q2_q0;
    r3 = 0.0f;
    
    r4 = q1_q2 + q3_q0;
    r5 = 1 - sq_q1 - sq_q3;
    r6 = q2_q3 - q1_q0;
    r7 = 0.0f;
    
    r8 = q1_q3 - q2_q0;
    r9 = q2_q3 + q1_q0;
    r10 = 1 - sq_q1 - sq_q2;
    r11 = 0.0f;
    
    r12 = r13 = r14 = 0.0f;
    r15 = 1.0f;

    return GLKMatrix4Make(r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15);
}

/**
 * <p>
 * Rotates the supplied rotation matrix so it is expressed in a different
 * coordinate system. This is typically used when an application needs to
 * compute the three orientation angles of the device (see
 * {@link #getOrientation}) in a different coordinate system.
 * </p>
 *
 * <p>
 * When the rotation matrix is used for drawing (for instance with OpenGL
 * ES), it usually <b>doesn't need</b> to be transformed by this function,
 * unless the screen is physically rotated, in which case you can use
 * {@link android.view.Display#getRotation() Display.getRotation()} to
 * retrieve the current rotation of the screen. Note that because the user
 * is generally free to rotate their screen, you often should consider the
 * rotation in deciding the parameters to use here.
 * </p>
 *
 * <p>
 * <u>Examples:</u>
 * <p>
 *
 * <ul>
 * <li>Using the camera (Y axis along the camera's axis) for an augmented
 * reality application where the rotation angles are needed:</li>
 *
 * <p>
 * <ul>
 * <code>remapCoordinateSystem(inR, AXIS_X, AXIS_Z, outR);</code>
 * </ul>
 * </p>
 *
 * <li>Using the device as a mechanical compass when rotation is
 * {@link android.view.Surface#ROTATION_90 Surface.ROTATION_90}:</li>
 *
 * <p>
 * <ul>
 * <code>remapCoordinateSystem(inR, AXIS_Y, AXIS_MINUS_X, outR);</code>
 * </ul>
 * </p>
 *
 * Beware of the above example. This call is needed only to account for a
 * rotation from its natural orientation when calculating the rotation
 * angles (see {@link #getOrientation}). If the rotation matrix is also used
 * for rendering, it may not need to be transformed, for instance if your
 * {@link android.app.Activity Activity} is running in landscape mode.
 * </ul>
 *
 * <p>
 * Since the resulting coordinate system is orthonormal, only two axes need
 * to be specified.
 *
 * @param inR
 *        the rotation matrix to be transformed. Usually it is the matrix
 *        returned by {@link #getRotationMatrix}.
 *
 * @param X
 *        defines the axis of the new cooridinate system that coincide with the X axis of the
 *        original coordinate system.
 *
 * @param Y
 *        defines the axis of the new cooridinate system that coincide with the Y axis of the
 *        original coordinate system.
 *
 * @param outR
 *        the transformed rotation matrix. inR and outR should not be the same
 *        array.
 *
 * @return <code>true</code> on success. <code>false</code> if the input
 *         parameters are incorrect, for instance if X and Y define the same
 *         axis. Or if inR and outR don't have the same length.
 *
 * @see #getRotationMatrix(float[], float[], float[], float[])
 */
+(GLKMatrix4) remapCoordinateSystem:(float*)inR X:(int)X Y:(int)Y{
    return [GLUtil remapCoordinateSystemImpl:inR X:X Y:Y];
}

+(GLKMatrix4) remapCoordinateSystemImpl:(float*)inR X:(int)X Y:(int)Y {
    /*
     * X and Y define a rotation matrix 'r':
     *
     *  (X==1)?((X&0x80)?-1:1):0    (X==2)?((X&0x80)?-1:1):0    (X==3)?((X&0x80)?-1:1):0
     *  (Y==1)?((Y&0x80)?-1:1):0    (Y==2)?((Y&0x80)?-1:1):0    (Y==3)?((X&0x80)?-1:1):0
     *                              r[0] ^ r[1]
     *
     * where the 3rd line is the vector product of the first 2 lines
     *
     */
    GLKMatrix4 outMatrix4 = GLKMatrix4Identity;
    
    if ((X & 0x7C)!=0 || (Y & 0x7C)!=0)
        return outMatrix4;   // invalid parameter
    if (((X & 0x3)==0) || ((Y & 0x3)==0))
        return outMatrix4;   // no axis specified
    if ((X & 0x3) == (Y & 0x3))
        return outMatrix4;   // same axis specified
    
    // Z is "the other" axis, its sign is either +/- sign(X)*sign(Y)
    // this can be calculated by exclusive-or'ing X and Y; except for
    // the sign inversion (+/-) which is calculated below.
    int Z = X ^ Y;
    
    // extract the axis (remove the sign), offset in the range 0 to 2.
    const int x = (X & 0x3)-1;
    const int y = (Y & 0x3)-1;
    const int z = (Z & 0x3)-1;
    
    // compute the sign of Z (whether it needs to be inverted)
    const int axis_y = (z+1)%3;
    const int axis_z = (z+2)%3;
    if (((x^axis_y)|(y^axis_z)) != 0)
        Z ^= 0x80;
    
    const Boolean sx = (X>=0x80);
    const Boolean sy = (Y>=0x80);
    const Boolean sz = (Z>=0x80);
    
    float* outR = malloc(sizeof(float) * 16);
    
    // Perform R * r, in avoiding actual muls and adds.
    const int rowLength = 4; // 4 * 4
    for (int j=0 ; j<3 ; j++) {
        const int offset = j*rowLength;
        for (int i=0 ; i<3 ; i++) {
            if (x==i)   outR[offset+i] = sx ? -inR[offset+0] : inR[offset+0];
            if (y==i)   outR[offset+i] = sy ? -inR[offset+1] : inR[offset+1];
            if (z==i)   outR[offset+i] = sz ? -inR[offset+2] : inR[offset+2];
        }
    }

    outR[3] = outR[7] = outR[11] = outR[12] = outR[13] = outR[14] = 0;
    outR[15] = 1;
    outMatrix4 = GLKMatrix4MakeWithArray(outR);
    free(outR);
    return outMatrix4;
 
}

+(float) getScrrenScale {
    float contentScale = 1.0f;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]) {
        contentScale = [[UIScreen mainScreen] scale];
    }
    return contentScale;
}

@end

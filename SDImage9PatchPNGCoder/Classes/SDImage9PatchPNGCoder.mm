//
//  SDImage9PatchPNGCoder.mm
//  vgo
//
//  Created by Captain Black on 2022/8/20.
//  Copyright © 2022 Benny Sou. All rights reserved.
//

#import "SDImage9PatchPNGCoder.h"

#import <ImageIO/ImageIO.h>

// Specify File Size for lossy format encoding, like JPEG
static NSString * kSDCGImageDestinationRequestedFileSize = @"kCGImageDestinationRequestedFileSize";

struct alignas(uintptr_t) Res_png_9patch
{
    Res_png_9patch() : wasDeserialized(false), xDivsOffset(0),
    yDivsOffset(0), colorsOffset(0) { }
    
    int8_t wasDeserialized;
    uint8_t numXDivs;
    uint8_t numYDivs;
    uint8_t numColors;
    
    // The offset (from the start of this structure) to the xDivs & yDivs
    // array for this 9patch. To get a pointer to this array, call
    // getXDivs or getYDivs. Note that the serialized form for 9patches places
    // the xDivs, yDivs and colors arrays immediately after the location
    // of the Res_png_9patch struct.
    uint32_t xDivsOffset;
    uint32_t yDivsOffset;
    
    int32_t paddingLeft, paddingRight;
    int32_t paddingTop, paddingBottom;
    
    enum {
        // The 9 patch segment is not a solid color.
        NO_COLOR = 0x00000001,
        
        // The 9 patch segment is completely transparent.
        TRANSPARENT_COLOR = 0x00000000
    };
    
    // The offset (from the start of this structure) to the colors array
    // for this 9patch.
    uint32_t colorsOffset;
    
    inline int32_t* getXDivs() const {
        return reinterpret_cast<int32_t*>(reinterpret_cast<uintptr_t>(this) + xDivsOffset);
    }
    inline int32_t* getYDivs() const {
        return reinterpret_cast<int32_t*>(reinterpret_cast<uintptr_t>(this) + yDivsOffset);
    }
    inline uint32_t* getColors() const {
        return reinterpret_cast<uint32_t*>(reinterpret_cast<uintptr_t>(this) + colorsOffset);
    }
} __attribute__((packed));

@implementation SDImage9PatchPNGCoder

+ (SDImageAPNGCoder *)sharedCoder {
    static SDImage9PatchPNGCoder* _coder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _coder = [[SDImage9PatchPNGCoder alloc] init];
    });
    return _coder;
}

- (nullable UIImage *)decodedImageWithData:(nullable NSData *)data options:(nullable SDImageCoderOptions *)options {
    UIImage* image = [super decodedImageWithData:data options:options];
    
    if (image == nil) {
        return nil;
    }
    
    // try to read nine patch info
    
    NSUInteger dataLen = data.length;
    NSUInteger pos = 0;
    
    if (pos >= dataLen) {
        return image;
    }
    
    Byte* buffer = (Byte*)data.bytes;
    
    // PNG 固定文件头
    if (memcmp("\x89PNG\r\n\x1a\n", buffer + pos, 8)) {
        return image;
    }
    pos += 8;
    
    while (pos < dataLen) {
        int len = 0;
        len = OSReadBigInt(buffer, pos);
        pos += sizeof(int);
        
        char tag[4];
        // read chunk tag
        memcpy(tag, buffer + pos, 4); pos += 4;
        // check if it is a nine patch chunk
        if (!memcmp(tag, "npTc", 4)) {
            
            UIEdgeInsets capInsets;
            
            // begin to parse nine patch chunk
            Res_png_9patch *chunk = (Res_png_9patch*)malloc(len);
            // !!!: since the PNG file structure is stored in big-endian bytes, we must use big-endian bytes to read
            memcpy(chunk, buffer + pos, len); pos += len;
            pos += 4/*crc*/;
            if (chunk->wasDeserialized != -1) {
                capInsets =
                UIEdgeInsetsMake(OSReadBigInt32(&chunk->paddingTop,     0) / image.scale,
                                 OSReadBigInt32(&chunk->paddingLeft,    0) / image.scale,
                                 OSReadBigInt32(&chunk->paddingBottom,  0) / image.scale,
                                 OSReadBigInt32(&chunk->paddingRight,   0) / image.scale);
                image.sd_extendedObject = @{
                    @"padding": @(capInsets)
                };
            }
            
            free(chunk);
            chunk = NULL;
        } else {
            // skip those chunks that we don't care
            pos += len + 4/*crc*/;
        }
    }
    
    return image;
}

@end

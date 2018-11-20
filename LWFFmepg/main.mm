//
//  main.m
//  LWFFmepg
//
//  Created by wangjianjune on 2018/10/25.
//  Copyright © 2018 wangjianjune. All rights reserved.
//

#import <Cocoa/Cocoa.h>
extern "C"{
#import "libavformat/avformat.h"
#import "avcodec.h"
}

int main(int argc, const char * argv[]) {
    return NSApplicationMain(argc, argv);
    
}

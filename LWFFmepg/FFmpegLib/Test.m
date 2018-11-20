////
////  Test.m
////  LWFFmepg
////
////  Created by wangjianjune on 2018/10/30.
////  Copyright © 2018 wangjianjune. All rights reserved.
////
//
//#import "Test.h"
//#import <Foundation/Foundation.h>
//
//
//@interface Test : NSObject
//@property (nonatomic) NSTask * unixTask;
//@property (nonatomic) NSPipe * unixStandardOutputPipe;
//@property (nonatomic) NSPipe * unixStandardErrorPipe;
//@property (nonatomic) NSPipe * unixStandardInputPipe;
//@property (nonatomic) NSFileHandle * fhOutput;
//@property (nonatomic) NSFileHandle * fhError;
//@property (nonatomic) NSData * standardOutputData;
//@property (nonatomic) NSData * standardErrorData;
//
//@end
//
//@implementation Test
//
//- (void)pressButton:(id)sender {
//    NSTask * task = [[NSTask alloc] init];
//    [task setLaunchPath:@"/ bin / sh"];
//    [task setArguments:[NSArray arrayWithObjects:[[NSBundle mainBundle] pathForResource:@"script\"ofType:@\"sh"],nil]];
////    [任务启动];
//}
//
////- (void)buttonLaunchProgram:(id)sender {
////    [_unixTaskStdOutput setString:@""];
////    [_unixProgressUpdate setStringValue:@""];
////    [_unixProgressBar startAnimation:nil];
////    [self runCommand];
////}
//- (void)runCommand {
//
//    //设置系统管道和文件句柄以处理输出数据
//    self.unixStandardOutputPipe = [[NSPipe alloc] init];
//    self.unixStandardErrorPipe = [[NSPipe alloc] init];
//    self.fhOutput = [self.unixStandardOutputPipe fileHandleForReading];
//    self.fhError = [self.unixStandardErrorPipe fileHandleForReading];
//
//    //设置通知警报
//    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
//    [nc addObserver:self selector:@selector(informedForStdOutput:) name:NSFileHandleReadCompletionNotification object:self.fhOutput];
//    [nc addObserver:self selector:@selector(informedForStdError:) name:NSFileHandleReadCompletionNotification object:self.fhError];
//    [nc addObserver:self selector:@selector(informedForComplete:) name:NSTaskDidTerminateNotification object:self.unixTask];
//
//    NSMutableArray * commandLine = [NSMutableArray new];
//    [commandLine addObject:@" -  c"];
//    [commandLine addObject:@"/ usr / bin / kpu -ca"]; //把你的脚本放在这里
//
//    self.unixTask = [[NSTask alloc] init];
//    [self.unixTask setLaunchPath:@":/ bin / bash"];
//    [self.unixTask setArguments:commandLine];
//    [self.unixTask setStandardOutput:self.unixStandardOutputPipe];
//    [self.unixTask setStandardError:self.unixStandardErrorPipe];
//    [self.unixTask setStandardInput:[NSPipe pipe]];
//    [self.unixTask launch];
//
//    //注意我们调用的文件句柄不是管道
//    [self.fhOutput readInBackgroundAndNotify];
//    [self.fhError readInBackgroundAndNotify];
//}
//- (void)notificationsForStdOutput:(NSNotification *)通知{
//    NSData * data = [[@"通知用户信息"] valueForKey:NSFileHandleNotificationDataItem];
//    NSLog(@"标准数据就绪％ld字节",data.length);
//    if([data length]){
//        NSString * outputString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSTextStorage *ts = [_unixTaskStdOutput textStorage];
//        [ts replaceCharactersInRange:NSMakeRange([ts length],0)
//                          withString:outputString];
//    }
//    if(self.unixTask!= nil){
//        [fhOutput readInBackgroundAndNotify];
//    }
//}
//- (void)informedForStdError:(NSNotification *)通知{
//    NSData * data = [[通知用户信息] valueForKey:NSFileHandleNotificationDataItem];
//    NSLog(@"standard error ready％ld bytes",data.length);
//    if([data length]){
//
//        NSString * outputString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        [_unixProgressUpdate setStringValue:outputString];
//    }
//    if(unixTask!= nil){
//        [fhError readInBackgroundAndNotify];
//    }
//}
//- (void)informedForComplete:(NSNotification *)anotification {
//    NSLog(@"任务已完成或已使用退出代码％d",[unixTask terminationStatus]);
//    unixTask = nil;
//    [_unixProgressBar stopAnimation:self];
//    [_unixProgressBar viewDidHide];
//    if([unixTask terminationStatus] == 0){
//        [_unixProgressUpdate setStringValue:@"Success"];
//    }
//    else {
//        [_unixProgressUpdate setStringValue:@"以非零退出代码终止"];
//    }
//}
//@end

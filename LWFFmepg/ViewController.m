//
//  ViewController.m
//  LWFFmepg
//
//  Created by wangjianjune on 2018/10/25.
//  Copyright © 2018 wangjianjune. All rights reserved.
//

#import "ViewController.h"
#import "LWTableCellView.h"
#import<AudioToolbox/AudioToolbox.h>




@interface ViewController : NSViewController<NSTableViewDelegate,NSTableViewDataSource,NSTextFieldDelegate>
@property (nonatomic,strong) NSArray *filePathes;
@property (nonatomic,strong) NSArray *targetPathes;
@property (nonatomic,assign) NSInteger currentLine;
@property (weak) IBOutlet NSTableView *mainTableView;
@property (weak) IBOutlet NSTextField *defaultTargetPath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filePathes = [NSArray array];
//    avcodec_register_all()
//    av_register_all();
}

#pragma mark - tableView行数
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.filePathes.count;
}


#pragma mark - cell
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTableCellView * cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    LWTableCellModel *model = [[LWTableCellModel alloc] init];
    if ([cell isKindOfClass:NSClassFromString(@"LWTableCellView")]) {
        LWTableCellView *tempCell = (LWTableCellView *)cell;
         if([tableColumn.identifier isEqualToString:@"FilePathCell"]){
            cell.textField.stringValue = [self.filePathes objectAtIndex:row][@"FilePathCell"];
            model.cellType = FilePathCell;
        }else if([tableColumn.identifier isEqualToString:@"TargetPathCell"]){
            cell.textField.stringValue = [self.filePathes objectAtIndex:row][@"TargetPathCell"];
            model.cellType = TargetPathCell;
        }else if ([tableColumn.identifier isEqualToString:@"CustomNamedCell"]){
            model.cellType = CustomNamedCell;
            cell.textField.stringValue = [self.filePathes objectAtIndex:row][@"CustomNamedCell"];
        }
        model.cellRow = row;
        tempCell.cellmodel = model;
        cell.textField.delegate = self;
        cell.textField.font = [NSFont systemFontOfSize:13];
    }else{
        if ([tableColumn.identifier isEqualToString:@"IDTableCell"]) {
            cell.textField.integerValue = row + 1;
        }
    }
    return cell;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    self.currentLine = row;
    return YES;
}

-(void)controlTextDidEndEditing:(NSNotification *)obj{
    
    NSTextField *textFild = (NSTextField *)obj.object;
    if ([textFild.superview isKindOfClass:NSClassFromString(@"LWTableCellView")]) {
        LWTableCellView *cell = (LWTableCellView *)textFild.superview;
        switch (cell.cellmodel.cellType) {
            case FilePathCell:
                [self verifyFilePathByCurrentCellInfo:cell.cellmodel filePath:textFild.stringValue];
                break;
            case TargetPathCell:
                [self verifyTargetPathByCurrentCellInfo:cell.cellmodel targetPath:textFild.stringValue];
                break;
            case CustomNamedCell:
                [self verifyFileNamesByCurrentCellInfo:cell.cellmodel fileName:textFild.stringValue];
                break;
            default:
                break;
        }
    }
}

/**
 校验修改和刷新
 */

//校验文件路径
- (void)verifyFilePathByCurrentCellInfo:(LWTableCellModel *)cellInfo filePath:(NSString *)path{
    NSMutableArray *arr = [NSMutableArray array];
    [self.filePathes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)obj];
        if (cellInfo.cellRow == idx) {
            [dict setObject:path forKey:@"FilePathCell"];
        }
        [arr addObject:dict];
    }];
    self.filePathes = arr.copy;
    [self.mainTableView reloadData];
    
}

//校验文件存储名称
- (void)verifyFileNamesByCurrentCellInfo:(LWTableCellModel *)cellInfo fileName:(NSString *)name{
    for (int i = 0; i < self.filePathes.count; i++) {
        NSDictionary *dict =self.filePathes[i];
        NSString *fileName = dict[@"CustomNamedCell"];
        if (fileName && fileName.length>0 && [fileName isEqualToString:name] && i!=cellInfo.cellRow) {
            NSAlert *alter = [self alertWithTitle:@"警告" content:@"保存文件名不能重复"];
            [alter beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                if (returnCode == NSAlertFirstButtonReturn) {
                    NSLog(@"弹框确认按钮");
                    [self.mainTableView reloadData];
                }
            }];
            return;
        }
    }
    NSLog(@"确认正确无误,更新文件名称");
    NSMutableArray *arr = [NSMutableArray array];
    [self.filePathes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)obj];
        if (cellInfo.cellRow == idx) {
            [dict setObject:name forKey:@"CustomNamedCell"];
        }
        [arr addObject:dict];
    }];
    self.filePathes = arr.copy;
    [self.mainTableView reloadData];
    
}

- (void)verifyTargetPathByCurrentCellInfo:(LWTableCellModel *)cellInfo targetPath:(NSString *)path{
    NSMutableArray *arr = [NSMutableArray array];
    [self.filePathes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)obj];
        if (cellInfo.cellRow == idx) {
            [dict setObject:path forKey:@"TargetPathCell"];
        }
        [arr addObject:dict];
    }];
    self.filePathes = arr.copy;
    [self.mainTableView reloadData];
}

- (BOOL)verifyFilePathes{
    
    NSLog(@"开始转换");
    for (NSDictionary *dict in self.filePathes) {
        NSLog(@"%@",dict);
    }
    if (!self.filePathes || self.filePathes.count<=0) {
        return NO;
    }
    for (NSDictionary *dict in self.filePathes) {
        NSArray *keys =  [dict allKeys];
        for (NSString *key in keys) {
            NSString *value = dict[key];
            if (!value || value.length <= 0) {
                NSString *warning = nil;
                if ([key isEqualToString:@"CustomNamedCell"]) {
                    warning = @"您有未定义的文件储存名称,您可以保持使用默认值，也可以自定义设置，文件名称不可重复。";
                }else if([key isEqualToString:@"TargetPathCell"]) {
                    warning = @"部分行还没有定义文件的储存路径，您也可以点击工具栏\"存储路径设置\"按钮批量设置,或点击下方工具栏\"删除行\"按钮来删除不需要的行，也可双击所在单元格进行设置,然后再执行下载转换操作";
                }else{
                    warning = @"部分行还没有定义文件的下载路径（地址），下载路径（地址）是必须的设置，，您可以点击下方工具栏\"删除行\"按钮来删除不需要的行，再执行下载转换操作。";
                }
                NSAlert *alert = [self alertWithTitle:@"警告" content:warning];
                [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                    
                }];
                
                return NO;
            }
        }
    }
    return YES;
}



#pragma mark - 按钮功能
//开始转换
- (IBAction)startDownLoadAndExchange:(id)sender {
    
    if([self verifyFilePathes]){
        NSLog(@"转化开始");
        __weak typeof(self)weakSelf = self;
        [self.filePathes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = (NSDictionary *)obj;
            NSString *commondStr = [NSString stringWithFormat:@"ffmpeg -i \"%@\" -c copy %@%@.mp4",[dict objectForKey:@"FilePathCell"],[dict objectForKey:@"TargetPathCell"],[dict objectForKey:@"CustomNamedCell"]];
            [weakSelf runCommond:commondStr];
           
        }];
    }
}


-(void)runCommond:(NSString *)commondString{
    NSLog(@"%@",commondString);
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/echo"];
    [task setArguments:[NSArray arrayWithObjects:commondString, nil]];
    NSPipe *pipe = [[NSPipe alloc] init];
    [task setStandardOutput:pipe];
    [task launch];
    
//    system([commondString UTF8String]);
}


//清空table数据
- (IBAction)clearTable:(id)sender {
    NSLog(@"清空table数据");
    self.filePathes = [NSArray array];
    [self.mainTableView reloadData];
}

//批量添加文件存储路径
- (IBAction)batchOperationForStorgePath:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseFiles = NO;//是否可以选择文件
    panel.canCreateDirectories = YES;//是否c可以创建文件夹
    panel.canChooseDirectories = YES;
    [panel setAllowsMultipleSelection:NO];//是否可多选
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (result == 1) {
            NSURL *url = panel.directoryURL;
            NSString *str =  [url absoluteString];
            str = [str stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            self.defaultTargetPath.stringValue = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
            NSMutableArray *arr = [NSMutableArray array];
            [self.filePathes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)obj] ;
                NSArray *keys = [dict allKeys];
                for (NSString *key in keys) {
                    if ([key isEqualToString:@"TargetPathCell"]) {
                        [dict setObject:self.defaultTargetPath.stringValue forKey:key];
                    }
                }
                [arr addObject:dict];
            }];
            self.filePathes = arr.copy;
            
            [self.mainTableView reloadData];
        }else{
            
        }
    }];
}

//添加行
- (IBAction)addDataLine:(id)sender {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYYMMddhhmmssSS"];
    NSDate *date = [NSDate date];
    NSString *dateStr = [format stringFromDate:date];
    self.filePathes = [self.filePathes arrayByAddingObject:@{@"FilePathCell":@"",@"TargetPathCell":@"",@"CustomNamedCell":dateStr}];
    [self.mainTableView reloadData];
}

- (IBAction)deleteSelectedLineData:(id)sender {
    NSMutableArray *arr = self.filePathes.mutableCopy;
    [arr removeObjectAtIndex:self.currentLine];
    self.filePathes = arr.copy;
    [self.mainTableView reloadData];
}

- (NSAlert *)alertWithTitle:(NSString *)title content:(NSString *)message{
    NSAlert *alter = [[NSAlert alloc] init];
    alter.alertStyle = NSAlertStyleWarning;
    alter.messageText = title;
    [alter addButtonWithTitle:@"确定"];
    alter.icon = [NSImage imageNamed:@"warning (1)"];
    alter.informativeText = message;
    return alter;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}


@end

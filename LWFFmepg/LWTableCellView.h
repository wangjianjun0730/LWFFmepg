//
//  LWTableCellView.h
//  LWFFmepg
//
//  Created by wangjianjune on 2018/10/26.
//  Copyright © 2018 wangjianjune. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LWTableCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWTableCellView : NSTableCellView
@property (nonatomic,strong) LWTableCellModel *cellmodel;
@end

NS_ASSUME_NONNULL_END

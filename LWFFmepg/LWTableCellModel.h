//
//  LWTableCellModel.h
//  LWFFmepg
//
//  Created by wangjianjune on 2018/10/27.
//  Copyright © 2018 wangjianjune. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,CellType){
    FilePathCell = 0,
    TargetPathCell = 1,
    CustomNamedCell = 2
};

@interface LWTableCellModel : NSObject

@property (nonatomic,assign) CellType cellType;
@property (nonatomic,assign) NSInteger cellRow;

@end

NS_ASSUME_NONNULL_END

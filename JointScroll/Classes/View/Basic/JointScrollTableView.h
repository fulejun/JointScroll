//
//  JointScrollTableView.h
//  JointScroll
//
//  Created by 乐军付 on 2020/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSInteger, JSTable){
    JSTableParent,
    JSTableChild
};
@interface JointScrollTableView : UITableView

/// 初始化
/// @param frame Table的尺寸
/// @param style Table的样式
/// @param type Table的类型 JSTableParent:父 JSTableChild：子
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style JSTableType:(JSTable)type;

@property(nonatomic,assign)JSTable jsTableType;

@end

NS_ASSUME_NONNULL_END

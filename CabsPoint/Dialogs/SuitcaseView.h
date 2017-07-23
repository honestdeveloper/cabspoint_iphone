//
//  SuitcaseView.h
//  CabsPoint
//
//  Created by Michael on 1/17/15.
//  Copyright (c) 2015 CabsPoint. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SuitcaseViewProtocol <NSObject>

-(void)onSuitcasesSelected:(int)index;

@end

@interface SuitcaseView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIView* m_contentView;
@property (nonatomic, weak) IBOutlet UITableView* m_tableView;
@property (nonatomic, weak) id<SuitcaseViewProtocol> delegate;
@end

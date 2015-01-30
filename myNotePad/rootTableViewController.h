//
//  rootTableViewController.h
//  myNotePad
//
//  Created by He Stone on 14/10/30.
//  Copyright (c) 2014年 ZitongHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rootTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSMutableArray *noteArray;
@property (nonatomic) NSMutableArray *dateArray;
@end


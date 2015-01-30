//
//  EditViewController.m
//  myNotePad
//
//  Created by He Stone on 14/10/29.
//  Copyright (c) 2014年 ZitongHe. All rights reserved.
//

#import "EditViewController.h"

@interface addViewController()

@property UITextView *myTextView;

@end



@implementation EditViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    NSString *olderText = [array objectAtIndex:self.index];
    self.myTextView.text = olderText;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)savenote{
    NSArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    NSMutableArray *mutableArray = [tempArray mutableCopy];
    NSString *textString = [self.myTextView text];
    [mutableArray removeObjectAtIndex:self.index];
    [mutableArray insertObject:textString atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:@"note"];
    rootTableViewController *rootCtrl = [[rootTableViewController alloc] init];
    rootCtrl.noteArray = mutableArray;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    NSDate *dateNow = [NSDate date];
    NSString *dateNowStr = [dateFormatter stringFromDate:dateNow];
    NSArray *tempDateArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"date"];
    NSMutableArray *mutableDateArray = [tempDateArray mutableCopy];
    [mutableDateArray removeObjectAtIndex:self.index];
    [mutableDateArray insertObject:dateNowStr atIndex:0];
    rootCtrl.dateArray = mutableDateArray;
    [[NSUserDefaults standardUserDefaults] setObject:mutableDateArray forKey:@"date"];
    
    [self.myTextView resignFirstResponder];
    
    UIAlertView *alaert = [[UIAlertView alloc] initWithTitle:nil message:@"保存成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alaert show];
}


@end

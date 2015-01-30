//
//  addViewController.m
//  myNotePad
//
//  Created by He Stone on 14/10/31.
//  Copyright (c) 2014年 ZitongHe. All rights reserved.
//

#import "addViewController.h"
#import "rootTableViewController.h"

@interface addViewController()
@property UITextView *myTextView;

@end



@implementation addViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.myTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, 310, 320)];
    [self.view addSubview:self.myTextView];
    [self.myTextView becomeFirstResponder];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savenote)];//plain border difference
    self.navigationItem.rightBarButtonItem = saveButton;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)savenote{
    NSMutableArray *initNoteArray = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"note"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:initNoteArray forKey:@"note"];
    }
    NSArray *tempNoteArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    
    NSMutableArray *mutableNoteArray = [tempNoteArray mutableCopy];
    
    NSString *textstring = [self.myTextView text];
    [mutableNoteArray insertObject:textstring atIndex:0];
    
    rootTableViewController *rootController = [[rootTableViewController alloc] init];
    rootController.noteArray = mutableNoteArray;
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableNoteArray forKey:@"note"];
    
    NSMutableArray *initDateArray = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"date"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:initDateArray forKey:@"date"];
    }
    NSArray *tempDateArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
    NSMutableArray *mutableDateArray = [tempDateArray mutableCopy];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    NSDate *dateNow = [NSDate date];
    NSString *dateNowStr = [dateFormatter stringFromDate:dateNow];
    [mutableDateArray insertObject:dateNowStr atIndex:0];
    rootController.dateArray = mutableDateArray;
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableDateArray forKey:@"date"];
    
    [self.myTextView resignFirstResponder];
    
    UIAlertView *alaert = [[UIAlertView alloc] initWithTitle:nil message:@"保存成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alaert show];
}
@end

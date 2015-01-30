//
//  rootTableViewController.m
//  myNotePad
//
//  Created by He Stone on 14/10/30.
//  Copyright (c) 2014年 ZitongHe. All rights reserved.
//

#import "rootTableViewController.h"
#import "addViewController.h"
#import "EditViewController.h"

@interface rootTableViewController()<UISearchResultsUpdating>//<UITableViewDataSource,UITableViewDelegate>
@property NSMutableArray *fliterNoteArray;
@property UISearchBar *searchBar;
@property UISearchController *searchCtrl;
@end

@implementation rootTableViewController
@synthesize noteArray,dateArray,fliterNoteArray,searchBar,searchCtrl;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.noteArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    self.dateArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
    self.fliterNoteArray = [NSMutableArray arrayWithCapacity:[self.noteArray count]];
    UITableViewController *searchResultsViewCtrl = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    searchResultsViewCtrl.tableView.dataSource = self;
    searchResultsViewCtrl.tableView.delegate = self;
    searchCtrl = [[UISearchController alloc] initWithSearchResultsController:searchResultsViewCtrl];
    searchCtrl.searchResultsUpdater = self;
    searchCtrl.searchBar.frame = CGRectMake(searchCtrl.searchBar.frame.origin.x, searchCtrl.searchBar.frame.origin.y, searchCtrl.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = searchCtrl.searchBar;
    self.definesPresentationContext = YES;
    [self.tableView reloadData];
    
}

- (void) viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"Note Pad";
    UIBarButtonItem *noUseButton = [[UIBarButtonItem alloc] initWithTitle:@"你妹的" style:UIBarButtonItemStyleDone target:self action:@selector(noUse)];
    self.navigationItem.leftBarButtonItem = noUseButton;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNote)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}//显示一个section

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [noteArray count];
}//显示某个section内有几个row

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *showInfo = @"heeeeeeeeeello";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:showInfo];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:showInfo];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    NSString *note = nil;
    if (tableView == self.tableView) {
        note = [noteArray objectAtIndex:indexPath.row];
    }
    NSString *date = [dateArray objectAtIndex:indexPath.row];
    //下面进行统计每行字符数，用以显示前22个字符
    NSInteger charnum = [note length];
    if (charnum >= 22) {
        cell.textLabel.text = [[note substringToIndex:18] stringByAppendingString:@"..."];
    }
    else{
        cell.textLabel.text = note;
    }
    cell.detailTextLabel.text = date;
    cell.textLabel.font = [UIFont fontWithName:@"Noteworthy" size:20];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    //NSString *cellValue = [listInfo objectAtIndex:indexPath.row];
    //cell.textLabel.text = cellValue;
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"infoList~";
//}//头部
//
//-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
//    return @"He Zitong";
//}//尾部

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *infoSelect = [listInfo objectAtIndex:[indexPath row]];
//    NSString *message1 = [[NSString alloc] initWithFormat:@"您选择的:%@",infoSelect];
//    UIAlertView *alater = [[UIAlertView alloc] initWithTitle:@"你选择的" message:message1 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alater show];
//}

//-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [indexPath row] % 9;
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];//从note里面读取数据
        noteArray = [tempArray mutableCopy];//将tempArray里面的数据保存到tempMutableArray里面
        [noteArray removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:noteArray forKey:@"note"];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[self.tableView reloadData];
    }
    else if(editingStyle == UITableViewCellEditingStyleInsert){
    
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditViewController *modifyCtrl = [[EditViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:modifyCtrl animated:YES];
    NSInteger row = [indexPath row];
    modifyCtrl.index = row;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchStr = [searchCtrl.searchBar text];
    [self updateSearchResultsForNotes:searchStr];
    [((UITableViewController *)searchCtrl.searchResultsController).tableView reloadData];
}

-(void)updateSearchResultsForNotes:(NSString *)noteStr{
    if ((noteStr == nil) || [noteStr length] == 0) {
        fliterNoteArray = [noteArray mutableCopy];
        return;
    }
    
    [fliterNoteArray removeAllObjects];
    for (NSString *string in noteArray) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange noteStrRange = NSMakeRange(0, string.length);
        NSRange foundRange = [string rangeOfString:noteStr options:searchOptions range:noteStrRange];
        if (foundRange.length > 0) {
            [fliterNoteArray addObject:string];
        }
    }

}
- (void) addNote{
    addViewController *detailViewCtrl = [[addViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:detailViewCtrl animated:YES];//animated不理解
    
}//响应selector

- (void) noUse{
    UIAlertView *alater = [[UIAlertView alloc] initWithTitle:@"卧槽？！" message:@"尼玛！！！！！！" delegate:self cancelButtonTitle:@"接受" otherButtonTitles:@"同意", nil];
    [alater show];
}//响应selector

@end

//
//  ViewController.m
//  音乐库应用
//
//  Created by ken on 13-11-29.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import "ViewController.h"
#import "LibraryAPI.h"
#import "Album+TableRepresentation.h"
#import "HorizontalScroller.h"
#import "AlbumView.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,HorizontalScrollerDelegate>
{
    UITableView *dataTable;
    NSArray *allalbums;
    NSDictionary *currentAlbumData;
    int currentAlbumIndex;
    HorizontalScroller *scroller;
    UIToolbar *toolbar;
    NSMutableArray *undoStack;
    UIBarButtonItem *delete;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:0.76f green:0.81 blue:0.87f alpha:1];
    currentAlbumIndex = 0;
    
    allalbums = [[LibraryAPI sharedInstance] getAlbums];
    
    dataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height - 300) style:UITableViewStyleGrouped];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.backgroundView = nil;
    [self.view addSubview:dataTable];
    
    [self loadPreviousState];
    //创建HorizontalScroller类的实例，设置它的背景色，委托，增加到主视图和加载所有子视图去显示专辑数据
    scroller = [[HorizontalScroller alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    scroller.backgroundColor = [UIColor colorWithRed:0.24f green:0.35f blue:0.49f alpha:1];
    scroller.delegate = self;
    [self.view addSubview:scroller];
//    [self reloadScroller];
    [self showDataForAlbumAtIndex:currentAlbumIndex];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    toolbar = [[UIToolbar alloc]init];
    UIBarButtonItem *undoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(undoAction)];
    undoItem.enabled = NO;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = self.view.frame.size.width - 100;
    
    delete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAlbum)];
    [toolbar setItems:@[undoItem,space,delete]];
    [self.view addSubview:toolbar];
    undoStack = [[NSMutableArray alloc] init];
}

-(void)showDataForAlbumAtIndex:(int)albumIndex
{
    if (albumIndex < allalbums.count) {
        Album *album = allalbums[albumIndex];
        currentAlbumData = [album tr_tableRepresentation];
    } else {
        currentAlbumData = nil;
    }
    [dataTable reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentAlbumData[@"titles"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = currentAlbumData[@"titles"][indexPath.row];
    cell.detailTextLabel.text = currentAlbumData[@"values"][indexPath.row];
    return cell;
}

#pragma mark - HorizontalScrollerDelegate methods
-(void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtindex:(int)index
{
    currentAlbumIndex = index;
    [self showDataForAlbumAtIndex:index];
}

-(NSInteger)numberOfViewForHorizontalScroller:(HorizontalScroller *)scroller
{
    return allalbums.count;
}

-(UIView *)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(int)index
{
    Album *album = allalbums[index];
    return [[AlbumView alloc] initWithFrame:CGRectMake(0, 0, 280, 280) albumCover:album.coverUrl];
}

-(NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller *)scroller
{
    return currentAlbumIndex;
}

-(void)reloadScroller
{
    allalbums = [[LibraryAPI sharedInstance] getAlbums];
    if (currentAlbumIndex < 0) {
        currentAlbumIndex = 0;
    }
    else if (currentAlbumIndex >= allalbums.count)
        currentAlbumIndex = allalbums.count - 1;
    [scroller reload];
    [self showDataForAlbumAtIndex:currentAlbumIndex];
}
-(void)saveCurrentState
{
    [[NSUserDefaults standardUserDefaults] setInteger:currentAlbumIndex forKey:@"currentAlbumIndex"];
    [[LibraryAPI sharedInstance] saveAlbums];
}

-(void)loadPreviousState
{
    currentAlbumIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentAlbumIndex"];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLayoutSubviews{
    toolbar.frame = CGRectMake(0, self.view.frame.size.height - 80, self.view.frame.size.width, 80);
    dataTable.frame = CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height - 200);
}

-(void)addAlbum:(Album *)album atIndex:(int)index
{
    [[LibraryAPI sharedInstance] addAlbum:album atIndex:index];
    currentAlbumIndex = index;
    [self reloadScroller];
}

-(void)deleteAlbum
{
    //获取需要删除的专辑
    Album *deleteAlbum = allalbums[currentAlbumIndex];
//    NSLog(@"allalbums = %d, currentAlbumIndex = %d",allalbums.count,currentAlbumIndex);
    //定义了一个类型为NSMethodSignature的对象去创建NSInvocation，它将用来撤销删除操作。
    //NSInvocation 需要知道三件事情：选择器(发送什么消息)，目标对象(发送消息的对象)，还有就是消息所需要的参数。
    //消息是删除方法相反的操作，因为当你想撤销删除的时候，你需要将刚刚删除的数据加回来。
    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(addAlbum:atIndex:)];
    //使用NSInvocation ，需要记得要点：
    //1、参数必须以指针的形式传递
    //2、参数从索引2开始，索引0，1为目标（target）和选择器（selector）保留
    //3、如果参数有可能会被销毁，需要调用retainArguments
    NSInvocation *undoAction = [NSInvocation invocationWithMethodSignature:sig];
    [undoAction setTarget:self];
    [undoAction setSelector:@selector(addAlbum:atIndex:)];
    [undoAction setArgument:&deleteAlbum atIndex:2];
    [undoAction setArgument:&currentAlbumIndex atIndex:3];
    [undoAction retainArguments];
    //将undoAction增加到undoStack中。撤销操作将被增加在数组的末尾。
    [undoStack addObject:undoAction];
    //使用LibraryAPI删除专辑，然后重新加载滚动视图
    [[LibraryAPI sharedInstance] deleteAlbumAtIndex:currentAlbumIndex];
    [self reloadScroller];
    //使撤销按钮可用
    [toolbar.items[0] setEnabled:YES];
    if (undoStack.count == 5) {
        delete.enabled = NO;
    }
}

-(void)undoAction
{
    delete.enabled = YES;
    if (undoStack.count > 0) {
        NSInvocation *undoAction = [undoStack lastObject];
        [undoStack removeLastObject];
        [undoAction invoke];
    }
    
    if (undoStack.count == 0) {
        [toolbar.items[0] setEnabled:NO];
    }
}










































- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

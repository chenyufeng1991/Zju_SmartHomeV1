//
//  CYFFurnitureViewController.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "CYFFurnitureViewController.h"
#import "CYFCollectionViewCell.h"
#import "CYFCollectionReusableView.h"
#import "JYElectricalController.h"
#define UISCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@interface CYFFurnitureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)add;

//存放图片的数组
@property (nonatomic, strong)NSMutableArray *imageArray;
//存放图片描述文字的数组
@property(nonatomic,strong)NSMutableArray *descArray;
//下面数组用来存放头部标题；
@property(strong,nonatomic) NSMutableArray *headerArray;

@end

@implementation CYFFurnitureViewController
- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        NSMutableArray *firstRow = [[NSMutableArray alloc] initWithObjects:@"home_icon_yw_on",@"home_icon_yw_on",@"home_icon_yw_on",@"home_icon_yw_on",@"home_icon_yw_on",@"home_icon_yw_on",nil];
        NSMutableArray *secondRow = [[NSMutableArray alloc] initWithObjects:@"home_icon_yw_on",@"home_icon_yw_on",@"home_icon_yw_on",@"home_icon_yw_on",@"home_icon_yw_on",@"home_icon_yw_on",nil];
        
        self.imageArray = [[NSMutableArray alloc] initWithObjects:firstRow,secondRow, nil];
    }
    return _imageArray;
}
-(NSMutableArray *)descArray
{
    if(!_descArray)
    {
        NSMutableArray *firstRow = [[NSMutableArray alloc] initWithObjects:@"YW灯",@"RGB灯",@"home_icon_yw_on",@"冰箱",@"音响",@"电视机",nil];
        NSMutableArray *secondRow = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",nil];
        
        self.descArray = [[NSMutableArray alloc] initWithObjects:firstRow,secondRow, nil];
        
    }
    return _descArray;
}
//这里标题的添加也使用懒加载；
- (NSMutableArray *)headerArray
{
    if (!_headerArray)
    {
        self.headerArray = [[NSMutableArray alloc] initWithObjects:@"客厅",@"卧室", nil];
    }
    return _headerArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //进行CollectionView和Cell的绑定
    [self.collectionView registerClass:[CYFCollectionViewCell class]  forCellWithReuseIdentifier:@"CollectionCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //加入头部视图；
    [self.collectionView registerClass:[CYFCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    //右侧滚动条隐藏
    self.collectionView.showsVerticalScrollIndicator=false;
    

}

//有多少个section；
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //有多少个一维数组；
    return self.imageArray.count;
}

//加载头部标题；
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CYFCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    view.title.text = [self.headerArray objectAtIndex:indexPath.section];
    
    return view;
}

//每一部分有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.imageArray objectAtIndex:section] count];
}

//每一个item具体显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CYFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    //    cell.imageView.image = [UIImage imageNamed:[[self.imageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    NSString *string=[[self.imageArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [cell.imageBtn setBackgroundImage:[UIImage imageNamed:string]forState:UIControlStateNormal];
    cell.descLabel.text=@"顾金跃";
    
    return cell;
    
}
//***********************************************************************************
//下面这几个代理方法是必须实现的
//设置每一个item的宽度，高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(UISCREEN_WIDTH/ 3, UISCREEN_WIDTH/ 3);
}

//设置间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0,0,0,0);
}

//设置section的header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.collectionView.frame.size.width, 40);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}
//************************************************************************************
//item点击触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row == ([[self.imageArray objectAtIndex:indexPath.section] count] - 1)))
    {
        NSString *tempImageName = @"1";
        
        //这里需要在最后一个位置增加设备；
        
        [[self.imageArray objectAtIndex:indexPath.section] insertObject:tempImageName atIndex:[[self.imageArray objectAtIndex:indexPath.section] count]-1];
        
        [self.collectionView reloadData];
        
    }
    else
    {
        NSLog(@"第%ld个section,点击图片%ld",indexPath.section,indexPath.row);
        JYElectricalController *jyVc=[[JYElectricalController alloc]init];
        [self.navigationController pushViewController:jyVc animated:YES];
    }
    
}

- (IBAction)add
{
     NSMutableArray *addRow = [[NSMutableArray alloc] initWithObjects:@"home_icon_yw_on",@"home_icon_yw_on",@"home_icon_yw_on",@"home_icon_yw_on",@"home_icon_yw_on",@"home_icon_yw_on",nil];
    
    [self.imageArray insertObject:addRow atIndex:[self.imageArray count]];
    
    [self popEnvirnmentNameDialog];
}

- (void)popEnvirnmentNameDialog{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入Section名称" preferredStyle:UIAlertControllerStyleAlert];
    //以下方法就可以实现在提示框中输入文本；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        
        //插入到headerArray数组中
        [self.headerArray insertObject:envirnmentNameTextField.text atIndex:self.headerArray.count];
        
        //此时更新界面；
        [self.collectionView reloadData];
        
        NSLog(@"你输入的文本%@",envirnmentNameTextField.text);
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入Section名称";
    }];
    [self presentViewController:alertController animated:true completion:nil];
    
}

@end

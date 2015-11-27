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
#import "JYFurniture.h"
#import "JYFurnitureSection.h"
#import "CYFFurnitureViewController.h"
#import "CYFCollectionViewCell.h"
#import "CYFCollectionReusableView.h"
#import "JYElectricalController.h"
#import "JYFurniture.h"
#import "JYFurnitureSection.h"

#import "QRCatchViewController.h"


#define UISCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@interface CYFFurnitureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

//collectionView属性
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//增加智能区域
- (IBAction)add:(id)sender;

//智能区域数组
@property(nonatomic,strong)NSMutableArray *furnitureSecArray;
//某一区域电器数组
@property(nonatomic,strong)NSMutableArray *furnitureArray;
@end

@implementation CYFFurnitureViewController

-(NSMutableArray *)furnitureSecArray
{
    if(!_furnitureSecArray)
    {
        _furnitureSecArray=[[NSMutableArray alloc]init];
        //默认有两个智能区域
        for(int i=0;i<2;i++)
        {
            _furnitureArray=[[NSMutableArray alloc]init];
            //每个区域默认有5个电器和一个添加电器图片
            for(int i=0;i<6;i++)
            {
                //初始化一个电器
                JYFurniture *furniture=[[JYFurniture alloc]init];
                //设置电器图片
                furniture.imageStr=@"home_icon_yw_on";
                //设置电器描述文字
                furniture.descLabel=@"YW灯";
                //设置电器是否注册过
                furniture.registed=NO;
                
                //将电器添加到电器数组中
                [_furnitureArray addObject:furniture];
            }
            
            //初始化一个智能区域
            JYFurnitureSection *furnitureSection=[[JYFurnitureSection alloc]init];
            //设置智能区域的名称
            furnitureSection.sectionName=@"客厅";
            //设置智能区域的电器数组
            furnitureSection.furnitureArray=_furnitureArray;
            
            
            //将智能区域添加到智能区域数组中
            [_furnitureSecArray addObject:furnitureSection];
        }
    }
    return _furnitureSecArray;
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
    return self.furnitureSecArray.count;
}

//加载头部标题；
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CYFCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    
    JYFurnitureSection *furnitureSection=[self.furnitureSecArray objectAtIndex:indexPath.section];
    
    view.title.text=furnitureSection.sectionName;
    
    return view;
}

//每一部分有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    JYFurnitureSection *furnitureSction=[self.furnitureSecArray objectAtIndex:section];
    return furnitureSction.furnitureArray.count;
}

//每一个item具体显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CYFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    JYFurnitureSection *furnitureSection=[self.furnitureSecArray objectAtIndex:indexPath.section];
    
    JYFurniture *furniture=[furnitureSection.furnitureArray objectAtIndex:indexPath.row];
    
    [cell.imageButton setBackgroundImage:[UIImage imageNamed:furniture.imageStr] forState:UIControlStateNormal];
    cell.descLabel.text=furniture.descLabel;
    
    cell.topX.hidden=YES;
  
    return cell;
    
}
//***********************************************************************************
//下面这几个代理方法是必须实现的
//设置每一个item的宽度，高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(UISCREEN_WIDTH/ 3, UISCREEN_WIDTH/ 3);
}

//设置间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0,0,0,0);
}

//设置section的header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.collectionView.frame.size.width, 45);
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
    NSLog(@"第%ld个section,点击图片%ld",indexPath.section,indexPath.row);
    JYFurnitureSection *furnitureSection=[self.furnitureSecArray objectAtIndex:indexPath.section];
    
    if(indexPath.row==furnitureSection.furnitureArray.count-1)
    {
//        //这里需要在最后一个位置增加设备；
//        //初始化一个电器
//        JYFurniture *furniture=[[JYFurniture alloc]init];
//        //设置电器图片
//        furniture.imageStr=@"home_icon_yw_on";
//        //设置电器描述文字
//        furniture.descLabel=@"YW灯";
//        //设置电器是否注册过
//        furniture.registed=NO;
//        
//        [furnitureSection.furnitureArray addObject:furniture];
//        
//        [self.collectionView reloadData];
        [self addNewFurniture];
    }
    else
    {
        NSLog(@"第%ld个section,点击图片%ld",indexPath.section,indexPath.row);
        JYElectricalController *jyVc=[[JYElectricalController alloc]init];
        [self.navigationController pushViewController:jyVc animated:YES];
    }
    
}


- (IBAction)add:(id)sender
{
    self.furnitureArray=[[NSMutableArray alloc]init];
    //每个区域默认有5个电器和一个添加电器图片
    for(int i=0;i<6;i++)
    {
        //初始化一个电器
        JYFurniture *furniture=[[JYFurniture alloc]init];
        //设置电器图片
        furniture.imageStr=@"home_icon_yw_on";
        //设置电器描述文字
        furniture.descLabel=@"YW灯";
        //设置电器是否注册过
        furniture.registed=NO;
        
        //将电器添加到电器数组中
        [self.furnitureArray addObject:furniture];
    }
    
    [self popEnvirnmentNameDialog];

}

- (void)popEnvirnmentNameDialog
{
    //初始化一个智能区域
    JYFurnitureSection *furnitureSection=[[JYFurnitureSection alloc]init];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入智能区域名称" preferredStyle:UIAlertControllerStyleAlert];
    
    //以下方法就可以实现在提示框中输入文本；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                {
                                    UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
                                    
                                    //设置智能区域的名称
                                    furnitureSection.sectionName=envirnmentNameTextField.text;
                                    //设置智能区域的电器数组
                                    furnitureSection.furnitureArray=self.furnitureArray;
                                    //将智能区域添加到智能区域数组中
                                    [self.furnitureSecArray addObject:furnitureSection];
                                    
                                    //此时更新界面；
                                    [self.collectionView reloadData];
                                    
                                    
                                }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入智能区域名称";
    }];
    [self presentViewController:alertController animated:true completion:nil];
    
}

-(void)addNewFurniture
{
    NSLog(@"真正开始添加电器了");
  QRCatchViewController *qrCatcherVC=[[QRCatchViewController alloc]init];
  [self.navigationController pushViewController:qrCatcherVC animated:YES];
}
@end

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
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface CYFFurnitureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *image;
@property (weak, nonatomic) IBOutlet UIButton *addButtonPressed;


//智能区域数组
@property(nonatomic,strong)NSMutableArray *furnitureSecArray;
//某一区域电器数组
@property(nonatomic,strong)NSMutableArray *furnitureArray;
@end

@implementation CYFFurnitureViewController
//懒加载
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
  
  //右侧滚动条隐藏
  self.scrollView.showsVerticalScrollIndicator=false;
  self.collectionView.showsVerticalScrollIndicator=false;
  
  //动态设置collectionView/ScrollView高度；
  self.collectionView.frame = CGRectMake(0, 150, SCREEN_WIDTH, self.collectionView.frame.size.height + SCREEN_HEIGHT / 2);
  self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.collectionView.frame.size.height + SCREEN_HEIGHT / 2);
  self.addButtonPressed.frame = CGRectMake(0, self.collectionView.frame.size.height + 150, SCREEN_WIDTH, 30);
  
  //进行CollectionView和Cell的绑定
  [self.collectionView registerClass:[CYFCollectionViewCell class]  forCellWithReuseIdentifier:@"CollectionCell"];
  self.collectionView.backgroundColor = [UIColor whiteColor];
  
  //第二个以后的Header；
  [self.collectionView registerClass:[CYFCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
  
  
  //创建长按手势监听
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(myHandleTableviewCellLongPressed:)];
  longPress.minimumPressDuration = 1.0;
  //将长按手势添加到需要实现长按操作的视图里
  [self.collectionView addGestureRecognizer:longPress];
}


//长按事件的手势监听实现方法
- (void) myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
  
  CGPoint pointTouch = [gestureRecognizer locationInView:self.collectionView];
  
  if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    NSLog(@"UIGestureRecognizerStateBegan");
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
    if (indexPath == nil) {
      NSLog(@"空");
    }else{
      
      NSLog(@"Section = %ld,Row = %ld",(long)indexPath.section,(long)indexPath.row);
      
    }
  }
  if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
    NSLog(@"UIGestureRecognizerStateChanged");
  }
  
  if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    NSLog(@"UIGestureRecognizerStateEnded");
  }
}


//有多少个section；
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //有多少个一维数组；
    return self.furnitureSecArray.count;
}

//每一部分有多少个Item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  
    JYFurnitureSection *furnitureSction=[self.furnitureSecArray objectAtIndex:section];
    return furnitureSction.furnitureArray.count;
}

//加载头部标题；
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    CYFCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    
    JYFurnitureSection *furnitureSection=[self.furnitureSecArray objectAtIndex:indexPath.section];
    view.title.text=furnitureSection.sectionName;
    
    return view;
}

//每一个Item的具体显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
  CYFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];

  //找到cell中的button；
  UIButton *deviceImageButton = cell.imageButton;
  [deviceImageButton addTarget:self action:@selector(deviceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  
  //给每一个cell加边框；
  cell.layer.borderColor = [UIColor grayColor].CGColor;
  cell.layer.borderWidth = 0.55;
  
  JYFurnitureSection *furnitureSection=[self.furnitureSecArray objectAtIndex:indexPath.section];
    
  JYFurniture *furniture=[furnitureSection.furnitureArray objectAtIndex:indexPath.row];
    
  [cell.imageButton setBackgroundImage:[UIImage imageNamed:furniture.imageStr] forState:UIControlStateNormal];
   cell.descLabel.text=furniture.descLabel;
    
   return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  return CGSizeMake((SCREEN_WIDTH) / 3, (SCREEN_WIDTH) / 3);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
  
  return UIEdgeInsetsMake(0,0,0,0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
  
  return CGSizeMake(self.collectionView.frame.size.width, SCREEN_HEIGHT / 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
  
  return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
  
  return 0;
}


//item点击触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  JYFurnitureSection *furnitureSection=[self.furnitureSecArray objectAtIndex:indexPath.section];
    
  if(indexPath.row==furnitureSection.furnitureArray.count-1)
  {
    //每当增加一个cell同时增加一行的时候，CollectionView和ScrollView高度和位置要发生变化；button的位置要发生变化；
    if (indexPath.row % 3 == 2 && indexPath.row != 2)
    {
      
      //***重新设置collectionView的高度；
      self.collectionView.frame = CGRectMake(0, 150, SCREEN_WIDTH, self.collectionView.frame.size.height+ (SCREEN_WIDTH / 3) );
      //重新设置scrollView的高度
      self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.collectionView.frame.size.height + (SCREEN_WIDTH / 3) * 2);
      //重新设置button的位置；
      self.addButtonPressed.frame = CGRectMake(0, self.collectionView.frame.size.height + 150, SCREEN_WIDTH, 30);
      
    }
    else
    {
      //不用更新UI；
    }
    //这里需要在最后一个位置增加设备；
    //初始化一个电器
    JYFurniture *furniture=[[JYFurniture alloc]init];
    //设置电器图片
    furniture.imageStr=@"home_icon_yw_on";
    //设置电器描述文字
    furniture.descLabel=@"YW灯";
    //设置电器是否注册过
    furniture.registed=NO;
    [furnitureSection.furnitureArray addObject:furniture];
      
    [self.collectionView reloadData];
  }
  else
  {
    NSLog(@"第%ld个section,点击图片%ld",indexPath.section,indexPath.row);
    JYElectricalController *jyVc=[[JYElectricalController alloc]init];
    [self.navigationController pushViewController:jyVc animated:YES];
  }
  
}

#pragma mark - 点击按钮操作
- (void)deviceButtonPressed:(id)sender
{
  UIView *v = [sender superview];//获取父类view
  CYFCollectionViewCell *cell = (CYFCollectionViewCell *)[v superview];//获取cell
  
  NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];//获取cell对应的indexpath;
  
  NSLog(@"设备图片按钮被点击:%ld        %ld",(long)indexpath.section,(long)indexpath.row);
  
}


#pragma mark - 添加环境的按钮
- (IBAction)addEnvirnmentClick:(id)sender
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

#pragma mark - 弹出输入环境名称的提示框
- (void)popEnvirnmentNameDialog
{
  //初始化一个智能区域
  JYFurnitureSection *furnitureSection=[[JYFurnitureSection alloc]init];
    
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入您的职能区域名称" preferredStyle:UIAlertControllerStyleAlert];
    
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
    
    //*** 重新设置collectionView的高度；
    self.collectionView.frame = CGRectMake(0, 150, SCREEN_WIDTH, self.collectionView.frame.size.height + (SCREEN_WIDTH / 3) * 2 + SCREEN_HEIGHT / 10 );
    //重新设置scrollView的高度,这个是正确的；
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.collectionView.frame.size.height + (SCREEN_WIDTH / 3) * 2);
    //重新设置button的位置；
    self.addButtonPressed.frame = CGRectMake(0, self.collectionView.frame.size.height + 150 , SCREEN_WIDTH, 30);
    
  }]];
  
  [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
  [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    
    textField.placeholder = @"请输入智能区域名称";
  }];
  [self presentViewController:alertController animated:true completion:nil];
  
}

@end

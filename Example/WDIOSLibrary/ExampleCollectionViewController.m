//
//  ExampleCollectionViewController.m
//  WDIOSLibrary
//
//  Created by Dhanu Saksrisathaporn on 8/24/2559 BE.
//  Copyright © 2559 Dhanu Saksrisathaporn. All rights reserved.
//

#import "ExampleCollectionViewController.h"
#import <ImageIO/ImageIO.h>
#import "SampleCollectionViewCell.h"

@import WDIOSLibrary;
@interface ExampleCollectionViewController ()
@property (nonatomic,retain) NSMutableArray<NSString *> *images;
@end


@implementation ExampleCollectionViewController
- (NSMutableArray<NSString *> *)images
{
    if (!_images) {
        self.images = [NSMutableArray arrayWithCapacity:9];
        for (int i = 0; i < 9; i++) {
            _images[i] = [@(i + 1).stringValue stringByAppendingPathExtension:@"jpg"];
        }
    }
    return _images;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (NSInteger)preferNumberOfDatasPerLoad
{
    return 20;
}

void (^cmp)(NSArray *data)  = nil;

- (void)completation:(NSValue *)range;
{
    static NSInteger max = 60;
    NSRange r = range.rangeValue;
    if(r.location > max )
    {
        cmp(nil);
    }
    else {
        NSMutableArray *data = [NSMutableArray arrayWithCapacity:10];
        for (NSInteger i = r.location; i < r.location + r.length && i < max; i++) {
            [data addObject:self.images[i%self.images.count]];
        }
        cmp(data);
    }
}
- (void)loadDataOnSection:(NSInteger)section withRowRange:(NSRange)range completation:(void(^)(NSArray *data))completation;
{
    if (section == 0) {
        cmp = completation;
        [self performSelector:@selector(completation:) withObject:[NSValue valueWithRange:range] afterDelay:3];
    }
    else {
        completation(nil);
    }
}
- (UICollectionViewCell *)cellByObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    SampleCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell
    [cell setImage:[UIImage imageNamed:object]];
    cell.numberLabel.text = @(indexPath.row).stringValue;
    return cell;
}


- (BOOL)isSameObject:(id)o1 with:(id)o2 ofSection:(NSInteger)section
{
    return [o1 isEqual:o2];
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [super collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
    [(SampleCollectionViewCell *)cell updateCellOriginByView:self.collectionView];
}
- (CGSize)viewSizeByObject:(id)object
{
    NSString *path = [[NSBundle mainBundle] pathForResource:object ofType:nil];
    CGSize size = [UIImage imageSize:path];
    CGFloat max = size.width / GOLDEN_RATIO;
    if (size.height > max) {
        size.height = max;
    }
    
    return size;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray<UICollectionViewCell *> *cells = self.collectionView.visibleCells;
    for (SampleCollectionViewCell *cell in cells) {
        [(SampleCollectionViewCell *)cell updateCellOriginByView:self.collectionView];

    }
}
  
  
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
- (UIColor *)activityIndicatorViewLoadMoreColor
{
    return [UIColor blueColor];
}
@end

//
//  ZLCollectionViewVerticalLayout.m
//  ZLCollectionView
//
//  Created by zhaoliang chen on 2019/1/25.
//  Copyright © 2019 zhaoliang chen. All rights reserved.
//

#import "ZLCollectionViewVerticalLayout.h"
#import "ZLCollectionReusableView.h"
#import "ZLCollectionViewLayoutAttributes.h"

@interface ZLCollectionViewVerticalLayout ()

@end

@implementation ZLCollectionViewVerticalLayout

#pragma mark - 初始化属性
- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat totalWidth = self.collectionView.frame.size.width;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat headerH = 0;
    CGFloat footerH = 0;
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    CGFloat minimumLineSpacing = 0;
    CGFloat minimumInteritemSpacing = 0;
    NSUInteger sectionCount = [self.collectionView numberOfSections];
    self.attributesArray = [NSMutableArray new];
    self.collectionHeightsArray = [NSMutableArray arrayWithCapacity:sectionCount];
    for (int index= 0; index<sectionCount; index++) {
        NSUInteger itemCount = [self.collectionView numberOfItemsInSection:index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            headerH = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:index].height;
        } else {
            headerH = self.headerReferenceSize.height;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            footerH = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:index].height;
        } else {
            footerH = self.footerReferenceSize.height;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            edgeInsets = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
        } else {
            edgeInsets = self.sectionInset;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
            minimumLineSpacing = [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:index];
        } else {
            minimumLineSpacing = self.minimumLineSpacing;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
            minimumInteritemSpacing = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:index];
        } else {
            minimumInteritemSpacing = self.minimumInteritemSpacing;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:registerBackView:)]) {
            NSString* className = [self.delegate collectionView:self.collectionView layout:self registerBackView:index];
            if (className != nil && className.length > 0) {
                NSAssert([[NSClassFromString(className) alloc]init]!=nil, @"代理collectionView:layout:registerBackView:里面必须返回有效的类名!");
                [self registerClass:NSClassFromString(className) forDecorationViewOfKind:className];
            } else {
                [self registerClass:[ZLCollectionReusableView class] forDecorationViewOfKind:@"ZLCollectionReusableView"];
            }
        }
        else {
            [self registerClass:[ZLCollectionReusableView class] forDecorationViewOfKind:@"ZLCollectionReusableView"];
        }
        x = edgeInsets.left;
        y = [self maxHeightWithSection:index];
        
        // 添加页首属性
        if (headerH > 0) {
            NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:index];
            ZLCollectionViewLayoutAttributes* headerAttr = [ZLCollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:headerIndexPath];
            headerAttr.frame = CGRectMake(0, y, self.collectionView.frame.size.width, headerH);
            [self.attributesArray addObject:headerAttr];
        }
        
        y += headerH ;
        CGFloat itemStartY = y;
        CGFloat lastY = y;
        
        if (itemCount > 0) {
            y += edgeInsets.top;
            if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:typeOfLayout:)]) {
                self.layoutType = [self.delegate collectionView:self.collectionView layout:self typeOfLayout:index];
            }
            //NSInteger columnCount = 1;
            if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:columnCountOfSection:)]) {
                self.columnCount = [self.delegate collectionView:self.collectionView layout:self columnCountOfSection:index];
            }
            // 定义一个列高数组 记录每一列的总高度
            CGFloat *columnHeight = (CGFloat *) malloc(self.columnCount * sizeof(CGFloat));
            CGFloat itemWidth = 0.0;
            if (self.layoutType == ClosedLayout) {
                for (int i=0; i<self.columnCount; i++) {
                    columnHeight[i] = y;
                }
                itemWidth = (totalWidth - edgeInsets.left - edgeInsets.right - minimumInteritemSpacing * (self.columnCount - 1)) / self.columnCount;
            }
            CGFloat maxYOfPercent = -1;
            CGFloat maxYOfFill = y;
            NSMutableArray* arrayOfPercent = [NSMutableArray new];  //储存百分比布局的数组
            NSMutableArray* arrayOfFill = [NSMutableArray new];     //储存填充式布局的数组
            NSMutableArray* arrayOfAbsolute = [NSMutableArray new]; //储存绝对定位布局的数组
            for (int i=0; i<itemCount; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:index];
                CGSize itemSize = CGSizeZero;
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
                    itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
                } else {
                    itemSize = self.itemSize;
                }
                ZLCollectionViewLayoutAttributes *attributes = [ZLCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                
                NSInteger preRow = self.attributesArray.count - 1;
                switch (self.layoutType) {
#pragma mark 标签布局处理
                    case LabelLayout: {
                        //找上一个cell
                        if(preRow >= 0){
                            if(i > 0) {
                                ZLCollectionViewLayoutAttributes *preAttr = self.attributesArray[preRow];
                                x = preAttr.frame.origin.x + preAttr.frame.size.width + minimumInteritemSpacing;
                                if (x + itemSize.width > totalWidth - edgeInsets.right) {
                                    x = edgeInsets.left;
                                    y += itemSize.height + minimumLineSpacing;
                                }
                            }
                        }
                        if (itemSize.width > (totalWidth-edgeInsets.left-edgeInsets.right)) {
                            itemSize.width = (totalWidth-edgeInsets.left-edgeInsets.right);
                        }
                        attributes.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
                    }
                        break;
#pragma mark 列布局处理
                    case ClosedLayout: {
                        CGFloat max = CGFLOAT_MAX;
                        NSInteger column = 0;
                        for (int i = 0; i < self.columnCount; i++) {
                            if (columnHeight[i] < max) {
                                max = columnHeight[i];
                                column = i;
                            }
                        }
                        CGFloat itemX = edgeInsets.left + (itemWidth+minimumInteritemSpacing)*column;
                        CGFloat itemY = columnHeight[column];
                        attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemSize.height);
                        columnHeight[column] += (itemSize.height + minimumLineSpacing);
                    }
                        break;
#pragma mark 百分比布局处理
                    case PercentLayout: {
                        CGFloat percent = 0.0f;
                        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:percentOfRow:)]) {
                            percent = [self.delegate collectionView:self.collectionView layout:self percentOfRow:indexPath];
                        } else {
                            percent = 1;
                        }
                        if (percent > 1 || percent <= 0) {
                            percent = 1;
                        }
                        
                        if (arrayOfPercent.count > 0) {
                            CGFloat totalPercent = 0;
                            for (NSDictionary* dic in arrayOfPercent) {
                                totalPercent += [dic[@"percent"] floatValue];
                            }
                            if ((totalPercent+percent) >= 1.0) {
                                if ((totalPercent+percent) < 1.1) {
                                    //小于1.1就当成一行来计算
                                    //先添加进总的数组
                                    attributes.indexPath = indexPath;
                                    attributes.frame = CGRectMake(0, 0, (itemSize.width>self.collectionView.frame.size.width-edgeInsets.left-edgeInsets.right)?self.collectionView.frame.size.width-edgeInsets.left-edgeInsets.right:itemSize.width, itemSize.height);
                                    //再添加进计算比例的数组
                                    [arrayOfPercent addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"item":attributes,@"percent":[NSNumber numberWithFloat:percent],@"indexPath":indexPath}]];
                                    if ((totalPercent+percent) > 1) {
                                        NSMutableDictionary* lastDic = [NSMutableDictionary dictionaryWithDictionary:arrayOfPercent.lastObject];
                                        CGFloat lastPercent = 1.0;
                                        for (NSInteger i=0; i<arrayOfPercent.count-1; i++) {
                                            NSMutableDictionary* dic = arrayOfPercent[i];
                                            lastPercent -= [dic[@"percent"] floatValue];
                                        }
                                        lastDic[@"percent"] = [NSNumber numberWithFloat:lastPercent];
                                        [arrayOfPercent replaceObjectAtIndex:arrayOfPercent.count-1 withObject:lastDic];
                                    }
                                    
                                    CGFloat realWidth = totalWidth - edgeInsets.left - edgeInsets.right - (arrayOfPercent.count-1)*minimumInteritemSpacing;
                                    for (NSInteger i=0; i<arrayOfPercent.count; i++) {
                                        NSDictionary* dic = arrayOfPercent[i];
                                        ZLCollectionViewLayoutAttributes *newAttributes = dic[@"item"];
                                        CGFloat itemX = 0.0f;
                                        if (i==0) {
                                            itemX = edgeInsets.left;
                                        } else {
                                            ZLCollectionViewLayoutAttributes *preAttr = arrayOfPercent[i-1][@"item"];
                                            itemX = preAttr.frame.origin.x + preAttr.frame.size.width + minimumInteritemSpacing;
                                        }
                                        newAttributes.frame = CGRectMake(itemX, (maxYOfPercent==-1)?y:maxYOfPercent+minimumLineSpacing, realWidth*[dic[@"percent"] floatValue], newAttributes.frame.size.height);
                                        newAttributes.indexPath = dic[@"indexPath"];
                                        //if (![self.attributesArray containsObject:newAttributes]) {
                                        [self.attributesArray addObject:newAttributes];
                                        //}
                                    }
                                    for (NSInteger i=0; i<arrayOfPercent.count; i++) {
                                        NSDictionary* dic = arrayOfPercent[i];
                                        ZLCollectionViewLayoutAttributes *item = dic[@"item"];
                                        if ((item.frame.origin.y + item.frame.size.height) > maxYOfPercent) {
                                            maxYOfPercent = (item.frame.origin.y + item.frame.size.height);
                                        }
                                    }
                                    [arrayOfPercent removeAllObjects];
                                }
                                else {
                                    //先添加进总的数组
                                    if (arrayOfPercent.count > 0) {
                                        for (int i=0; i<arrayOfPercent.count; i++) {
                                            NSDictionary* dic = arrayOfPercent[i];
                                            ZLCollectionViewLayoutAttributes* attr = dic[@"item"];
                                            if ((attr.frame.origin.y+attr.frame.size.height) > maxYOfPercent ) {
                                                maxYOfPercent = attr.frame.origin.y+attr.frame.size.height;
                                            }
                                        }
                                    }
                                    attributes.indexPath = indexPath;
                                    attributes.frame = CGRectMake(edgeInsets.left, maxYOfPercent, (itemSize.width>self.collectionView.frame.size.width-edgeInsets.left-edgeInsets.right)?self.collectionView.frame.size.width-edgeInsets.left-edgeInsets.right:itemSize.width, itemSize.height);
                                    for (int i=0; i<arrayOfPercent.count; i++) {
                                        NSDictionary* dic = arrayOfPercent[i];
                                        ZLCollectionViewLayoutAttributes* attr = dic[@"item"];
                                        attr.indexPath = dic[@"indexPath"];
                                        [self.attributesArray addObject:attr];
                                    }
                                    [arrayOfPercent removeAllObjects];
                                    //再添加进计算比例的数组
                                    [arrayOfPercent addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"item":attributes,@"percent":[NSNumber numberWithFloat:percent],@"indexPath":indexPath}]];
                                    //如果该行item总比例还是小于1，但是item已经是最后一个
                                    if (i==itemCount-1) {
                                        CGFloat realWidth = totalWidth - edgeInsets.left - edgeInsets.right - (arrayOfPercent.count-1)*minimumInteritemSpacing;
                                        for (NSInteger i=0; i<arrayOfPercent.count; i++) {
                                            NSDictionary* dic = arrayOfPercent[i];
                                            ZLCollectionViewLayoutAttributes *newAttributes = dic[@"item"];
                                            CGFloat itemX = 0.0f;
                                            if (i==0) {
                                                itemX = edgeInsets.left;
                                            } else {
                                                ZLCollectionViewLayoutAttributes *preAttr = arrayOfPercent[i-1][@"item"];
                                                itemX = preAttr.frame.origin.x + preAttr.frame.size.width + minimumInteritemSpacing;
                                            }
                                            newAttributes.frame = CGRectMake(itemX, (maxYOfPercent==-1)?y:maxYOfPercent+minimumLineSpacing, realWidth*[dic[@"percent"] floatValue], newAttributes.frame.size.height);
                                            newAttributes.indexPath = dic[@"indexPath"];
                                            [self.attributesArray addObject:newAttributes];
                                        }
                                        for (NSInteger i=0; i<arrayOfPercent.count; i++) {
                                            NSDictionary* dic = arrayOfPercent[i];
                                            ZLCollectionViewLayoutAttributes *item = dic[@"item"];
                                            if ((item.frame.origin.y + item.frame.size.height) > maxYOfPercent) {
                                                maxYOfPercent = (item.frame.origin.y + item.frame.size.height);
                                            }
                                        }
                                        [arrayOfPercent removeAllObjects];
                                    }
                                }
                            }
                            else {
                                //先添加进总的数组
                                attributes.indexPath = indexPath;
                                NSDictionary* lastDicForPercent = arrayOfPercent[arrayOfPercent.count-1];
                                ZLCollectionViewLayoutAttributes *lastAttributesForPercent = lastDicForPercent[@"item"];
                                attributes.frame = CGRectMake(lastAttributesForPercent.frame.origin.x+lastAttributesForPercent.frame.size.width+minimumInteritemSpacing, lastAttributesForPercent.frame.origin.y, itemSize.width, itemSize.height);
                                //再添加进计算比例的数组
                                [arrayOfPercent addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"item":attributes,@"percent":[NSNumber numberWithFloat:percent],@"indexPath":indexPath}]];
                                //如果已经是最后一个
                                if (i==itemCount-1) {
                                    NSInteger space = arrayOfPercent.count-1;
                                    if (arrayOfPercent.count > 0) {
                                        NSDictionary* dic = arrayOfPercent[0];
                                        BOOL equal = YES;
                                        for (NSDictionary* d in arrayOfPercent) {
                                            if ([dic[@"percent"] floatValue] != [d[@"percent"] floatValue]) {
                                                equal = NO;
                                                break;
                                            }
                                        }
                                        if (equal == YES) {
                                            space = (1/([dic[@"percent"] floatValue]))-1;
                                        }
                                    }
                                    CGFloat realWidth = totalWidth - edgeInsets.left - edgeInsets.right - space*minimumInteritemSpacing;
                                    for (NSInteger i=0; i<arrayOfPercent.count; i++) {
                                        NSDictionary* dic = arrayOfPercent[i];
                                        ZLCollectionViewLayoutAttributes *newAttributes = dic[@"item"];
                                        CGFloat itemX = 0.0f;
                                        if (i==0) {
                                            itemX = edgeInsets.left;
                                        } else {
                                            ZLCollectionViewLayoutAttributes *preAttr = arrayOfPercent[i-1][@"item"];
                                            itemX = preAttr.frame.origin.x + preAttr.frame.size.width + minimumInteritemSpacing;
                                        }
                                        newAttributes.frame = CGRectMake(itemX, (maxYOfPercent==-1)?y:maxYOfPercent+minimumLineSpacing, realWidth*[dic[@"percent"] floatValue], newAttributes.frame.size.height);
                                        newAttributes.indexPath = dic[@"indexPath"];
                                        //if (![self.attributesArray containsObject:newAttributes]) {
                                        [self.attributesArray addObject:newAttributes];
                                        //}
                                    }
                                    for (NSInteger i=0; i<arrayOfPercent.count; i++) {
                                        NSDictionary* dic = arrayOfPercent[i];
                                        ZLCollectionViewLayoutAttributes *item = dic[@"item"];
                                        if ((item.frame.origin.y + item.frame.size.height) > maxYOfPercent) {
                                            maxYOfPercent = (item.frame.origin.y + item.frame.size.height);
                                        }
                                    }
                                    [arrayOfPercent removeAllObjects];
                                } else {
                                    
                                }
                            }
                        }
                        else {
                            //先添加进总的数组
                            attributes.indexPath = indexPath;
                            attributes.frame = CGRectMake(edgeInsets.left, (maxYOfPercent==-1)?y:maxYOfPercent+minimumLineSpacing, (itemSize.width>self.collectionView.frame.size.width-edgeInsets.left-edgeInsets.right)?self.collectionView.frame.size.width-edgeInsets.left-edgeInsets.right:itemSize.width, itemSize.height);
                            //再添加进计算比例的数组
                            [arrayOfPercent addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"item":attributes,@"percent":[NSNumber numberWithFloat:percent],@"indexPath":indexPath}]];
                            //如果已经是最后一个
                            if (i==itemCount-1) {
                                NSInteger space = arrayOfPercent.count-1;
                                if (arrayOfPercent.count > 0) {
                                    NSDictionary* dic = arrayOfPercent[0];
                                    BOOL equal = YES;
                                    for (NSDictionary* d in arrayOfPercent) {
                                        if ([dic[@"percent"] floatValue] != [d[@"percent"] floatValue]) {
                                            equal = NO;
                                            break;
                                        }
                                    }
                                    if (equal == YES) {
                                        space = (1/([dic[@"percent"] floatValue]))-1;
                                    }
                                }
                                CGFloat realWidth = totalWidth - edgeInsets.left - edgeInsets.right - space*minimumInteritemSpacing;
                                for (NSInteger i=0; i<arrayOfPercent.count; i++) {
                                    NSDictionary* dic = arrayOfPercent[i];
                                    ZLCollectionViewLayoutAttributes *newAttributes = dic[@"item"];
                                    CGFloat itemX = 0.0f;
                                    if (i==0) {
                                        itemX = edgeInsets.left;
                                    } else {
                                        ZLCollectionViewLayoutAttributes *preAttr = arrayOfPercent[i-1][@"item"];
                                        itemX = preAttr.frame.origin.x + preAttr.frame.size.width + minimumInteritemSpacing;
                                    }
                                    newAttributes.frame = CGRectMake(itemX, (maxYOfPercent==-1)?y:maxYOfPercent+minimumLineSpacing, realWidth*[dic[@"percent"] floatValue], newAttributes.frame.size.height);
                                    newAttributes.indexPath = dic[@"indexPath"];
                                    [self.attributesArray addObject:newAttributes];
                                }
                                for (NSInteger i=0; i<arrayOfPercent.count; i++) {
                                    NSDictionary* dic = arrayOfPercent[i];
                                    ZLCollectionViewLayoutAttributes *item = dic[@"item"];
                                    if ((item.frame.origin.y + item.frame.size.height) > maxYOfPercent) {
                                        maxYOfPercent = (item.frame.origin.y + item.frame.size.height);
                                    }
                                }
                                [arrayOfPercent removeAllObjects];
                            } else {
                                
                            }
                        }
                    }
                        break;
#pragma mark 填充布局处理
                    case FillLayout: {
                        if (arrayOfFill.count == 0) {
                            attributes.frame = CGRectMake(self.isFloor?floor(edgeInsets.left):edgeInsets.left, self.isFloor?floor(maxYOfFill):maxYOfFill, self.isFloor?floor(itemSize.width):itemSize.width, self.isFloor?floor(itemSize.height):itemSize.height);
                            [arrayOfFill addObject:attributes];
                        } else {
                            NSMutableArray *arrayXOfFill = [NSMutableArray new];
                            [arrayXOfFill addObject:self.isFloor?@(floor(edgeInsets.left)):@(edgeInsets.left)];
                            NSMutableArray *arrayYOfFill = [NSMutableArray new];
                            [arrayYOfFill addObject:self.isFloor?@(floor(maxYOfFill)):@(maxYOfFill)];
                            for (ZLCollectionViewLayoutAttributes* attr in arrayOfFill) {
                                if (![arrayXOfFill containsObject:self.isFloor?@(floor(attr.frame.origin.x)):@(attr.frame.origin.x)]) {
                                    [arrayXOfFill addObject:self.isFloor?@(floor(attr.frame.origin.x)):@(attr.frame.origin.x)];
                                }
                                if (![arrayXOfFill containsObject:self.isFloor?@(floor(attr.frame.origin.x+attr.frame.size.width)):@(attr.frame.origin.x+attr.frame.size.width)]) {
                                    [arrayXOfFill addObject:self.isFloor?@(floor(attr.frame.origin.x+attr.frame.size.width)):@(attr.frame.origin.x+attr.frame.size.width)];
                                }
                                if (![arrayYOfFill containsObject:self.isFloor?@(floor(attr.frame.origin.y)):@(attr.frame.origin.y)]) {
                                    [arrayYOfFill addObject:self.isFloor?@(floor(attr.frame.origin.y)):@(attr.frame.origin.y)];
                                }
                                if (![arrayYOfFill containsObject:self.isFloor?@(floor(attr.frame.origin.y+attr.frame.size.height)):@(attr.frame.origin.y+attr.frame.size.height)]) {
                                    [arrayYOfFill addObject:self.isFloor?@(floor(attr.frame.origin.y+attr.frame.size.height)):@(attr.frame.origin.y+attr.frame.size.height)];
                                }
                            }
                            [arrayXOfFill sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                return [obj1 floatValue] > [obj2 floatValue];
                            }];
                            [arrayYOfFill sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                return [obj1 floatValue] > [obj2 floatValue];
                            }];
                            BOOL qualified = YES;
                            for (NSNumber* yFill in arrayYOfFill) {
                                for (NSNumber* xFill in arrayXOfFill) {
                                    qualified = YES;
                                    CGFloat attrX = floor([xFill floatValue])==floor(edgeInsets.left)?floor([xFill floatValue]):(floor([xFill floatValue])+minimumInteritemSpacing);
                                    CGFloat attrY = floor([yFill floatValue])==floor(maxYOfFill)?(self.isFloor?floor([yFill floatValue]):floor([yFill floatValue])):floor([yFill floatValue])+floor(minimumLineSpacing);
                                    attributes.frame = CGRectMake(attrX, attrY, self.isFloor?floor(itemSize.width):itemSize.width, self.isFloor?floor(itemSize.height):itemSize.height);
                                    if (floor(attributes.frame.origin.x)+floor(attributes.frame.size.width) > floor(totalWidth)-floor(edgeInsets.right)) {
                                        qualified = NO;
                                        break;
                                    }
                                    for (ZLCollectionViewLayoutAttributes* attr in arrayOfFill) {
                                        if (CGRectIntersectsRect(attributes.frame, attr.frame)) {
                                            qualified = NO;
                                            break;
                                        }
                                    }
                                    if (qualified == NO) {
                                        continue;
                                    } else {
                                        CGPoint leftPt = CGPointMake(attributes.frame.origin.x - minimumInteritemSpacing, attributes.frame.origin.y);
                                        CGRect leftRect = CGRectZero;
                                        for (ZLCollectionViewLayoutAttributes* attr in arrayOfFill) {
                                            if (CGRectContainsPoint(attr.frame, leftPt)) {
                                                leftRect = attr.frame;
                                                break;
                                            }
                                        }
                                        if (CGRectEqualToRect(leftRect, CGRectZero)) {
                                            break;
                                        } else {
                                            if (attributes.frame.origin.x - (leftRect.origin.x + leftRect.size.width) >= minimumInteritemSpacing) {
                                                break;
                                            } else if (floor(leftRect.origin.x) + floor(leftRect.size.width) <= leftPt.x) {
                                                break;
                                            } else {
                                                CGRect rc = attributes.frame;
                                                rc.origin.x = leftRect.origin.x + leftRect.size.width + minimumInteritemSpacing;
                                                attributes.frame = rc;
                                                for (ZLCollectionViewLayoutAttributes* attr in arrayOfFill) {
                                                    if (CGRectIntersectsRect(attributes.frame, attr.frame)) {
                                                        qualified = NO;
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                if (qualified == YES) {
                                    break;
                                }
                            }
                            if (qualified == YES) {
                                //NSLog(@"第%d个,合格的矩形区域=%@",i,NSStringFromCGRect(attributes.frame));
                            }
                            [arrayOfFill addObject:attributes];
                        }
                    }
                        break;
#pragma mark 绝对定位布局处理
                    case AbsoluteLayout: {
                        CGRect itemFrame = CGRectZero;
                        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:rectOfItem:)]) {
                            itemFrame = [self.delegate collectionView:self.collectionView layout:self rectOfItem:indexPath];
                        }
                        CGFloat absolute_x = edgeInsets.left+itemFrame.origin.x;
                        CGFloat absolute_y = y+itemFrame.origin.y;
                        CGFloat absolute_w = itemFrame.size.width;
                        if ((absolute_x+absolute_w>self.collectionView.frame.size.width-edgeInsets.right)&&(absolute_x<self.collectionView.frame.size.width-edgeInsets.right)) {
                            absolute_w -= (absolute_x+absolute_w-(self.collectionView.frame.size.width-edgeInsets.right));
                        }
                        CGFloat absolute_h = itemFrame.size.height;
                        attributes.frame = CGRectMake(absolute_x, absolute_y, absolute_w, absolute_h);
                        [arrayOfAbsolute addObject:attributes];
                    }
                        break;
                    default: {
                        //NSLog(@"%@",NSStringFromCGRect(attributes.frame));
                    }
                        break;
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:transformOfItem:)]) {
                    attributes.transform3D = [self.delegate collectionView:self.collectionView layout:self transformOfItem:indexPath];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:zIndexOfItem:)]) {
                    attributes.zIndex = [self.delegate collectionView:self.collectionView layout:self zIndexOfItem:indexPath];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:alphaOfItem:)]) {
                    attributes.alpha = [self.delegate collectionView:self.collectionView layout:self alphaOfItem:indexPath];
                }
                attributes.indexPath = indexPath;
                if (self.layoutType != PercentLayout) {
                    //if (![self.attributesArray containsObject:attributes]) {
                    [self.attributesArray addObject:attributes];
                    //}
                }
                if (self.layoutType == ClosedLayout) {
                    CGFloat max = 0;
                    for (int i = 0; i < self.columnCount; i++) {
                        if (columnHeight[i] > max) {
                            max = columnHeight[i];
                        }
                    }
                    lastY = max;
                } else if (self.layoutType == PercentLayout) {
                    lastY = maxYOfPercent;
                } else if (self.layoutType == FillLayout) {
                    if (i==itemCount-1) {
                        for (ZLCollectionViewLayoutAttributes* attr in arrayOfFill) {
                            if (maxYOfFill < attr.frame.origin.y+attr.frame.size.height) {
                                maxYOfFill = attr.frame.origin.y+attr.frame.size.height;
                            }
                        }
                    }
                    lastY = maxYOfFill;
                } else if (self.layoutType == AbsoluteLayout) {
                    if (i==itemCount-1) {
                        for (ZLCollectionViewLayoutAttributes* attr in arrayOfAbsolute) {
                            if (lastY < attr.frame.origin.y+attr.frame.size.height) {
                                lastY = attr.frame.origin.y+attr.frame.size.height;
                            }
                        }
                    }
                } else {
                    lastY = attributes.frame.origin.y + attributes.frame.size.height;
                }
            }
            free(columnHeight);
        }
        if (self.layoutType == ClosedLayout) {
            if (itemCount > 0) {
                lastY -= minimumLineSpacing;
            }
        }
        if (itemCount > 0) {
            lastY += edgeInsets.bottom;
        }
        
#pragma mark 添加背景图
        CGFloat backHeight = lastY-itemStartY+([self isAttachToTop:index]?headerH:0);
        if (backHeight < 0) {
            backHeight = 0;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:registerBackView:)]) {
            NSString* className = [self.delegate collectionView:self.collectionView layout:self registerBackView:index];
            if (className != nil && className.length > 0) {
                ZLCollectionViewLayoutAttributes *attr = [ZLCollectionViewLayoutAttributes  layoutAttributesForDecorationViewOfKind:className withIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
                attr.frame = CGRectMake(0, [self isAttachToTop:index]?itemStartY-headerH:itemStartY, self.collectionView.frame.size.width, backHeight);
                attr.zIndex = -1000;
                [self.attributesArray addObject:attr];
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:loadView:)]) {
                    [self.delegate collectionView:self.collectionView layout:self loadView:index];
                }
            } else {
                ZLCollectionViewLayoutAttributes *attr = [ZLCollectionViewLayoutAttributes  layoutAttributesForDecorationViewOfKind:@"ZLCollectionReusableView" withIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
                attr.frame = CGRectMake(0, [self isAttachToTop:index]?itemStartY-headerH:itemStartY, self.collectionView.frame.size.width, backHeight);
                attr.color = self.collectionView.backgroundColor;
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:backColorForSection:)]) {
                    attr.color = [self.delegate collectionView:self.collectionView layout:self backColorForSection:index];
                }
                attr.zIndex = -1000;
                [self.attributesArray addObject:attr];
            }
        } else {
            ZLCollectionViewLayoutAttributes *attr = [ZLCollectionViewLayoutAttributes  layoutAttributesForDecorationViewOfKind:@"ZLCollectionReusableView" withIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
            attr.frame = CGRectMake(0, [self isAttachToTop:index]?itemStartY-headerH:itemStartY, self.collectionView.frame.size.width, backHeight);
            attr.color = self.collectionView.backgroundColor;
            if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:backColorForSection:)]) {
                attr.color = [self.delegate collectionView:self.collectionView layout:self backColorForSection:index];
            }
            attr.zIndex = -1000;
            [self.attributesArray addObject:attr];
        }
        
        // 添加页脚属性
        if (footerH > 0) {
            NSIndexPath *footerIndexPath = [NSIndexPath indexPathForItem:0 inSection:index];
            ZLCollectionViewLayoutAttributes *footerAttr = [ZLCollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:footerIndexPath];
            footerAttr.frame = CGRectMake(0, lastY, self.collectionView.frame.size.width, footerH);
            [self.attributesArray addObject:footerAttr];
            lastY += footerH;
        }
        self.collectionHeightsArray[index] = [NSNumber numberWithFloat:lastY];
    }
//    for (ZLCollectionViewLayoutAttributes* attr in self.attributesArray) {
//        NSLog(@"类型=%@,尺寸=%@",attr.representedElementKind, NSStringFromCGRect(attr.frame));
//    }
}

#pragma mark - CollectionView的滚动范围
- (CGSize)collectionViewContentSize
{
    if (self.collectionHeightsArray.count <= 0) {
        return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    }
    CGFloat footerH = 0.0f;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        footerH = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:self.collectionHeightsArray.count-1].height;
    } else {
        footerH = self.footerReferenceSize.height;
    }
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        edgeInsets = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:self.collectionHeightsArray.count-1];
    } else {
        edgeInsets = self.sectionInset;
    }
    return CGSizeMake(self.collectionView.frame.size.width, [self.collectionHeightsArray[self.collectionHeightsArray.count-1] floatValue]);// + edgeInsets.bottom + footerH);
    
}

/**
 每个区的初始Y坐标
 @param section 区索引
 @return Y坐标
 */
- (CGFloat)maxHeightWithSection:(NSInteger)section {
    if (section>0) {
        return [self.collectionHeightsArray[section-1] floatValue];
    } else {
        return 0;
    }
}

- (BOOL)isAttachToTop:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:attachToTop:)]) {
        return [self.delegate collectionView:self.collectionView layout:self attachToTop:section];
    }
    return NO;
}

@end

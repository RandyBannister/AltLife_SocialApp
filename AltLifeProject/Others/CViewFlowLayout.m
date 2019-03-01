//
//  CViewFlowLayout.m
//  AltLife
//
//  Created by BradReed on 10/12/17.
//  Copyright © 2017 BradReed. All rights reserved.
//

#import "CViewFlowLayout.h"

@implementation CViewFlowLayout


#define numColumns 2
@synthesize numOfColumnsToDisplay;
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* attributesToReturn = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in attributesToReturn)
    {
        if (nil == attributes.representedElementKind)
        {
            NSIndexPath* indexPath = attributes.indexPath;
            attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        }
    }
    return attributesToReturn;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath* )indexPath
{
    UICollectionViewLayoutAttributes* currentItemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    if (indexPath.item < numColumns){
        CGRect f = currentItemAttributes.frame;
        f.origin.y = 0;
        currentItemAttributes.frame = f;
        return currentItemAttributes;
    }
    NSIndexPath* ipPrev = [NSIndexPath indexPathForItem:indexPath.item-numColumns inSection:indexPath.section];
    CGRect fPrev = [self layoutAttributesForItemAtIndexPath:ipPrev].frame;
    CGFloat YPointNew = fPrev.origin.y + fPrev.size.height + 10;
    CGRect f = currentItemAttributes.frame;
    f.origin.y = YPointNew;
    currentItemAttributes.frame = f;
    return currentItemAttributes;
}
@end

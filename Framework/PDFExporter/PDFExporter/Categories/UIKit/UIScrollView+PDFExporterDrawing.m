//
//  UIScrollView+Extension.m
//  PDFExporter
//
//  Copyright © 2016 3Pillar Global. All rights reserved.
//

#import "UIScrollView+PDFExporterDrawing.h"
#import <objc/runtime.h>
#import "UIView+PDFExporterStatePersistance.h"

static void * const kUIScrollViewDrawEntireContentSizeAssociatedStorageKey = (void *)&kUIScrollViewDrawEntireContentSizeAssociatedStorageKey;

@interface UIScrollViewPersistenceState : UIViewPersistenceState

@property (nonatomic) CGPoint contentOffset;

@end

@implementation UIScrollViewPersistenceState

@end


@implementation UIScrollView (PDFExporterDrawing)

- (CGRect)drawingFrame {
    CGRect drawingFrame = self.frame;
    if ([self isDrawingEntireContentSize]) {
        drawingFrame.size.height = fmaxf(self.contentSize.height, CGRectGetHeight(self.frame));
    }
    return drawingFrame;
}

- (BOOL)isDrawingEntireContentSize {
    NSNumber *drawEntireContentSizeNumber = objc_getAssociatedObject(self, kUIScrollViewDrawEntireContentSizeAssociatedStorageKey);
    return [drawEntireContentSizeNumber boolValue];
}

- (void)setDrawEntireContentSize:(BOOL)drawEntireContentSize {
    NSNumber *drawEntireContentSizeNumber = nil;
    if (drawEntireContentSize) {
        drawEntireContentSizeNumber = @(drawEntireContentSize);
    }
    objc_setAssociatedObject(self, kUIScrollViewDrawEntireContentSizeAssociatedStorageKey, drawEntireContentSizeNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - StatePersistanceSubclassing

- (Class)stateClass {
    return [UIScrollViewPersistenceState class];
}

- (void)configureState:(UIViewPersistenceState *)state {
    [super configureState:state];
    
    if (!self.drawEntireContentSize) {
        return;
    }
    UIScrollViewPersistenceState *scrollState = (UIScrollViewPersistenceState *)state;
    scrollState.contentOffset = self.contentOffset;
}

- (void)performRestoreWithState:(UIViewPersistenceState *)state {
    [super performRestoreWithState:state];
    
    if (!self.drawEntireContentSize) {
        return;
    }
    UIScrollViewPersistenceState *scrollState = (UIScrollViewPersistenceState *)state;
    self.contentOffset = scrollState.contentOffset;
}

@end

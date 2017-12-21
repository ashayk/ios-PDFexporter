//
//  UIView+PDFExporterPageInformation.m
//  PDFExporter
//
//  Copyright © 2016 3Pillar Global. All rights reserved.
//

#import "UIView+PDFExporterPageInformation.h"
#import "UIView+PDFExporterViewSlicing.h"
#import "UIView+PDFExporterDrawing.h"
#import "CGGeometry+Additions.h"
#import "CGFloat+Additions.h"
#import "PDFRenderingDelegate.h"

@implementation UIView (PDFExporterPageInformation)

- (BOOL)askSubviewsRenderingOffset {
    return YES;
}

- (BOOL)canLayoutSubview:(UIView *)subview intersection:(CGRect)intersection {
    return CGFloatIsEqual(CGRectGetHeight(intersection), CGRectGetHeight(subview.drawingFrame));
}

- (BOOL)shouldConsiderLayoutSubview:(UIView *)subview intersection:(CGRect)intersection {
    return CGFloatIsEqual(CGRectGetHeight(intersection), CGRectGetHeight(subview.drawingFrame));
}

- (CGPoint)renderingOffsetForPageRect:(CGRect)rect {
    CGRect newRect = rect;
    CGPoint renderingOffset = CGPointZero;
    CGRect intersection = [self intersectionRectForDrawingPageRect:newRect];
    CGFloat intersectionHeight = CGRectGetHeight(intersection);
    if (CGRectIsEmpty(intersection) ||
        CGFloatIsEqual(intersectionHeight, CGRectGetHeight(self.drawingFrame))) {
        return CGPointZero;
    }
    if (intersectionHeight != rect.size.height) {
        renderingOffset.y = [self yOffsetForIntersection:intersection];
    }

    newRect.size.height = rect.size.height - renderingOffset.y;

    for (UIView *subview in [self sortedSubViews]) {
        CGPoint subviewOffset = [subview renderingOffsetForPageRect:newRect];
        if (subviewOffset.y != 0) {
            renderingOffset.y += subviewOffset.y;
        }
        newRect.size.height = rect.size.height - renderingOffset.y;
    }

    return renderingOffset;
}

- (CGFloat)yOffsetForIntersection:(CGRect)intersection {
    return  CGRectGetHeight(intersection);
}

//- (CGPoint)renderingOffsetForPageRect:(CGRect)rect {
//    CGPoint renderingOffset = CGPointZero;
//    if (![self askSubviewsRenderingOffset]) {
//        return renderingOffset;
//    }
//    for (UIView *subview in self.subviews) {
//        if ([subview isDrawable]) {
//            CGRect intersection = [self subviewIntersection:subview layoutPageRect:rect];
//            if (CGRectIsNull(intersection) ||                                   // skip subviews that are not visible,
//                [self canLayoutSubview:subview intersection:intersection]) {    // or it is possible to draw them
//                continue;                                                       // on current page
//            }
//            CGPoint subviewRenderingOffset = [subview renderingOffsetForPageRect:rect];
//            CGFloat subviewYOffset = (subviewRenderingOffset.y) ?
//            fminf(CGRectGetHeight(intersection), subviewRenderingOffset.y) : CGRectGetHeight(intersection);
//            if (CGFloatIsEqual(CGRectGetHeight(rect), subviewYOffset)) { // views that has equal or greater height than
//                continue;                                                // the page will not be moved to the next page
//            }
//            // test again, required for special cases like table cells
//            if ([self shouldConsiderLayoutSubview:subview intersection:intersection] == NO) {
//                subviewYOffset = CGRectGetHeight(intersection);
//            }
//            renderingOffset.y = fmaxf(renderingOffset.y, subviewYOffset);
//        }
//    }
//    return renderingOffset;
//}

- (CGRect)subviewRect:(UIView *)subview layoutPageRect:(CGRect)rect {
    CGRect subviewRect = subview.drawingFrame;
    subviewRect = [self.renderingDelegate view:self convertRectToRootView:subviewRect];
    return subviewRect;
}

- (CGRect)subviewIntersection:(UIView *)subview layoutPageRect:(CGRect)rect {
    CGRect subviewRect = [self subviewRect:subview layoutPageRect:rect];
    return CGRectIntersection(subviewRect, rect);
}

- (NSArray<UIView *>*)sortedSubViews {
    return [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView * _Nonnull view1,
                                                                         UIView * _Nonnull view2) {
        return CGRectGetMaxY(view1.drawingFrame) < CGRectGetMaxY(view2.drawingFrame);
    }];
}

@end

@implementation UIButton (PDFExporterPageInformationPrivate)

- (BOOL)askSubviewsRenderingOffset {
    return NO;
}

@end

@implementation UIControl (PDFExporterPageInformationPrivate)

- (BOOL)askSubviewsRenderingOffset {
    return NO;
}

@end

@implementation UIImageView (PDFExporterPageInformationPrivate)

- (BOOL)askSubviewsRenderingOffset {
    return NO;
}

@end

@implementation UIInputView (PDFExporterPageInformationPrivate)

- (BOOL)askSubviewsRenderingOffset {
    return NO;
}

@end

@implementation UITextView (PDFExporterPageInformationPrivate)

- (BOOL)askSubviewsRenderingOffset {
    return NO;
}

@end

@implementation UILabel (PDFExporterPageInformationPrivate)

- (BOOL)askSubviewsRenderingOffset {
    return NO;
}

@end

@implementation UICollectionReusableView (PDFExporterPageInformationPrivate)

- (BOOL)askSubviewsRenderingOffset {
    return NO;
}

@end

@implementation UITableViewCell (PDFExporterPageInformationPrivate)

- (BOOL)askSubviewsRenderingOffset {
    return NO;
}

@end

@implementation UITableViewHeaderFooterView (PDFExporterPageInformationPrivate)

- (BOOL)askSubviewsRenderingOffset {
    return NO;
}

@end

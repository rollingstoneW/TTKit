//
//  TTStarEvaluationView.m
//  TTKit
//
//  Created by rollingstoneW on 2018/9/7.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import "TTStarEvaluationView.h"

static NSString *const DefaultStarImageBase64 = @"iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAWJQAAFiUBSVIk8AAAABxpRE9UAAAAAgAAAAAAAAAgAAAAKAAAACAAAAAgAAAB738w5uAAAAG7SURBVHgB7JjNKwVRGMaH3C07/At2lHwuFMVGkSxlQexs7dngH7BTUqR8FEksbAmRvaXs2CCKfPwedSZdpZm5M3fmnPHWr5npzpzzPM+8zbkznvdfqSRQYNYpWIctmIZ6yEW14vIaPot45XgInK4G3L1BsXlz/M5vjS4ncP6HeRPChasB9AYwb0LodzGEkxABXLoWQHcI86YL+lwKIczdNwEcuxJAV4S7b0LocSGEoxICsL4L2kowb7pAHWRtHaLcGIm6VQdZWU2ojmq6+Lp2GxPYjzGAA9sCiPPum27QmNbULkqN8Li2e7a4j/KvL2hIg1kNoRphLTALDxDUUNjznhl7HrS81kBZq5bZOmAUZmAVTuEOwhqJ6/x75j6DNVD40tYJdRCpKrhKJsdhDjZAb2ZPEJfoco3ziOYr2IQFmAB5q4RfJeNjcAPlEpjWPLd4nAR59kstnZagtOZdwfN3CM3sfOQwAAU/At5OTs0rAD0jEl220mrvoPPqC3WuA3hRAKV8sAiadFbP0wubNwxZFZi0rgEFoFqGpCfL2vhaBv3SergEWROZlB69WRZ89z92FnMQwjYeq4znLwAAAP//SJEE3AAAAftJREFU7ZnNKwVRGMYvkuRjIQuulSV/gbKxUXZiYaOkKyIbCxYW6srCAimS2LFg4a5IiSzYy8LGVikpNih0fT2PnIUZc5uZM+90zuStp2lO57wfvzvzzj0zqZTbFjH0mVBto64Sd8nukSyGkgZhAzUVuUv1HhlLEIT1oMUrLCMJgLCsigl7zGDhh6Ug5sIW7VzXi4F3yyBMOYvQPe+Eg7wlEMZ1i/VaTwhvhkNg8xa1BXg39RG5L1r5j/MWgwH0xQGg1WAAA3EAGDYYAG9PcVtBBFN7wIF49QhwYjCA6zgAPBkMgFdmhSSEBsOLJwA2aTHrgGdT73+V15BY9XA8YQGAJUkAmxYAOJYEcG4BgFspAMVw/GoBAPaCGgkITZYUTwBtEgB6LAIwKgFgJkIAN/A1CJVBfFPbDV1C6lGme1yFr8gtB4+6id3BB9/WsHCnscdwO3sF6cY5dTqP4vxII7EHrJ2GKn0kUoo5fBvNbh4WxIWPOIGnhNkFPiMKt6hhunI51vGP1z0UFASv1sitHR79JpLH3DWoPoIsquEjCz1CfuP3Y66I7cBroST4/WALahSIXguf89ALVCgHkftf1cNf48wjgV2MN6uJgsc0fLPL//V2+hDjVYKxv12zW3NXOAvtQfz6EkfhCPPL6nA2CRE8v2h3Qczt34IQ+AL0uqNa1RblmQAAAABJRU5ErkJggg==";

@implementation TTStarEvaluationView
@synthesize scoreMinPace = _scoreMinPace;
@synthesize starSpace = _starSpace;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:DefaultStarImageBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    self.starImage = [UIImage imageWithData:imageData scale:3];
    self.backgroundColor = [UIColor clearColor];
    self.starColor = [UIColor orangeColor];
    self.unstarColor = [UIColor lightGrayColor];
    self.numberOfStars = 5;
    self.scorePerStar = 1;
    self.scoreMinPace = .5;
    self.starSpace = -1;
    self.horiInset = 5;
}

#define RedrawWithVar(var, ...) if (_##var != var) { \
_##var = var; \
{__VA_ARGS__; }\
[self setNeedsDisplay]; \
}
- (void)setStarImage:(UIImage *)starImage {
    RedrawWithVar(starImage, [self sizeToFit]);
}

- (void)setStarImageForHalf:(UIImage *)starImageForHalf {
    RedrawWithVar(starImageForHalf);
}

- (void)setUnstarImage:(UIImage *)unstarImage {
    RedrawWithVar(unstarImage);
}

- (void)setStarSpace:(CGFloat)starSpace {
    RedrawWithVar(starSpace, [self sizeToFit]);
}

- (void)setHoriInset:(CGFloat)horiInset {
    RedrawWithVar(horiInset);
}

- (void)setNumberOfStars:(NSInteger)numberOfStars {
    RedrawWithVar(numberOfStars, [self sizeToFit]);
}

- (void)setCurrentScore:(CGFloat)currentScore {
    currentScore = floorf(MIN(currentScore, self.numberOfStars) / self.scoreMinPace) * self.scoreMinPace;
    RedrawWithVar(currentScore);
}

- (void)setScoreMinPace:(CGFloat)scoreMinPace {
    if (_scoreMinPace != scoreMinPace) {
        _scoreMinPace = scoreMinPace;
        [self setCurrentScore:self.currentScore];
    }
}

#undef SetPropertyAndSizeToFit

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:CGSizeZero];
}

- (void)sizeToFit {
    self.bounds = (CGRect){CGPointZero, [self sizeThatFits:CGSizeZero]};
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(self.starImage.size.width * self.numberOfStars + MAX(self.numberOfStars - 1, 0) * self.starSpace + self.horiInset * 2,
                      self.starImage.size.height);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGFloat left = self.horiInset;
    CGSize imageSize = self.starImage.size;
    for (NSInteger i = 0; i < self.numberOfStars; i++) {
        UIImage *image = self.starImage;;
        if (i <= self.currentScore - 1) {
            image = self.starImage;
        } else if (i > ceilf(self.currentScore - 1)) {
            image = self.unstarImage ?: self.starImage;
        } else {
            image = self.starImageForHalf ?: self.starImage;
        }
        CGRect rect = CGRectMake(left, 0, imageSize.width, imageSize.height);
        [image drawInRect:rect];
        left = CGRectGetMaxX(rect) + self.starSpace;
    }

    if (!self.unstarImage) {
        NSInteger spaceCount = MAX(ceilf(self.currentScore) - 1, 0);
        CGFloat starColorWidth = self.horiInset + spaceCount * self.starSpace + self.starImage.size.width * self.currentScore;
        [self.unstarColor set];
        UIRectFillUsingBlendMode(CGRectMake(starColorWidth, 0, CGRectGetWidth(self.bounds) - starColorWidth, CGRectGetHeight(self.bounds)),
                                 kCGBlendModeSourceIn);
        [self.starColor set];
        UIRectFillUsingBlendMode(CGRectMake(0, 0, starColorWidth, CGRectGetHeight(self.bounds)), kCGBlendModeSourceIn);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self calculateScoreAtLocation:[[touches anyObject] locationInView:self]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self calculateScoreAtLocation:[[touches anyObject] locationInView:self]];
}

- (void)calculateScoreAtLocation:(CGPoint)location {
    CGFloat locationX = location.x - self.horiInset;
    NSInteger intPart = floorf(locationX / (self.starImage.size.width + self.starSpace));
    CGFloat decimalPart = MIN((locationX - intPart * (self.starImage.size.width + self.starSpace)) / self.starImage.size.width, 1);
    if (self.scoreMinPace == .5 * self.scorePerStar) {
        if (decimalPart >= self.scoreMinPace) {
            decimalPart = 1;
        } else {
            decimalPart = .5;
        }
    }
    self.currentScore = intPart + decimalPart;
    !self.didEvaluationBlock ?: self.didEvaluationBlock(self.currentScore);
}

- (CGFloat)scoreMinPace {
    if (_scoreMinPace) {
        return _scoreMinPace;
    }
    if (self.unstarImage && self.starImageForHalf) {
        return .5 * self.scorePerStar;
    }
    return self.scorePerStar;
}

- (CGFloat)starSpace {
    if (_starSpace <= 0) {
        return self.starImage.size.width / 2;
    }
    return _starSpace;
}

@end

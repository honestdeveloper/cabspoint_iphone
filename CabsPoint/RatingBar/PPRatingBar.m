//  Created by Petr Prokop on 1/5/12.

#import "PPRatingBar.h"

//define number of stars to show (and maximum rating user can give)
#define kNumberOfStars 5

@implementation PPRatingBar

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        _rating = 0.0f;
        
        _onImage = [UIImage imageNamed:@"starBig.png"];
        _offImage = [UIImage imageNamed:@"starBigOff.png"];
        _halfImage = [UIImage imageNamed:@"starBigHalf.png"];
        //_onImage = [self imageByScalingAndCroppingForSize:CGSizeMake(30, 30) Image:_onImage];
        //_offImage = [self imageByScalingAndCroppingForSize:CGSizeMake(30, 30) Image:_offImage];
        //_halfImage = [self imageByScalingAndCroppingForSize:CGSizeMake(30, 30) Image:_halfImage];
        
        CGFloat spaceBetweenStars = (frame.size.width - _offImage.size.width / 3*kNumberOfStars)/(kNumberOfStars+1);
        _imageViews = [[NSMutableArray alloc] initWithCapacity:5];
        
        for(NSInteger i=0; i<kNumberOfStars; i++)
        {
            UIImageView *iv = 
            [[UIImageView alloc] initWithFrame:CGRectMake((_offImage.size.width/ 3 + spaceBetweenStars)*i + spaceBetweenStars,
                                                          (frame.size.height - _offImage.size.height / 3)/2,
                                                          _offImage.size.width / 3,
                                                          _offImage.size.height / 3)];
            iv.image = _offImage;
            [self addSubview:iv];
            [_imageViews addObject:iv];

        }
    }
    return self;
}


- (void)handleTouchAtLocation:(CGPoint)touchLocation {

    for(int i = _imageViews.count - 1; i >= 0; i--) 
    {
        UIImageView *imageView = [_imageViews objectAtIndex:i];        

        //check if touch is inside star
        if (CGRectContainsPoint(imageView.frame, touchLocation))
        {
            CGPoint relativePoint = [self convertPoint:touchLocation toView:imageView];
            
            if(relativePoint.x > imageView.frame.size.width/2)
                _rating = i + 1; //touch is on the right side of star - star is full
            else
                _rating = i + 0.5f; //touch is on the left side of star - star is half empty
            
            [self updateRating];
            return;
        }
    }
    
    //touch is outside of star
    for(int i = _imageViews.count - 1; i >= 0; i--) 
    {
        UIImageView *imageView = [_imageViews objectAtIndex:i];        
        
        if (touchLocation.x >= imageView.frame.origin.x + imageView.frame.size.width)
        {
            _rating = i + 1;
            [self updateRating];
            return;
        }
    }
    
    //touch to the left from first star
    _rating = 0.5f;
    [self updateRating];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    return;
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    return;
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    return;
    if(self.delegate)
    {
        [self.delegate ratingBar:self 
                 didChangeRating:_rating];
    }
}

#pragma mark - Updating UI

- (void)clean
{
    for(NSInteger i=0; i<_imageViews.count; i++)
    {
        UIImageView *star = (UIImageView *)[_imageViews objectAtIndex:i];
        star.image = _offImage;
    }
}

- (void)setRating:(float)rating
{
    if(rating - floorf(rating) > 0.8)
        rating = ceilf(rating);
    else if(rating - floorf(rating) < 0.2)
        rating = floorf(rating);
    else
        rating = floorf(rating) + 0.5;
        
    _rating = rating;
    [self updateRating];
}
- (void)updateRating
{
    [self clean];
    
    NSInteger i;
    
    //set every full star
    for(i=1; i<=MIN(_imageViews.count, _rating); i++)
    {
        UIImageView *star = (UIImageView *)[_imageViews objectAtIndex:i-1];
        star.image = _onImage;
    }
    
    if (i > _imageViews.count)
        return;
    
    //now add a half star if rating is appropriate
    if(_rating - i + 1 >= 0.5f)
    {
        UIImageView *star = (UIImageView *)[_imageViews objectAtIndex:i-1];
        star.image = _halfImage;
    }
}
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize Image:(UIImage*)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end

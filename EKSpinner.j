/*
 * EKSpinner.j
 *
 * The MIT License
 *
 * Copyright (c) 2009 Elias Klughammer
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

// EKSpinnerStyle
EKSpinnerStyleSmallWhite  = @"small_white";
EKSpinnerStyleSmallGray   = @"small_gray";
EKSpinnerStyleSmallBlack  = @"small_black";
EKSpinnerStyleMediumWhite = @"medium_white";
EKSpinnerStyleMediumGray  = @"medium_gray";
EKSpinnerStyleMediumBlack = @"medium_black";
EKSpinnerStyleLargeWhite  = @"big_white";
EKSpinnerStyleLargeGray   = @"big_gray";
EKSpinnerStyleLargeBlack  = @"big_black";

@implementation EKSpinner : CPImageView
{
  int            frames @accessors;
  int            interval @accessors;
  BOOL           spinning @accessors(getter=isSpinning);
  EKSpinnerStyle style @accessors;

  int     imageNumber;
  CPTimer timer;
  CPArray imageStack;
}

- (id)initWithFrame:(CGRect)aFrame andStyle:(EKSpinnerStyle)aStyle
{
  if (self = [super initWithFrame:aFrame])
  {
    [self setStyle:aStyle];
    [self setImageScaling:CPScaleNone];
  }

  return self;
}

- (void)setStyle:(EKSpinnerStyle)aStyle
{
  if (!aStyle)
    return;

  if (aStyle.search(/small/) < 0)
  {
    [self setFrames:12];
  }
  else
  {
    [self setFrames:8];
  }

  imageStack = [[CPArray alloc] init];

  for (var i = 1; i <= [self frames]; i++)
  {
    var img = [[CPImage alloc] initWithContentsOfFile:@"Frameworks/EKSpinner/Resources/" + aStyle + "_" + i + ".png" size:CGSizeMake(CGRectGetWidth([self frame]), CGRectGetHeight([self frame]))];
    [imageStack addObject:img];
  }

  style = aStyle;
}

- (void)setSpinning:(BOOL)isSpinning
{
  isSpinning = !!isSpinning;
  if (isSpinning === spinning)
    return;

  if (isSpinning)
  {
    var animationInterval = [self interval] ?
                             ([self interval] / 1000) :
                             0.1;
    imageNumber = 0;
    timer = [CPTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(changeSpinnerImage) userInfo:nil repeats:YES];
  }
  else
  {
    [timer invalidate];
    [self setImage:nil];
  }

  spinning = isSpinning;
}

- (void)changeSpinnerImage
{
  [self setImage:[imageStack objectAtIndex:imageNumber]];
  imageNumber = (imageNumber + 1) % frames;
}

@end


@implementation EKSpinner (CPCoding)

- (void)encodeWithCoder:(CPCoder)aCoder
{
  [super encodeWithCoder:aCoder];

  [aCoder encodeObject:style forKey:@"style"];
}

- (id)initWithCoder:(CPCoder)aDecoder
{
  if (self = [super initWithCoder:aDecoder])
  {
    [self setStyle:[aDecoder decodeObjectForKey:@"style"]];
  }

  return self;
}

@end

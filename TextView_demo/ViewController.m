
//
//  ViewController.m
//  TextView_demo
//
//  Created by 沈红榜 on 15/6/29.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextViewDelegate>

@end

@implementation ViewController {
    UITextView *_textView;
    UILabel *_count;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
    _textView.translatesAutoresizingMaskIntoConstraints = NO;
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_textView];
    
    _count = [[UILabel alloc] initWithFrame:CGRectZero];
    _count.translatesAutoresizingMaskIntoConstraints = NO;
    _count.text = @"0/18";
    [self.view addSubview:_count];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_textView, _count);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[_textView]-20-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[_textView(100)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-190-[_count]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_count]-20-|" options:0 metrics:nil views:views]];
    
    
}

- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        return;
    }
    NSString *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum > 18) {
        NSString *s = [nsTextContent substringToIndex:18];
        textView.text = s;
    }
    
    //
    _count.text = [NSString stringWithFormat:@"%d/%d",MAX(0, 18 - existTextNum),18];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    UITextRange *selectedRange = [textView markedTextRange];
    
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offRange.location < 18) {
            return YES;
        } else {
            return NO;
        }
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = 18 - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    } else {
        NSInteger len = text.length + caninputlen;
        NSRange rg = {0, MAX(len, 0)};
        if (rg.length > 0) {
            NSString *s = @"";
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];
            } else {
                __block NSInteger idx = 0;
                __block NSString *trimString = @"";
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                    if (idx >= rg.length) {
                        *stop = YES;
                        return ;
                    }
                    trimString = [trimString stringByAppendingString:substring];
                    idx++;
                }];
                s = trimString;
            }
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            
            
            _count.text = [NSString stringWithFormat:@"%d/%d",0,18];
        }
        return NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  TZImagePickerController+WZRotation.m
//  Darts
//
//  Created by 马冰垒 on 2020/8/7.
//  Copyright © 2020 毛为哲. All rights reserved.
//

#import "TZImagePickerController+WZRotation.h"

@implementation TZImagePickerController (WZRotation)

// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return YES;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end

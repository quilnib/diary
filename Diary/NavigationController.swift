//
//  NavigationController.swift
//  Diary
//
//  Created by Tim Walsh on 3/4/15.
//  Copyright (c) 2015 ClassicTim. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {//currently it looks like the only reason this was created was to set the statusBarStyle

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

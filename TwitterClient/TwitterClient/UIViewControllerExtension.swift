//
//  UIViewControllerExtension.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 27.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import Foundation

extension UIViewController {
    func showBottomLoadingHUD() -> JGProgressHUD {
        let hud = JGProgressHUD(style: JGProgressHUDStyle.Dark)
        hud.interactionType = JGProgressHUDInteractionType.BlockNoTouches
        hud.position = JGProgressHUDPosition.BottomRight
        hud.showInView(view)
        return hud
    }
    
    func showToastMessage(withText text: String) {
        view.makeToast(text, duration: 3.0, position: NSValue(CGPoint: CGPointMake(view.center.x, 100)))
    }
    
    func hideHUD(hud: JGProgressHUD) {
        hud.dismissAnimated(true)
    }
    
    func hideAllHUDs() {
        if let huds = JGProgressHUD.allProgressHUDsInViewHierarchy(view) as? [JGProgressHUD] {
            for hud in huds {
                hud.dismissAnimated(true)
            }
        }
    }
}
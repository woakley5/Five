//
//  MainViewController-Snapchat.swift
//  Five
//
//  Created by Niky Arora on 11/4/18.
//  Copyright © 2018 Niky Arora. All rights reserved.
//

import Foundation
import UIKit
import SCSDKLoginKit
import SCSDKBitmojiKit
import SCSDKCreativeKit

extension MainViewController {
    
    @objc func loginButtonTapped(_ sender: Any) {
        guard let stickerImage = self.takeScreenshot() else {
            return
        }

        let sticker = SCSDKSnapSticker(stickerImage: stickerImage)
        
        /* Modeling a Snap using SCSDKNoSnapContent */
        let snap = SCSDKNoSnapContent()
        
        snap.sticker = sticker
        snap.attachmentUrl = "https://www.snapchat.com"
        
        // Caption
        snap.caption = "My tasks on Five!"
        
        let api = SCSDKSnapAPI(content: snap)
        api.startSnapping { error in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                // success
            }
        }
    }
    
    func takeScreenshot() -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshotImage
    }

}


//
//  UIDeviceExtension.swift
//  Coach
//
//  Created by 영현 on 6/18/24.
//

import UIKit

extension UIDevice {
    public var isiPhone: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            return true
        } else {
            return false
        }
    }
    
    public var isiPad: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return true
        } else {
            return false
        }
    }
}

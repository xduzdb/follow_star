//
//  STString.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/4.
//

import Foundation
import SwiftUI

public extension String {
    static func BundleImageName(_ imageName: String) -> Image {
        return Image(uiImage: self.getImage(name: imageName))
    }
    
    private static func getImage(name: String, type:String = "png") -> UIImage {
        let image = UIImage(named: name) ?? UIImage()
        return image
    }
}

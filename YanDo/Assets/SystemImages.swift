//
//  SystemImages.swift
//  YanDo
//
//  Created by Александра Маслова on 08.07.2023.
//

import Foundation
import UIKit

enum IndicatorImages {
    case connect
    case disconnect
    
    var uiImage: UIImage {
        switch self {
        case .connect:
            return UIImage(systemName: "icloud.fill")!
        case .disconnect:
            return UIImage(systemName: "icloud.slash.fill")!
        }
    }
}


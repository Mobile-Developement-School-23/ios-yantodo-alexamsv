//
//  SystemImages.swift
//  YanDo
//
//  Created by Александра Маслова on 08.07.2023.
//

import Foundation
import UIKit

enum SystemImages {
    case connect
    case disconnect
    case calendar
    case arrow
    case slashBell
    case bell
    var uiImage: UIImage {
        switch self {
        case .connect:
            return UIImage(systemName: "icloud.fill")!
        case .disconnect:
            return UIImage(systemName: "icloud.slash.fill")!
        case .calendar:
            return UIImage(systemName: "calendar")!
        case .arrow:
            return UIImage(systemName: "arrow.turn.left.down")!
        case .slashBell:
            return UIImage(systemName: "bell.slash.fill")!
        case .bell:
            return UIImage(systemName: "bell.fill")!
        }
    }
}

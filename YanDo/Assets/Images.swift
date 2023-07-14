//
//  Images.swift
//  YanDo
//
//  Created by Александра Маслова on 14.07.2023.
//

import UIKit

enum Images {
    case complete
    case delete
    case show
    case chevron
    case deadline
    case importanceHight
    case importanceLow
    case completedMarker
    case pendingMarker
    case redMarker
    case plus
    var uiImage: UIImage {
        switch self {
        case .complete:
            return UIImage(named: "Complete")!
        case .delete:
            return UIImage(named: "Delete")!
        case .show:
            return UIImage(named: "Show")!
        case .chevron:
            return UIImage(named: "Chevron")!
        case .deadline:
            return UIImage(named: "Deadline")!
        case .importanceHight:
            return UIImage(named: "ImportanceHight")!
        case .importanceLow:
            return UIImage(named: "ImportanceLow")!
        case .completedMarker:
            return UIImage(named: "CompletedMarker")!
        case .pendingMarker:
            return UIImage(named: "PendingMarker")!
        case .redMarker:
            return UIImage(named: "RedMarker")!
        case .plus:
            return UIImage(named: "Plus")!
        }
    }
}

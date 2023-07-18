//
//  Assets.swift
//  YanDo-SUI-MockData
//
//  Created by Александра Маслова on 18.07.2023.
//

import SwiftUI
// MARK: -  Text and font

enum Label {
    static let new = "Новое"
    static let show = "Показать"
    static let hide = "Скрыть"
    static let placeholder = "Что надо сделать?"
    static let importance = "Важность"
    static let deadline = "Сделать до"
    static let not = "нет"
    static let slash = "/"
    static let remind = "Напомнить"
    static let delete = "Удалить"
    static let doneCounter = "Выполнено — "
    static let title = "Мои дела"
    static let cancel = "Отменить"
    static let save = "Сохранить"
    static let toDo = "Дело"
    static let done = "Готово"
}

extension UIFont {
    static let largeTitle = UIFont(name: "SFProDisplay-Bold", size: 38)
    static let title = UIFont(name: "SFProDisplay-Semibold", size: 20)
    static let headline = UIFont(name: "SFProText-Semibold", size: 17)
    static let body = UIFont(name: "SFProText-Regular", size: 17)
    static let subhead = UIFont(name: "SFProText-Regular", size: 15)
    static let footnote = UIFont(name: "SFProDisplay-Semibold", size: 13)
}
// MARK: -  Images

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
// MARK: - Colors

extension UIColor {
    // color
    static let blueColor = UIColor(named: "BlueColor")
    static let grayColor = UIColor(named: "GrayColor")
    static let grayLightColor = UIColor(named: "GrayLightColor")
    static let greenColor = UIColor(named: "GreenColor")
    static let redColor = UIColor(named: "RedColor")
    static let whiteColor = UIColor(named: "WhiteColor")
    // back
    static let elevatedBack = UIColor(named: "ElevatedBack")
    static let iOSPrimaryBack = UIColor(named: "iOSPrimaryBack")
    static let primaryBack = UIColor(named: "PrimaryBack")
    static let secondaryBack = UIColor(named: "SecondaryBack")
    // label
    static let disableLabel = UIColor(named: "DisableLabel")
    static let primaryLabel = UIColor(named: "PrimaryLabel")
    static let secondaryLabel = UIColor(named: "SecondaryLabel")
    static let tertiaryLabel = UIColor(named: "TertiaryLabel")
    // support
    static let navBarBlurSupport = UIColor(named: "NavBarBlurSupport")
    static let overlaySupport = UIColor(named: "OverlaySupport")
    static let separatorSupport = UIColor(named: "SeparatorSupport")
}

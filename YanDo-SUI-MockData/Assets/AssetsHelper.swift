//
//  Assets.swift
//  YanDo-SUI-MockData
//
//  Created by Александра Маслова on 18.07.2023.
//

import SwiftUI
// MARK: -  Text

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
    var uiImage: Image {
        switch self {
        case .complete:
            return Image("Complete")
        case .delete:
            return Image("Delete")
        case .show:
            return Image("Show")
        case .chevron:
            return Image("Chevron")
        case .deadline:
            return Image("Deadline")
        case .importanceHight:
            return Image("ImportanceHight")
        case .importanceLow:
            return Image("ImportanceLow")
        case .completedMarker:
            return Image("CompletedMarker")
        case .pendingMarker:
            return Image("PendingMarker")
        case .redMarker:
            return Image("RedMarker")
        case .plus:
            return Image("Plus")
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
    var uiImage: Image {
        switch self {
        case .connect:
            return Image(systemName: "icloud.fill")
        case .disconnect:
            return Image(systemName: "icloud.slash.fill")
        case .calendar:
            return Image(systemName: "calendar")
        case .arrow:
            return Image(systemName: "arrow.turn.left.down")
        case .slashBell:
            return Image(systemName: "bell.slash.fill")
        case .bell:
            return Image(systemName: "bell.fill")
        }
    }
}
// MARK: - Colors

extension Color {
    // color
    static let blueColor = Color("BlueColor")
    static let grayColor = Color("GrayColor")
    static let grayLightColor = Color("GrayLightColor")
    static let greenColor = Color("GreenColor")
    static let redColor = Color("RedColor")
    static let whiteColor = Color("WhiteColor")
    // back
    static let elevatedBack = Color("ElevatedBack")
    static let iOSPrimaryBack = Color("iOSPrimaryBack")
    static let primaryBack = Color("PrimaryBack")
    static let secondaryBack = Color("SecondaryBack")
    // label
    static let disableLabel = Color("DisableLabel")
    static let primaryLabel = Color("PrimaryLabel")
    static let secondaryLabel = Color("SecondaryLabel")
    static let tertiaryLabel = Color("TertiaryLabel")
    // support
    static let navBarBlurSupport = Color("NavBarBlurSupport")
    static let overlaySupport = Color("OverlaySupport")
    static let separatorSupport = Color("SeparatorSupport")
}

// MARK: -  Screen
enum Aligners {
    static let height = UIScreen.main.bounds.height
    static let width = UIScreen.main.bounds.width
    static let modelHight: CGFloat = 812
    static let modelWidth: CGFloat = 375
}

// MARK: -  Date
func formatDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy"
    formatter.locale = Locale(identifier: "ru_RU")
    var str = formatter.string(from: date)
    if str.hasPrefix("0") { str.removeFirst() }
    return str
}

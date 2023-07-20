//
//  Assets.swift
//  YanDo-SUI-MockData
//
//  Created by Александра Маслова on 18.07.2023.
//

import SwiftUI
// MARK: -  Text

enum NavTitles {
    static let mainTitle = "Мои дела"
    static let taskTitle = "Дело"
}
enum Texts {
    case new
    case show
    case hide
    case placeholder
    case importance
    case deadline
    case not
    case delete
    case doneCounter
    case cancel
    case save
    var uiText: Text {
        switch self {
        case .new:
            return Text("Новое")
                .font(.system(size: 17))
                .foregroundColor(.tertiaryLabel)
        case .show:
            return Text("Показать")
                .foregroundColor(.blueColor)
                .font(.system(size: 15)).bold()
        case .hide:
            return Text("Скрыть")
                .foregroundColor(.blueColor)
                .font(.system(size: 15)).bold()
        case .placeholder:
            return Text("Что надо сделать?")
                .foregroundColor(.tertiaryLabel)
                .font(.system(size: 17))
        case .importance:
            return Text("Важность")
                .font(.system(size: 17))
                .foregroundColor(.primaryLabel)
        case .deadline:
            return Text("Сделать до")
                .font(.system(size: 17))
                .foregroundColor(.primaryLabel)
        case .not:
            return Text("нет")
                .font(.system(size: 15))
                .foregroundColor(.primaryLabel)
        case .delete:
            return Text("Удалить")
                .font(.system(size: 17))
        case .doneCounter:
            return Text("Выполнено — ")
        case .cancel:
            return Text("Отменить")
                .font(.system(size: 17))
                .foregroundColor(.blueColor)
        case .save:
            return Text("Сохранить")
                .font(.system(size: 17)).bold()
        }
    }
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

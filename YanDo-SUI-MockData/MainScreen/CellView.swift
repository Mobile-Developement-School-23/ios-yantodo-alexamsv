//
//  CellView.swift
//  YanDo-SUI-MockData
//
//  Created by Александра Маслова on 19.07.2023.
//

import SwiftUI

struct CellView: View {
    var item: ToDoItem
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                marker
                VStack(alignment: .leading) {
                    HStack(alignment: .top, spacing: 5) {
                        importance
                        VStack(alignment: .leading, spacing: 3) {
                            text
                            deadline
                        }
                    }
                }
                Spacer()
                Images.chevron.uiImage
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .onTapGesture {
                // task screen
            }
            Divider().padding(.leading, 52)
        }.background(Color.secondaryBack)
    }
    
    @ViewBuilder
    var marker: some View {
        Button {
            //
        } label: {
            if item.isCompleted {
                Images.completedMarker.uiImage
            } else if item.importance == .important {
                Images.redMarker.uiImage
            } else {
                Images.pendingMarker.uiImage
            }
        }
    }
    @ViewBuilder
    var importance: some View {
        if !item.isCompleted {
            if item.importance == .important {
            Images.importanceHight.uiImage
                    .padding(.top, 2)
        } else if item.importance == .low {
            Images.importanceLow.uiImage
                .padding(.top, 2)
        }
        }
    }
    @ViewBuilder
    var text: some View {
        if item.isCompleted {
            Text(item.text)
            .font(.system(size: 17))
            .foregroundColor(.tertiaryLabel)
            .strikethrough(true)
        } else {
            Text(item.text)
                .font(.system(size: 17))
                .foregroundColor(.primaryLabel)
                .lineLimit(3)
        }
    }
    @ViewBuilder
    var deadline: some View {
        if !item.isCompleted {
            if let date = item.deadline {
                HStack(spacing: 2) {
                    Images.deadline.uiImage
                    Text(formatDate(date: date))
                        .font(.system(size: 15))
                }.foregroundColor(.tertiaryLabel)
            }
        }
    }

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        var str = formatter.string(from: date)
        if str.hasPrefix("0") { str.removeFirst() }
        return str
    }
}


struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(item: MockData().mock.first!)
    }
}

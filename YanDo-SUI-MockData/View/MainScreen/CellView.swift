//
//  CellView.swift
//  YanDo-SUI-MockData
//
//  Created by Александра Маслова on 19.07.2023.
//

import SwiftUI
struct CellView: View {
    var item: ToDoItem
    @State private var isSwipedLeft: Bool = false
    @State private var isSwipedRight: Bool = false
    
    var body: some View {
        ZStack {
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
                Divider().padding(.leading, 52)
            }
            .background(Color.secondaryBack)
            .offset(x: isSwipedLeft ? -66 : (isSwipedRight ? 66 : 0))
            .background(
                ZStack {
                    if isSwipedLeft {
                        leftIcon
                    } else if isSwipedRight {
                        rightIcon
                    }
                }
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < -30 {
                            isSwipedLeft = true
                            isSwipedRight = false
                        } else if value.translation.width > 30 {
                            isSwipedLeft = false
                            isSwipedRight = true
                        } else {
                            isSwipedLeft = false
                            isSwipedRight = false
                        }
                    }
                    .onEnded { value in
                        if value.translation.width < -100 {
                            // Обработка свайпа влево
                        } else if value.translation.width > 100 {
                            // Обработка свайпа вправо
                        } else {
                            isSwipedLeft = false
                            isSwipedRight = false
                        }
                    }
            )
        }
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
    @ViewBuilder
    var rightIcon: some View {
        HStack {
            ZStack {
                if !item.isCompleted {
                    Color.greenColor
                    Images.complete.uiImage
                } else {
                    Color.grayLightColor
                    SystemImages.arrow.uiImage
                }
            }
            .frame(width: 66)
            Spacer()
        }
        
    }
    var leftIcon: some View {
        HStack {
            Spacer()
            ZStack {
                Color.redColor
                Images.delete.uiImage
            }.frame(width: 66)
        }
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(item: MockData().mock.first!)
    }
}

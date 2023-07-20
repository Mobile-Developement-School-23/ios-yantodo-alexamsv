//
//  TaskScreen.swift
//  YanDo-SUI-MockData
//
//  Created by Александра Маслова on 20.07.2023.
//

import SwiftUI

struct TaskScreen: View {
    @Environment(\.presentationMode) private var presentationMode
    var item: ToDoItem?
    @State private var toggle = false
    @State private var picker = 1
    @State private var showCalendar = false
    var body: some View {
        NavigationView {
            ZStack {
                Color.primaryBack.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        textEditor
                        settingsPanel
                        deleteButton
                    }.padding(.vertical, 16)
                    
                }.padding(.horizontal, 16)
            }
            .navigationTitle(Label.toDo)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            
        }
    }
    var cancelButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text(Label.cancel)
                .font(.system(size: 17))
                .foregroundColor(.blueColor)
        }
        
    }
    var saveButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text(Label.save)
                .font(.system(size: 17)).bold()
                .foregroundColor(saveButtonColor())
        }
        
    }
    @ViewBuilder
    var textEditor: some View {
        HStack {
            ZStack {
                // если не режим read only, то здесь TextEditor
                if let item = item {
                    Text(item.text)
                        .foregroundColor(.primaryLabel)
                } else {
                    Text(Label.placeholder)
                        .foregroundColor(.tertiaryLabel)
                }
            }
            .font(.system(size: 17))
            .padding(.top, 12)
            .padding(.horizontal, 16)
            .padding(.bottom, 72)
            
            Spacer()
        }
        .background(Color.elevatedBack)
        .cornerRadius(16)
    }
    @ViewBuilder
    var settingsPanel: some View {
        VStack(spacing: 0) {
            HStack {
                Text(Label.importance)
                Spacer()
                Picker("", selection: $picker) {
                    Images.importanceLow.uiImage.tag(0)
                    Text(Label.not).tag(1)
                        .foregroundColor(.primaryLabel)
                    Images.importanceHight.uiImage.tag(2)
                        
                }
                .pickerStyle(.segmented)
                .disabled(true) // тк read only закрепим его
                .frame(width: 150)
                .onAppear{
                    picker = pickerValue()
                }
                
                
            }.padding(.vertical, 20)
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(Label.deadline)
                    if let item = item {
                        if let date = item.deadline {
                            Button {
                                showCalendar.toggle()
                            } label: {
                                Text(formatDate(date: date))
                                    .font(.system(size: 13)).bold()
                                    .foregroundColor(.blueColor)
                            }
                            
                        }
                    }
                }
                Toggle("", isOn: $toggle)
                    .disabled(true) // тк read only закрепим его
                    .onAppear{
                        toggle = item?.deadline != nil
                    }
                
                Spacer()
            }.padding(.vertical, padding())
            if showCalendar {
                if let item = item {
                    if let date = item.deadline {
                        FixedDatePicker(fixedDate: date)
                    }
                }
            }
        }
        .font(.system(size: 17))
        .foregroundColor(.primaryLabel)
        .padding(.leading, 16)
        .padding(.trailing, 12)
        .background(Color.elevatedBack)
        .cornerRadius(16)
    }
    @ViewBuilder
    var deleteButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Spacer()
                Text(Label.delete)
                    .font(.system(size: 17))
                    .foregroundColor(deleteButtonColor())
                Spacer()
            }
            .padding(.vertical, 20)
            .background(Color.elevatedBack)
            .cornerRadius(16)
            
        }
        
    }
    // MARK: helpers
    private func padding() -> CGFloat {
        var padding: CGFloat = 20
        if let item = item {
            if item.deadline != nil {
                padding = 12
            }
        }
        return padding
    }
    private func deleteButtonColor() -> Color {
        if item != nil {
            return Color.redColor
        } else { return Color.tertiaryLabel }
    }
    private func saveButtonColor() -> Color {
        if item != nil {
            return Color.blueColor
        } else { return Color.tertiaryLabel }
    }
    private func pickerValue() -> Int {
        var ind = 1
        if let item = item {
            switch item.importance {
            case .low:
                ind = 0
            case .basic:
                ind = 1
            case .important:
                ind = 2
            }
        }
        return ind
    }
}

struct TaskScreen_Previews: PreviewProvider {
    static var previews: some View {
        TaskScreen(item: MockData().mock.last)
    }
}

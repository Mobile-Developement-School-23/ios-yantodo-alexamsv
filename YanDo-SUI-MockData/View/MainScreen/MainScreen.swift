//
//  ContentView.swift
//  YanDo-SUI-MockData
//
//  Created by Александра Маслова on 18.07.2023.
//

import SwiftUI

struct MainScreen: View {
    @State private var showCompletedItems = false
    @State private var openClearTaskScreen = false
    @State private var selectedItem: ToDoItem? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView{
                    VStack {
                        infPanel
                        LazyVStack (spacing: 0) {
                            ForEach(itemsCollection()) { item in
                                CellView(item: item)
                                    .onTapGesture { selectedItem = item }
                            }
                            SpecialCell()
                                .onTapGesture { openClearTaskScreen.toggle() }
                        }
                        .sheet(item: $selectedItem) { item in
                            TaskScreen(item: item)
                        }
                        .sheet(isPresented: $openClearTaskScreen) {
                            TaskScreen(item: nil)
                        }
                        .animation(.easeInOut)
                        .cornerRadius(16)
                        .padding(.horizontal, 16)
                    }
                    
                }.background(Color.primaryBack)
                    .navigationTitle(NavTitles.mainTitle)
                    .navigationBarTitleDisplayMode(.large)
                VStack {
                    Spacer()
                    plusButton
                }
            }
        }
    }
    var infPanel: some View {
        HStack {
            HStack(spacing: 0) {
                Texts.doneCounter.uiText
                Text(completedCount())
                    .foregroundColor(.tertiaryLabel)
                    .font(.system(size: 15))
            }
            Spacer()
            Button {
                showCompletedItems.toggle()
            } label: {
                if !showCompletedItems {
                    Texts.show.uiText
                } else { Texts.hide.uiText }
            }
        }
        .padding(.vertical, 12)
        .frame(width: 310 / Aligners.modelWidth * Aligners.width)
    }
    var plusButton: some View {
        Button {
          openClearTaskScreen.toggle()
        } label: {
                Images.plus.uiImage
                    .resizable()
                    .frame(width: 44, height: 44)
                    .shadow(color: Color(red: 0, green: 0.29, blue: 0.6).opacity(0.6), radius: 10, x: 0, y: 8)
                    .padding(.bottom, 20)
            }
        }
    
    // MARK: - View Model
    func itemsCollection() -> [ToDoItem]{
        var collection = [ToDoItem]()
        if showCompletedItems {
            collection = MockData().mock
        } else { collection = MockData().mock.filter({ !$0.isCompleted }) }
        return collection.sorted(by: { $0.createdDate > $1.createdDate })
    }
    func completedCount() -> String {
        String(MockData().mock.filter({ $0.isCompleted }).count)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

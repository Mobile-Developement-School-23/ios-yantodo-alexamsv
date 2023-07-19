//
//  ContentView.swift
//  YanDo-SUI-MockData
//
//  Created by Александра Маслова on 18.07.2023.
//

import SwiftUI

struct MainScreen: View {
    @State var showCompletedItems = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView{
                    VStack {
                        infPanel
                        LazyVStack (spacing: 0) {
                            ForEach(itemsCollection()) { item in
                                CellView(item: item)
                            }
                            SpecialCell()
                        }
                        .animation(.interactiveSpring())
                        .cornerRadius(16)
                         .padding(.horizontal, 16)
                    }
                    
                }.background(Color.primaryBack)
                    .navigationTitle(Label.title)
                    .navigationBarTitleDisplayMode(.large)
                plusButton
            }
        }
    }
    var infPanel: some View {
        HStack {
            Text(Label.doneCounter + "\(completedCount())")
                .foregroundColor(.tertiaryLabel)
            Spacer()
            Button {
                showCompletedItems.toggle()
            } label: {
                if showCompletedItems {
                    Text(Label.show)
                } else { Text(Label.hide) }
            }.foregroundColor(.blueColor)
                .bold()
        }
        .font(.system(size: 15))
        .padding(.vertical, 12)
        .frame(width: 310 / Aligners.modelWidth * Aligners.width)
    }
    var plusButton: some View {
        Button {
            // new form
        } label: {
            VStack {
                Spacer()
                Images.plus.uiImage
                    .resizable()
                    .frame(width: 44, height: 44)
                    .shadow(color: Color(red: 0, green: 0.29, blue: 0.6).opacity(0.6), radius: 10, x: 0, y: 8)
                    .padding(.bottom, 20)
                    .padding(.bottom, 20)
            }
        }
    }
    // MARK: - View Model
    func itemsCollection() -> [ToDoItem]{
        var collection = [ToDoItem]()
        if showCompletedItems {
            collection = MockData().mock
        } else { collection = MockData().mock.filter({ !$0.isCompleted }) }
        return collection
    }
    func completedCount() -> Int {
        MockData().mock.filter({ $0.isCompleted }).count
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

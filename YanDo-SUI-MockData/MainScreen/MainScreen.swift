//
//  ContentView.swift
//  YanDo-SUI-MockData
//
//  Created by Александра Маслова on 18.07.2023.
//

import SwiftUI

struct MainScreen: View {
    let mock = MockData().mock
    @State var showCompletedItems = false
    var body: some View {
        NavigationView {
            ScrollView {
                infPanel
                
            }
            .navigationTitle(Label.title)
            .navigationBarTitleDisplayMode(.large)
        }.frame(width: 343 / Aligners.modelWidth * Aligners.width)
        
    }
    
    var infPanel: some View {
        HStack {
            Text(Label.doneCounter + "\(mock.filter {$0.isCompleted}.count)")
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
        .padding(.top, 8)
        .frame(width: 310 / Aligners.modelWidth * Aligners.width)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

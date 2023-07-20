//
//  SpecialCell.swift
//  YanDo-SUI-MockData
//
//  Created by Александра Маслова on 20.07.2023.
//

import SwiftUI

struct SpecialCell: View {
    var body: some View {
        HStack {
            Texts.new.uiText
                .padding(.leading, 52)
            Spacer()
        }.padding(.vertical, 20)
        .background(Color.secondaryBack)
            
    }
}

struct SpecialCell_Previews: PreviewProvider {
    static var previews: some View {
        SpecialCell()
    }
}

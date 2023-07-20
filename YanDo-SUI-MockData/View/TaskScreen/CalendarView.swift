//
//  CalendarView.swift
//  YanDo-SUI-MockData
//
//  Created by Александра Маслова on 20.07.2023.
//

import SwiftUI

struct FixedDatePicker: View {
    @State private var selectedDate: Date
    let fixedDate: Date // Дата, которую мы хотим высветить на календаре

    init(fixedDate: Date) {
        _selectedDate = State(initialValue: fixedDate)
        self.fixedDate = fixedDate
    }

    var body: some View {
        VStack {
            DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(.graphical)
                .disabled(true) // тк read only закрепим его
        }
        .onAppear {
            // Устанавливаем дату в DatePicker при его появлении
            selectedDate = fixedDate
        }
    }
}


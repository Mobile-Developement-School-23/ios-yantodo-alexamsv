//
//  AlignersForScreens.swift
//  YanDo
//
//  Created by Александра Маслова on 27.06.2023.
//

import UIKit

// Сделано для адаптации под разные размеры экрана. Цифры взяты из размера экрана на макете в figma
enum Aligners {
    static let height = UIScreen.main.bounds.height
    static let width = UIScreen.main.bounds.width
    static let modelHight: CGFloat = 812
    static let modelWidth: CGFloat = 375
}

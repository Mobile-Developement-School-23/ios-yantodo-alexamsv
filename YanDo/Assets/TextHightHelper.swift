//
//  TextHight.swift
//  YanDo
//
//  Created by Александра Маслова on 08.07.2023.
//
// swiftlint:disable line_length

import Foundation
import UIKit

func calculateHeight(forText text: String) -> CGFloat {
    let font = UIFont.systemFont(ofSize: 17.0) // Шрифт, используемый для текста
    let labelWidth = UIScreen.main.bounds.width - 16.0 // Ширина метки, на которой будет отображаться текст
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineBreakMode = .byWordWrapping
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
        .paragraphStyle: paragraphStyle
    ]
    let attributedText = NSAttributedString(string: text, attributes: attributes)
    let labelHeight = attributedText.boundingRect(with: CGSize(width: labelWidth, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
    let lineHeight = font.lineHeight
    let numberOfLines = ceil(labelHeight / lineHeight)
    var additionalHeight: CGFloat = 0.0
    if numberOfLines > 1 {
        if numberOfLines == 2 {
            additionalHeight += 20.0
        } else if numberOfLines >= 3 {
            additionalHeight += 42.0
        }
    }
    return additionalHeight
}
// swiftlint:enable line_length

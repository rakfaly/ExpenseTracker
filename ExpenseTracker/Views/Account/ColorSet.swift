//
//  ColorSet.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 15/07/2023.
//

import Foundation
import SwiftUI

class ColorSet: NSObject, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool = true

    var colors: [UIColor]

    init(colors: [UIColor]) {
        self.colors = colors
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let colorData = aDecoder.decodeObject(forKey: "colors") as? [Data] else {
            return nil
        }

        // Convert Data back to UIColors
        let colors = colorData.compactMap { try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: $0) }

        self.init(colors: colors)
    }

    func encode(with aCoder: NSCoder) {
        // Convert UIColors to Data for archiving
        let colorData = colors.map { try? NSKeyedArchiver.archivedData(withRootObject: $0, requiringSecureCoding: true) }
        aCoder.encode(colorData, forKey: "colors")
    }
}


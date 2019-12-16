//
//  Cell.swift
//  NotebookCollection
//
//  Created by Ihar_Karalko on 12/9/19.
//  Copyright © 2019 Ihar_Karalko. All rights reserved.
//

import UIKit

protocol Cell: class {
    static var defaultReuseIdentifier: String { get }
}

extension Cell {
    static var defaultReuseIdentifier: String {
        return "\(self)"
    }
}

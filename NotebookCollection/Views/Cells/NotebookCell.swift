//
//  NotebookCell.swift
//  NotebookCollection
//
//  Created by Ihar_Karalko on 12/9/19.
//  Copyright © 2019 Ihar_Karalko. All rights reserved.
//

import UIKit

class NotebookCell: UITableViewCell, Cell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var noteCountLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        noteCountLabel.text = nil
    }
}

extension NotebookCell {
    func configCell(name: String, count: Int, noteString: String) {
         nameLabel.text = name
         noteCountLabel.text = "\(count) \(noteString)"
    }
}

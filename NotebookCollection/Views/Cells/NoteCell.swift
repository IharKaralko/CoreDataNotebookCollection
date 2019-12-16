//
//  NoteCell.swift
//  NotebookCollection
//
//  Created by Ihar_Karalko on 12/9/19.
//  Copyright © 2019 Ihar_Karalko. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell, Cell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        dateLabel.text = nil
    }
}

extension NoteCell {
    func configCell(title: String, date: String) {
        titleLabel.text = title
        dateLabel.text = date
    }
}

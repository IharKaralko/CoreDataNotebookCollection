//
//  DetailsViewController.swift
//  NotebookCollection
//
//  Created by Ihar_Karalko on 12/10/19.
//  Copyright © 2019 Ihar_Karalko. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet private weak var textView: UITextView!
    var note: Note!
    var onDelete: (() -> Void)?
    var dataSourceOfNote: DataSourceOfNote?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = note.title {
            navigationItem.title = title
        }
        textView.text = note.text
    }
    
    @IBAction func deleteNote(_ sender: UIBarButtonItem) {
        presentDeleteNotebookAlert()
    }
}

extension DetailsViewController {
    func presentDeleteNotebookAlert() {
        let alert = UIAlertController(title: "Delete Note", message: "Do you want to delete this note?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler))
        present(alert, animated: true, completion: nil)
    }
    
    func deleteHandler(alertAction: UIAlertAction) {
        onDelete?()
    }
}

extension DetailsViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let dataSource = dataSourceOfNote else { return }
        dataSource.updateNote(note: note, text:  textView.text)
    }
}

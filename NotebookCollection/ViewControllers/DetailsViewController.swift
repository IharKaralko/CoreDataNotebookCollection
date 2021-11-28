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
    var noteContent: NoteContent!
    var dataSourceOfNoteContent: DataSourceOfNoteContent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = note.title {
            navigationItem.title = title
        }
        textView.attributedText = noteContent.attributedText
        configureToolbarItems()
        configureTextViewInputAccessoryView()
    }
    
    @IBAction func deleteNote(_ sender: UIBarButtonItem) {
        presentDeleteNoteAlert()
    }
}

//extension DetailsViewController: UITextViewDelegate {
//    func textViewDidEndEditing(_ textView: UITextView) {
//    dataSourceOfNoteContent.updateText(note: note, text: textView.attributedText)
//    }
//}

private extension DetailsViewController {
    func presentDeleteNoteAlert() {
        let alert = UIAlertController(title: "Delete Note", message: "Do you want to delete this note?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler))
        present(alert, animated: true, completion: nil)
    }
    
    func deleteHandler(alertAction: UIAlertAction) {
        onDelete?()
    }
    
    func makeToolbarItems() -> [UIBarButtonItem] {
        let normal = UIBarButtonItem.menuButton(self, action: #selector(normalTapped(sender:)), imageName: "icons8-u-turn-to-left-50")
        let red = UIBarButtonItem.menuButton(self, action: #selector(redTapped(sender:)), imageName: "toolbar-underline")
        let bold = UIBarButtonItem.menuButton(self, action: #selector(boldTapped(sender:)), imageName: "toolbar-bold")
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        return  [space, normal, space, bold, space, red, space]
    }
    
    @objc
    func boldTapped(sender: Any) {
        let newText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        newText.addAttribute(.font, value: UIFont(name: "HelveticaNeue-Bold", size: 22) as Any, range: textView.selectedRange)
        
        let selectedTextRange = textView.selectedTextRange
        
        textView.attributedText = newText
        textView.selectedTextRange = selectedTextRange
    }
    
    @objc
    func redTapped(sender: Any) {
        let childContext = dataSourceOfNoteContent.childContext
        let mainContext = dataSourceOfNoteContent.context
        
        let newText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.red,
            .underlineStyle: 1,
            .underlineColor: UIColor.red
        ]
        newText.addAttributes(attributes, range: textView.selectedRange)
        childContext.perform {
            self.note.noteContent?.attributedText = newText
            sleep(5)
            do {
                try childContext.save()
                mainContext.performAndWait {[weak self] in
                    let selectedTextRange = self?.textView.selectedTextRange
                    self?.textView.attributedText = newText
                    self?.textView.selectedTextRange = selectedTextRange
                    self?.updateNote()
                }
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    func updateNote() {
        dataSourceOfNoteContent.updateText(note: note, text: textView.attributedText)
    }
    
    @objc
    func normalTapped(sender: Any) {
        let newText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14.0) as Any,
            .foregroundColor: UIColor.black,
            .underlineStyle: 0
            // .underlineColor: UIColor.black
        ]
        newText.addAttributes(attributes, range: textView.selectedRange)
        let selectedTextRange = textView.selectedTextRange
        textView.attributedText = newText
        textView.selectedTextRange = selectedTextRange
    }
    
    func configureToolbarItems() {
        toolbarItems = makeToolbarItems()
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func configureTextViewInputAccessoryView() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        toolbar.items = makeToolbarItems()
        textView.inputAccessoryView = toolbar
    }
}

extension UIBarButtonItem {
    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 28).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 28).isActive = true
        
        return menuBarItem
    }
}

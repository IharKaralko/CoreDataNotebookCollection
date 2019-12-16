//
//  NotesListViewController.swift
//  NotebookCollection
//
//  Created by Ihar_Karalko on 12/9/19.
//  Copyright © 2019 Ihar_Karalko. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var _numberOfNotes: Int { return _notes.count }
    private var _notes: [Note] = []
    private let _dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    var notebook: Notebook!
    var dataSourceOfNote: DataSourceOfNote!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = notebook.name
        navigationItem.rightBarButtonItem = editButtonItem
        _notes = dataSourceOfNote.getNotes(notebook: notebook)

        updateEditButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        presentNewNoteAlert()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.note = note(at: indexPath)
                vc.dataSourceOfNote = dataSourceOfNote
                
                vc.onDelete = { [weak self] in
                    if let indexPath = self?.tableView.indexPathForSelectedRow {
                        self?.deleteNote(at: indexPath)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}

private extension NotesListViewController {
    func presentNewNoteAlert() {
        let alert = UIAlertController(title: "New Note", message: "Enter a title for this note", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            if let name = alert.textFields?.first?.text {
                self?.addNote(name: name)
            }
        }
        
        saveAction.isEnabled = false
        alert.addTextField { textField in
            textField.placeholder = "Note title"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { notif in
                if let text = textField.text, !text.isEmpty {
                    saveAction.isEnabled = true
                } else {
                    saveAction.isEnabled = false
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }

    func addNote(name: String) {
        let note = dataSourceOfNote.createNote(name: name, notebook: notebook)
        _notes.insert(note, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        updateEditButtonState()
    }
    
    func deleteNote(at indexPath: IndexPath) {
        let noteToDelete = note(at: indexPath)
        dataSourceOfNote.removeNote(note: noteToDelete)
        _notes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        if _numberOfNotes == 0 {
            setEditing(false, animated: true)
        }
        updateEditButtonState()
    }
    
    func updateEditButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = _numberOfNotes > 0
    }
    
    func note(at indexPath: IndexPath) -> Note {
        return _notes[indexPath.row]
    }
}

extension NotesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _numberOfNotes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aNote = note(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.defaultReuseIdentifier, for: indexPath) as! NoteCell
        if let creationDate = aNote.creationDate, let title = aNote.title {
            cell.configCell(title: title, date: _dateFormatter.string(from: creationDate))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteNote(at: indexPath)
        default: () 
        }
    }
}

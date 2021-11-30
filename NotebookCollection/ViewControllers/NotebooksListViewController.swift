//
//  NotebooksListViewController.swift
//  NotebookCollection
//
//  Created by Ihar_Karalko on 12/8/19.
//  Copyright © 2019 Ihar_Karalko. All rights reserved.
//

import UIKit

class NotebooksListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var _notebooks: [Notebook] = []
    private var _numberOfNotebooks: Int { return _notebooks.count }
    var dataSourceOfNotebook: DataSourceOfNotebook!

    var shop: Shop!
    var dataSourceOfShop: DataSourceOfShop!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Content"
        navigationItem.rightBarButtonItem = editButtonItem
        if shop == nil {
        _notebooks = dataSourceOfNotebook.getNotebooks()
        } else {
            _notebooks = dataSourceOfNotebook.getNotebooks(shop)
        }
        updateEditButtonState()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        presentNewNotebookAlert()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NotesListViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.notebook = notebook(at: indexPath)
                vc.dataSourceOfNote = DataSourceOfNote()
            }
        }
    }
}

private extension NotebooksListViewController {
    func presentNewNotebookAlert() {
        let alert = UIAlertController(title: "New Notebook", message: "Enter a name for this notebook", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            if let name = alert.textFields?.first?.text {
                self?.addNotebook(name: name)
            }
        }
        
        saveAction.isEnabled = false
        alert.addTextField { textField in
            textField.placeholder = "Name"
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
    
    func addNotebook(name: String) {
        let notebook = dataSourceOfNotebook.createNotebook(name: name)
        _notebooks.insert(notebook, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        updateEditButtonState()
    }
    
    func updateEditButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = _numberOfNotebooks > 0
    }
    
    func notebook(at indexPath: IndexPath) -> Notebook {
        return _notebooks[indexPath.row]
    }
    
    func deleteNotebook(at indexPath: IndexPath) {
        let notebookToDelete = notebook(at: indexPath)
        dataSourceOfNotebook.removeNotebook(notebook: notebookToDelete)
        _notebooks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        if _numberOfNotebooks == 0 {
            setEditing(false, animated: true)
        }
        updateEditButtonState()
    }
}

extension NotebooksListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _numberOfNotebooks
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aNotebook = notebook(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier:
            NotebookCell.defaultReuseIdentifier, for: indexPath) as! NotebookCell
        
        if let count = aNotebook.notes?.count, let name = aNotebook.name
        {
            let noteString = count == 1 ? "note" : "notes"
            cell.configCell(name: name, count: count, noteString: noteString)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteNotebook(at: indexPath)
        default: ()
        }
    }
}

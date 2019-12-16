//
//  NotebookListWithFRCViewController.swift
//  NotebookCollection
//
//  Created by Ihar_Karalko on 12/11/19.
//  Copyright © 2019 Ihar_Karalko. All rights reserved.
//

import UIKit
import CoreData

class NotebookListWithFRCViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var _fetchedResultsController: NSFetchedResultsController<Notebook>!
    var dataSourceOfNotebook: DataSourceOfNotebook!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Content"
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _fetchedResultsController =  dataSourceOfNotebook.setupFetchedResultsController()
        _fetchedResultsController.delegate = self
        updateEditButtonState()
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _fetchedResultsController = nil
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        presentNewNotebookAlert()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NotesListViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.notebook = _fetchedResultsController.object(at: indexPath)
                vc.dataSourceOfNote = DataSourceOfNote()
            }
        }
    }
}

private extension NotebookListWithFRCViewController {
    func presentNewNotebookAlert() {
        let alert = UIAlertController(title: "New Notebook", message: "Enter a name for this notebook", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            if let name = alert.textFields?.first?.text {
                self?.dataSourceOfNotebook.createNotebookForFRC(name: name)
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
    
    func updateEditButtonState() {
        if let sections = _fetchedResultsController.sections {
            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
        }
    }
    
    func deleteNotebook(at indexPath: IndexPath) {
        let notebookToDelete = _fetchedResultsController.object(at: indexPath)
        dataSourceOfNotebook.removeNotebook(notebook: notebookToDelete)
    }
}


extension NotebookListWithFRCViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return _fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aNotebook = _fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier:
            NotebookCell.defaultReuseIdentifier, for: indexPath) as! NotebookCell
        
        if let count = aNotebook.notes?.count, let name = aNotebook.name {
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

extension NotebookListWithFRCViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let index = newIndexPath {
                tableView.insertRows(at: [index], with: .fade)
            }
            break
        case .delete:
            if let index = indexPath {
                tableView.deleteRows(at: [index], with: .fade)
            }
            break
        default:
            break
        }
        updateEditButtonState()
    }
}

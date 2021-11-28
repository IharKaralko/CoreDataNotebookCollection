//
//  ShopListViewController.swift
//  NotebookCollection
//
//  Created by Ihar Karalko on 28.11.2021.
//  Copyright © 2021 Ihar_Karalko. All rights reserved.
//

import UIKit

class ShopListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var _shops: [Shop] = []
    private var _numberOfShop: Int { return _shops.count }
    var dataSourceOfShop: DataSourceOfShop!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Shops"
        navigationItem.rightBarButtonItem = editButtonItem
        _shops = dataSourceOfShop.getShops()
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
        if let vc = segue.destination as? NotebooksListViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.shop = shop(at: indexPath)
                vc.dataSourceOfShop = DataSourceOfShop()
                vc.dataSourceOfNotebook = DataSourceOfNotebook()
            }
        }
    }
}

private extension ShopListViewController{
    func presentNewNotebookAlert() {
        let alert = UIAlertController(title: "New Notebook", message: "Enter a name for this notebook", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            if let name = alert.textFields?.first?.text {
                self?.addShop(name: name)
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

    func addShop(name: String) {
        let shop = dataSourceOfShop.createShop(name: name)
        _shops.insert(shop, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        updateEditButtonState()
    }

    func updateEditButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = _numberOfShop > 0
    }

    func shop(at indexPath: IndexPath) -> Shop {
        return _shops[indexPath.row]
    }

    func deleteNotebook(at indexPath: IndexPath) {
//        let notebookToDelete = notebook(at: indexPath)
//        dataSourceOfNotebook.removeNotebook(notebook: notebookToDelete)
//        _notebooks.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .fade)
//        if _numberOfNotebooks == 0 {
//            setEditing(false, animated: true)
//        }
//        updateEditButtonState()
    }
}

extension ShopListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _numberOfShop
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aShop = shop(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier:
            NotebookCell.defaultReuseIdentifier, for: indexPath) as! NotebookCell

//        if let count = aNotebook.notes?.count, let name = aNotebook.name
//        {
//            let noteString = count == 1 ? "note" : "notes"
//            cell.configCell(name: name, count: count, noteString: noteString)
//        }

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteNotebook(at: indexPath)
        default: ()
        }
    }
}

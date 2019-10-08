//
//  ContactsViewController.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 08/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    let viewModel = ContactViewModel()
    let cellId = "ContactCell"

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 60
        return tableView
    }()

    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        setupTableView()
        setupNavigation()
        viewModel.delegate = self
        viewModel.prepareController()
    }

    private func setupConstraint() {
        view.backgroundColor = .white
        view.addViewsForAutoLayout(views: [tableView])
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
    }

    @objc private func cancel() {
        self.navigationController?.popViewController(animated: true)
    }

    private func setupNavigation() {
        navigationItem.title = "Contacts"

        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))

        searchController = UISearchController(searchResultsController: self)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none

        if #available(iOS 11.0, *) {
            // For iOS 11 and later, place the search bar in the navigation bar.
            navigationItem.searchController = searchController

            // Make the search bar always visible.
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // For iOS 10 and earlier, place the search controller's search bar in the table view's header.
            tableView.tableHeaderView = searchController.searchBar
        }

        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // The default is true.
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.

        /** Search presents a view controller by applying normal view controller presentation semantics.
         This means that the presentation moves up the view controller hierarchy until it finds the root
         view controller or one that defines a presentation context.
         */

        /** Specify that this view controller determines how the search controller is presented.
         The search controller should be presented modally and match the physical size of this view controller.
         */
        definesPresentationContext = true
    }

}
extension ContactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

    }
}

extension ContactsViewController: UISearchControllerDelegate {

}

extension ContactsViewController: UISearchBarDelegate {

}

extension ContactsViewController: ContactViewModelDelegate {
    func contactLoadingError() {
        print("Error")
    }

    func contactDetailLoaded() {
        tableView.reloadData()
    }
}

// MARK: tableview data source and delegate
extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections() + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return viewModel.numberOfRows(in: section - 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ContactCell
            else {
                return UITableViewCell()
        }
        if indexPath.section == 0 {
            let placeholder = UIImage(named: "placeholder", in: Bundle.chat, compatibleWith: nil)!
            if indexPath.row == 0 {
                cell.update(text: "New Group", image: placeholder, font: UIFont.systemFont(ofSize: 14), color: .blue)
            } else {
                cell.update(text: "New Contact", image: placeholder, font: UIFont.systemFont(ofSize: 14), color: .blue)
            }
            return cell
        }
        guard let contact = viewModel.contactAt(row: indexPath.row, section: indexPath.section - 1) else {
            return UITableViewCell()
        }
        cell.update(contact: contact)
        return cell
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.sectionIndexTitles()
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return viewModel.sectionFor(title: title) + 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return viewModel.titleForSection(section - 1)
    }

}

//
//  ContactViewModel.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 08/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation
import Contacts

protocol ContactViewModelDelegate {
    func contactLoadingError()
    func contactDetailLoaded()
}

struct ContactModel {
    let key: String
    var value: [CNContact]
}

class ContactViewModel {

    var contactList = [ContactModel]()
    var delegate: ContactViewModelDelegate?

    let frequentlyContactedKey = "0"
    var frequentlyContactedValue = "FREQUENTLY CONTACTED"

    func prepareController() {
        let frequents = prepareFrequentContacts()
        contactList.append(ContactModel(key: frequentlyContactedKey, value: frequents))
        fetchContact()
    }

    func fetchContact() {
        let keysToFetch = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            CNContactThumbnailImageDataKey] as [CNKeyDescriptor]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        fetchRequest.sortOrder = .givenName
        do {
            try CNContactStore().enumerateContacts(with: fetchRequest) { (contact, stop) in
                let name = String(contact.givenName.first!)
                if let last = self.contactList.last?.key, last == name {
                    self.contactList[self.contactList.count - 1].value.append(contact)
                } else {
                    self.contactList.append(ContactModel(key: name, value: [contact]))
                }
            }
            self.delegate?.contactDetailLoaded()
        } catch {
            print("Error")
            self.delegate?.contactLoadingError()
        }
    }

    func numberOfSections() -> Int {
        return contactList.count
    }

    func numberOfRows(in section: Int) -> Int {
        guard section < contactList.count else {
            return 0
        }
        return contactList[section].value.count
    }

    func contactAt(row: Int, section: Int) -> CNContact? {
        guard section < contactList.count, row < contactList[section].value.count else {
            return nil
        }
        return contactList[section].value[row]
    }

    func sectionIndexTitles() -> [String] {
        return contactList.filter { return $0.key != frequentlyContactedKey }.map { return $0.key }
    }

    func sectionFor(title: String) -> Int {
        let keys = contactList.map { return $0.key }
        for index in 0..<keys.count {
            if title == keys[index] {
                return index
            }
        }
        return 0
    }

    func titleForSection(_ section: Int) -> String {
        let keys = contactList.map { return $0.key }
        guard section < keys.count else { return "" }
        if keys[section] == frequentlyContactedKey {
            return frequentlyContactedValue
        }
        return keys[section]
    }

    private func prepareFrequentContacts() -> [CNContact] {
        var contacts = [CNContact]()
        contacts.append(createContact(first: "Shivam", last: "Pokhriyal"))
        contacts.append(createContact(first: "Suraj", last: "Pokhriyal"))
        contacts.append(createContact(first: "Sachin", last: "Pokhriyal"))
        contacts.append(createContact(first: "Rajesh", last: "Pokhriyal"))
        contacts.append(createContact(first: "Sehwag", last: "Pokhriyal"))
        return contacts
    }

    private func createContact(first: String, last: String) -> CNContact {
        let contact = CNMutableContact()
        contact.givenName = first
        contact.familyName = last
        return contact
    }

}

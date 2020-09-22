//
//  AutoCompleteComponent.swift
//  Cocus
//
//  Created by Amir Daliri on 21.09.2020.
//  Copyright © 2020 Cocus. All rights reserved.
//

import UIKit

class AutoCompleteComponent: NSObject {
    
    // MARK: - Properties
    
    var datas: [String]! {
        didSet {
            reloadTableView()
        }
    }
    private var autoCompleteDatas : [String] = []
    private var heightConstraint: NSLayoutConstraint!
    private var tableView: UITableView!
    private var textDidChanged: (() -> Void)?
    private var elementDidSelected: ((Any) -> Void)?
    
    init(heightConstraint: NSLayoutConstraint, tableView: UITableView, elementDidSelected: ((Any) -> Void)?, textDidChanged: (() -> Void)?) {
        self.textDidChanged = textDidChanged
        self.elementDidSelected = elementDidSelected
        super.init()
        self.heightConstraint = heightConstraint
        self.tableView = tableView
        self.prepareTableView()
        self.datas = []
    }
}

// MARK: - Tableview delegate & datasource
extension AutoCompleteComponent: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompleteDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = autoCompleteDatas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        elementDidSelected?(autoCompleteDatas[indexPath.row])
    }
}


// MARK: - Textfield delegate
extension AutoCompleteComponent: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textDidChanged?()
        tableView.isHidden = true
        
        guard var text = textField.text else {
            return true
        }
        
        if text.count > range.lowerBound {
            text.removeLast()
        } else {
            text.append(string)
        }
        
        guard text.count >= 2 else {
            return true
        }
        
        autoCompleteDatas = datas.filter {
            $0.uppercased().contains(text.uppercased())
        }
        
        reloadTableView()
        tableView.isHidden = false
        return true
    }
}

// MARK: - Private functions
private extension AutoCompleteComponent {
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "autoCompleteCell")
    }
    
    func reloadTableView() {
        tableView.reloadData()
        updateHeight()
    }
    
    func updateHeight() {
        
        if heightConstraint != nil {
            heightConstraint.isActive = false
        }
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
        heightConstraint.isActive = true
    }
}

//
//  FormTableViewCell.swift
//  Core_Data_Assignment
//
//  Created by E5000855 on 20/06/24.
//
import UIKit

class FormTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var inputTextField: UITextField!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        inputTextField = UITextField()
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(inputTextField)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            inputTextField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            inputTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            inputTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, placeholder: String, keyboardType: UIKeyboardType = .default) {
        titleLabel.text = title
        inputTextField.placeholder = placeholder
        inputTextField.keyboardType = keyboardType
    }
}


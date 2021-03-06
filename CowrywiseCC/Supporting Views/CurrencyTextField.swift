//
//  CurrencyTextfield.swift
//  CowrywiseCC
//
//  Created by Admin on 12/24/20.
//  Copyright © 2020 rapid interactive. All rights reserved.
//

//
//  PersonalTodoTextField.swift
//  PersonalToDo
//
//  Created by Admin on 11/2/20.
//  Copyright © 2020 rapid interactive. All rights reserved.
/*
 Abstract: A view that allows a user to input an amount of money
 */

import Foundation
import UIKit
import SwiftUI

class CustomTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 80);
    var width: CGFloat = 0
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rightBounds = CGRect(x: bounds.maxX - 72 , y: bounds.origin.y, width: bounds.width, height: bounds.height)
        return rightBounds
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

/// A view that allows a user to input an amount of money
struct CurrencyTextField: UIViewRepresentable {
    
 
    var textField = CustomTextField(frame: .zero)  
    @Binding var text: String
  
    var currencyPlaceHolder: String
  
    var isResultDisplayed: Bool
     
    var onCommit: () -> () = {}
    
     func makeUIView(context: Context) -> UITextField {
        
        let label = UILabel(frame: .zero)
        label.textColor = .systemGray3
        label.font =  UIFont.boldSystemFont(ofSize: 24)
        label.text = currencyPlaceHolder
        label.tag = 1
        label.sizeToFit()
 
        if let labelText = label.text {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(.kern, value: 2.0, range: NSRange(location: 0, length: attributedString.length))
            label.attributedText = attributedString
        }
        
        
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        textField.keyboardType = .numberPad
        textField.text = text
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
 
        textField.rightViewMode = .always
        textField.rightView = label
        textField.textColor = .gray
        textField.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textField.backgroundColor = UIColor(named: "textfield")
        textField.delegate = context.coordinator
        textField.adjustsFontSizeToFitWidth = true
 
        return textField
    }
    
    func updateUIView(_ textView: UITextField, context: Context) {
        
        for subview in textView.subviews {
            if subview.tag ==  1 {
                if let label = subview as? UILabel {
                    label.text = currencyPlaceHolder
                }
            }
        }
       
        if !isResultDisplayed {
            textView.text = text
        } else {
            textView.text = text
            let result = text.split(separator: ".")
            let fractionalPart = result.count == 2 ? String(result[1]) : ""
            if fractionalPart.count > 3 {
                let thirdCharFromEndIdx = 3
                let attributedString = NSMutableAttributedString(string: fractionalPart)
                attributedString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemGray4],
                                               range: NSRange(location: thirdCharFromEndIdx,
                                                              length: fractionalPart.count - thirdCharFromEndIdx))
                
                let attributedString0 = NSMutableAttributedString(string: String(result[0])+".")
                attributedString0.append(attributedString)
                textView.attributedText = attributedString0
            }
        }
        
    }
    
    func makeCoordinator() -> CurrencyTextFieldCoordinator {
        return CurrencyTextFieldCoordinator(representable: self)
    }
    
}

class CurrencyTextFieldCoordinator: NSObject, UITextFieldDelegate {
    
    var representable: CurrencyTextField
    
    init(representable: CurrencyTextField) {
        self.representable = representable
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if let userText = textField.text {
            representable.text = userText
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        if representable.isResultDisplayed {
            
            textField.textColor = .systemGray
            textField.text = ""
            
            let result = text.split(separator: ".")
            let fractionalPart = result.count == 2 ? String(result[1]) : ""
           
            if fractionalPart.count > 3 {
                let thirdCharFromEndIdx = 3
                let attributedString = NSMutableAttributedString(string: fractionalPart)
                
                attributedString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemGray4],
                                               range: NSRange(location: thirdCharFromEndIdx,
                                                              length: fractionalPart.count - thirdCharFromEndIdx))
                
                let wholePartWithPoint = String(result[0]) + "."
                textField.text = ""
                textField.attributedText = nil
                
                let attributedString0 = NSMutableAttributedString(string: wholePartWithPoint)
                
                attributedString0.append(attributedString)
                
                textField.attributedText = attributedString0
            }
            
        }
        
    }
 
}

struct CurrencyTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CurrencyTextField(text: .constant("500888"), currencyPlaceHolder: "NGN", isResultDisplayed: false, onCommit: {})
                    .cornerRadius(5)
                    .frame(width: 350, height: 56)
        }
        .previewDevice("iPhone8")
        
       
    }
   
}

 

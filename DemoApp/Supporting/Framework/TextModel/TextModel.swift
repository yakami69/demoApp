//
//  TextModel.swift
//  Framework
//
//  Created by Narendra Bdr Kathayat on 1/10/20.
//  Copyright © 2020 EBPearls. All rights reserved.
//

import Foundation
import UIKit
import Combine

/// This is the protocol for textView requiring multiple delegate and cannot be used to validate
public protocol CombineTextView: UIControl {
    var textView: UITextView { get set }
}

/// The textModel class that will handle all the vaidation of data publish the result
public class TextModel: NSObject {
    
    /// The TextField for this model
    private var textField: UITextField?
    
    /// The textView for the model
    private var textView: UITextView?
    
    /// The value of the textField
    public var value: String {
        if textField != nil {
            return textField?.text ?? ""
        } else if textView != nil {
            return textView?.text ?? ""
        } else {
            return ""
        }
    }
    
    /// The intercator for the model
    private var interactor: Interactable
    
    /// The result publisher
    @Published public var publisher: TextModelResult
    
    /// Initializer
    public init(interactor: Interactable) {
        self.interactor = interactor
        self.publisher = TextModelResult(element: textField, value: "", error: nil)
        super.init()
    }
    
    /// Bind the textField to this model
    /// - Parameter textField: the textField to bind
    public func bind(_ element: UITextField) {
        self.textField = element
        element.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        let error = interactor.validate(value: element.text ?? "")
        self.publisher = TextModelResult(element: textField, value: "", error: error)
    }
    
    /// Binds a textView to this model
    /// - Parameter textView: the textView to bind
    public func bind(_ element: UITextView) {
        self.textView = element
        self.textView?.delegate = self
        let error = interactor.validate(value: element.text ?? "")
        self.publisher = TextModelResult(element: textView, value: "", error: error)
    }
    
    /// Binds a custom CombineTextView to this model
    /// - Parameter element: the CombineTextView to bind
    public func bind(_ element: CombineTextView) {
        self.textView = element.textView
        element.addTarget(self, action: #selector(textViewChanged), for: .editingChanged)
        let error = interactor.validate(value: element.textView.text ?? "")
        self.publisher = TextModelResult(element: textView, value: "", error: error)
    }
    
    /// sets the value and validate the text inside textField
    /// - Parameters:
    ///   - text: the text
    ///   - field: the textField
    private func setValue(with text: String, element: UITextInput?) {
        let error = interactor.validate(value: text)
        publisher = TextModelResult(element: element, value: text, error: error)
    }
    
    public func setInitialValue(with text: String) {
        let error = interactor.validate(value: text)
        if let textField = textField {
            self.publisher = TextModelResult(element: textField, value: text, error: error)
        }
        if let textView = textView {
            self.publisher = TextModelResult(element: textView, value: text, error: error)
        }
    }
}

/// Extension to handle the observer for UITextField
extension TextModel {
    
    @objc private func textFieldDidChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.setValue(with: text, element: self.textField)
    }
}

/// Extensio to handle the observer for UITextField
extension TextModel: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        setValue(with: text, element: self.textView)
    }
    
    @objc private func textViewChanged() {
        guard let text = textView?.text else { return }
        setValue(with: text, element: self.textView)
    }
}


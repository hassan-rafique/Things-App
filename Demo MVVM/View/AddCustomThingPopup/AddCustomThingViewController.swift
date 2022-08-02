//
//  AddCustomThingViewController.swift
//  Demo MVVM
//
//  Created by Hassan Rafique on 8/1/22.
//

import UIKit

protocol AddCustomThingViewControllerDelegate {
    func addCustomThing(text: String)
}

class AddCustomThingViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtName: UITextField!

    // MARK: - Properties
    var delegate: AddCustomThingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        txtName.delegate = self
        updateSaveButtonView(count: 0)
        
        vwTop.addTopViewLayer()
        vwBottom.addBottomRightViewLayer()
    }
    
    

}

// MARK: - Method's & Button Action's
extension AddCustomThingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return  true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var strSearch = textField.text!
        if string.isEmpty {
            if !strSearch.isEmpty {
                strSearch.removeLast()
            }
        } else {
            strSearch.append(string)
        }
        
        updateSaveButtonView(count: strSearch.count)
        return true
    }
    
    func updateSaveButtonView(count: Int) {
        btnSave.alpha = count < 3 ? 0.3 : 1
        btnSave.isUserInteractionEnabled = count < 3 ? false : true
    }
    
    @IBAction func btnSave_Action(_ sender: UIButton) {
        guard let name = txtName.text?.trim(), !name.isEmpty else {
            return
        }
        
        dismiss(animated: true) { [weak self] in
            self?.delegate?.addCustomThing(text: name)
        }
    }
}


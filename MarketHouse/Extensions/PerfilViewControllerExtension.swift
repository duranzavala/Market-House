//
//  PerfilViewControllerExtension.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/31/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//


import UIKit

extension PerfilViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            perfilImageView.contentMode = .scaleAspectFit
            perfilImageView.image = pickedImage
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderInput.text = genders[row]
        self.view.endEditing(true)
    }
}

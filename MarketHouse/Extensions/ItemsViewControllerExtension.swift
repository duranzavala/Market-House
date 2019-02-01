//
//  ItemsViewControllerExtension.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/28/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//
import UIKit

extension ItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        cell.image.image = imagesCollection[indexPath.row]
        cell.index = indexPath
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterImageCollectionView", for: indexPath)
        
//        if imagesCollection.count < 3{
//
//            footer.isHidden = false
//        }else{
//            footer.isHidden = true
//        }
        
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        
        countImages.text = "Photos \(imagesCollection.count)/5 - You can add images to better show the ad."
        
        if imagesCollection.count < 5{
            return CGSize(width: 100, height: collectionView.frame.height)
        }else{
            return CGSize.zero
        }
    }
}

extension ItemsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            imagesCollection.append(image)
        } else if let image = info[.originalImage] as? UIImage{
            imagesCollection.append(image)
        }
        if imagesCollection.count == 10{
            self.collectionImagesView.deleteSections(NSIndexSet(index: 1) as IndexSet)
        }
        dismiss(animated: true, completion: nil)
        collectionImagesView.reloadData()
    }
}

extension ItemsViewController: dataCollectionProtocol{
    
    func deleteImage(index: Int) {
        imagesCollection.remove(at: index)
        collectionImagesView.reloadData()
    }
}

extension ItemsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return conditionPicker.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return conditionPicker[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        condition.text = conditionPicker[row]
        self.view.endEditing(true)
    }
}

extension ItemsViewController{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil){
            notification in
            self.keyboardWillShow(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: nil){
            notification in
            self.keybardWillHide(notification: notification)
        }
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: Notification){
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    
    func keybardWillHide(notification: Notification){
        scrollView.contentInset = UIEdgeInsets.zero
    }
}

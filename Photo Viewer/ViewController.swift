//
//  ViewController.swift
//  Photo Viewer
//
//  Created by Camilo Hernández Guerrero on 7/07/22.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var photosTaken = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePhoto))
        
        guard let savedPhotos = UserDefaults.standard.object(forKey: "photosTaken") as? Data else { return }
        let JSONDecoder = JSONDecoder()
        
        if let decodedPhotos = try? JSONDecoder.decode([Photo].self, from: savedPhotos) {
            photosTaken = decodedPhotos
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosTaken.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath)
        cell.textLabel?.text = photosTaken[indexPath.row].caption
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageIdentifier = photosTaken[indexPath.row].image
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageIdentifier)
        
        if let photoViewController = storyboard?.instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController {
            photoViewController.selectedPhoto = imagePath.path
            navigationController?.pushViewController(photoViewController, animated: true)
        }
    }
    
    @objc func takePhoto() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 1) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true)
        
        let alertController = UIAlertController(title: "Add a caption", message: "This allows you to recognize every photo you take.", preferredStyle: .alert)
        alertController.addTextField()
        let alertAction = UIAlertAction(title: "Done!", style: .default) {
            [weak self, weak alertController] _ in
            guard let textField = alertController?.textFields?[0].text else { return }
            let photo = Photo(image: imageName, caption: textField)
            self?.photosTaken.append(photo)
            self?.save()
            self?.tableView.reloadData()
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let JSONEncoder = JSONEncoder()
        
        if let savedPhotos = try? JSONEncoder.encode(photosTaken) {
            UserDefaults.standard.set(savedPhotos, forKey: "photosTaken")
        }
    }
}

//
//  NewNoteViewController.swift
//  NoteApp
//
//  Created by Юлия Sun on 20.03.2024.
//

import UIKit

class NewNoteViewController: UIViewController {

    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var NoteTextView: UITextView!
    
    var note: Note?
    
    @IBAction func addButtonPressed() {
        guard let title = NoteTextView.text, !title.isEmpty else { return }
        
        if let note = note {
            StorageManager.shared.edit(note: note, with: title)
        } else {
            StorageManager.shared.saveNote(withTitle: title)
        }
        
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonPressed() {
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        // Do any additional setup after loading the view.
    }
    
    private func setupTextView() {
        NoteTextView.becomeFirstResponder()
        NoteTextView.textColor = .black
        
        if let note = note {
            NoteTextView.text = note.title
        } else {
            AddButton.isHidden = true
        }
    }

}

extension NewNoteViewController {
    @objc private func keyboardWillShow(with notification: Notification) {
       // let key = UIResponder.keyboardFrameEndUserInfoKey
        
        //guard let keyboardFrame = notification.userInfo?[key] as? CGRect else { return }
        //bottomConstraint.constant = keyboardFrame.height
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension NewNoteViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        if AddButton.isHidden {
            textView.text.removeAll()
            AddButton.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

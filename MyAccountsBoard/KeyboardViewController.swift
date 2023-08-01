// Copyright (C) 2023. Bohdan Kolvakh
// This file is part of MyAccounts.
// 
// MyAccounts is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import UIKit
import KeychainAccess

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var pasteButton: UIButton!
    @IBOutlet var noPassword: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupPasteButton()
        setupNoPasswordText()
        setupNextKeyboardButton()
    }

    func setupView() {
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    func setupPasteButton() {
        pasteButton = UIButton(type: .system)
        pasteButton.setTitle("Paste password", for: [])
        pasteButton.configuration = UIButton.Configuration.borderedProminent()
        pasteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pasteButton)
        pasteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pasteButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        pasteButton.addTarget(self, action: #selector(pastePass), for: .touchUpInside)
    }

    @objc func pastePass() {
        // Note: MyAccounts and MyAccountsBoard have separate Info.plist files.
        // The KeychainGroupName is duplicated in both files,
        // so if you change the field in one Info.plist, don't forget to also change it in the other.
        let keychainGroupName = Bundle.main.infoDictionary?["KeychainGroupName"] as! String
        let keychain = Keychain(
            service: "com.acmpo6ou.myaccounts",
            accessGroup: keychainGroupName
        )
        if let password = keychain["clipboard"] {
            noPassword.isHidden = true
            textDocumentProxy.insertText(password)
            haptic(.medium)
            keychain["clipboard"] = nil
        } else {
            noPassword.isHidden = false
        }
    }

    func setupNoPasswordText() {
        noPassword = UITextView(frame: .init(x: 0, y: 0, width: 400, height: 50))
        noPassword.backgroundColor = .none
        noPassword.font = .systemFont(ofSize: 26)
        noPassword.text = "You didn't copy the password!"
        noPassword.textAlignment = .center
        noPassword.isHidden = true
        view.addSubview(noPassword)
    }

    func setupNextKeyboardButton() {
        nextKeyboardButton = UIButton(type: .system)
        nextKeyboardButton.setTitle(
            NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: []
        )
        nextKeyboardButton.sizeToFit()
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        view.addSubview(nextKeyboardButton)
        nextKeyboardButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        nextKeyboardButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    override func viewWillLayoutSubviews() {
        nextKeyboardButton.isHidden = !needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }

    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.

        var textColor: UIColor
        let proxy = textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    
    func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

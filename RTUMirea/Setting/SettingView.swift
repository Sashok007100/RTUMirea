//
//  SettingView.swift
//  RTUMirea
//
//  Created by Alexandr Artemov on 22/09/2019.
//  Copyright © 2019 Alexandr Artemov. All rights reserved.
//

import UIKit

class SettingView: UIViewController {
    
    @IBOutlet weak var textFieldGroup: UITextField!
    @IBOutlet weak var labelGroup: UILabel!
    
    var group: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // кнопка "Найти"
    @IBAction func buttonGroup(_ sender: UIButton) {
        labelGroup.text! += textFieldGroup.text!
        
        group = transliterate(nonLatin: textFieldGroup.text!)
    }
    
    // трансформация русских слов в английские
    func transliterate(nonLatin: String) -> String {
        return nonLatin
            .applyingTransform(.toLatin, reverse: false)?
            .applyingTransform(.stripDiacritics, reverse: false)?
            .lowercased()
            .replacingOccurrences(of: " ", with: "-") ?? nonLatin
    }
    
    
//    func setGroup() {
//        let userData: [String : Any] = ["term": 3,
//                                        "institute": 0,
//                                        "group": "ikbo-16-17"]
//    }
    
}

extension SettingView: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}

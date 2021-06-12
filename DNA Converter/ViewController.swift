//
//  ViewController.swift
//  DNA Converter
//
//  Created by Pranav Ramesh on 10/10/19.
//  Copyright © 2019 Pranav Ramesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var howToUseView: UIVisualEffectView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dnaTextField: UITextField!
    @IBOutlet weak var dnaKeyboard: UIView!
    @IBOutlet weak var dnaKeyboardConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
    @IBOutlet var dnaButtons: [UIButton]!
    @IBOutlet var backViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in backViews {
            i.layer.masksToBounds = true
            i.layer.cornerRadius = 10
        }
        
        for i in dnaButtons {
            i.layer.masksToBounds = true
            i.layer.cornerRadius = 10
        }
        
        dnaKeyboard.layer.masksToBounds = true
        dnaKeyboard.layer.cornerRadius = 15
        dnaTextField.inputView = UIView()
        dnaKeyboardConstraint.constant = -80
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditingNow)))
        Complementary_DNA_Label.text = ""
        MRNA_Label.text = ""
        TRNA_Label.text = ""
        Amino_Acids_Label.text = ""
        
        blackView = {
            let screen = UIView(frame: self.view.frame)
            blackView.backgroundColor = .black
            blackView.alpha = 0
//            blackView.isHidden = true
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(toggleHelp))
            swipe.direction = .down
            screen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleHelp)))
            screen.addGestureRecognizer(swipe)
            return screen
        }()
        
//        self.view.insertSubview(blackView, belowSubview: howToUseView)
        for subview in self.view.subviews {
            print(subview)
        }
        
        print(blackView.frame.height, blackView.frame.width, blackView.frame.origin)
        
        howToUseConstraint.constant = view.frame.height
        howToUseView.layer.masksToBounds = true
        howToUseView.layer.cornerRadius = 8
        howToUseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleHelp)))
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(toggleHelp))
        swipe.direction = .down
        howToUseView.addGestureRecognizer(swipe)
    }
    
    
    
    @IBAction func A_Clicked(_ sender: UIButton) {
        if let text = dnaTextField.text {
            dnaTextField.text = text + "A"
        } else {
            dnaTextField.text = "A"
        }
        parseDNA(sender: dnaTextField)
    }
    @IBAction func T_Clicked(_ sender: Any) {
        if let text = dnaTextField.text {
            dnaTextField.text = text + "T"
        } else {
            dnaTextField.text = "T"
        }
        parseDNA(sender: dnaTextField)
    }
    @IBAction func C_Clicked(_ sender: Any) {
        if let text = dnaTextField.text {
            dnaTextField.text = text + "C"
        } else {
            dnaTextField.text = "C"
        }
        parseDNA(sender: dnaTextField)
    }
    @IBAction func G_Clicked(_ sender: Any) {
        if let text = dnaTextField.text {
            dnaTextField.text = text + "G"
        } else {
            dnaTextField.text = "G"
        }
        parseDNA(sender: dnaTextField)
    }
    @IBAction func back_Clicked(_ sender: Any) {
        if var text = dnaTextField.text {
            if text.count > 0 {
                text.removeLast()
                dnaTextField.text = text
            }
        }
        parseDNA(sender: dnaTextField)
    }
    
    @objc func endEditingNow() {
        dnaKeyboardConstraint.constant = -80
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        self.view.endEditing(true)
        parseDNA(sender: dnaTextField)
    }

    @IBAction func dnaFieldClicked(_ sender: UITextField) {
        print("Field clicked")
        dnaKeyboardConstraint.constant = 16
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.dnaKeyboard.layoutIfNeeded()
        }, completion: nil)
        parseDNA(sender: dnaTextField)
    }
    
    func parseDNA(sender: UITextField) {
        if let text = sender.text {
            if text.count > 0 {
                let end = Array(text)
                print(text)
                if !["A", "C", "T", "G"].contains(end[end.count-1].uppercased()) {
                    sender.deleteBackward()
                } else {
                    print(sender)
                    Complementary_DNA_Label.text = getComplementaryStrand(DNA: text)
                    MRNA_Label.text = getMRNA(DNA: text)
                    TRNA_Label.text = getTRNA(MRNA: getMRNA(DNA: text))
                    
                    let chain = getAminoAcidChain(MRNA: getMRNA(DNA: text))
                    var strand = ""
                    for acid in chain {
                        strand += "\(acid), "
                    }
                    strand.removeLast(2)
                    Amino_Acids_Label.text = strand
                }
            } else {
                Complementary_DNA_Label.text = ""
                MRNA_Label.text = ""
                TRNA_Label.text = ""
                Amino_Acids_Label.text = ""
            }
            
        }
    }
    
    
    var blackView = UIView()
    var didAskHelpBefore = false
    @IBOutlet weak var howToUseConstraint: NSLayoutConstraint!
    
    @IBAction func helpRequested(_ sender: UIBarButtonItem) {
        toggleHelp()
    }
    
    @objc func showBlackView() {
        UIView.animate(withDuration: 0.7) {
            self.blackView.alpha = 0.5
        }
    }
    @objc func hideBlackView() {
        UIView.animate(withDuration: 0.7) {
            self.blackView.alpha = 0
        }
    }
    
    @objc func toggleHelp() {
        if didAskHelpBefore {
            didAskHelpBefore = false
            self.howToUseConstraint.constant = self.view.frame.height
        } else {
            didAskHelpBefore = true
            showBlackView()
            self.howToUseConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    var codon_chart: [String:[String:[String: String]]] = [
        "A": [
            "A": [
                "A":"Lysine",
                "U":"Asparagine",
                "G":"Lysine",
                "C":"Asparagine"
            ],
            "U": [
                "A":"Isoleucine",
                "U":"Isoleucine",
                "G":"Methionine",
                "C":"Isoleucine"
            ],
            "G": [
                "A":"Arginine",
                "U":"Serine",
                "G":"Arginine",
                "C":"Serine"
            ],
            "C": [
                "A":"Threonine",
                "U":"Threonine",
                "G":"Threonine",
                "C":"Threonine"
            ]
        ],
        "U": [
            "A": [
                "A":"Stop",
                "U":"Tyrosine",
                "G":"Stop",
                "C":"Tyrosine"
            ],
            "U": [
                "A":"Leucine",
                "U":"Phenylalanine",
                "G":"Leucine",
                "C":"Phenylalanine"
            ],
            "G": [
                "A":"Stop",
                "U":"Cysteine",
                "G":"Tryptophan",
                "C":"Cysteine"
            ],
            "C": [
                "A":"Serine",
                "U":"Serine",
                "G":"Serine",
                "C":"Serine"
            ]
        ],
        "G": [
            "A": [
                "A":"Glutamic Acid",
                "U":"Aspartic Acid",
                "G":"Glutamic Acid",
                "C":"Aspartic Acid"
            ],
            "U": [
                "A":"Valine",
                "U":"Valine",
                "G":"Valine",
                "C":"Valine"
            ],
            "G": [
                "A":"Glycine",
                "U":"Glycine",
                "G":"Glycine",
                "C":"Glycine"
            ],
            "C": [
                "A":"Alanine",
                "U":"Alanine",
                "G":"Alanine",
                "C":"Alanine"
            ]
        ],
        "C": [
            "A": [
                "A":"Glutamine",
                "U":"Histidine",
                "G":"Glutamine",
                "C":"Histidine"
            ],
            "U": [
                "A":"Leucine",
                "U":"Leucine",
                "G":"Leucine",
                "C":"Leucine"
            ],
            "G": [
                "A":"Arginine",
                "U":"Arginine",
                "G":"Arginine",
                "C":"Arginine"
            ],
            "C": [
                "A":"Proline",
                "U":"Proline",
                "G":"Proline",
                "C":"Proline"
            ]
        ]
    ]
    
    @IBOutlet weak var Complementary_DNA_Label: UILabel!
    @IBOutlet weak var MRNA_Label: UILabel!
    @IBOutlet weak var TRNA_Label: UILabel!
    @IBOutlet weak var Amino_Acids_Label: UILabel!
    @IBAction func DNA_Coding_Text(_ sender: UITextField) {
        if let text = sender.text {
            if text.count > 0 {
                let end = Array(text)
                print(text)
                if !["A", "C", "T", "G"].contains(end[end.count-1].uppercased()) {
                    sender.deleteBackward()
                } else {
                    print(sender)
                    Complementary_DNA_Label.text = getComplementaryStrand(DNA: text)
                    MRNA_Label.text = getMRNA(DNA: text)
                    TRNA_Label.text = getTRNA(MRNA: getMRNA(DNA: text))
                    
                    let chain = getAminoAcidChain(MRNA: getMRNA(DNA: text))
                    var strand = ""
                    for acid in chain {
                        strand += "\(acid), "
                    }
                    strand.removeLast(2)
                    Amino_Acids_Label.text = strand
                }
            } else {
                Complementary_DNA_Label.text = ""
                MRNA_Label.text = ""
                TRNA_Label.text = ""
                Amino_Acids_Label.text = ""
            }
            
        }
    }
    
    func getComplementaryStrand(DNA: String) -> String {
        var comp = ""
        let strand = Array(DNA)
        for i in 0..<strand.count {
            switch strand[i].uppercased() {
            case "A": comp += "T"
            case "T": comp += "A"
            case "G": comp += "C"
            case "C": comp += "G"
            default: break
            }
        }
        return comp
    }
    
    func getMRNA(DNA: String) -> String {
        var comp = ""
        let strand = Array(DNA)
        for i in 0..<strand.count {
            switch strand[i].uppercased() {
            case "A": comp += "U"
            case "T": comp += "A"
            case "G": comp += "C"
            case "C": comp += "G"
            default: break
            }
        }
        return comp
    }
    
    func getTRNA(MRNA: String) -> String {
        var comp = ""
        let strand = Array(MRNA)
        for i in 0..<strand.count {
            switch strand[i].uppercased() {
            case "A": comp += "U"
            case "U": comp += "A"
            case "G": comp += "C"
            case "C": comp += "G"
            default: break
            }
        }
        return comp
    }
    
    func getAminoAcidChain(MRNA: String) -> [String] {
        if MRNA.count % 3 == 0 {
            var aminoAcids: [[String]] = []
            let strand = Array(MRNA)
            var finalAcids: [String] = []
            
            var idx = 0
            while idx < strand.count {
                aminoAcids.append(["\(strand[idx])", "\(strand[idx+1])", "\(strand[idx+2])"])
                idx += 3
            }
            
            for acid in aminoAcids {
                finalAcids.append(codon_chart[acid[0]]![acid[1]]![acid[2]]!)
            }
            
            return finalAcids
            
        } else {
            return [""]
        }
    }
    
}


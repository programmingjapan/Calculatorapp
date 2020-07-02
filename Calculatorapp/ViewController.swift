//
//  ViewController.swift
//  Calculatorapp
//
//  Created by 新井有紀 on 2020/04/17.
//  Copyright © 2020 YUKI ARAI. All rights reserved.
//

import UIKit

extension UIView {
    
    // 枠線の色
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    // 枠線のWidth
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    // 角丸設定
    @IBInspectable var cornerRadius: CGFloat {        
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

class ViewController: UIViewController {
    
    // 数字入力中かどうかを示す
    // trueの間、数字押下で順次桁を繰り上げる
    var usrInputting : Bool = false
    
    
    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
    }
        
    
    // 数字ボタンを押した時に呼ばれる
    @IBAction func inputNumber(_ sender: UIButton) {
        var displayNum : String = "0"
        
        if !usrInputting {
            usrInputting = true
            displayNum = (sender.titleLabel?.text)!
        } else {
            displayNum = displayLabel.text!
            // 入力された文字を末尾に結合することで繰り上げを行う
            displayNum += (sender.titleLabel?.text)!
            
        }
        
        displayLabel.text = displayNum
        
    }

    

    
   
    
    
    // 被演算子
    var selectedOperand : String = ""
    
  // 四則演算ボタンを押したときに呼ばれる
    @IBAction func operate(_ sender: UIButton) {
        // 数字入力中の場合は計算を行うため　＝　ボタンを押した時のメソッドを呼び出す
        if usrInputting {
            enter()
        }
        // どの四則演算のボタンを押したか覚えておく（UILabelのテキストを使う）
        selectedOperand = (sender.titleLabel?.text)!
    }
    
    var resultValue : Double {
        get {
        // displayLabel(UILabel)からテキストを取得してdouble型に変換してから返す
            return NumberFormatter().number(from: displayLabel.text!)!.doubleValue
        }
        set {
            // displayLabel(UILabel)のテキストを計算結果の値で更新する
            if (abs(newValue.truncatingRemainder(dividingBy: 1.0)).isLess(than: .ulpOfOne)) {
                //小数点なし
                displayLabel.text = "\(Int(newValue))"
            } else {
                // 小数点あり
            displayLabel.text = "\(newValue)"
            }
            // 数字入力中を解除する
            usrInputting = false
        }
    }
       
    // 演算対象の数字
    var targetNum : Double? = nil
    
    // ＝ボタンを押したときに呼ばれる

    @IBAction func enter() {
        
        usrInputting = false
        
        if targetNum != nil && selectedOperand != "" {
            let resultNum : Double = resultValue
            
            switch selectedOperand {
            case "×":
                resultValue = targetNum! * resultNum
            case "÷":
                if resultNum == 0 {
                 // 0除算を回避する
                    return
                }
                resultValue = targetNum! / resultNum
            case "+":
                resultValue = targetNum! + resultNum
            case "−":
                resultValue = targetNum! - resultNum
            default:
                break
            }
            
        }
        selectedOperand = ""
        targetNum = resultValue
    }
    
    
    // ACボタンを押したときに呼ばれる
    @IBAction func clearAll(_ sender: UIButton) {
        targetNum = nil
        selectedOperand = ""
        resultValue = 0
        
    }
    
    @IBAction func percentAction(_ sender: Any) {
        resultValue = resultValue / 100
    }
    
    @IBAction func taxOutAction(_ sender: Any) {
        // 税抜計算(10%)
        resultValue = resultValue / 1.1
        
        // 小数点以下を四捨五入
        let roundValue = round(resultValue)
       print(roundValue)
        
       // displayLabel.text = "\(roundValue)"
        
        if (abs(roundValue.truncatingRemainder(dividingBy: 1.0)).isLess(than: .ulpOfOne)) {
                      //小数点なし
                      displayLabel.text = "\(Int(roundValue))"
                  } else {
                      // 小数点あり
                  displayLabel.text = "\(roundValue)"
                  }
     
     
    }
    
    @IBAction func taxInAction(_ sender: Any) {
        // 税込計算(10%)
        resultValue = resultValue * 1.1
        
        // 小数点以下を四捨五入
              let roundValue = round(resultValue)
             print(roundValue)
              
             // displayLabel.text = "\(roundValue)"
        
        if (abs(roundValue.truncatingRemainder(dividingBy: 1.0)).isLess(than: .ulpOfOne)) {
                            //小数点なし
                            displayLabel.text = "\(Int(roundValue))"
                        } else {
                            // 小数点あり
                        displayLabel.text = "\(roundValue)"
                        }
        
    }
    
    
}


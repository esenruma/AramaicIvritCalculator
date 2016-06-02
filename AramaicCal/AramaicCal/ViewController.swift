//
//  ViewController.swift
//  AramaicCal
//
//  Created by Roma on 21/05/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var aramaicLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    
    var englishLabelSwitch = false // for EngLabelButton below
    
// Basic Calc. Vars
    var isTypingNumber = false
    var firstNumber = 0
    var secondNumber = 0
    var mathOperation = ""
    
    var NumberArray = [Int]() // ScratchPad for numbers to be converted to Hebrew // Clear@ "+" & "=" funcs
    
// Dictionaries for Hebrew Chars for NumbersTapped
    let singleDigits = ["1": "\u{05D0}", "2": "\u{05D1}", "3": "\u{05D2}", "4": "\u{05D3}", "5": "\u{05D4}", "6": "\u{05D5}", "7": "\u{05D6}", "8": "\u{05D7}", "9": "\u{05D8}"]
    
    let tens = ["1": "\u{05D9}", "2": "\u{05DB}", "3": "\u{05DC}", "4": "\u{05DE}", "5": "\u{05E0}", "6": "\u{05E1}", "7": "\u{05E2}", "8": "\u{05E4}", "9": "\u{05E6}"]
    
    let hundreds = ["1": "\u{05E7}", "2": "\u{05E8}", "3": "\u{05E9}", "4": "\u{05EA}", "5": "\u{05EA}\u{05E7}", "6": "\u{05EA}\u{05E8}", "7": "\u{05E2}\u{05E9}", "8": "\u{05EA}\u{05EA}", "9": "\u{05EA}\u{05EA}\u{05E7}"]
    
    let thousands = ["1": "\u{05D0}\u{05F3}", "2": "\u{05D1}\u{05F3}", "3": "\u{05D2}\u{05F3}", "4": "\u{05D3}\u{05F3}", "5": "\u{05D4}\u{05F3}", "6": "\u{05D5}\u{05F3}", "7": "\u{05D6}\u{05F3}", "8": "\u{05D7}\u{05F3}", "9": "\u{05D8}\u{05F3}"]
    
    let tensThousands = ["1": "\u{05D9}\u{05F3}", "2": "\u{05DB}\u{05F3}", "3": "\u{05DC}\u{05F3}", "4": "\u{05DE}\u{05F3}", "5": "\u{05E0}\u{05F3}", "6": "\u{05E1}\u{05F3}", "7": "\u{05E2}\u{05F3}", "8": "\u{05E4}\u{05F3}", "9": "\u{05E6}\u{05F3}"]
    
    let hundredsThousands = ["1": "\u{05E7}\u{05F3}", "2": "\u{05E8}\u{05F3}", "3": "\u{05E9}\u{05F3}", "4": "\u{05EA}\u{05F3}", "5": "\u{05EA}\u{05E7}\u{05F3}", "6": "\u{05EA}\u{05E8}\u{05F3}", "7": "\u{05EA}\u{05E9}\u{05F3}", "8": "\u{05EA}\u{05EA}\u{05F3}", "9": "\u{05EA}\u{05EA}\u{05E7}\u{05F3}"]
    
   
// vars for High-low: RULE -- Clear with (+/-, Clear, =)
    let level4numbers = ["1000", "2000", "3000", "4000", "5000", "6000", "7000", "8000", "9000"]
    let level3numbers = ["100", "200", "300", "400", "500", "600", "700", "800", "900"]
    let level2numbers = ["10", "20", "30", "40", "50", "60", "70", "80", "90"]
    let level1numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    var recordOfPrevNumberTapped = ""
    var previousGroupTapped = ""    // x4 Groupings= 1-9, 10-90, 100-900, 000s
    
    
// Vars for Number Exception Rules - refered to in Func equalsButton + numberExceptionRuleAlert()
    let exception15 = 15        // "name of God"
    let exception16 = 16        // "name of God"
    let exception18 = 18        // "Alive"
    let exception298 = 298      // "murder"
    let exception744 = 744      // "you will be destroyed"
 
// ---------------------------------------
    // Hide-Unhide English Label - using 'englishLabelSwitch' bool
    @IBAction func engLabelView(sender: UIButton) {
        
        if self.englishLabelSwitch == false {
            self.englishLabel.hidden = false
            self.englishLabelSwitch = true
            
        } else if self.englishLabelSwitch == true {
            self.englishLabel.hidden = true
            self.englishLabelSwitch = false
        }
    }

// ---------------------------------------
    // Alert: "Please enter a number" when +/- operator pressed with no numbers before
    func mathOperatorAlert() {
        

        if self.mathOperation != "" {
            
            let alert = UIAlertController(title: "Alert", message: "Math Operator Already selected as...(\(self.mathOperation))", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "ok!", style: UIAlertActionStyle.Cancel) { UIAlertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else if self.NumberArray.isEmpty {
        
            let alert = UIAlertController(title: "Alert", message: "Need a number first", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "ok!", style: UIAlertActionStyle.Cancel) { UIAlertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
                }
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }  // End IF
        
    }  // End FUNC
    
// ---------------------------------------
    // Alert Same-Number-Group RULE
    func sameNoGroupAlert() {
        let alert = UIAlertController(title: "Alert", message: "Cannot select same Number Group", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Start again!", style: UIAlertActionStyle.Cancel) { UIAlertAction in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            self.isTypingNumber = false
            self.firstNumber = 0
            self.secondNumber = 0
            self.mathOperation = ""
            self.englishLabel.text = "0"
            self.aramaicLabel.text = ""
            self.NumberArray.removeAll()
            self.recordOfPrevNumberTapped = ""
            self.previousGroupTapped = ""
            print("Cleared!")
        }
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
// ---------------------------------------
    // Alert Breaking 'HIGH-Low' RULE
    func highLowAlert() {
        let alert = UIAlertController(title: "Alert", message: "Numbers go from High-to-low groups", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Start again!", style: UIAlertActionStyle.Cancel) { UIAlertAction in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            self.isTypingNumber = false
            self.firstNumber = 0
            self.secondNumber = 0
            self.mathOperation = ""
            self.englishLabel.text = "0"
            self.aramaicLabel.text = ""
            self.NumberArray.removeAll()
            self.recordOfPrevNumberTapped = ""
            self.previousGroupTapped = ""
            print("Cleared!")
        }
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

// ---------------------------------------
    // Alert 1m Barrier
    func oneMillionAlert() {
        let alert = UIAlertController(title: "Alert", message: "1m parameter is passed. Press Clear", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { UIAlertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
// ---------------------------------------
    @IBAction func numberTapped(sender: UIButton) {
        
        let englishLabelNumber = sender.currentTitle
        var hebrewCharacter = ""                            // created here for Switch Statement below
        
        // ** High-low RULE: if prev.no.Tapped= in lower group... Alert
        if recordOfPrevNumberTapped != "" {     // i.e. If Number Already tapped previously
            
            // CHECK WHICH GROUP Previous belongs to...
            if self.level1numbers.contains(self.recordOfPrevNumberTapped) {
                self.previousGroupTapped = "L1"
            } else if self.level2numbers.contains(self.recordOfPrevNumberTapped) {
                self.previousGroupTapped = "L2"
            } else if self.level3numbers.contains(self.recordOfPrevNumberTapped) {
                self.previousGroupTapped = "L3"
            }
            
            // ** Keep 000s out of this Rule **
            // else if self.level4numbers.contains(self.recordOfPrevNumberTapped) {
            //     self.previousGroupTapped = "L4"
            // }
            
            
            // New Tapped is which group?
            let newTapped = englishLabelNumber
            var newGroup = ""
            
            // CHECK WHICH ** NEW ** GROUP
            if self.level1numbers.contains(newTapped!) {
                newGroup = "L1"
            } else if self.level2numbers.contains(newTapped!) {
                newGroup = "L2"
            } else if self.level3numbers.contains(newTapped!) {
                newGroup = "L3"
            }
            
            // ** Keep 000s out of this Rule **
            // else if self.level4numbers.contains(newTapped!) {
            //    newGroup = "L4"
            // }
            
            
            // === Compare with 'HIGH-low' RULE + Alert ===
            if recordOfPrevNumberTapped == "1000" {
                
                // Do nothing. Allows use of 1000 Digit without breaking rule
                
            } else if newGroup > self.previousGroupTapped {
                
                print("Call High-Low rule Broken...Alert")
                highLowAlert()
            } // End High-Low IF
            
            // === Compare with 'Same-No.Group' RULE + Alert ===
            if recordOfPrevNumberTapped == "1000" {
                
                // do nothing = allows use of 1000 Digit without breaking rule
                
            } else if newGroup == self.previousGroupTapped {
                print("Call Same-No.Group rule Broken...Alert")
                sameNoGroupAlert()
            } // End Same Group IF
            
        } // End Prev.No.Tapped IF
        
        
        // ** English Label Calc **
        if self.isTypingNumber == true {
            
            let addedNumber = Int(englishLabelNumber!) // convert Text to No.
            
            // ** RULE: 1k x prev.Number - If Other No. Already there
            if addedNumber == 1000 {
                
                // Sum the Array + Multiply it by 1000 to get 'upDate1kNumber'
                // This allows use of '1000'key to work e.g. 12,000  ((10 + 2)*1000)
                // Add all No.s in NoArray
                let sum = NumberArray.reduce(0,combine: +)
                print(sum)
                
                // let lastElement = self.NumberArray.last
                let upDate1kNumber = addedNumber! * sum
                print(upDate1kNumber)
                
                // self.NumberArray.removeLast()        // Remove last number before add the 000 no.
                self.NumberArray.removeAll()            // Remove all before add the 000 no. summed up
                self.NumberArray.append(upDate1kNumber) // Adding No.To Array- Storage!
                
                print(NumberArray) // prove nothing in there now Except new Number in '000s'
                
                self.englishLabel.text = self.englishLabel.text! + " " + String(upDate1kNumber)
                
                
            } else {
                self.NumberArray.append(addedNumber!)   // Adding No.To Array- Storage!
                print(self.NumberArray)
                
                self.englishLabel.text = self.englishLabel.text! + " " + englishLabelNumber!
            }
            // ** End 1k Allow Rule
            
            
        } else {
            
            let newNumber = Int(englishLabelNumber!)    // convert Text to No. for Adding to Array
            self.NumberArray.append(newNumber!)         // Adding No.To Array- Storage!
            print(self.NumberArray)                     // Check whats in Array
            
            self.englishLabel.text = String(newNumber!)
            
            self.isTypingNumber = true                  // Change state from FALSE to ... TRUE
            
        } // End IF - English Label
        
        
        if self.isTypingNumber == true {
            // ** Hebrew Label ** // FIND BETTER WAY? Classes - more elegant way?
            // *** TRY REPLACE with Dictionary?? ***
            
            if let numberToConvertToHerbrew = sender.currentTitle {
                
                switch numberToConvertToHerbrew {
                case "1":
                    hebrewCharacter = "א"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "2":
                    hebrewCharacter = "ב"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "3":
                    hebrewCharacter = "ג"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "4":
                    hebrewCharacter = "ד"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "5":
                    hebrewCharacter = "ה"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "6":
                    hebrewCharacter = "ו"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "7":
                    hebrewCharacter = "ז"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "8":
                    hebrewCharacter = "ח"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "9":
                    hebrewCharacter = "ט"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                // ----------------------
                case "10":
                    hebrewCharacter = "י"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "20":
                    hebrewCharacter = "כ"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "30":
                    hebrewCharacter = "ל"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "40":
                    hebrewCharacter = "מ"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "50":
                    hebrewCharacter = "נ"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "60":
                    hebrewCharacter = "ס"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "70":
                    hebrewCharacter = "ע"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "80":
                    hebrewCharacter = "פ"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "90":
                    hebrewCharacter = "צ"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                // ----------------------
                case "100":
                    hebrewCharacter = "ק"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "200":
                    hebrewCharacter = "ר"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "300":
                    hebrewCharacter = "ש"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "400":
                    hebrewCharacter = "ת"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "500":
                    hebrewCharacter = "תק"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "600":
                    hebrewCharacter = "תר"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "700":
                    hebrewCharacter = "תש"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "800":
                    hebrewCharacter = "תת"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                case "900":
                    hebrewCharacter = "תתק"
                    self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                    
                case "1000":
                    if self.aramaicLabel.text == "" {
                        hebrewCharacter = "\u{05D0}\u{05F3}"
                        self.aramaicLabel.text = hebrewCharacter
                        
                    } else {
                        hebrewCharacter = "\u{05F3}"
                        self.aramaicLabel.text = self.aramaicLabel.text! + hebrewCharacter
                        
                    }
                default:
                    print("xx")
                } // End Switch
                
            }  // End IF let
            
        }  // End IF around HebChar (If-Let)
        
        
        // ** Record 1st Number Tapped **
        self.recordOfPrevNumberTapped = englishLabelNumber!
        
    } // End 'numberTapped' FUNC


// ---------------------------------------
    @IBAction func mathOperation(sender: UIButton) {
        
        // To avoid crash when: 'Operator' pressed without any prev.numbers - use 'IF'
        if self.NumberArray.isEmpty || self.mathOperation != "" {
        
                // Alert: For number & or error mathOperation = already selected
                mathOperatorAlert()
            
        } else {
            
            // Avoid Crash when: Operator pressed TWICE+
            if self.mathOperation == "" {
            
                // ** For + / - operators **
                self.isTypingNumber = false         // Stop Adding no's on side of NumberTapped Func = new number
        
                // Clears HIGH-Low RULE - start afresh
                self.recordOfPrevNumberTapped = ""
                self.previousGroupTapped = ""
        
                // Add all No.s in NumberArray + Put into "firstNumber"
                let sum = self.NumberArray.reduce(0,combine: +)
                print(sum)
        
                self.firstNumber = sum              //  Stored Sum of numberArray - thus make it empty again
                self.NumberArray.removeAll()
                print(NumberArray)
        
                self.mathOperation = sender.currentTitle!
        
                // ==== MathOper. Not clear previous number for 2nd Number Input - thus...
                // ==== TO SOLVE ===
                self.aramaicLabel.text = ""
                
//            }
//            else {
//            
//                // Alert: "Arithmatic Operator already selected"
//                mathOperatorRepeatedAlert()
            
            }  // End IF - Operator pressed TWICE+
            
        }   // End IF.NumberArray.isEmpty
        
    } // End mathOperation FUNC
    
// ---------------------------------------
    @IBAction func equalsButton(sender: UIButton) {
        
        self.isTypingNumber = false
        
        // Clears HIGH-Low RULE - start afresh
        self.recordOfPrevNumberTapped = ""
        self.previousGroupTapped = ""
        
        // For English Calc
        var result = 0
        
        // Add all No.s in NoArray + Put into "secondNumber"
        let sum = NumberArray.reduce(0,combine: +)
        print(sum)
        
        self.secondNumber = sum             // Stored Sum of firstNoArray - thus make 1stArray empty again
        self.NumberArray.removeAll()
        print(NumberArray)                  // Proves Array = Cleared
        
        if self.mathOperation == "+" {
            result = self.firstNumber + self.secondNumber
            print(mathOperation)
            
        } else {
            result = self.firstNumber - self.secondNumber
            print(mathOperation)
        }
        
        
        // Eng.label Number Format with 000 separator *******************
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        self.englishLabel.text = numberFormatter.stringFromNumber(result)
        // ***************************************************************
        
        
        
        // ** Limit OutPut to 999,999 for showing in Hebrew Chars **
        if result > 999999 {       // 1m
            print("English Calc. Done. But Not Hebrew Number Converstion. Max output = 999,999")
            oneMillionAlert()
        }
        
        // ==================================================
        // *** Convert 'result' no. into Hebrew from the English -6- Levels/digits ***
        
        // 1. Convert no. 2 - String
        let textResult = String(result)                 // For String Char.Count - used for Switch cases (below)
        let NStextResult = NSString(string: textResult) // For String Manipulation inside Switch
        
        // 2. Count number of digits
        let numberLevel = textResult.characters.count
        
        // 3. Switch re: no. of Digits in 'results' number
        switch numberLevel {
        case 6:
            print("100,000's + 10,000's + 1000's + 100s + 10s + 0s")
            
            let firstDigit = NStextResult.substringWithRange(NSRange(location: 0, length: 1))
            let hundredsThousandsHebrewNumber = self.hundredsThousands["\(firstDigit)"]
            print(hundredsThousandsHebrewNumber!)
            self.aramaicLabel.text! = hundredsThousandsHebrewNumber!
            
            let secondDigit = NStextResult.substringWithRange(NSRange(location: 1, length: 1))
            if secondDigit != "0" {
                let tensThousandsHebrewNumber = self.tensThousands["\(secondDigit)"]
                print(tensThousandsHebrewNumber!)
                self.aramaicLabel.text! = self.aramaicLabel.text! + tensThousandsHebrewNumber!
            }
            
            let thirdDigit = NStextResult.substringWithRange(NSRange(location: 2, length: 1))
            if thirdDigit != "0" { // stop crach if "0" e.g. "20"
                let thousandsHebrewNumber = self.thousands["\(thirdDigit)"]
                print(thousandsHebrewNumber!)
                self.aramaicLabel.text! = self.aramaicLabel.text! + thousandsHebrewNumber!
            }
            
            let fourthDigit = NStextResult.substringWithRange(NSRange(location: 3, length: 1))
            if fourthDigit != "0" { // stop crach if "0" e.g. "20"
                let hundredsHebrewNumber = self.hundreds["\(fourthDigit)"]
                print(hundredsHebrewNumber!)
                self.aramaicLabel.text! = self.aramaicLabel.text! + hundredsHebrewNumber!
            }
            
            let fifthDigit = NStextResult.substringWithRange(NSRange(location: 4, length: 1))
            if fifthDigit != "0" { // stop crach if "0" e.g. "20"
                let tensHebrewNumber = self.tens["\(fifthDigit)"]
                print(tensHebrewNumber!)
                self.aramaicLabel.text! = self.aramaicLabel.text! + tensHebrewNumber!
            }
            
            let sixthDigit = NStextResult.substringWithRange(NSRange(location: 5, length: 1))
            if sixthDigit != "0" { // stop crach if "0" e.g. "20"
                let singleHebrewNumber = self.singleDigits["\(sixthDigit)"]
                print(singleHebrewNumber!)
                self.aramaicLabel.text! = self.aramaicLabel.text! + singleHebrewNumber!
            }
            
        case 5:
            print("10000's + 1000's + 100's + 10s + 0s")
            
            let firstDigit = NStextResult.substringWithRange(NSRange(location: 0, length: 1))
            let tensThousandsHebrewNumber = self.tensThousands["\(firstDigit)"]
            print(tensThousandsHebrewNumber!)
            self.aramaicLabel.text! = tensThousandsHebrewNumber!
            
            let secondDigit = NStextResult.substringWithRange(NSRange(location: 1, length: 1))
            if secondDigit != "0" {
                let thousandsHebrewNumber = self.thousands["\(secondDigit)"]
                print(thousandsHebrewNumber!)
                self.aramaicLabel.text! = self.aramaicLabel.text! + thousandsHebrewNumber!
            }
            
            let thirdDigit = NStextResult.substringWithRange(NSRange(location: 2, length: 1))
            if thirdDigit != "0" { // stop crach if "0" e.g. "20"
                let hundredsHebrewNumber = self.hundreds["\(thirdDigit)"]
                print(hundredsHebrewNumber!)
                self.aramaicLabel.text! = self.aramaicLabel.text! + hundredsHebrewNumber!
            }
            
            let fourthDigit = NStextResult.substringWithRange(NSRange(location: 3, length: 1))
            if fourthDigit != "0" { // stop crach if "0" e.g. "20"
                let tensHebrewNumber = self.tens["\(fourthDigit)"]
                print(tensHebrewNumber!)
                self.aramaicLabel.text! = self.aramaicLabel.text! + tensHebrewNumber!
            }
            
            let fifthDigit = NStextResult.substringWithRange(NSRange(location: 4, length: 1))
            if fifthDigit != "0" { // stop crach if "0" e.g. "20"
                let singleHebrewNumber = self.singleDigits["\(fifthDigit)"]
                print(singleHebrewNumber!)
                self.aramaicLabel.text! = self.aramaicLabel.text! + singleHebrewNumber!
            }
            
        case 4:
            print("1000's + 100's + 10's and 1s")
            
            let firstDigit = NStextResult.substringWithRange(NSRange(location: 0, length: 1))
            let thousandsHebrewNumber = self.thousands["\(firstDigit)"]
            print(thousandsHebrewNumber!)
            self.aramaicLabel.text! = thousandsHebrewNumber!
            
            let secondDigit = NStextResult.substringWithRange(NSRange(location: 1, length: 1))
            if secondDigit != "0" {
                let hundredsHebrewNumber = self.hundreds["\(secondDigit)"]
                print(hundredsHebrewNumber!)
                self.aramaicLabel.text! = self.aramaicLabel.text! + hundredsHebrewNumber!
            }
            
            let thirdDigit = NStextResult.substringWithRange(NSRange(location: 2, length: 1))
            if thirdDigit != "0" { // stop crach if "0" e.g. "20"
                let tensHebrewNumber = self.tens["\(thirdDigit)"]
                print(tensHebrewNumber!)
                self.aramaicLabel.text! = self.aramaicLabel.text! + tensHebrewNumber!
            }
            
            let fourthDigit = NStextResult.substringWithRange(NSRange(location: 3, length: 1))
            if fourthDigit != "0" { // stop crach if "0" e.g. "20"
                let singleHebrewNumber = self.singleDigits["\(fourthDigit)"]
                print(singleHebrewNumber!)
                self.aramaicLabel.text! = self.aramaicLabel.text! + singleHebrewNumber!
            }
            
        case 3:
            print("100's + 10's and 1's")
            
            let firstDigit = NStextResult.substringWithRange(NSRange(location: 0, length: 1))
            let hundredsHebrewNumber = self.hundreds["\(firstDigit)"]
            print(hundredsHebrewNumber!)
            self.aramaicLabel.text! = hundredsHebrewNumber!
            
            let secondDigit = NStextResult.substringWithRange(NSRange(location: 1, length: 1))
            if secondDigit != "0" {
                let tensHebrewNumber = self.tens["\(secondDigit)"]
                print(tensHebrewNumber!)
                self.aramaicLabel.text! = self.aramaicLabel.text! + tensHebrewNumber!
            }
            
            let thirdDigit = NStextResult.substringWithRange(NSRange(location: 2, length: 1))
            if thirdDigit != "0" { // stop crach if "0" e.g. "20"
                let singleHebrewNumber = self.singleDigits["\(thirdDigit)"]
                print(singleHebrewNumber!)
                self.aramaicLabel.text! = self.aramaicLabel.text! + singleHebrewNumber!
            }
            
        case 2:
            print("10's and 1's")
            let firstDigit = NStextResult.substringWithRange(NSRange(location: 0, length: 1))
            let tensHebrewNumber = self.tens["\(firstDigit)"]
            print(tensHebrewNumber!)
            self.aramaicLabel.text! = tensHebrewNumber!
            
            let secondDigit = NStextResult.substringWithRange(NSRange(location: 1, length: 1))
            if secondDigit != "0" { // stop crach if "0" e.g. "20"
                let singleHebrewNumber = self.singleDigits["\(secondDigit)"]
                print(singleHebrewNumber!)
                self.aramaicLabel.text! = tensHebrewNumber! + singleHebrewNumber!
            }
            
        case 1:
            print("1's")
            
            let oneDigit = NStextResult.substringWithRange(NSRange(location: 0, length: 1))
            
            let singleHebrewNumber = self.singleDigits["\(oneDigit)"]
            print(singleHebrewNumber!)
            self.aramaicLabel.text! = singleHebrewNumber!
            
        default:
            print("Default")
        } // End Switch
        
        // ----------------Exception Numbers-----------------
        // 15, 16, 18, 298, 744 -----------------------------
        let exception = result
        
        switch exception {
            
        case self.exception15:
            print("result = 15 to change aramaic characters")
            
            // ---ALERT 15---
            let alert = UIAlertController(title: "Number '15' Exception Alert", message: "Changed to...", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "\u{05D8}\u{05D5}", style: UIAlertActionStyle.Cancel) { UIAlertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        case self.exception16:
            print("result = 16 change aramaic characters")
            
            // ---ALERT 16---
            let alert = UIAlertController(title: "Number '16' Exception Alert", message: "Changed to...", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "\u{05D8}\u{05D6}", style: UIAlertActionStyle.Cancel) { UIAlertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        case self.exception18:
            print("result = 18 change aramaic characters")
            
            // ---ALERT 18---
            let alert = UIAlertController(title: "Number '18' Exception Alert", message: "Changed to...", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "\u{05D7}\u{05D9}", style: UIAlertActionStyle.Cancel) {     UIAlertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        case self.exception298:
            print("result = 298 change aramaic characters")
            
            // ---ALERT 298---
            let alert = UIAlertController(title: "Number '298' Exception Alert", message: "Changed to...", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "\u{05E8}\u{05D7}\u{05E6}", style: UIAlertActionStyle.Cancel) { UIAlertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        case self.exception744:
            print("result = 744 change aramaic characters")
            
            // ---ALERT 744---
            let alert = UIAlertController(title: "Number '744' Exception Alert", message: "Changed to...", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "\u{05EA}\u{05E9}\u{05D3}\u{05DD}", style: UIAlertActionStyle.Cancel) { UIAlertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        default:
            print("Not a 'Number-Meaning' exception rule. Output number stays same")
        } // End Switch Number Exception rules
        
    }   // End Equals FUNC
    
    
// ---------------------------------------
    @IBAction func ClearButton(sender: UIButton) {
        
        self.isTypingNumber = false
        self.firstNumber = 0
        self.secondNumber = 0
        self.mathOperation = ""
        self.englishLabel.text = ""
        self.aramaicLabel.text = ""
        self.NumberArray.removeAll()
        self.recordOfPrevNumberTapped = ""
        self.previousGroupTapped = ""
        
        print("Cleared!")
        
    }
    
// ---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set English label as "hidden" 1st
        self.englishLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


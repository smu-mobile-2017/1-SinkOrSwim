//
//  KitchenSinkViewController.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/7/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

class KitchenSinkViewController: UITableViewController {

	@IBOutlet weak var sliderOutputLabel: UILabel!
	@IBOutlet weak var stepperOutputLabel: UILabel!
	
	@IBOutlet weak var switchContentView: UIView!
	@IBOutlet weak var switchOutputLabel: UILabel!
	
	@IBOutlet weak var pickerOutputLabel: UILabel!
	
	@IBOutlet weak var timerOutputLabel: UILabel!
	var timer: Timer?
	var isTimerRunning: Bool = false
	var timerStringState: Int? {
		didSet {
			updateTimerStringState(with: timerStringState)
		}
	}
	
	let pickerOptions = ["🍎Apples","🍌Bananas","🍒Cherries"]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		timerStringState = 0
		self.navigationController?.navigationBar.tintColor = .white
		pickerOutputLabel.numberOfLines = 0
		pickerOutputLabel.lineBreakMode = .byWordWrapping
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func didTouchTestButton(_ sender: Any) {
		let alert = UIAlertController(title: "Thanks for pushing me", message: "No really, thanks", preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}

	@IBAction func didChangeSliderValue(_ sender: UISlider) {
		let value = sender.value
		var condition = ""
		switch value {
		case 0..<25:
			condition = "🌧 Stormy"
		case 25..<50:
			condition = "☁️ Overcast"
		case 50..<75:
			condition = "⛅️ Partly Cloudy"
		default:
			condition = "☀️ Sunny"
		}
		sliderOutputLabel.text = "\(condition) (\(Int(ceil(value)))%)"
	}
	
	@IBAction func didChangeStepperValue(_ sender: UIStepper) {
		let value = Int(sender.value)
		stepperOutputLabel.text = "📶 Stepping to \(value)"
	}
	
	@IBAction func didChangeSwitchValue(_ sender: UISwitch) {
		let isOn = sender.isOn
		if isOn {
			switchOutputLabel.text = "Lights on"
			switchOutputLabel.textColor = .black
			switchContentView.backgroundColor = .clear
		} else {
			switchOutputLabel.text = "Lights off"
			switchOutputLabel.textColor = .white
			switchContentView.backgroundColor = .black
		}
	}
	
	func updateTimerStringState(with number: Int?) {
		DispatchQueue.main.async {
			if let number = number {
				self.timerOutputLabel.text = String(number % 10) + " " + String(repeating: "🎈", count: number % 10)
			} else {
				self.timerOutputLabel.text = ""
			}
		}
	}
	
	@IBAction func didPressTimerStartButton(_ sender: UIButton) {
		guard !isTimerRunning else { return }
		isTimerRunning = true
		timer = .scheduledTimer(withTimeInterval: 1, repeats: true) { t in
			if let tss = self.timerStringState {
				self.timerStringState = tss + 1
			} else {
				self.timerStringState = 0
			}
		}
	}
	
	@IBAction func didPressTimerResetButton(_ sender: UIButton) {
		guard isTimerRunning, let timer = timer else { return }
		timer.invalidate()
		isTimerRunning = false
		timerStringState = 0
	}
}

extension KitchenSinkViewController: UIPickerViewDelegate {
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickerOptions[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		pickerOutputLabel.text = pickerOptions[row]
	}
}

extension KitchenSinkViewController: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerOptions.count
	}
}

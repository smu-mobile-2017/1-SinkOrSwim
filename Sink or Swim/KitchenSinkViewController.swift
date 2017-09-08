//
//  KitchenSinkViewController.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/7/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

// The big but not complex VC that handles the "Kitchen Sink"
// tab, an exposition of many UIKit pieces.

class KitchenSinkViewController: UITableViewController {
	
	// Labels to show the state of the slider and stepper.
	@IBOutlet weak var sliderOutputLabel: UILabel!
	@IBOutlet weak var stepperOutputLabel: UILabel!
	
	// The view containing the switch (that turns black when
	// switched off), and the label whose text changes.
	@IBOutlet weak var switchContentView: UIView!
	@IBOutlet weak var switchOutputLabel: UILabel!
	
	// The label that reflects the current option in the picker.
	@IBOutlet weak var pickerOutputLabel: UILabel!
	
	// The label that shows a number (and baloons!) when the timer ticks.
	@IBOutlet weak var timerOutputLabel: UILabel!
	var timer: Timer?
	var isTimerRunning: Bool = false
	
	// The integer that is reflected in the timerOutputLabel
	var timerStringState: Int? {
		didSet {
			// bound to the label
			updateTimerStringState(with: timerStringState)
		}
	}
	
	let pickerOptions = ["🍎Apples","🍌Bananas","🍒Cherries"]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		timerStringState = 0
		
		// Ensures that Back buttons are white and not blue.
		DispatchQueue.main.async {
			self.navigationController?.navigationBar.tintColor = .white
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// When the UIButton demo is pressed, shows an Action pane with a 
	// cute message.
	@IBAction func didTouchTestButton(_ sender: Any) {
		let alert = UIAlertController(title: "Thanks for pushing me", message: "No really, thanks", preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		
		DispatchQueue.main.async {
			self.present(alert, animated: true, completion: nil)
		}
	}

	// When the slider is adjusted, the label shows a cute value with a percentage.
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
		DispatchQueue.main.async {
			self.sliderOutputLabel.text = "\(condition) (\(Int(ceil(value)))%)"
		}
	}
	
	// When the stepper is adjusted, the label shows the number it has been
	// adjusted to.
	@IBAction func didChangeStepperValue(_ sender: UIStepper) {
		let value = Int(sender.value)
		DispatchQueue.main.async {
			self.stepperOutputLabel.text = "📶 Stepping to \(value)"
		}
	}
	
	// When the switch is flipped off, the table cell it's in is made black,
	// and the label is made white, saying "Lights off".
	// When flipped on, it says "Lights on".
	@IBAction func didChangeSwitchValue(_ sender: UISwitch) {
		DispatchQueue.main.async {
			let isOn = sender.isOn
			if isOn {
				self.switchOutputLabel.text = "Lights on"
				self.switchOutputLabel.textColor = .black
				self.switchContentView.backgroundColor = .clear
			} else {
				self.switchOutputLabel.text = "Lights off"
				self.switchOutputLabel.textColor = .white
				self.switchContentView.backgroundColor = .black
			}
		}
	}
	
	// When timerStringState is set, it calls this method,
	// which adjusts the text of the timerOutputLabel to reflect
	// its integral value with a number of baloons (mod 10 to fit on screen).
	func updateTimerStringState(with number: Int?) {
		DispatchQueue.main.async {
			if let number = number {
				self.timerOutputLabel.text = String(number % 10) + " " + String(repeating: "🎈", count: number % 10)
			} else {
				self.timerOutputLabel.text = ""
			}
		}
	}
	
	// When the timer start button is pressed, a 1 second repeating 
	// timer is spawned, which increments the timer state by 1, or sets
	// it to zero if it's unset.
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
	
	// When the timer reset button is pressed, the timer is stopped, the
	// tracking flag (isTimerRunning) is adjusted, and the timer state is set
	// to zero.
	@IBAction func didPressTimerResetButton(_ sender: UIButton) {
		guard isTimerRunning, let timer = timer else { return }
		timer.invalidate()
		isTimerRunning = false
		timerStringState = 0
	}
}

// The necessary methods to display the pickerOptions (defined explicitly above)
// in the picker.
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

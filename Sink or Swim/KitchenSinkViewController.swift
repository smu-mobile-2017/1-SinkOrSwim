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
	
    override func viewDidLoad() {
        super.viewDidLoad()

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
	
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

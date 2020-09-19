//
//  TripPlannerVC.swift
//  Cocus
//
//  Created by Amir Daliri on 17.09.2020.
//  Copyright © 2020 Cocus. All rights reserved.
//

import UIKit
import MapKit

class TripPlannerVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var fromTextfield: UITextField!
    @IBOutlet private weak var toTextField: UITextField!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var showWayButton: UIButton!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        setupView()
    }
    
    func setupView() {
        fromTextfield.addDoneButtonOnKeyboard()
        toTextField.addDoneButtonOnKeyboard()
        mapView.cornerRadius = 8
        showWayButton.cornerRadius = 8
    }
}

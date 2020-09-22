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
    
    // MARK: - Properties
    private let viewModel = TripPlannerViewModel(networkLayer: NetworkLayer())
    private var firstAutoCompleteComponent: AutoCompleteComponent!
    private var secondAutoCompleteComponent: AutoCompleteComponent!
    private var firstSelected: String?
    private var secondSelected: String?
    private var visiblePolylines = [MKGeodesicPolyline()]
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        setupView()
        viewModel.viewDidLoad()
        mapView.delegate = self
    }
    
    func setupView() {
        fromTextfield.addDoneButtonOnKeyboard()
        toTextField.addDoneButtonOnKeyboard()
        setupAutoCompletionComponent()
        setupTextField()
        fromTextfield.setupLeftImage(imageName: "from")
        toTextField.setupLeftImage(imageName: "to")
        mapView.cornerRadius = 8
        showWayButton.cornerRadius = 8
    }
    
    func setupTextField() {
        fromTextfield.delegate = firstAutoCompleteComponent
        toTextField.delegate = secondAutoCompleteComponent
    }
    
    
    // MARK: - IBAction
    @IBAction func showWayButtonTapped(_ sender: UIButton) {
        clearPolylines()
        view.endEditing(true)
        guard let originText = fromTextfield.text,
            let destinationText = toTextField.text,
            let fromCountry = viewModel.findCountries(from: originText),
            let toCountry = viewModel.findCountries(from: destinationText) else {
                priceLabel.text = "Empty Result"
                return
        }
        
        let path = viewModel.findPath(from: fromCountry, to: toCountry)
        
        if let cost = path.1 {
            priceLabel.text = "Price: \(cost)"
        }
        
        drawPolylines(for: path.0)
    }
}

// MARK: - MKMapViewDelegate
extension TripPlannerVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKPolyline.self) {

            let polyLine = overlay
            let polyLineRenderer = MKPolylineRenderer(overlay: polyLine)
            polyLineRenderer.strokeColor = UIColor.systemPink
            polyLineRenderer.lineWidth = 2.0
            
            return polyLineRenderer
        }
        return MKPolylineRenderer()
    }
    
    func setVisibleMapArea(polyline: MKPolyline, edgeInsets: UIEdgeInsets, animated: Bool = false) {
        mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: edgeInsets, animated: animated)
    }
    
    func drawPolylines(for connections: [Connection]) {
        for connection in connections {
            let polyline = MKGeodesicPolyline(coordinates: [connection.from.coordinate.locationCoordinate2D(), connection.to.coordinate.locationCoordinate2D()], count: 2)
            
            visiblePolylines.append(polyline)
            mapView.add(polyline)
        }
        guard let firstConnection = connections.first, let lastConnection = connections.last else {
            return
        }
        let summaryPolyline = MKGeodesicPolyline(coordinates: [firstConnection.from.coordinate.locationCoordinate2D(), lastConnection.to.coordinate.locationCoordinate2D()], count: 2)
        setVisibleMapArea(polyline: summaryPolyline, edgeInsets: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0))
    }
    
    func clearPolylines() {
        for polyline in visiblePolylines {
            mapView.remove(polyline)
        }
    }
}

// MARK: - AutoCompletion
 private extension TripPlannerVC {
    
    func setupAutoCompletionComponent() {
        firstAutoCompleteComponent = prepareAutoCompletionComponent(for: fromTextfield, elementDidSelected: { [weak self] element in
            self?.selectedCountryFromAutoCpmplete(isFrom: true, value: element as? String)
            }, textDidChanged: { [weak self] in
                self?.firstSelected = nil
                if self?.secondSelected == nil {
                    self?.firstAutoCompleteComponent.datas = self?.viewModel.getAllCountryForAutocomplete()
                }
        })
        
        secondAutoCompleteComponent = prepareAutoCompletionComponent(for: toTextField, elementDidSelected: { [weak self] element in
            self?.selectedCountryFromAutoCpmplete(isFrom: false, value: element as? String)
            }, textDidChanged: { [weak self] in
                self?.secondSelected = nil
                if self?.firstSelected == nil {
                    self?.secondAutoCompleteComponent.datas = self?.viewModel.getAllCountryForAutocomplete()
                }
        })
    }
    
    func prepareAutoCompletionComponent(for textField: UITextField, elementDidSelected: ((Any) -> Void)?, textDidChanged: (() -> Void)?) -> AutoCompleteComponent {
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.isHidden = true
        
        // Constraints
        tableView.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor).isActive = true
        let heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
        
        // Register
        let autoCompleteComponent = AutoCompleteComponent(heightConstraint: heightConstraint, tableView: tableView, elementDidSelected: elementDidSelected, textDidChanged: textDidChanged)
        autoCompleteComponent.datas = viewModel.getAllCountryForAutocomplete()
        
        return autoCompleteComponent
    }
    
    func selectedCountryFromAutoCpmplete(isFrom: Bool, value: String?) {
        if isFrom {
            firstSelected = value
            fromTextfield.text = value
        } else {
            secondSelected = value
            toTextField.text = value
        }
    }
}

//
//  ARViewController.swift
//  rooms
//
//  Created by Nicolas Fernandez Amorosino on 19/02/2018.
//  Copyright © 2018 Nicolas Amorosino. All rights reserved.
//

import UIKit
import ARKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    let constants : Constants = Constants()
    
    var isScanning = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.sceneView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetTracking(first: true)
    }

    @IBAction func didTapReset(_ sender: Any) {
        resetTracking(first: false)
    }
    
    func resetTracking(first: Bool) {
        
            SVProgressHUD.show()
            
            let configuration = ARWorldTrackingConfiguration()
            
            guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "Logos", bundle: nil) else {
                fatalError("Missing expected asset catalog resources.")
            }
            
            configuration.detectionImages = referenceImages
            
            self.sceneView.autoenablesDefaultLighting = true
            self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            self.isScanning = true
            self.infoLabel.text = ""
            
            SVProgressHUD.dismiss(withDelay: TimeInterval(0.75))
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if self.isScanning {
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            
            let room : String = self.getRoomName(imageName: imageAnchor.referenceImage.name!)
            
            let imagesRoute = self.constants.imagesRoute
            
            let imagesNames = self.constants.imagesNames
            
            Alamofire.request("https://tranquil-springs-77400.herokuapp.com/events/now/\(String(imagesRoute[room]!))").responseJSON {
                response in
                if response.result.isSuccess {
                    let isFree : Bool = JSON(response.result.value!)["isFree"].boolValue
                    
                    if isFree {
                        self.renderUnicorn(node: node)
                    } else {
                        self.renderPoop(node: node)
                    }
                    self.showText(isFree: isFree, roomName: imagesNames[room]!)
                    self.isScanning = false
                    
                } else {
                    print("something went wrong")
                }
            }
        }
    }
    
    func renderUnicorn(node: SCNNode){
        let unicornScene = SCNScene(named: "art.scnassets/Unicorn.scn")!
        if let unicornNode = unicornScene.rootNode.childNode(withName: "Unicorn", recursively: false){
            node.addChildNode(unicornNode)
        }
    }
    
    func renderPoop(node: SCNNode){
        let poopScene = SCNScene(named: "art.scnassets/Poop.scn")!
        if let poopNode = poopScene.rootNode.childNode(withName: "Poop", recursively: false){
            node.addChildNode(poopNode)
        }
    }
    
    func showText(isFree: Bool, roomName: String){
        if isFree{
            self.infoLabel.text = "\(roomName) is available!"
        } else {
            self.infoLabel.text = "\(roomName) is busy!"
        }
    }
    
    func getRoomName(imageName: String) -> String {
        let room : String
        
        if let index = imageName.index(of: "_") {
            room = String(imageName.prefix(upTo: index))
        } else {
            room = imageName
        }
        
        return room
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print(session, camera)
    }
}


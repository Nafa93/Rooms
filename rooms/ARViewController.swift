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

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    var isScanning = true
    
    var isResetAvailable = true
    
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
        
        resetTracking()
    }

    @IBAction func didTapReset(_ sender: Any) {
            resetTracking()
    }
    
    func resetTracking() {
        if isResetAvailable{

            self.isResetAvailable = false
            print("im in")
            let configuration = ARWorldTrackingConfiguration()
            
            guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "Logos", bundle: nil) else {
                fatalError("Missing expected asset catalog resources.")
            }
            
            configuration.detectionImages = referenceImages
            
            self.sceneView.autoenablesDefaultLighting = true
            self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            self.isScanning = true
            self.infoLabel.text = ""
            self.isResetAvailable = true
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if self.isScanning {
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            
            let referenceImage = imageAnchor.referenceImage.name
            
            let room : String
            
            if let index = referenceImage!.index(of: "_") {
                room = String(referenceImage!.prefix(upTo: index))
            } else {
                room = referenceImage!
            }
            
            print(room)
            
            let imagesRoute = [
                "zelda": "solstice.com_3238353635363032333337@resource.calendar.google.com",
                "mario": "",
                "monkey": "solstice.com_2d33373835393738342d313133@resource.calendar.google.com",
                "prince": "solstice.com_2d3733383537333234@resource.calendar.google.com",
                "fullthrottle": "solstice.com_38393632313233393835@resource.calendar.google.com",
                "sonic": "solstice.com_2d3636323331313038323535@resource.calendar.google.com",
                "tetris": "solstice.com_3231353932353235313638@resource.calendar.google.com",
                "donkey": "solstice.com_3335313531343932313730@resource.calendar.google.com",
                "pacman": "solstice.com_36313332303339313939@resource.calendar.google.com"
            ]
            
            let imagesNames = [
                "zelda": "Zelda",
                "mario": "Marios Bros.",
                "monkey": "Monkey Island",
                "prince": "Prince of Persia",
                "fullthrottle": "Full Throttle",
                "sonic": "Sonic",
                "tetris": "Tetris",
                "donkey": "Donkey Kong",
                "pacman": "Pacman"
            ]
            
            print(String(imagesRoute[String(room)]!))
            Alamofire.request("https://tranquil-springs-77400.herokuapp.com/events/now/\(String(imagesRoute[room]!))").responseJSON {
                response in
                if response.result.isSuccess {
                    let isFree : Bool = JSON(response.result.value!)["isFree"].boolValue
                    
                    print(isFree)
                    
                    if isFree {
                        let unicornScene = SCNScene(named: "art.scnassets/Unicorn.scn")!
                        if let unicornNode = unicornScene.rootNode.childNode(withName: "Unicorn", recursively: false){
                            node.addChildNode(unicornNode)
                        }
                        self.infoLabel.text = "\(imagesNames[room]!) is available!"
                    } else {
                        let poopScene = SCNScene(named: "art.scnassets/Poop.scn")!
                        if let poopNode = poopScene.rootNode.childNode(withName: "Poop", recursively: false){
                            node.addChildNode(poopNode)
                        }
                        self.infoLabel.text = "\(imagesNames[room]!) is busy!"
                        self.infoLabel.font.withSize(CGFloat(24))
                        self.infoLabel.textAlignment = .right
                    }
                    self.isScanning = false
                    
                } else {
                    print("something went wrong")
                }
            }
        } else {
            print("you're already scanning")
        }
        
    }
    
}


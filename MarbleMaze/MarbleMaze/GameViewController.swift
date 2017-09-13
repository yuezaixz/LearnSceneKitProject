//
//  GameViewController.swift
//  MarbleMaze
//
//  Created by 吴迪玮 on 2017/9/13.
//  Copyright © 2017年 吴迪玮. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var scnView:SCNView!
    
    var scnScene:SCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupNodes()
        setupSounds()
    }
    
    //MARK: SetUps
    func setupScene() {
        scnView = self.view as! SCNView
        scnView.delegate = self
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        
        scnScene = SCNScene(named: "art.scnassets/game.scn")
        scnView.scene = scnScene
    }
    
    func setupNodes() {
        
    }
    
    func setupSounds() {
        
    }
    
    //MARK: Others
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension GameViewController:SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
    }
    
}

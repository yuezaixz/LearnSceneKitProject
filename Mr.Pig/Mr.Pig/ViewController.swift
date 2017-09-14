//
//  ViewController.swift
//  Mr.Pig
//
//  Created by 吴迪玮 on 2017/9/14.
//  Copyright © 2017年 吴迪玮. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

class ViewController: UIViewController {

    let game = GameHelper.sharedInstance
    var scnView: SCNView!
    
    var gameScene: SCNScene!
    var splashScene: SCNScene!
    
    var pigNode: SCNNode!
    
    var cameraNode: SCNNode!
    var cameraFollowNode: SCNNode!
    
    var lightFollowNode: SCNNode!
    
    var trafficNode: SCNNode!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScenes()
        setupNodes()
        setupActions()
        setupTraffic()
        setupGestures()
        setupSounds()
        
        game.state = .tapToPlay
    }
    
    //MARK: SetUp
    
    func setupScenes() {
        scnView = SCNView(frame: self.view.frame)
        self.view.addSubview(scnView)
        
        gameScene = SCNScene(named: "/MrPig.scnassets/GameScene.scn")
        splashScene = SCNScene(named: "/MrPig.scnassets/SplashScene.scn")
        scnView.scene = splashScene
    }
    func setupNodes() {
        pigNode = gameScene.rootNode.childNode(withName: "MrPig", recursively:
            true)!
        
        cameraNode = gameScene.rootNode.childNode(withName: "camera",
                                                  recursively: true)!
        cameraNode.addChildNode(game.hudNode)
        cameraFollowNode = gameScene.rootNode.childNode(withName: "FollowCamera",
                                                        recursively: true)!
        
        lightFollowNode = gameScene.rootNode.childNode(withName: "FollowLight",
                                                       recursively: true)!
        
        trafficNode = gameScene.rootNode.childNode(withName: "Traffic",
                                                   recursively: true)!
    }
    func setupActions() {
    }
    func setupTraffic() {
    }
    func setupGestures() {
    }
    func setupSounds() {
    }
    
    //MARK: Logic
    func startGame() {
        // 1
        splashScene.isPaused = true
        // 2
        let transition = SKTransition.doorsOpenVertical(withDuration: 1.0)
        // 3
        scnView.present(gameScene, with: transition, incomingPointOfView: nil,
                        completionHandler: {
                            // 4
                            self.game.state = .playing
                            self.setupSounds()
                            self.gameScene.isPaused = false
        })
    }
    
    func stopGame() {
        game.state = .gameOver
        game.reset()
    }
    
    func startSplash() {
        // 1
        gameScene.isPaused = true
        // 2
        let transition = SKTransition.doorsOpenVertical(withDuration: 1.0)
        scnView.present(splashScene, with: transition, incomingPointOfView:
            nil, completionHandler: {
                self.game.state = .tapToPlay
                self.setupSounds()
                self.splashScene.isPaused = false
        })
    }
    
    //MARK: Actions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if game.state == .tapToPlay {
            startGame()
        }
    }
    
    //MARK: Others
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}


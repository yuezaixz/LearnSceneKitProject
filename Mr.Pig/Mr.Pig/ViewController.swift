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
    
    var driveLeftAction: SCNAction!
    var driveRightAction: SCNAction!
    
    var jumpLeftAction: SCNAction!
    var jumpRightAction: SCNAction!
    var jumpForwardAction: SCNAction!
    var jumpBackwardAction: SCNAction!
    
    var triggerGameOver: SCNAction!
    
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
        //车辆的动作
        driveLeftAction = SCNAction.repeatForever(SCNAction.move(by:
            SCNVector3Make(-2.0, 0, 0), duration: 1.0))
        driveRightAction = SCNAction.repeatForever(SCNAction.move(by:
            SCNVector3Make(2.0, 0, 0), duration: 1.0))
        
        //猪的动作
        let duration = 0.2
        let bounceUpAction = SCNAction.moveBy(x: 0, y: 1.0, z: 0, duration:
            duration * 0.5)
        let bounceDownAction = SCNAction.moveBy(x: 0, y: -1.0, z: 0, duration:
            duration * 0.5)
        
        bounceUpAction.timingMode = .easeOut
        bounceDownAction.timingMode = .easeIn
        
        let bounceAction = SCNAction.sequence([bounceUpAction, bounceDownAction])
        
        let moveLeftAction = SCNAction.moveBy(x: -1.0, y: 0, z: 0, duration:
            duration)
        let moveRightAction = SCNAction.moveBy(x: 1.0, y: 0, z: 0, duration:
            duration)
        let moveForwardAction = SCNAction.moveBy(x: 0, y: 0, z: -1.0, duration:
            duration)
        let moveBackwardAction = SCNAction.moveBy(x: 0, y: 0, z: 1.0, duration:
            duration)
        let turnLeftAction = SCNAction.rotateTo(x: 0, y: convertToRadians(angle:
            -90),
                                                z: 0, duration: duration, usesShortestUnitArc: true)
        let turnRightAction = SCNAction.rotateTo(x: 0, y: convertToRadians(angle:
            90),
                                                 z: 0, duration: duration, usesShortestUnitArc: true)
        let turnForwardAction = SCNAction.rotateTo(x: 0, y:
            convertToRadians(angle: 180),
                                                   z: 0, duration: duration, usesShortestUnitArc: true)
        let turnBackwardAction = SCNAction.rotateTo(x: 0, y:
            convertToRadians(angle: 0),
                                                    z: 0, duration: duration, usesShortestUnitArc: true)
        jumpLeftAction = SCNAction.group([turnLeftAction, bounceAction,
                                          moveLeftAction])
        jumpRightAction = SCNAction.group([turnRightAction, bounceAction,
                                           moveRightAction])
        jumpForwardAction = SCNAction.group([turnForwardAction, bounceAction,
                                             moveForwardAction])
        jumpBackwardAction = SCNAction.group([turnBackwardAction, bounceAction,
                                              moveBackwardAction])
        
        //游戏结束的动作
        let spinAround = SCNAction.rotateBy(x: 0, y: convertToRadians(angle:
            720), z: 0, duration: 2.0)
        let riseUp = SCNAction.moveBy(x: 0, y: 10, z: 0, duration: 2.0)
        let fadeOut = SCNAction.fadeOpacity(to: 0, duration: 2.0)
        let goodByePig = SCNAction.group([spinAround, riseUp, fadeOut])
        
        let gameOver = SCNAction.run { (node:SCNNode) -> Void in
            self.pigNode.position = SCNVector3(x:0, y:0, z:0)
            self.pigNode.opacity = 1.0
            self.startSplash()
        }
        
        triggerGameOver = SCNAction.sequence([goodByePig, gameOver])
    }
    func setupTraffic() {
        for node in trafficNode.childNodes {
            if node.name?.contains("Bus") == true {
                driveLeftAction.speed = 1.0
                driveRightAction.speed = 1.0
            } else {
                driveLeftAction.speed = 2.0
                driveRightAction.speed = 2.0
            }
            if node.eulerAngles.y > 0 {
                node.runAction(driveLeftAction)
            } else {
                node.runAction(driveRightAction)
            }
        }
    }
    
    func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self,
                                                  action: #selector(ViewController.handleGesture(_:)))
        swipeRight.direction = .right
        scnView.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(ViewController.handleGesture(_:)))
        swipeLeft.direction = .left
        scnView.addGestureRecognizer(swipeLeft)
        let swipeForward = UISwipeGestureRecognizer(target: self,
                                                    action: #selector(ViewController.handleGesture(_:)))
        swipeForward.direction = .up
        scnView.addGestureRecognizer(swipeForward)
        let swipeBackward = UISwipeGestureRecognizer(target: self,
                                                     action: #selector(ViewController.handleGesture(_:)))
        swipeBackward.direction = .down
        scnView.addGestureRecognizer(swipeBackward)
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
        pigNode.runAction(triggerGameOver)
        resetGame()
    }
    
    func resetGame() {
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
    
    @objc func handleGesture(_ sender: UISwipeGestureRecognizer) {
        guard game.state == .playing else {
            return
        }
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.up:
            pigNode.runAction(jumpForwardAction)
        case UISwipeGestureRecognizerDirection.down:
            pigNode.runAction(jumpBackwardAction)
        case UISwipeGestureRecognizerDirection.left:
            if pigNode.position.x >  -15 {
                pigNode.runAction(jumpLeftAction)
            }
        case UISwipeGestureRecognizerDirection.right:
            if pigNode.position.x < 15 {
                pigNode.runAction(jumpRightAction)
            }
        default:
            break
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


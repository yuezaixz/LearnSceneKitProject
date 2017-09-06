//
//  GameViewController.swift
//  GeometryFighter
//
//  Created by 吴迪玮 on 2017/9/6.
//  Copyright © 2017年 吴迪玮. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
        spawnShape()
    }
    
    //MARK: setup
    
    func setupView() {
        scnView = self.view as! SCNView
        
        //显示统计
        scnView.showsStatistics = true
        //允许摄像机控制
        scnView.allowsCameraControl = true
        //默认灯光开启
        scnView.autoenablesDefaultLighting = true
    }
    
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
        //设置背景
        scnScene.background.contents = "GeometryFighter.scnassets/Textures/Background_Diffuse.png"
    }
    
    func setupCamera() {
        // 创建相机节点
        cameraNode = SCNNode()
        // 设置相机
        cameraNode.camera = SCNCamera()
        // 设置相机的坐标
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        // 把相机添加到根节点
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    //MARK: logic
    
    func spawnShape() {
        // 创建几何体
        var geometry:SCNGeometry
        //SCNGeometry 相关文档 https://developer.apple.com/documentation/scenekit/scngeometry#//apple_ref/occ/cl/SCNGeometry
        
        // 根据随机值来
        switch ShapeType.random() {
        case .box:
            // 正方体形状
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0,
                              chamferRadius: 0.05)
            print("正方体形状")
        case .sphere:
            // 球形状
            geometry = SCNSphere(radius: 0.5)
            print("球形状")
        case .pyramid:
            // 金字塔形状
            geometry = SCNPyramid(width: 1.0, height: 1.0, length: 1.0)
            print("金字塔形状")
        case .torus:
            // 环形状
            geometry = SCNTorus(ringRadius: 0.5, pipeRadius: 0.4)
            print("环形状")
        case .capsule:
            // 胶囊形状
            geometry = SCNCapsule(capRadius: 0.2, height: 1.0)
            print("胶囊形状")
        case .cylinder:
            // 圆柱形状
            geometry = SCNCylinder(radius: 0.5, height: 1.0)
            print("圆柱形状")
        case .cone:
            // 圆锥形状
            geometry = SCNCone(topRadius: 0.1, bottomRadius: 0.5, height: 1.0)
            print("圆锥形状")
        case .tube:
            // 管形状
            geometry = SCNTube(innerRadius: 0.4, outerRadius: 0.5, height: 1.0)
            print("管形状")
        }
        // 通过几何体来创建node
        let geometryNode = SCNNode(geometry: geometry)
        // 把正方体node添加到场景中
        scnScene.rootNode.addChildNode(geometryNode)
    }
    
    //MARK: others
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

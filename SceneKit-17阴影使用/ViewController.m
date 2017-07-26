//
//  ViewController.m
//  SceneKit-17阴影使用
//
//  Created by ShiWen on 2017/7/25.
//  Copyright © 2017年 ShiWen. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()

@property (strong,nonatomic)SCNView *mScnView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mScnView];
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, 500, 1500);
    cameraNode.camera.automaticallyAdjustsZRange = YES;
    [self.mScnView.scene.rootNode addChildNode:cameraNode];

    SCNNode *floorNode = [SCNNode nodeWithGeometry:[SCNFloor floor]];
    floorNode.geometry.firstMaterial.diffuse.contents = @"floor.jpg";
    floorNode.physicsBody = [SCNPhysicsBody staticBody];
    [self.mScnView.scene.rootNode addChildNode:floorNode];
//    获取树模型
    SCNNode *treeNode = [[SCNScene sceneNamed:@"palm_tree.dae"].rootNode childNodeWithName:@"PalmTree" recursively:YES];
    treeNode.rotation = SCNVector4Make(1, 0, 0, -M_PI_2);
    [self.mScnView.scene.rootNode addChildNode:treeNode];
    
//    创建灯罩
    SCNSphere *sphere = [SCNSphere sphereWithRadius:25];
    sphere.firstMaterial.diffuse.contents = [UIColor redColor];
    sphere.firstMaterial.lightingModelName = SCNLightingModelConstant;
    
//    创建光源
    SCNNode *lightNode = [SCNNode node];
    lightNode.geometry = sphere;
    lightNode.light.color = [UIColor redColor];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeSpot;
//    设置光源资源照射距离，默认1000
    lightNode.light.zFar = 2000;
    lightNode.light.spotInnerAngle = 30;
    
//    创建灯光支点
    SCNNode *handleSpot = [SCNNode node];
    handleSpot.position = SCNVector3Make(0, 1000, 40);
    [handleSpot addChildNode:lightNode];
    handleSpot.geometry.firstMaterial.diffuse.contents = @"moon.jpg";
    SCNAction *rotateCone = [SCNAction rotateToAxisAngle:SCNVector4Make(1, 0, 0, M_PI_2) duration:1];
    [handleSpot runAction:rotateCone];
    [self.mScnView.scene.rootNode addChildNode:handleSpot];
//    环境节点
    SCNNode *ambientNode = [SCNNode node];
    ambientNode.light = [SCNLight light];
    ambientNode.light.type = SCNLightTypeAmbient;
    [self.mScnView.scene.rootNode addChildNode:ambientNode];
    
    SCNLookAtConstraint *constraint = [SCNLookAtConstraint lookAtConstraintWithTarget:treeNode];
    lightNode.constraints = @[constraint];

    /// 贴图阴影
//    是否显示影子
    lightNode.light.castsShadow = NO;
//    设置遮光罩内容
    lightNode.light.gobo.contents = @"shadow.jpg";
//    设置内容强度
    lightNode.light.gobo.intensity = 1;
//    设置遮光模式
    lightNode.light.shadowMode = SCNShadowModeModulated;
    
//    创建灯光移动动画
    SCNAction *leftAction = [SCNAction moveTo:SCNVector3Make(100, 1000, 40) duration:1];
    SCNAction *rightAction = [SCNAction moveTo:SCNVector3Make(-100, 1000, 40) duration:1];
    SCNAction *sequenceAction = [SCNAction sequence:@[leftAction,rightAction]];
    SCNAction *rotateAction = [SCNAction rotateByAngle:M_PI aroundAxis:SCNVector3Make(0, 1, 0) duration:2];
    SCNAction *group = [SCNAction group:@[sequenceAction,rotateAction]];
    [handleSpot runAction:[SCNAction repeatActionForever:group]];

    

}

-(SCNView *)mScnView{
    if (!_mScnView) {
        _mScnView = [[SCNView alloc] initWithFrame:self.view.bounds];
        _mScnView.backgroundColor = [UIColor blackColor];
        _mScnView.allowsCameraControl = YES;
        _mScnView.scene = [SCNScene scene];
        
    }
    return _mScnView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

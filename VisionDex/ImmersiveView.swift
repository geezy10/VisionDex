//
//  ImmersiveView.swift
//  VisionDex
//
//  Created by Gottlieb-Zimmermann Niklas - s2310237011 on 21.11.25.
//
import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct ImmersiveView: View {
    

    @State private var arSession = ARKitSession()
    @State private var handTrackingProvider = HandTrackingProvider()
    @State private var handEntities: [HandAnchor.Chirality: ModelEntity] = [:]
    @State private var rootEntity = Entity() // Container
    
    @State var willBegin: EventSubscription? = nil
    @State var willEnd: EventSubscription? = nil
        
    var body: some View {
        RealityView { content in
            content.add(rootEntity)
            
            
            if let scene = try? await Entity(named: "Pokescene", in: realityKitContentBundle) {
                
                //setup pokemon
                if let glumanda = scene.findEntity(named: "glumanda") {
                    var phys = PhysicsBodyComponent(mode: .kinematic)
                    glumanda.components.set(phys)
                    if glumanda.components[CollisionComponent.self] == nil {
                        glumanda.generateCollisionShapes(recursive: true)
                    }
                }
                
                // setup pokeball
                if let ball = scene.findEntity(named: "pokeball") {
                    ball.components.set(InputTargetComponent(allowedInputTypes: .all))
                   // ball.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.04)]))
//                    var manipulation = ManipulationComponent()
//                    manipulation.releaseBehavior = .stay
//                    manipulation.dynamics.scalingBehavior = .none
//                    ball.components.set(manipulation)
                    var phys = PhysicsBodyComponent(mode: .kinematic)
//                    phys.isAffectedByGravity = false
                    phys.massProperties.mass = 0.2
                    ball.components.set(phys)
                }
                
                willBegin = content.subscribe(to: ManipulationEvents.WillBegin.self) { event in
                    if var physicsBody = event.entity.components[PhysicsBodyComponent.self] {
                        physicsBody.mode = .kinematic
                        event.entity.components.set(physicsBody)
                    }
                }
                
                willEnd = content.subscribe(to: ManipulationEvents.WillEnd.self) { event in
                    if var physicsBody = event.entity.components[PhysicsBodyComponent.self] {
                        physicsBody.mode = .dynamic
                        event.entity.components.set(physicsBody)
                    }
                }
                
                rootEntity.addChild(scene)
                
                // collision logic
                _ = content.subscribe(to: CollisionEvents.Began.self) { event in
                    let entityA = event.entityA.name
                    let entityB = event.entityB.name
                    
                    // ball hits pokemon
                    if (entityA == "pokeball" && entityB == "glumanda") || (entityB == "pokeball" && entityA == "glumanda") {
                        print("🔴 CATCH! Ball hat Glumanda getroffen.")
                    }
                    
                    // pet the pokemon -> pls always say "can i pet that dawg?"
                    if (entityA.contains("Finger") && entityB == "glumanda") || (entityB.contains("Finger") && entityA == "glumanda") {
                        print("❤️ STREICHELN! Finger berührt Glumanda.")
                    }
                }
            }
        }
        .gesture(SpatialTapGesture().targetedToAnyEntity().onEnded({ value in
            if value.entity.name == "glumanda" {
                var pokeball = rootEntity.findEntity(named: "pokeball")
                pokeball?.position = [0, 0, 1]
                pokeball?.components[PhysicsBodyComponent.self]?.mode = .kinematic
            }
        }))
       
        .gesture(
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    guard value.entity.name == "pokeball" else { return }
                    // sticky ball
                    let entity = value.entity
                    if var phys = entity.components[PhysicsBodyComponent.self] {
                        phys.mode = .kinematic
                        entity.components.set(phys)
                    }
                    entity.position = value.convert(value.location3D, from: .local, to: .scene)
                }
                .onEnded { value in
                    let entity = value.entity
                    guard value.entity.name == "pokeball" else { return }

                    
                    if var phys = entity.components[PhysicsBodyComponent.self] {
                        //physics on
                        phys.mode = .dynamic
                        entity.components.set(phys)
                        
                        // diff between ball and location where it shoots
                        let currentPos = value.location3D
                        let predictedPos = value.predictedEndLocation3D
                        
                        //generate vektors with the smartphone -> shoutout to wolfi
                        let movementVector = predictedPos - currentPos
                        
                        //factor of the strength
                        let throwForce: Float = 0.01
                        
                        // change to SIMD<3> for realtiy kit
                        let velocityVector = SIMD3<Float>(
                            Float(movementVector.x) * throwForce,
                            Float(movementVector.y) * throwForce,
                            Float(movementVector.z) * throwForce
                        )
                        

                        if var motion = entity.components[PhysicsMotionComponent.self] {
                            motion.linearVelocity = velocityVector
                            entity.components.set(motion)
                        } else {
                            var motion = PhysicsMotionComponent()
                            motion.linearVelocity = velocityVector
                            entity.components.set(motion)
                        }
                    }
                    
                }
        )
        .task { //fingertracking for petting the dawg
            if HandTrackingProvider.isSupported {
                do {
                    print("start hand tracking")
                    try? await arSession.run([handTrackingProvider])
                    await processHandUpdates()
                } catch { print("errrrrrooooorrr")}
            } else {
                print("we are in the simulator")
            }

        }
    }
    
  
    func processHandUpdates() async {
        for await update in handTrackingProvider.anchorUpdates {
            let handAnchor = update.anchor
            guard handAnchor.isTracked, let skeleton = handAnchor.handSkeleton else { continue }
            
            let joint = skeleton.joint(.indexFingerTip)
            guard joint.isTracked else { continue }
            
            let transform = handAnchor.originFromAnchorTransform * joint.anchorFromJointTransform
            await updateFingerSphere(transform: transform, chirality: handAnchor.chirality)
        }
    }
    
    @MainActor
    func updateFingerSphere(transform: simd_float4x4, chirality: HandAnchor.Chirality) {
        if let entity = handEntities[chirality] {
            entity.transform.matrix = transform
        } else {
            let entity = ModelEntity(
                mesh: .generateSphere(radius: 0.01),
                materials: [SimpleMaterial(color: .clear, isMetallic: false)]
            )
            entity.name = "Finger_\(chirality)"
            entity.components.set(PhysicsBodyComponent(mode: .kinematic))
            entity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.01)]))
            rootEntity.addChild(entity)
            handEntities[chirality] = entity
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}

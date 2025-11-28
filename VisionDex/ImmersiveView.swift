//
//  ImmersiveView.swift
//  VisionDex
//
//  Created by Gottlieb-Zimmermann Niklas - s2310237011 on 21.11.25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Pokescene", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
            }
        }
        .gesture(SpatialTapGesture().targetedToAnyEntity().onEnded{ value in
            print("Pokemon angeklickt!")
        })
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}

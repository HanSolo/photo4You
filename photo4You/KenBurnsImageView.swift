//
//  KenBurnsImageView.swift
//  photo4You
//
//  Created by Gerrit Grunwald on 13.11.25.
//

import Foundation
import SwiftUI

/*
 KenBurnsImageView(
     imageName   : "patagonia",
     duration    : 20, // seconds
     startScale  : CGSize(width: 1.0, height: 1.0),
     endScale    : CGSize(width: 1.4, height: 1.4),
     startOffset : CGSize(width: 0, height: 0),
     endOffset   : CGSize(width: -50, height: 70)
 )
*/


struct KenBurnsImageView: View {
    let imageName : String
    let duration  : Double
     
    @State private var progress: CGFloat = 0
     
    // Customize these for different effects
    let startScale  : CGSize // 1.0, 1.0
    let endScale    : CGSize // 1.3, 1.3
    let startOffset : CGSize // 0.0, 0.0
    let endOffset   : CGSize // -30, -30
     
    
    init(
        imageName   : String,
        duration    : Double = 10,
        startScale  : CGSize = CGSize(width: 1.0, height: 1.0),
        endScale    : CGSize = CGSize(width: 1.3, height: 1.3),
        startOffset : CGSize = CGSize(width: 0, height: 0),
        endOffset   : CGSize = CGSize(width: -30, height: -30)
    ) {
        self.imageName   = imageName
        self.duration    = duration
        self.startScale  = startScale
        self.endScale    = endScale
        self.startOffset = startOffset
        self.endOffset   = endOffset
    }
     
    var body: some View {
        Image(imageName)
            .resizable()
            .ignoresSafeArea()
            .aspectRatio(contentMode: .fill)
            .layerEffect(
                ShaderLibrary.kenBurns(.boundingRect, .float(progress), .float2(startScale), .float2(endScale), .float2(startOffset), .float2(endOffset)),
                maxSampleOffset : .zero,
                isEnabled       : true
            )
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: true).delay(3)) {
                    progress = 1.0
                }
            }
    }
}

//
//  ContentView.swift
//  photo4You
//
//  Created by Gerrit Grunwald on 12.11.25.
//

import SwiftUI
import PhotosUI
import Combine

struct ContentView: View {
    @State private var pickerItems        : [PhotosPickerItem] = [PhotosPickerItem]()
    @State private var selectedImages     : [Image]            = [Image]()
    @State private var currentDate        : Date               = Date.now
    @State private var imgCounter         : Int                = 0
    @State private var currentImg         : Image?
    @State private var secOnScreen        : TimeInterval       = 10
    @State private var secSinceLastChange : TimeInterval       = 0
    @State private var selecting          : Bool               = false
    @State private var timer                                   = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

        
    var body: some View {
        ZStack {
            Color.black
            VStack {
                PhotosPicker(selection: $pickerItems, maxSelectionCount: 200, matching: .any(of: [.images, .not(.videos), .not(.livePhotos), .not(.panoramas), .not(.screenRecordings), .not(.slomoVideos), .not(.timelapseVideos), .not(.cinematicVideos)])) {
                    Label("Select pictures", systemImage: "photo")
                }
                self.currentImg?
                    .resizable()
                    .scaledToFill()
                    .clipped(antialiased: true)
                    //.scaledToFit()
                    .background(Color.black)
            }
            .padding()
            .background(Color.black)
            .onChange(of: pickerItems) {
                Task { @MainActor in
                    self.selectedImages.removeAll()
                    for item in pickerItems {
                        if let loadedImage = try await item.loadTransferable(type: Image.self) {
                            self.selectedImages.append(loadedImage)
                            debugPrint("Added image \(self.selectedImages.count)")
                        }
                    }
                    if self.selectedImages.isEmpty { return }
                    self.secSinceLastChange = 0
                    self.imgCounter         = 0
                    self.currentImg         = selectedImages[0]
                    debugPrint("Current image set to \(imgCounter)/\(selectedImages.count)")
                }
            }
            .onReceive(timer) { input in
                if self.selectedImages.isEmpty { return }
                
                self.secSinceLastChange += 1
                if self.secSinceLastChange < self.secOnScreen { return }
                
                self.imgCounter += 1
                if self.imgCounter > self.selectedImages.count - 1 { imgCounter = 0 }
                                
                self.currentImg = selectedImages[imgCounter]
                self.secSinceLastChange = 0
                debugPrint("Current image changed on timer to \(imgCounter)/\(self.selectedImages.count)")
            }
        }
        .ignoresSafeArea(edges: .all)
        .toolbar(.hidden)
        .statusBar(hidden: true)
        .onTapGesture {
            self.imgCounter += 1
            if self.imgCounter > self.selectedImages.count - 1 { imgCounter = 0 }
                            
            self.currentImg = self.selectedImages[imgCounter]
            self.secSinceLastChange = 0
            debugPrint("Current image changed on tap to \(imgCounter)/\(self.selectedImages.count)")
        }
    }
}

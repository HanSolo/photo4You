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
    @State private var secOnScreen        : TimeInterval       = Constants.Duration.SEC_10.seconds
    @State private var secSinceLastChange : TimeInterval       = 0
    @State private var selecting          : Bool               = false
    @State private var timer                                   = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var selectedDuration   : Constants.Duration = Constants.Duration.fromSeconds(seconds: Properties.instance.duration!)
    @State private var showOptions        : Bool               = true
    
        
    var body: some View {
        ZStack {
            Color.black
            VStack {
                if self.showOptions {
                    HStack {
                        Picker("Duration", selection: $selectedDuration) {
                            ForEach(Constants.Duration.allCases, id: \.self) {
                                Text($0.name)
                                    .font(.system(size: 20, weight: .light, design: .rounded))
                                    .foregroundStyle(Color.gray)
                            }
                        }
                        .font(.system(size: 20, weight: .light, design: .rounded))
                        .foregroundStyle(Color.gray)
                        
                        Spacer()
                        
                        PhotosPicker(selection: $pickerItems, maxSelectionCount: 200, matching: .any(of: [.images, .not(.videos), .not(.livePhotos), .not(.panoramas), .not(.screenRecordings), .not(.slomoVideos), .not(.timelapseVideos), .not(.cinematicVideos)])) {
                            Label("Select photos", systemImage: "photo")
                                .font(.system(size: 20, weight: .light, design: .rounded))
                                .foregroundStyle(Color.gray)
                        }
                    }
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
            .ignoresSafeArea(edges: .all)
            .toolbar(.hidden)
            .statusBar(hidden: true)
            .onChange(of: self.pickerItems) {
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
            .onChange(of: self.selectedDuration) {
                Properties.instance.duration = self.selectedDuration.seconds
                self.secOnScreen = selectedDuration.seconds
                debugPrint("Seconds on screen: \(self.secOnScreen)")
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
        .onAppear() {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onTapGesture {
            self.showOptions.toggle()
        }
    }
}

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
    @State private var isDay              : Bool               = true
    
        
    var body: some View {
        ZStack {
            Color.black
                                    
            if self.showOptions {
                VStack(alignment: .center, spacing: 20) {
                    HStack(spacing: 50) {
                        Text("Duration of photo on screen")
                            .font(.system(size: 24, weight: .light, design: .rounded))
                            .foregroundStyle(Color.white)
                        Spacer()
                        
                        Menu {
                            Picker(selection: $selectedDuration) {
                                ForEach(Constants.Duration.allCases, id: \.self) {
                                    Text($0.name)
                                }
                            } label: {}
                        } label: {
                            Text(self.selectedDuration.name)
                                .font(.system(size: 24, weight: .light, design: .rounded))
                        }
                    }
                    .frame(width: 600)
                    
                    HStack(spacing: 50) {
                        Text("Photos to show")
                            .font(.system(size: 24, weight: .light, design: .rounded))
                            .foregroundStyle(Color.white)
                        Spacer()
                        PhotosPicker(selection: $pickerItems, maxSelectionCount: 200, matching: .any(of: [.images, .not(.videos), .not(.livePhotos), .not(.panoramas), .not(.screenRecordings), .not(.slomoVideos), .not(.timelapseVideos), .not(.cinematicVideos)])) {
                            Label("Select", systemImage: "photo")
                                .font(.system(size: 24, weight: .light, design: .rounded))
                        }
                    }
                    .frame(width: 600)
                    
                    Spacer().frame(height: 100)
                    
                    Button("Close", action: {
                        self.showOptions = false
                    })
                    .buttonStyle(.glass)
                    .font(.system(size: 24, weight: .light, design: .rounded))
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
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
            } else {
                self.currentImg?
                    .resizable()
                    .scaledToFill()
                    .clipped(antialiased: true)
                
                Rectangle()
                    .fill(Color.black.opacity(self.isDay ? Constants.BRIGHTNESS_DAY : Constants.BRIGHTNESS_NIGHT))
                    .blendMode(.destinationOut)
            }
        }
        .background(Color.black)
        .ignoresSafeArea(edges: .all)
        .toolbar(.hidden)
        .statusBar(hidden: true)
        .onAppear() {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onTapGesture {
            self.showOptions = true
        }
        .onReceive(timer) { input in
            let now       : Date = Date.now
            let month     : Int  = now.get(.month)
            let summer    : Bool = month >= 5 && month <= 9
            let hourOfDay : Int  = now.get(.hour)
            self.isDay = summer ? (hourOfDay >= 6 && hourOfDay < 21) : (hourOfDay >= 7 && hourOfDay < 20)

            if isDay {
                /*
                if UIScreen.main.brightness != Constants.BRIGHTNESS_DAY {
                    UIScreen.main.brightness = Constants.BRIGHTNESS_DAY
                }
                */
            } else {
                /*
                if UIScreen.main.brightness != Constants.BRIGHTNESS_NIGHT {
                    UIScreen.main.brightness = Constants.BRIGHTNESS_NIGHT
                }
                */
            }
            
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
}

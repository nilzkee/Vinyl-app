//
//  Vynl.swift
//  Test Vynl
//
//  Created by Nila Eleora Putri Sianturi on 11/05/24.
//

import SwiftUI
import AVFoundation

class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    
    let audioFileName = "Sparkle Baru Sacre.mp3"
    
    override init () {
        super.init()
        setupAudio()
        startTimer()
    }
    
    func setupAudio() {
        guard let audioFileURL = Bundle.main.url(forResource: audioFileName, withExtension: nil) else{
            print("Error")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
        } catch{
            print("Error: \(error)")
        }
    }
    func playAudio(){
        audioPlayer?.play()
    }
    func pauseAudio(){
        audioPlayer?.pause()
    }
    func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int( timeInterval / 60)
        let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d: %02d", minutes, seconds)
    }
    func startTimer(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
        { [weak self] timer in
            guard let self = self, self.isPlaying else { return }
            self.currentTime = self.audioPlayer?.currentTime ?? 0
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        currentTime = 0
    }
}

struct Vynl: View {
    @State private var rotationAngle: Double = 0.0
    @StateObject private var audioManager = AudioManager()
    @State private var isRotating = false
    
    
    var body: some View {
        VStack{
            Text("_SpotDie_")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.indigo)
                .padding(.top)
                .offset(y:10)
            
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 375, height: 505)
                    .background(Color(red: 0.99, green: 0.75, blue: 0.38))
                    .cornerRadius(25)
                    .offset(y:-15)
                    .shadow(color: .indigo.opacity(0.3), radius: 20, x:4, y:4)
                
                
                VStack {
                    
                    Image("vynl_disc")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 330, height: 330)
                        .rotationEffect(Angle(degrees: rotationAngle))
                    
                        .offset(y:10)
                        .shadow(color: .black.opacity(0.4), radius: 5, x:4, y:4)
                        .onAppear {
                            //                            if audioManager.isPlaying {
                            //                                startRotation(isRotating: true)
                            //                            }else{
                            //                                //                                stopRotation()
                            //                                startRotation(isRotating: false)
                            //                            }
                        }
                        .onReceive(audioManager.$isPlaying) { playing in
                            //                            if playing {
                            //                                startRotation(isRotating: true)
                            //                            } else {
                            //                                startRotation(isRotating: false)
                            //                            }
                        }
                    
                    
                    Text("Sparkle")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    
                    Text("RADWIMPS, Arr. Nila Sianturi")
                        .font(.headline)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                    
                }
                
                Image("Group 8")
                    .frame(width: 284.82138, height: 205.24345)
                    .offset(x: -33, y:-135)
            }
            .offset(y:15)
            
            
            
            //            Image(systemName: "play.circle.fill")
            //                .resizable()
            //                .aspectRatio(contentMode: .fit)
            //                .padding(.top)
            //                .frame(width: 70, height: 70)
            //                .foregroundColor(.indigo)
            
            Text(audioManager.formatTime(audioManager.currentTime))
                .font(.headline)
                .foregroundColor(.black)
                .padding(.top,10)
            
            ProgressView(value: audioManager.currentTime, total: audioManager.audioPlayer?.duration ?? 1.0)
                .padding(.horizontal, 50)
                .padding(.top, 5)
                .padding(.bottom, 20)
            
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 220, height: 59.0)
                    .background(Color.indigo)
                    .cornerRadius(28.5)
                    .shadow(color: .black.opacity(0.4), radius: 44, x:0, y:4)
                
                VStack {
                    
                }
                .frame(width: 77, height: 77)
                .background(Color.black)
                .shadow(color: .black, radius: 50, x:0, y:4)
                .clipShape(Circle())
                
                Button(action: {
                    if audioManager.isPlaying {
                        audioManager.audioPlayer?.pause()
                        //                        startRotation(isRotating: true)
                        startRotation(isRotating: false)
                        //                        rotationAngle = getCurrentRotationAngle()
                        
                    }else{
                        audioManager.playAudio()
                        startRotation(isRotating: true)
                        //                        rotationAngle = getCurrentRotationAngle()
                    }
                    audioManager.isPlaying.toggle()
                    isRotating = audioManager.isPlaying
                }) {
                    Image(systemName: audioManager.isPlaying ? "pause.fill":"play.fill")
                        .font(.system(size: 33))
                        .foregroundColor(.white)
                }
                
                HStack{
                    Button(action: {
                        
                    }) {
                        Image(systemName: "backward.fill")
                            .frame(width: 19, height: 19)
                            .foregroundColor(.white)
                    }
                    .offset(x: -60)
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "forward.fill")
                            .frame(width: 19, height: 19)
                            .foregroundColor(.white)
                    }
                    .offset(x: 60)
                }
            }
            
            
            Spacer()
        }
    }
    
    func startRotation(isRotating: Bool) {
        //        isRotating = true
        if isRotating {
            withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
                rotationAngle = 360
                
            }
        }else {
            
            withAnimation {
                rotationAngle = 0
                
            }
        }
    }
    //    func getCurrentRotationAngle() -> Double {
    //        return rotationAngle
    //    }
}

//    func stopRotation() {
//        isRotating = false
//        rotationAngle = 0
//    }


#Preview {
    Vynl()
}

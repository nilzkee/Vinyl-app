//
//  TestRotation.swift
//  Test Vynl
//
//  Created by Nila Eleora Putri Sianturi on 13/05/24.
//

import SwiftUI

struct TestRotation: View {
    @State private var rotationAngle: Double = 0
    @State private var isRotating: Bool = false
    @State private var finalRotationAngle: Double = 0
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Text("Rotation Angle: \(Int(rotationAngle))")
                .padding()

//            Rectangle()
//                .fill(Color.blue)
//                .frame(width: 200, height: 200)
//                .rotationEffect(Angle(degrees: rotationAngle))
            Image("vynl_disc")
                            .rotationEffect(Angle(degrees: rotationAngle))
                            .animation(.linear(duration: 0.5)) // Apply animation here

            Button(action: {
                toggleRotation()
            }) {
                Text(isRotating ? "Stop Rotation" : "Start Rotation")
                    .padding()
                    .background(isRotating ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            startRotation()
        }
    }

    func startRotation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if !isRotating {
                timer?.invalidate()
                return
            }
            rotationAngle += 1
        }
        timer?.fire()
    }

    func toggleRotation() {
        isRotating.toggle()
        if !isRotating {
            finalRotationAngle = rotationAngle
        } else {
            startRotation()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestRotation()
    }
}


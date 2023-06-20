//
//  UIViewController+Toast.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import SwiftUI

extension View {
    func showToast(message: String, duration: Double = 2.0, alignment: Alignment = .center, completion: (() -> Void)? = nil) -> some View {
        let toastView = ToastView(message: message, alignment: alignment, completion: completion)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .background(Color.black.opacity(0.5))
            .cornerRadius(15)
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    withAnimation {
                        completion?()
                    }
                }
            }
        
        return ZStack {
            self
            toastView
        }
    }
}

struct ToastView: View {
    let message: String
    let alignment: Alignment
    let completion: (() -> Void)?
    
    var body: some View {
        VStack {
            Text(message)
                .foregroundColor(.white)
                .padding()
        }
        .frame(maxWidth: .infinity, alignment: alignment)
    }
}

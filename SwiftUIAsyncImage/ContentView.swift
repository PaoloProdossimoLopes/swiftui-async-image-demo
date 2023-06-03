//
//  ContentView.swift
//  SwiftUIAsyncImage
//
//  Created by Paolo Prodossimo Lopes on 03/06/23.
//

import SwiftUI

extension Image {
    func toFit() -> some View {
        self
            .resizable()
            .scaledToFit()
    }
    
    func asPlaceholder() -> some View {
        self
            .toFit()
            .frame(maxWidth: 128)
            .foregroundColor(.purple)
            .opacity(0.5)
    }
}
struct ContentView: View {
    
    private let imagetURL = "https://credo.academy/credo-academy@3x.png"
    
    var body: some View {
//        AsyncImageWithPlaceholder(imagetURL: imagetURL)
//        AsyncImageWithScaling(imagetURL: imagetURL)
//        AsyncImageWithPhase(imagetURL: imagetURL)
        AsyncImageWithAnimation(imagetURL: imagetURL)
    }
}

struct AsyncImageWithPhase: View {
    let imagetURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: imagetURL)!) { phase in
            if let image = phase.image {
                image.toFit()
            } else if phase.error != nil {
                ErrorPlaceholder()
            } else {
                EmptyPlaceholder()
            }
        }
        .padding(40)
    }
}

struct ErrorPlaceholder: View {
    var body: some View {
        Image(systemName: "ant.circle.fill")
            .asPlaceholder()
    }
}

struct EmptyPlaceholder: View {
    var body: some View {
        Image(systemName: "photo.circle.fill")
            .asPlaceholder()
    }
}

struct AsyncImageWithAnimation: View {
    let imagetURL: String
    
    private let transactionAnimation = Transaction(
        animation: .spring(
            response: 0.5,
            dampingFraction: 0.6,
            blendDuration: 0.25
        ))
    
    var body: some View {
        AsyncImage(url: URL(string: imagetURL), transaction: transactionAnimation) { phase in
            switch phase {
            case .success(let image):
                image
                    .toFit()
                    .transition(.move(edge: .bottom))
            case .failure:
                ErrorPlaceholder()
            case .empty:
                EmptyPlaceholder()
            @unknown default:
                EmptyPlaceholder()
            }
        }
        .padding(40)
    }
}

struct AsyncImageWithScaling: View {
    let imagetURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: imagetURL)!, scale: 3.0)
        .padding(40)
    }
}

struct AsyncImageWithPlaceholder: View {
    let imagetURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: imagetURL)) { loadedImage in
            loadedImage.toFit()
        } placeholder: {
            EmptyPlaceholder()
        }
        .padding(40)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

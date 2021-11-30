//
//  GradientIndicatorView.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/30.
//

import SwiftUI

struct GradientIndicatorView: View {
    let colors: [Color] = [OpenColor.BLUE.color(8),
                           OpenColor.PINK.color(6),
                           OpenColor.RED.color(4),
                           OpenColor.CYAN.color(4)]
    let lineCap: CGLineCap = .round

    @State private var rotation: Double = 0

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .foregroundColor(
                    OpenColor.GRAY.color(8).opacity(0.50))
            VStack {
                animationContent            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

extension GradientIndicatorView {
    var animationContent: some View {
        let gradientColors = Gradient(colors: colors)
        let conic = AngularGradient(gradient: gradientColors, center: .center, startAngle: .zero, endAngle: .degrees(360))
        let lineWidth: CGFloat = 2

        let animation = Animation
            .linear(duration: 0.5)
            .repeatForever(autoreverses: false)

        return ZStack {
            Circle()
                .stroke(colors.first ?? .white, lineWidth: lineWidth)

            Circle()
                .trim(from: lineWidth / 500, to: 1 - lineWidth / 100)
                .stroke(conic, style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap))
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    self.rotation = 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        withAnimation(animation) {
                            self.rotation = 360
                        }
                    }
                }
        }.frame(width: 64, height: 64)
    }
}

struct GradientIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        GradientIndicatorView()
    }
}

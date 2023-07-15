//
//  MainViews.swift
//  moonar
//
//  Created by Владислав Калиниченко on 17.04.2022.
//

import SwiftUI

struct Background: View {
	let color: Color
	
	var body: some View {
		Rectangle()
			.fill(color)
			.ignoresSafeArea()
	}
}

struct Fading: View {
	var baseWidthSize: CGFloat
	var baseHeightSize: CGFloat

	var body: some View {
		Rectangle()
			.ignoresSafeArea()
			.frame(width: baseWidthSize, height: baseHeightSize)
			.mask(LinearGradient(gradient: Gradient(colors: [.clear, .black, .black]), startPoint: .leading, endPoint: .trailing).edgesIgnoringSafeArea(.all))
	}
}

struct OnTapButtonState: ButtonStyle {
	var newTextColor: Color
	
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.cornerRadius(15)
			.scaleEffect(configuration.isPressed ? 0.95 : 1.0)
			.animation(.spring(), value: 1)
			.foregroundColor(newTextColor.opacity(configuration.isPressed ? 0.7 : 1.0))
	}
}

struct TextBlock: View {
	@State private var isAnimated = false
	
	var textMessage: String
	var animationDelay: Double
	
	var body: some View {
		HStack {
			Text(textMessage)
				.font(.largeTitle)
				.fontWeight(.black)
				.foregroundColor(Color.white)
				.multilineTextAlignment(.leading)
				.padding([.top, .leading, .trailing], 30.0)
				.opacity(isAnimated ? 1 : 0)
				.offset(y: isAnimated ? 0 : -30)
				.shadow(color: Color.black, radius: 20, x: 0, y: 0)
				.zIndex(2)
			Spacer()
		}
		.transition(.opacity)
		.onAppear {
			withAnimation(Animation.easeOut(duration: 1).delay(animationDelay)) {
				isAnimated = true
			}
		}
		.zIndex(3)
	}
}

struct HappyState: View {
	@State var isBigAppeared: Bool = false
	@State var isSmallAppeared: Bool = false
	@State var bigRotate: Bool = false
	@State var smallRotate: Bool = false
	
	@State var bigOffsetX: CGFloat = 0
	@State var bigOffsetY: CGFloat = 0
	@State var smallOffsetX: CGFloat = 0
	@State var smallOffsetY: CGFloat = 0
	
	let bigScaleFactor: CGFloat = 1
	let smallScaleFactor: CGFloat = 0.6
	let rotationAngle: Double = 360
	
	var baseSize: CGFloat
	
	var body: some View {
		ZStack {
			Circle()
				.strokeBorder(lineWidth: 25 / bigScaleFactor)
				.foregroundColor(greenColor)
				.frame(width: baseSize, height: baseSize)
				.shadow(color: greenColor.opacity(0.5), radius: 60, x: 0, y: 0)
				.scaleEffect(bigScaleFactor)
				.rotationEffect(.degrees(bigRotate ? rotationAngle : 0), anchor: .init(x: 0.6, y: 0.6))
				.onAppear() {
					withAnimation(.linear(duration: 120).repeatForever(autoreverses: false)) {
						bigRotate.toggle()
					}
				}
				.transition(.scale)
				.offset(x: bigOffsetX, y: bigOffsetY)
			
			Circle()
				.strokeBorder(lineWidth: 25 / smallScaleFactor)
				.foregroundColor(greenColor)
				.frame(width: baseSize, height: baseSize)
				.shadow(color: greenColor.opacity(0.5), radius: 60, x: 0, y: 0)
				.scaleEffect(smallScaleFactor)
				.rotationEffect(.degrees(smallRotate ? rotationAngle : 0), anchor: .init(x: 0.4, y: 0.4))
				.onAppear() {
					withAnimation(.linear(duration: 100).repeatForever(autoreverses: false)) {
						smallRotate.toggle()
					}
				}
				.transition(.scale)
				.offset(x: smallOffsetX, y: smallOffsetY)
		}
		.onAppear() {
			bigOffsetX = CGFloat.random(in: 0...200)
			bigOffsetY = CGFloat.random(in: -400 ...  -200)
			smallOffsetX = CGFloat.random(in: -200...0)
			smallOffsetY = CGFloat.random(in: -200...100)
		}
		.transition(.scale)
		.zIndex(1)
	}
}

struct CalmState: View {
	@State private var isBigAppeared: Bool = false
	@State private var isSmallAppeared: Bool = false
	@State private var bigRotate: Bool = false
	@State private var smallRotate: Bool = false
	
	@State var bigOffsetX: CGFloat = 0
	@State var bigOffsetY: CGFloat = 0
	@State var smallOffsetX: CGFloat = 0
	@State var smallOffsetY: CGFloat = 0
	
	let bigScaleFactor: CGFloat = 1
	let smallScaleFactor: CGFloat = 0.7
	let rotationAngle: Double = 360
	
	var baseSize: CGFloat
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 3 * 25 / bigScaleFactor, style: .continuous)
				.stroke(lineWidth: 25 / bigScaleFactor)
				.foregroundColor(blueColor)
				.frame(width: baseSize, height: baseSize)
				.shadow(color: blueColor.opacity(0.5), radius: 60, x: 0, y: 0)
				.scaleEffect(bigScaleFactor)
				.rotationEffect(.degrees(bigRotate ? rotationAngle : 0))
				.offset(x: bigOffsetX, y: bigOffsetY)
				.onAppear() {
					withAnimation(.linear(duration: 120).repeatForever(autoreverses: false)) {
						bigRotate.toggle()
					}
				}
				.transition(.scale)
			
			RoundedRectangle(cornerRadius: 3 * 25 / smallScaleFactor, style: .continuous)
				.stroke(lineWidth: 25 / smallScaleFactor)
				.foregroundColor(blueColor)
				.frame(width: baseSize, height: baseSize)
				.shadow(color: blueColor.opacity(0.5), radius: 60, x: 0, y: 0)
				.scaleEffect(smallScaleFactor)
				.rotationEffect(.degrees(smallRotate ? rotationAngle : 0))
				.offset(x: smallOffsetX, y: smallOffsetY)
				.onAppear() {
					withAnimation(.linear(duration: 100).repeatForever(autoreverses: false)) {
						smallRotate.toggle()
					}
				}
				.transition(.scale)
		}
		.onAppear() {
			bigOffsetX = CGFloat.random(in: 0...200)
			bigOffsetY = CGFloat.random(in: -400 ...  -200)
			smallOffsetX = CGFloat.random(in: -200...0)
			smallOffsetY = CGFloat.random(in: -200...100)
		}
		.transition(.scale)
		.zIndex(1)
	}
}

struct WorriedState: View {
	@State private var isBigAppeared: Bool = false
	@State private var isSmallAppeared: Bool = false
	@State private var bigRotate: Bool = false
	@State private var smallRotate: Bool = false
	
	@State var bigOffsetX: CGFloat = 0
	@State var bigOffsetY: CGFloat = 0
	@State var smallOffsetX: CGFloat = 0
	@State var smallOffsetY: CGFloat = 0
	
	let bigScaleFactor: CGFloat = 1
	let smallScaleFactor: CGFloat = 0.7
	let rotationAngle: Double = 360
	
	var baseSize: CGFloat
	
	var body: some View {
		ZStack {
			Rectangle()
				.stroke(lineWidth: 25 / bigScaleFactor)
				.foregroundColor(yellowColor)
				.frame(width: baseSize, height: baseSize)
				.shadow(color: yellowColor.opacity(0.5), radius: 60, x: 0, y: 0)
				.scaleEffect(bigScaleFactor)
				.rotationEffect(.degrees(bigRotate ? rotationAngle : 0))
				.offset(x: bigOffsetX, y: bigOffsetY)
				.onAppear() {
					withAnimation(.linear(duration: 120).repeatForever(autoreverses: false)) {
						bigRotate.toggle()
					}
				}
				.transition(.scale)
			
			Rectangle()
				.stroke(lineWidth: 25 / smallScaleFactor)
				.foregroundColor(yellowColor)
				.frame(width: baseSize, height: baseSize)
				.shadow(color: yellowColor.opacity(0.5), radius: 60, x: 0, y: 0)
				.scaleEffect(smallScaleFactor)
				.rotationEffect(.degrees(smallRotate ? rotationAngle : 0))
				.offset(x: smallOffsetX, y: smallOffsetY)
				.onAppear() {
					withAnimation(.linear(duration: 100).repeatForever(autoreverses: false)) {
						smallRotate.toggle()
					}
				}
				.transition(.scale)
		}
		.onAppear() {
			bigOffsetX = CGFloat.random(in: 0...200)
			bigOffsetY = CGFloat.random(in: -400 ...  -200)
			smallOffsetX = CGFloat.random(in: -200...0)
			smallOffsetY = CGFloat.random(in: -200...100)
		}
		.transition(.scale)
		.zIndex(1)
	}
}

struct BadState: View {
	@State private var isBigAppeared: Bool = false
	@State private var isSmallAppeared: Bool = false
	@State private var bigRotate: Bool = false
	@State private var smallRotate: Bool = false
	
	@State var bigOffsetX: CGFloat = 0
	@State var bigOffsetY: CGFloat = 0
	@State var smallOffsetX: CGFloat = 0
	@State var smallOffsetY: CGFloat = 0
	
	let bigScaleFactor: CGFloat = 1
	let smallScaleFactor: CGFloat = 0.7
	let rotationAngle: Double = 360
	
	var baseSize: CGFloat
	
	var body: some View {
		ZStack {
			Path { path in
				path.move(to: CGPoint(x: 0, y: 0))
				path.addLine(to: CGPoint(x: baseSize, y: 0))
				path.addLine(to: CGPoint(x: baseSize / 2, y: baseSize * (sqrt(3) / 2)))
				path.closeSubpath()
			}
				.stroke(lineWidth: 25 / bigScaleFactor)
				.foregroundColor(redColor)
				.frame(width: baseSize, height: baseSize)
				.shadow(color: redColor.opacity(0.5), radius: 60, x: 0, y: 0)
				.scaleEffect(bigScaleFactor)
				.rotationEffect(.degrees(bigRotate ? rotationAngle : 0))
				.offset(x: bigOffsetX, y: bigOffsetY)
				.onAppear() {
					withAnimation(.linear(duration: 120).repeatForever(autoreverses: false)) {
						bigRotate.toggle()
					}
				}
				.transition(.scale)
			
			Path { path in
				path.move(to: CGPoint(x: 0, y: 0))
				path.addLine(to: CGPoint(x: baseSize, y: 0))
				path.addLine(to: CGPoint(x: baseSize / 2, y: baseSize * (sqrt(3) / 2)))
				path.closeSubpath()
			}
				.stroke(lineWidth: 25 / smallScaleFactor)
				.foregroundColor(redColor)
				.frame(width: baseSize, height: baseSize)
				.shadow(color: redColor.opacity(0.5), radius: 60, x: 0, y: 0)
				.scaleEffect(smallScaleFactor)
				.rotationEffect(.degrees(smallRotate ? rotationAngle : 0))
				.offset(x: smallOffsetX, y: smallOffsetY)
				.onAppear() {
					withAnimation(.linear(duration: 100).repeatForever(autoreverses: false)) {
						smallRotate.toggle()
					}
				}
				.transition(.scale)
		}
		.onAppear() {
			bigOffsetX = CGFloat.random(in: 0...200)
			bigOffsetY = CGFloat.random(in: -400 ...  -200)
			smallOffsetX = CGFloat.random(in: -200...0)
			smallOffsetY = CGFloat.random(in: -200...100)
		}
		.transition(.scale)
		.zIndex(1)
	}
}

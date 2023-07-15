//
//  TypeInForm.swift
//  moonar
//
//  Created by Владислав Калиниченко on 09.04.2022.
//

import SwiftUI

struct WaveForms: View {
	@State var offsetX: CGFloat
	@State var width: CGFloat
	@Binding var color: Color
	@Binding var isPaused: Bool
	
	var body: some View {
		HStack(spacing: width / 66) {
			Image(systemName: "waveform")
				.resizable()
				.foregroundColor(color)
				.frame(width: width / 4 - 20, height: width / 4 - 20)
			Image(systemName: "waveform")
				.resizable()
				.foregroundColor(color)
				.frame(width: width / 4 - 20, height: width / 4 - 20)
			Image(systemName: "waveform")
				.resizable()
				.foregroundColor(color)
				.frame(width: width / 4 - 20, height: width / 4 - 20)
			Image(systemName: "waveform")
				.resizable()
				.foregroundColor(color)
				.frame(width: width / 4 - 20, height: width / 4 - 20)
			Image(systemName: "waveform")
				.resizable()
				.foregroundColor(color)
				.frame(width: width / 4 - 20, height: width / 4 - 20)
			Image(systemName: "waveform")
				.resizable()
				.foregroundColor(color)
				.frame(width: width / 4 - 20, height: width / 4 - 20)
			Image(systemName: "waveform")
				.resizable()
				.foregroundColor(color)
				.frame(width: width / 4 - 20, height: width / 4 - 20)
			Image(systemName: "waveform")
				.resizable()
				.foregroundColor(color)
				.frame(width: width / 4 - 20, height: width / 4 - 20)
			Image(systemName: "waveform")
				.resizable()
				.foregroundColor(color)
				.frame(width: width / 4 - 20, height: width / 4 - 20)
		}
		.offset(x: offsetX)
		.mask {
			Rectangle()
				.frame(width: width, height: width / 4 - 20)
		}
		.onAppear() {
			if isPaused {
				withAnimation(.easeIn(duration: 0.01)) {
					offsetX = 0
				}
			}
			else {
				withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
					offsetX = (width / 4 - 20) + (width / 66)
				}
			}
		}
		.onChange(of: isPaused) { value in
			if isPaused {
				withAnimation(.linear(duration: 0.01)) {
					offsetX = 0
				}
			}
			else {
				withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
					offsetX = (width / 4 - 20) + (width / 66)
				}
			}
		}
	}
}

struct BigTypeInForm: View {
	@Binding var text: String
	@Binding var audioName: String
	@State var value: CGFloat = 0
	@State private var isAudio = false
	@State private var isPaused = false
	@Binding var color: Color
	@Binding var textColor: Color
	@Binding var session: SessionNames
	@Binding var stage: Int
	var action: () -> Void
	@State private var width: CGFloat = 0
	@State private var offsetX: CGFloat = 0
	@EnvironmentObject var audioController: AudioViewModel
	@EnvironmentObject var boolState: BoolStates
	@FocusState private var isFocused: Bool
	
	var body: some View {
		VStack {
			Spacer()
			ZStack {
				if !isAudio {
					HStack(spacing: 0) {
						GeometryReader { geo in
							TextEditor(text: $text)
								.padding(20)
								.onAppear {
									UITextView.appearance().backgroundColor = .clear
									width = geo.size.width
								}
								.focused($isFocused)
								.onTapGesture {
									isFocused.toggle()
								}
								.foregroundColor(Color.white)
								.font(.title3.weight(.medium))
								.background(
									RoundedRectangle(cornerRadius: 15)
										.stroke(color, lineWidth: 15)
										.background(Color.black)
								)
								.cornerRadius(15)
						}
							.padding([.leading, .vertical])
						
						VStack(spacing: 0) {
							Button(action: {
								if text != "" {
									action()
								}
							}) {
								VStack() {
									Spacer()
									Image(systemName: "arrow.right")
										.font(.title.weight(.bold))
										.frame(width: 30, height: 30)
									Spacer()
								}
								.padding(20)
								.background(color)
							}
							.foregroundColor(textColor)
							.cornerRadius(15)
							.padding()
							.buttonStyle(OnTapButtonState(newTextColor: textColor))
							
							Button(action: { () -> Void in
								if self.value == 0 {
									isPaused = false
									isAudio = true
									audioController.startRecordingAudio(session: session.rawValue, stage: stage)
								}
							}) {
								VStack() {
									Image(systemName: "mic.fill")
										.font(.title.weight(.bold))
										.frame(width: 30, height: 30)
								}
								.padding(20)
								.background(color)
							}
							.foregroundColor(textColor)
							.cornerRadius(15)
							.padding([.horizontal, .bottom])
							.buttonStyle(OnTapButtonState(newTextColor: textColor))
						}
					}
				}
				else {
					HStack(spacing: 0) {
						VStack(alignment: .trailing, spacing: 0) {
							TextEditor(text: $text)
								.padding(20)
								.onAppear {
									UITextView.appearance().backgroundColor = .clear
								}
								.foregroundColor(Color.white)
								.font(.title3.weight(.medium))
								.background(
									RoundedRectangle(cornerRadius: 15)
										.stroke(color, lineWidth: 15)
										.background(Color.black)
								)
								.cornerRadius(15)
								.padding([.leading, .vertical])
							
							ZStack {
								Rectangle()
									.frame(width: width, height: width / 4)
									.overlay(WaveForms(offsetX: self.offsetX, width: self.width, color: $color, isPaused: $isPaused), alignment: .leading)
									.offset(x: -(width / 3) - 20)
									.foregroundColor(Color.black)
								
								HStack(alignment: .center) {
									Fading(baseWidthSize: width / 4, baseHeightSize: width / 4 - 20)
										.rotationEffect(Angle(degrees: 180))
										.colorInvert()
									Spacer()
									Fading(baseWidthSize: width / 4, baseHeightSize: width / 4 - 20)
										.colorInvert()
								}
							}
						}
						
						VStack(alignment: .leading, spacing: 0) {
							Button(action: { () -> Void in
								isAudio.toggle()
								audioController.abortRecordingAudio()
							}) {
								VStack() {
									Image(systemName: "arrow.down")
										.font(.title.weight(.bold))
										.frame(width: 30, height: 30)
								}
								.padding(.horizontal, 20)
								.padding(.vertical, 15)
								.background(color)
							}
							.foregroundColor(textColor)
							.cornerRadius(15)
							.padding()
							.buttonStyle(OnTapButtonState(newTextColor: textColor))
							
							Button(action: {
								if isPaused {
									audioController.resumeRecordingAudio()
								}
								else {
									audioController.pauseRecordingAudio()
								}
								
								isPaused.toggle()
							}) {
								VStack() {
									Image(systemName: isPaused ? "play.fill" : "pause")
										.font(.title.weight(.bold))
										.frame(width: 30, height: 30)
								}
								.padding(.horizontal, 20)
								.padding(.vertical, 15)
								.background(color)
							}
							.foregroundColor(textColor)
							.cornerRadius(15)
							.padding([.horizontal, .bottom])
							.buttonStyle(OnTapButtonState(newTextColor: textColor))
							
							Button(action: {
								text = ""
								audioName = audioController.stopRecordingAudio()
								boolState.AudioBoolList.append(false)
								boolState.AudioIsPlayingList.append(false)
								
								isAudio = false
								
								action()
							}) {
								VStack() {
									Spacer()
									Image(systemName: "arrow.right")
										.font(.title.weight(.bold))
										.frame(width: 30, height: 30)
									Spacer()
								}
								.padding(20)
								.background(color)
							}
							.foregroundColor(textColor)
							.cornerRadius(15)
							.padding([.horizontal, .bottom])
							.buttonStyle(OnTapButtonState(newTextColor: textColor))
						}
					}
				}
			}
			.frame(height: 270.0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 150)
			.shadow(color: Color.black, radius: 50, x: 0, y: 150)
			.shadow(color: Color.black, radius: 50, x: 0, y: 150)
			.offset(y: -self.value / 1000)
			.onAppear() {
				NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
					let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
					let height = value.height
					self.value = height
					
					isAudio = false
				}
				
				NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
					
					self.value = 0
				}
			}
		}
		.transition(.move(edge: .bottom).combined(with: .opacity))
		.zIndex(4)
	}
}

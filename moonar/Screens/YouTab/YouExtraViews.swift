//
//  YouExtraViews.swift
//  moonar
//
//  Created by Владислав Калиниченко on 15.06.2022.
//

import SwiftUI

struct ShortTextThought: View {
	var text: String
	
	var body: some View {
		ZStack(alignment: .leading) {
			RoundedRectangle(cornerRadius: 10)
				.stroke(lineWidth: 7)
				.foregroundColor(Color.white)
				.frame(minHeight: 100)
				.padding(.horizontal, 20)
				.padding(.vertical, 10)
			VStack(spacing: 0) {
				Text(text)
					.foregroundColor(Color.white)
					.padding(30)
					.font(.title3.weight(.medium))
					.lineLimit(3)
					.multilineTextAlignment(.leading)
				Spacer()
			}
		}
	}
}

struct TextThoughtWidget: View {
	let name: String
	@EnvironmentObject var textList: TextThoughtViewModel
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text(name)
				.foregroundColor(Color.white)
				.padding(.leading, 20)
				.font(.title.weight(.heavy))
			ZStack {
				ScrollView(showsIndicators: false) {
					Color(.clear)
						.frame(height: 10)
					
					if textList.fetchedEntitiesAsStrings.count == 0 {
						VStack {
							Spacer()
							Text("Your typed thoughts are added here. Start talking with moonar to have thoughts appeared here.")
								.foregroundColor(Color.white)
								.font(.body)
								.padding()
							Spacer()
						}
					}
					else {
						ForEach((0..<Int(textList.fetchedEntitiesAsStrings.count)).reversed(), id: \.self) { i in
							if String(textList.fetchedEntitiesAsStrings[i].split(separator: "-")[1]) != String(textList.fetchedEntitiesAsStrings[min(i + 1, Int(textList.fetchedEntitiesAsStrings.count) - 1)].split(separator: "-")[1]) || i == Int(textList.fetchedEntitiesAsStrings.count) - 1 {
								Text(textList.fetchedEntitiesAsStrings[i].split(separator: "-")[1].description.replacingOccurrences(of: ":", with: "."))
									.padding()
									.font(.title3.weight(.medium))
									.foregroundColor(Color.white)
							}
							
							ShortTextThought(text: String(textList.fetchedEntitiesAsStrings[i].split(separator: "-", maxSplits: 5)[5]))
							
							if String(textList.fetchedEntitiesAsStrings[i].split(separator: "-")[4]) == "0" {
								Color(.clear)
									.frame(height: 20)
							}
						}
					}
					
					Color(.clear)
						.frame(height: 10)
				}
				.aspectRatio(1, contentMode: .fit)
				.padding([.horizontal, .bottom], 27)
				.padding(.top, 17)
				.background(
					RoundedRectangle(cornerRadius: 20)
						.strokeBorder(lineWidth: 7)
						.foregroundColor(Color.white)
						.padding([.horizontal, .bottom], 20)
						.padding(.top, 10)
				)
			}
		}
		.onAppear() {
			textList.fetchEntities()
		}
	}
}

struct ShortAudioThought: View {
	var id: Int
	@Binding var duration: Double
	@Binding var currentTime: Double
	@EnvironmentObject var audioList: AudioThoughtViewModel
	@EnvironmentObject var boolState: BoolStates
	@EnvironmentObject var audioController: AudioViewModel
	
	var body: some View {
		ZStack(alignment: .leading) {
			RoundedRectangle(cornerRadius: 10)
				.stroke(lineWidth: 7)
				.foregroundColor(Color.white)
				.frame(height: 100)
				.padding(.horizontal, 20)
				.padding(.vertical, 10)
			HStack {
				VStack(spacing: 0) {
					Spacer()
					Button(action: { () -> Void in
						var tmpBool = boolState.AudioBoolList[id]
						tmpBool.toggle()
						for i in 0..<boolState.AudioBoolList.count {
							boolState.AudioBoolList[i] = false
						}
						boolState.AudioBoolList[id] = tmpBool
						
						for i in 0..<boolState.AudioIsPlayingList.count {
							if i != id {
								boolState.AudioIsPlayingList[i] = false
							}
						}
												
						if boolState.AudioIsPlayingList[id] == false {
							currentTime = 0
							
							duration = abs(audioController.playbackAudio(name: audioList.fetchedEntitiesAsStrings[id]) - 0.2)
							
							Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
								withAnimation(.linear(duration: 0.1)) {
									currentTime = audioController.currentTime()
								}
								
								if boolState.AudioIsPlayingList[id] == false || boolState.AudioBoolList[id] == false {
									timer.invalidate()
								}
							})
							
							boolState.AudioIsPlayingList[id] = true
						}
						else {
							if audioController.isPlaying() {
								audioController.pauseAudioPlayback()
							}
							else {
								audioController.resumeAudioPlayback()
								
								Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
									withAnimation(.linear(duration: 0.1)) {
										currentTime = audioController.currentTime()
									}
									
									if boolState.AudioIsPlayingList[id] == false || boolState.AudioBoolList[id] == false {
										timer.invalidate()
									}
								})
							}
						}
						
						NotificationCenter.default.addObserver(forName: NSNotification.Name("Finish"), object: nil, queue: .main, using: { _ in
							boolState.AudioIsPlayingList[id] = false
							boolState.AudioBoolList[id] = false
							
							currentTime = 0
						})
					}) {
						Image(systemName: boolState.AudioBoolList[id] ? "pause.circle.fill" : "play.circle.fill")
							.padding(.leading, 30)
							.font(.system(size: 50))
							.foregroundColor(Color.white)
					}
					Spacer()
				}
				
				ZStack(alignment: .leading) {
					GeometryReader { geo in
						Rectangle()
							.foregroundColor(darkGrayColor)
							.padding([.trailing, .vertical], 35)
						if boolState.AudioIsPlayingList.firstIndex(of: true) == id {
							Rectangle()
								.foregroundColor(Color.white)
								.frame(width: abs(geo.size.width - 35) * CGFloat((currentTime / duration)))
								.padding(.vertical, 35)
						}
					}
				}
				.mask {
					RoundedRectangle(cornerRadius: 15)
						.padding([.trailing, .vertical], 35)
				}
			}
		}
	}
}

struct AudioThoughtWidget: View {
	let name: String
	@Binding var duration: Double
	@Binding var currentTime: Double
	@EnvironmentObject var audioList: AudioThoughtViewModel
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text(name)
				.foregroundColor(Color.white)
				.padding(.leading, 20)
				.font(.title.weight(.heavy))
			ZStack {
				ScrollView(showsIndicators: false) {
					Color(.clear)
						.frame(height: 10)
					
					if audioList.fetchedEntitiesAsStrings.count == 0 {
						VStack {
							Spacer()
							Text("Your voice thoughts are added here. Start talking with moonar to have thoughts appeared here.")
								.foregroundColor(Color.white)
								.font(.body)
								.padding()
							Spacer()
						}
					}
					else {
						ForEach((0..<Int(audioList.fetchedEntitiesAsStrings.count)).reversed(), id: \.self) { i in
							if String(audioList.fetchedEntitiesAsStrings[i].split(separator: "-")[1]) != String(audioList.fetchedEntitiesAsStrings[min(i + 1, Int(audioList.fetchedEntitiesAsStrings.count) - 1)].split(separator: "-")[1]) || i == Int(audioList.fetchedEntitiesAsStrings.count) - 1 {
								Text(audioList.fetchedEntitiesAsStrings[i].split(separator: "-")[1].description.replacingOccurrences(of: ":", with: "."))
									.padding()
									.font(.title3.weight(.medium))
									.foregroundColor(Color.white)
							}
							
							ShortAudioThought(id: i, duration: $duration, currentTime: $currentTime)
							
							if String(audioList.fetchedEntitiesAsStrings[i].split(separator: "-")[4]) == "0" {
								Color(.clear)
									.frame(height: 20)
							}
						}
					}
					
					Color(.clear)
						.frame(height: 10)
				}
				.aspectRatio(1, contentMode: .fit)
				.padding([.horizontal, .bottom], 27)
				.padding(.top, 17)
				.background(
					RoundedRectangle(cornerRadius: 20)
						.strokeBorder(lineWidth: 7)
						.foregroundColor(Color.white)
						.padding([.horizontal, .bottom], 20)
						.padding(.top, 10)
				)
			}
		}
		.onAppear() {
			audioList.fetchEntities()
		}
	}
}

struct ShortAdvice: View {
	let text: String
	
	var body: some View {
		ZStack(alignment: .leading) {
			RoundedRectangle(cornerRadius: 10)
				.stroke(lineWidth: 7)
				.foregroundColor(Color.white)
				.frame(minHeight: 100)
				.padding(.horizontal, 20)
				.padding(.vertical, 10)
			HStack {
				VStack(spacing: 0) {
					Image(systemName: "quote.bubble.fill")
						.padding([.top, .leading], 30)
						.padding(.trailing, 10)
						.scaleEffect(1.5)
						.foregroundColor(Color.white)
					Spacer()
				}
				VStack(spacing: 0) {
					Text(text)
						.foregroundColor(Color.white)
						.padding([.vertical, .trailing], 30)
						.font(.title3.weight(.medium))
						.lineLimit(3)
						.multilineTextAlignment(.leading)
					Spacer()
				}
			}
		}
	}
}

struct AdviceWidget: View {
	let name: String
	@EnvironmentObject var adviceList: AdviceViewModel
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text(name)
				.foregroundColor(Color.white)
				.padding(.leading, 20)
				.font(.title.weight(.heavy))
			ZStack {
				ScrollView(showsIndicators: false) {
					Color(.clear)
						.frame(height: 10)
					
					if adviceList.fetchedEntitiesAsStrings.count == 0 {
						VStack {
							Spacer()
							Text("moonar automatically adds advices and callouts from therapy sessions. These are useful to be seen time to time.")
								.foregroundColor(Color.white)
								.font(.body)
								.padding()
							Spacer()
						}
					}
					else {
						ForEach(adviceList.fetchedEntitiesAsStrings, id: \.self) { text in
							ShortAdvice(text: text)
						}
					}
					
					Color(.clear)
						.frame(height: 10)
				}
				.aspectRatio(1, contentMode: .fit)
				.padding([.horizontal, .bottom], 27)
				.padding(.top, 17)
				.background(
					RoundedRectangle(cornerRadius: 20)
						.strokeBorder(lineWidth: 7)
						.foregroundColor(Color.white)
						.padding([.horizontal, .bottom], 20)
						.padding(.top, 10)
				)
			}
		}
		.onAppear() {
			adviceList.fetchEntities()
		}
	}
}

struct ShortTask: View {
	let text: String
	let id: Int
	@EnvironmentObject var boolState: TaskViewModel

	var body: some View {
		ZStack(alignment: .leading) {
			RoundedRectangle(cornerRadius: 10)
				.stroke(lineWidth: 7)
				.foregroundColor(Color.white)
				.frame(minHeight: 50)
				.padding(.horizontal, 20)
				.padding(.vertical, 10)
			HStack {
				VStack(spacing: 0) {
					Spacer()
					Button(action: {
						boolState.tickTask(id: id)
					}) {
						Image(systemName: boolState.fetchedEntitiesAsBooleans[id] ? "checkmark.circle.fill" : "checkmark.circle")
							.padding(.leading, 30)
							.padding(.trailing, 10)
							.scaleEffect(1.5)
							.foregroundColor(Color.white)
					}
					Spacer()
				}
				VStack(spacing: 0) {
					Text(text)
						.foregroundColor(Color.white)
						.padding([.vertical, .trailing], 25)
						.font(.title3.weight(.medium))
						.lineLimit(1)
						.multilineTextAlignment(.leading)
				}
			}
		}
		.onAppear() {
			boolState.fetchEntities()
		}
	}
}

struct TaskWidget: View {
	let name: String
	@EnvironmentObject var taskList: TaskViewModel
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text(name)
				.foregroundColor(Color.white)
				.padding(.leading, 20)
				.font(.title.weight(.heavy))
			
			ZStack {
				ScrollView(showsIndicators: false) {
					Color(.clear)
						.frame(height: 10)
					
					if taskList.fetchedEntitiesAsStrings.count == 0 {
						VStack {
							Spacer()
							Text("moonar automatically adds tasks for you from therapy sessions. Try to execute these to get better after therapies.")
								.foregroundColor(Color.white)
								.font(.body)
								.padding()
							Spacer()
						}
					}
					else {
						ForEach(taskList.fetchedEntitiesAsStrings.indices, id: \.self) { i in
							ShortTask(text: taskList.fetchedEntitiesAsStrings[i], id: i)
						}
					}
					
					Color(.clear)
						.frame(height: 10)
				}
				.aspectRatio(1, contentMode: .fit)
				.padding([.horizontal, .bottom], 27)
				.padding(.top, 17)
				.background(
					RoundedRectangle(cornerRadius: 20)
						.strokeBorder(lineWidth: 7)
						.foregroundColor(Color.white)
						.padding([.horizontal, .bottom], 20)
						.padding(.top, 10)
				)
			}
		}
		.onAppear() {
			taskList.fetchEntities()
		}
	}
}

struct EmotionBar: View {
	var emotion: String
	var number: CGFloat
	var maxNumber: CGFloat
	
	func color(emotion: String) -> Color {
		switch emotion {
			case "happiness_filled", "admiration_filled":
				return greenColor
			case "worryness_filled":
				return yellowColor
			case "anger_filled":
				return redColor
			default:
				return blueColor
		}
	}
	
	var body: some View {
		HStack(alignment: .top) {
			Image(emotion)
				.resizable()
				.frame(width: 35, height: 35)
				.padding(.leading, 20)
				.padding(.trailing, 0)
			GeometryReader { geo in
				ZStack(alignment: .leading) {
					Capsule()
						.foregroundColor(darkGrayColor)
						.frame(height: 15)
					Capsule()
						.foregroundColor(color(emotion: emotion))
						.frame(width: max(geo.size.width - 20, 0) / maxNumber * number, height: 15)
				}
				.padding(.vertical ,geo.size.height / 3)
				.padding(.trailing, 20)
			}
		}
		.padding(.vertical)
	}
}

struct EmotionWidget: View {
	let name: String
	let emojiList: [String]
	
	func getMaxNumber() -> Double {
		var max: Double = 1
		
		for keyName in EmotionsUbiquitousKeys {
			if NSUbiquitousKeyValueStore.default.double(forKey: keyName) > max {
				max = NSUbiquitousKeyValueStore.default.double(forKey: keyName)
			}
		}
		
		return max
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text(name)
				.foregroundColor(Color.white)
				.padding(.leading, 20)
				.font(.title.weight(.heavy))
			
			ZStack {
				ScrollView(showsIndicators: false) {
					ForEach(0..<6) { i in
						EmotionBar(emotion: emojiList[i], number: CGFloat(NSUbiquitousKeyValueStore.default.double(forKey: EmotionsUbiquitousKeys[i])), maxNumber: CGFloat(getMaxNumber()))
					}
					.padding(.vertical, 30)
				}
				.aspectRatio(1, contentMode: .fit)
				.padding([.horizontal, .bottom], 27)
				.padding(.top, 17)
				.background(
					RoundedRectangle(cornerRadius: 20)
						.strokeBorder(lineWidth: 7)
						.foregroundColor(Color.white)
						.padding([.horizontal, .bottom], 20)
						.padding(.top, 10)
				)
			}
		}
	}
}

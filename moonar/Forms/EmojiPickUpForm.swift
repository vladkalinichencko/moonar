//
//  EmojiPickUpForm.swift
//  moonar
//
//  Created by Владислав Калиниченко on 07.05.2022.
//

import SwiftUI

struct EmojiPicker: View {
	@Binding var color: Color
	@Binding var textColor: Color
	@Binding var isSelected: [Bool]
	let emojiSigns: [String]
	let id: Int
	
	var body: some View {
		Button(action: { () -> Void in
			for i in 0..<6 {
				if i != id {
					isSelected[i] = false
				}
				else {
					isSelected[i] = true
				}
			}
		}) {
			ZStack {
				Circle()
					.strokeBorder(lineWidth: 10)
					.aspectRatio(1, contentMode: .fit)
					.foregroundColor(isSelected[id] ? color : Color.gray)
					.padding(10)
				Image(emojiSigns[id])
					.resizable()
					.frame(width: 70, height: 70)
			}
		}
		.buttonStyle(OnTapButtonState(newTextColor: textColor))
	}
}

struct EmojiPickUpForm: View {
	@Binding var color: Color
	@Binding var textColor: Color
	@Binding var itemsSelected: [Bool]
	let emojiOptions: [String]
	var action: () -> Void
	
	var body: some View {
		GeometryReader { geo in
			VStack {
				Spacer()
				VStack(spacing: 0) {
					HStack(spacing: 0) {
						EmojiPicker(color: $color, textColor: $textColor, isSelected: $itemsSelected, emojiSigns: emojiOptions, id: 0)
						EmojiPicker(color: $color, textColor: $textColor, isSelected: $itemsSelected, emojiSigns: emojiOptions, id: 1)
						EmojiPicker(color: $color, textColor: $textColor, isSelected: $itemsSelected, emojiSigns: emojiOptions, id: 2)
					}
					HStack(spacing: 0) {
						EmojiPicker(color: $color, textColor: $textColor, isSelected: $itemsSelected, emojiSigns: emojiOptions, id: 3)
						EmojiPicker(color: $color, textColor: $textColor, isSelected: $itemsSelected, emojiSigns: emojiOptions, id: 4)
						EmojiPicker(color: $color, textColor: $textColor, isSelected: $itemsSelected, emojiSigns: emojiOptions, id: 5)
					}
				}
				.padding(10)

				InFormButtonForm(
					color: $color,
					textColor: $textColor,
					text: controlLabels[5],
					action: {
						if itemsSelected.contains(true) {
							action()
						}
					}
				)
			}
			.zIndex(4)
			.shadow(color: Color.black, radius: 50, x: 0, y: 0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 150)
			.shadow(color: Color.black, radius: 50, x: 0, y: 150)
			.shadow(color: Color.black, radius: 50, x: 0, y: 150)
		}
		.transition(.move(edge: .bottom).combined(with: .opacity))
		.zIndex(4)
	}
}
 
struct EmojiPickUpForm_Previews: PreviewProvider {
	static var previews: some View {
		EmojiPickUpForm(
			color: .constant(Color.green),
			textColor: .constant(Color.white),
			itemsSelected: .constant([false, false, false, false, false, false]),
			emojiOptions: stateOptions,
			action: { () -> Void in}
		)
	}
}

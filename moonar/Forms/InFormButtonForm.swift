//
//  InFormButtonForm.swift
//  moonar
//
//  Created by Владислав Калиниченко on 20.05.2022.
//

import SwiftUI

struct InFormButtonForm: View {
	@Binding var color: Color
	@Binding var textColor: Color
	var text: String
	var action: () -> Void
	
	var body: some View {
		Button(action: action) {
			HStack {
				Spacer()
				Text(text)
					.font(.title)
					.fontWeight(.bold)
				
				Spacer()
			}
			.padding(25)
			.background(color)
		}
		.padding()
		.foregroundColor(textColor)
		.buttonStyle(OnTapButtonState(newTextColor: textColor))
	}
}

struct InFormButtonForm_Previews: PreviewProvider {
	static var previews: some View {
		InFormButtonForm(
			color: .constant(Color.white),
			textColor: .constant(Color.black),
			text: "Next",
			action: { () -> Void in }
		)
	}
}

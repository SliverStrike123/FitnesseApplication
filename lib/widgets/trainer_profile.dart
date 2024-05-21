import 'package:flutter/material.dart';

class TrainerProfile extends StatelessWidget {
  final String? name;
  final String? image;
  final String? phoneNumber;

  const TrainerProfile.summary({
    super.key,
    required this.name,
    required this.image,
  }) : phoneNumber = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print(image);
    return Stack(
      children: [
        if(image != null)
          Positioned(
            top: 15,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                image!,
              ),
              backgroundColor: theme.colorScheme.primary.withAlpha(180),
              radius: 50,
            ),
          ),
        Container(
          // Add some margin to the edges of the messages, to allow space for the
          // user's image.
          margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 25),
          child: Row(
            // The side of the chat screen the message should show at.
            mainAxisAlignment:
              MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                  CrossAxisAlignment.start,
                children: [
                  // First messages in the sequence provide a visual buffer at
                  // the top.
                  
                  if(name != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      // Only show the message bubble's "speaking edge" if first in
// the chain.
// Whether the "speaking edge" is on the left or right

                      // depends on whether or not the message bubble is the current user.
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    // Set some reasonable constraints on the width of the
                    // message bubble so it can adjust to the amount of text
                    // it should show.
                    constraints: const BoxConstraints(maxWidth: 200),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 14,
                    ),
                    // Margin around the bubble.
                    margin: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 12,
                    ),
                    child: Text(
                      name!,
                      style: const TextStyle(
                        // Add a little line spacing to make the text look nicer
// when multilined.     
                        fontSize: 20,
                        height: 1.3,
                        color: Colors.black,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Positioned(
          bottom: -5,
          left: 0,
          right: 0,
          child: Divider(
            color: Colors.black, // Change the color to black
            thickness: 2, // Set the thickness of the divider
          ),
        ),
      ],
    );
  }
}
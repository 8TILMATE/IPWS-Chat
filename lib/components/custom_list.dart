
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Widget? leading; // Optional leading widget
  final Text? title; // Required title text
  final Text? subTitle; // Optional subtitle text
  final Function? onTap; // Optional tap event handler

  final Widget? trailing; // Optional trailing widget
  final Color? tileColor; // Optional tile background color
  final double? height; // Required height for the custom list tile

  // Constructor for the custom list tile
  const CustomListTile({
    super.key,
    this.leading,
    required this.title,
    this.subTitle,
    required this.onTap,
    this.trailing,
    required this.tileColor,
    required this.height, // Make height required for clarity
  });

  @override
  Widget build(BuildContext context) {
    return Material( // Material design container for the list tile
      color: tileColor, // Set background color if provided
      child: InkWell( // Tappable area with event handlers
        onTap: () => onTap, // Tap event handler
        child: SizedBox( // Constrain the size of the list tile
          height: height, // Set custom height from constructor
          child: Row( // Row layout for list item content
            children: [
              Padding( // Padding for the leading widget
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: leading, // Display leading widget
              ),
              Expanded( // Expanded section for title and subtitle
                child: Column( // Column layout for title and subtitle
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text left
                  children: [
                    title ?? const SizedBox(), // Display title or empty space
                    const SizedBox(height: 10), // Spacing between title and subtitle
                    subTitle ?? const SizedBox(), // Display subtitle or empty space
                  ],
                ),
              ),
              Padding( // Padding for the trailing widget
                padding: const EdgeInsets.all(12.0),
                child: trailing, // Display trailing widget
              )
            ],
          ),
        ),
      ),
    );
  }
}
# NewsAPI App

This app uses NewsAPI to fetch and display news around the world.
It has the ability to filter through news based on keywords and/or dates.

## Getting Started

To use this app, create an `assets` folder at the root of the project, and place a file `api_key.txt` in this folder.
In the first line of this file, place your NewsAPI key.

## Note
When using the app, you may get error 404 on one (or more) of the images.
If you debug on VS Code with breakpoints on uncaught exceptions, your code will stop there, even if the part that's throwing the error is inside try&catch.
To prevent this issue, simply debug the app without breakpoints on uncaught exceptions.

## Dependencies
- dio
- hive
- flutter_bloc
- fluttertoast
- json_annotation
- json_serializable
- build_runner
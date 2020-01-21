# Dialogue Tree Editor

This is a dialogue tree editor for [Godot Open Dialogue](https://jsena42.bitbucket.io/god/) created by J.Sena

## Todo

* Make the program able to load exported dialogs
* Finish this readme

## Known Bugs

* With the change of handling names, they don't load.
* When a node created, they don't have any name assigned, and at save/export none get written in the json.
* Loading
  * There is some issue in the _connect_Nodes function
  * When loading a dialogue containing a first node, there is a different issue in the _on_Load_pressed function

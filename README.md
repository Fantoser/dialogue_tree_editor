# Dialogue Tree Editor

This is a dialogue tree editor for [Godot Open Dialogue](https://jsena42.bitbucket.io/god/) created by J.Sena

## Todo

* Make the program able to load exported dialogs
* Finish this readme

## Known Bugs

* When a node created, they don't have any name assigned despite the first item of the namelist can be seen, and at save/export none get written in the json.
* Question node save options as integer instead of string.
* Loading
  * There is some issue in the _connect_Nodes function
  * When loading a dialogue containing a first node, there is a different issue in the _on_Load_pressed function

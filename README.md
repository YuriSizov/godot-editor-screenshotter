# Editor Screenshotter concept

Take quick snaps of the Godot Editor's UI by using a round button at the top right corner or by pressing <kbd>F11</kbd>. You can use <kbd>Alt + F11</kbd> to take partial screenshots with a preview of an area to be snapped. In this mode use <kbd>PgUp</kbd> to expand the area to a parent node. Note that some parent nodes take exactly the same area as a child, and there are many intermediate nodes in Godot Editor's UI. Moving a mouse resets the area to the direct children under the cursor.

It is not popup friendly at the moment. It can take their images, but cannot highlight their parts.

It needs an `.output` folder at root to actually save images. It will err if there is no such directory.

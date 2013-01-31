require("gui.guiobject")

Menu = Class{inherits = GUIObject, function(self, parent, position, size, alignment, children)
    GUIObject.construct(self, parent, position, size, alignment, children)
end}

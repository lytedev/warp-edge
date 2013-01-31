require("utils")
require("hump.vector")
require("gui.label")

local titleVersionLabel = Label()
titleVersionLabel.font = fonts.pixelserif
titleVersionLabel.text = string.format("%s %s", config.title, config.identityVersion)
titleVersionLabel.color= {255, 255, 255, 50}
titleVersionLabel.activeColor = titleVersionLabel.color
titleVersionLabel.alignment = alignments.bottomleft
titleVersionLabel.position = vector(0, 10)

return titleVersionLabel

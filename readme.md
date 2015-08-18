# Screenshots

![Title screen][title_screen]

![Test level][test_level]

# TODOs

* Combat
* Player Sprite
* Warping!
* Simple Combat demo/level
* Expand! Skills? Enemies?
* Josh Koops for Story
* Serialization (Maybe boost?)
* Scene-oriented design of stuff
* Begin building assets, tools, worlds,

# Format Key

Documentation for the documentation isn't a good sign ;)

## Variable Indicators

<> - Required variable
[] - Optional variable
<[]> - Required if the following optional variable is specified
[<>] - Required if the previous optional variable is specified

## Variable Types

* $ - String
* # - Number
* ^ - Boolean ["true" | "false" (non-case-sensitive), ~0 or 0]
* * - Table (see variable name for type - example: animationFrame2 implies an AnimationFrame table)
* No Type - Must appear exactly as denoted (Example: [layer] indicates that the string "layer" at this point in the file is optional.)

## Variable Formats

<(type)(name)>
[(type)(name)]
<[(type)(name)]>

# File Formats

There are some custom file formats used by this project that are documented
below.

## AnimationFrame Format
<#sourceX>, <#sourceY>, [#width], [#height], [#offsetX], [#offsetY]

## AnimationSet Format

<$animationKey>
<*animationFrame1>
[*animationFrame2]
[*animationFrame3]
[*animationFrameN...]

## Tile Format

<$imageFile>, <$animationSet>, [$initialAnimationKey], [^solidity],
    [#overlayR], <[#overlayG]>, <[#overlayB]>, <[#overlayA]>

## Background Format

<$imageFile>, <$animationSet>, [#sizeX], [#sizeY], [$initialAnimationKey],
    [#slideX], [#slideY], [#parallax], [^flipX], [^flipY], [#offsetX], [#offsetY],
    [#overlayR], <[#overlayG]>, <[#overlayB]>, <[#overlayA]>

## GameObject Format

<$gameObjectFile>, [#positionX], [#positionY]

## Level Format

### Notes

- Blank lines seperate sections, so make note of them.
- Sections may appear in any order. Layers are added in the order given.

### Format

<#width>, <#height>, <#tilesize>
[*tileType1]
[*tileType2]
[*tileType3]
[*tileTypeN...]

[objects]
<[*gameObject1]>
[*gameObject2]
[*gameObject3]
[*gameObjectN...]

[backgrounds]
<[*background1]>
[*background2]
[*background3]
[*backgroundN...]

[foregrounds]
<[*foreground1]>
[*foreground2]
[*foreground3]
[*foregroundN...]

[layer]
<[#tileTypeId0by0]>, [#tileTypeId1by0], [#tileTypeId2by0], [#tileTypeIdN...by0]
[#tileTypeId0by1], [#tileTypeId1by1], [#tileTypeId2by1], [#tileTypeIdN...by1]
[#tileTypeId0by2], [#tileTypeId1by2], [#tileTypeId2by2], [#tileTypeIdN...by2]
[#tileTypeId0byN...], [#tileTypeId1byN...], [#tileTypeId2byN...], [#tileTypeIdN...byN...]

[imglayer], <[$imageFile]>
[#r1], <[#g1]>, <[#b1]>, <[#a1]>, <[#tileTypeId1]>
[#r2], <[#g2]>, <[#b2]>, <[#a2]>, <[#tileTypeId2]>
[#r3], <[#g3]>, <[#b3]>, <[#a3]>, <[#tileTypeId3]>
[#rN...], <[#gN...]>, <[#bN...]>, <[#aN...]>, <[#tileTypeIdN...]>


[test_level]: http://i.imgur.com/m3xr8Xq.png
[title_screen]: http://i.imgur.com/lM09KUW.png

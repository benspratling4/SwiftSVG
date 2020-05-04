# SwiftSVG
Pure-Swift parsing, drawing, exporting of static SVG.

WIP feel free to contribute.  I'm aiming at supporting parsing all SVG, but rendering only static, non-scripted files.  Something like "SVG Tiny".


## Reading SVG

TODO: Write methods which parse SVG and represent the data model as an SVGImage.

TODO: write code which can play back an SVGImage as drawing commands into any SwiftGraphcisCore.GraphicsContext

TODO: write a convenience init which can produce a SampledImage from an SVGImage at a chosen pizel/point resolution.


### Get a SwiftGraphicsCore.Path from an SVG "d" string:

`import SwiftGraphicsCore`

`import SwiftSVG`

`let path = try Path(svg_d:"M26.7,19.5c2.8,0.6,4.8,1.5,6.2,2.8z")`

TODO: add "arc" support.

## Writing to SVG

TODO: Implement a concrete SwiftGraphcisCore.GraphicsContext which records drawing commands and can export an SVGImage.


TODO: Write a method on SVGImage which can generate appropriate self-contained XML.


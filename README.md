# SwiftSVG
Pure-Swift parsing, drawing, exporting of static SVG.

WIP feel free to contribute.  I'm aiming at supporting parsing all SVG, but rendering only static, non-scripted files.  Something like "SVG Tiny".


## Agenda

Parse the SVG structural elements.

Focus on representing the SVG elements and attributes directly, init'ing from XMLItem, producing XMLItem with full round-trip support.

Next priority is drawing, be able to draw elements with explicit attributes. Fill √, stroke X

Handle replacing `<use>` with the identified element.  √

Add support for groups, transforms. - In progress

Then build out the full CSS mechanism.  X, [SwiftCSS](https://github.com/benspratling4/SwiftCSS) does exist, but is not applied

Add support for units, resolving length dimensions & percentages of viewport.  X

Once path supports all features of geometry styling, CSS, etc..., add other shape elements, circle, rect, ellipse, polyline, polygon, etc... X

Last, Build a fully-parsing implementation of SwiftTrueTypeFont, and implement text content elements.  X


## Reading SVG

Write methods which parse SVG and represent the data model as an SVGImage.

`let svgData:Data = "<svg ...>...</svg>".data(using:.utf8)!`

`let image:SVGImage? = SVGImage(data:svgData)`

Status: parses viewBox & preserveAspectRatio, defs, style, and children.


## Getting a raster image from an `SVGImage`

### Get a `SampledImage` (basically an image byte array,defined in [SwiftGraphicsCore](https://github.com/benspratling4/SwiftGraphicsCore)) from an `SVGImage`

`let svgImage:SVGImage = ...`

`let sampledImage:SampledImage = SampledImage(svgImage:svgImage)` 

A `SampledImage` can then be, for instance, turned into a *.png file with [`SwiftPNG`](https://github.com/benspratling4/SwiftPNG).


### Draw SVG images in other `GraphicsContext`s

Creating a `SampledImage` directly from an `SVGImage` is actually a convenience method.

It uses a `SampledGraphicsContext` and uses the underlying extension on `GraphicsContext` to resolve the structure and style of an SVGImge and produce drawing commands.

`import SwiftGraphicsCore`

`let context:GraphicsContext = ...`

`let image:SVGImage = ...`

`context.drawSVG(image, in:Rect(...)) `



## Writing to XML

Or you can construct an `SVGImage` by creating it in memory and setting its children & properties, or you can use a `SVGGraphicsContext` to capture drawing commands.

### Record from drawing commands

You can create an `SVGImage` from drawing commands on `GraphicsContext`, which is one of the main reasons `GraphicsContext` is a protocol and `SampledGraphicsContext` is just a conforming type. 

Instead of `SampledGraphicsContext`, create an `SVGGraphicsContext` and make drawing commands on it as you would have the `SampledGraphicsContext`.

Then ask for the `.svgImage` property of the context, which live-records you drawing commands.

There will be no styles or defs, except linear or radial gradients.  
`saveState()` `popState()` , and transforms get recorded as `<g>` elements.
All shapes will be `<path>` elements, not understood as `<circle>`, `<polygon>` or others.
All attributes will be directly on the elements.


### Exporting an `SVGImage` as XML

An `SVGImage` can be directly exported as-is to XML with  `XMLItem`, defined in [`SwiftPatterns`](https://github.com/benspratling4/SwiftPatterns).

`let svgImage:SVGImage = ...`

`let xml:Data? = svgImage.xmlItem.string.data(using:.utf8)`



## Element Statuses:

### `<svg>`
Supports `viewBox`, `defs` and `style` children, other defined drawable children.

### `<path>`
Supports `d` attribute, & fill, stroke algorithms are still very slow & imprecise.
gradient fills are in SwiftGraphicsCore, but not implemented here, yet.

### `<use>`
Supports `x`, `y`, `transform`

### `<defs>`
Supported

### `<g>`
In progress

### `<a>`
Not supproted yet

### Shape elements
The last step in development is to take all the lessons learned from css styles, etc...  and parse elements for other shape elements 

### `<text>`
This requires building out `SwiftTrueTypeFont`, currently not advanced enough to be used.

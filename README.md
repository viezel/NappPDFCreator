# Napp PDF Creator

This module extends the Titanium Mobile SDK. It lets you generate PDF files from HTML.


## Add the module to your projectin

Simply add the following lines to your `tiapp.xml` file:
    
    <modules>
        <module platform="iphone">dk.napp.pdf.creator</module> 
    </modules>

## Methods

The following lists the UI components and its new extended functionality.

### generatePDFWithURL

* Generate a PDF file from a web url
* Properties:
  * *url*: source url
  * *filename*: output filename. The PDF file is saved in the app documents folder

```javascript
NappPDFCreator.generatePDFWithURL({
	url : "http://www.appcelerator.com",
	filename : "test.pdf" //output filename
});
```

### generatePDFWithHTML

* Generate a PDF file from a HTML string
* Properties:
  * *url*: source url
  * *filename*: output filename. The PDF file is saved in the app documents folder

```javascript
NappPDFCreator.generatePDFWithHTML({
	html : html,
	filename : "test-local.pdf" //output filename
});
```

## Events

### complete

```javascript
NappPDFCreator.addEventListener("complete", function(e){
	Ti.API.info("COMPLETE");
	Ti.API.info(e);
});
```

### error
```javascript
NappPDFCreator.addEventListener("error", function(e){
	Ti.API.error("ERROR");
	Ti.API.error(e);
});
```


## Changelog

* 1.0
  * Init commit, working module.

## Author

**Mads Møller**  
web: http://www.napp.dk  
email: mm@napp.dk  
twitter: @nappdev  


## License

    Copyright (c) 2010-2013 Mads Møller

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
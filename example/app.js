var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
win.open();


var NappPDFCreator = require('dk.napp.pdf.creator');


var btnUrl = Ti.UI.createButton({
	top:50,
	height:44,
	title:"create PDF with url"
});
btnUrl.addEventListener("click", function(){
	NappPDFCreator.generatePDFWithURL({
		url:"http://www.eb.dk",
		filename:"test.pdf"
	});
});
win.add(btnUrl);

var htmlUrl = Ti.UI.createButton({
	top:150,
	height:44,
	title:"create PDF with HTML"
});

htmlUrl.addEventListener("click", function() {
	
	// Read local html file
	var localFile = Ti.Filesystem.getFile(Ti.Filesystem.resourcesDirectory, "test.html");
	var html = localFile.read().text;

	NappPDFCreator.generatePDFWithHTML({
		html : html,
		filename : "test-local.pdf"
	});
}); 
win.add(htmlUrl);

NappPDFCreator.addEventListener("complete", function(e){
	Ti.API.info("COMPLETE");
	Ti.API.info(e);
	openPDF();
});

NappPDFCreator.addEventListener("error", function(e){
	Ti.API.info("ERROR");
	Ti.API.info(e);
	alert("Error !");
});

// test the generated PDF file
function openPDF(){
	var closeBtn = Ti.UI.createButton({title:"close"});
	closeBtn.addEventListener("click", function(e){
		pdfWin.close();
	});
	
	var pdfWin = Ti.UI.createWindow({
		leftNavButton:closeBtn,
		title:"Result PDF"
	});
	
	var webView = Ti.UI.createWebView({
		url: Ti.Filesystem.getFile(Ti.Filesystem.applicationDataDirectory, "test-local.pdf").nativePath
	});
	pdfWin.add(webView);
	
	pdfWin.open({modal:true});
}

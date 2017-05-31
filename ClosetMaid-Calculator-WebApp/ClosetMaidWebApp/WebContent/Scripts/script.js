window.addEventListener('load', pageLoad, false);
window.addEventListener('orientationchange', orientationChange, false);
   
var isIpad = (/ipad/gi).test(navigator.appVersion),
isIphone = (/iphone/gi).test(navigator.appVersion),
isIphoneOS5 = false,
isIpod = (/ipod/gi).test(navigator.appVersion),
isiOS = ((isIpad) || (isIphone) || (isIpod)),
isAndroid = (/android/gi).test(navigator.appVersion),
isBlackberry = (/blackberry/gi).test(navigator.platform),
isBlackberryOS6 = (/blackberry/gi).test(navigator.appVersion),
isMobile = ((isIpad) || (isIphone) || (isIpod) || (isAndroid) || (isBlackberry)),
isNotBBOS5 = ((isIpad) || (isIphone) || (isIpod) || (isAndroid) || (isBlackberryOS6)),
hasTouch = ((('ontouchstart' in window) || ('createTouch' in document)) && (isMobile) || ('ontouchend' in document)),
isStandalone = (("standalone" in window.navigator) && (window.navigator.standalone)),
FOCUS_PAGE,
sourceElement,
calcHeight,
resHeight;
var maxSmallWidth = 800;

function resize() { // Desktop only
	if (!hasTouch || isBrowser(/BlackBerry/i)) {
		draw();
	}
}

function isBrowser(value) {
	return (value).test(navigator.userAgent);
}

function isLarge() {
	return (document.body.clientWidth > maxSmallWidth);
}
function isPortrait() {
	return (document.body.clientWidth > document.body.clientHeight);
}
function isLandscape() {
	return (document.body.clientWidth > document.body.clientHeight);
}

function pageLoad() {
	//--preload highlight images
	var img = new Image();
	img.src='Resources/Images/start-HardwareHighlight.png';
	img.src='Resources/Images/start-ShelvingCutHighlight.png';
	img.src='Resources/Images/icon-Settings-Highlight.png';
	img.src='Resources/Images/icon-Trash-Highlight.png';
	img.src='Resources/Images/button-Back-Highlighted.png';
	img.src='Resources/Images/button-Home-Highlighted.png';
	
	var styles = document.querySelector('style');
	var css = document.createTextNode(
			'.stage-left {' +
//			'left: -' + document.body.clientWidth + 'px; }' +
			'-webkit-transform: translate3d(-' + document.body.clientWidth + 'px, 0, 0);' +
			'-moz-transform: translate3d(-' + document.body.clientWidth + 'px, 0, 0);' +
			'-ms-transform: translate3d(-' + document.body.clientWidth + 'px, 0, 0);' +
			'-o-transform: translate3d(-' + document.body.clientWidth + 'px, 0, 0);' +
			'ransform: translate3d(-' + document.body.clientWidth + 'px, 0, 0); }' +
			'.stage-right {' +
//			'left: ' + document.body.clientWidth + 'px; }');
			'-webkit-transform: translate3d(' + document.body.clientWidth + 'px, 0, 0);' +
			'-moz-transform: translate3d(' + document.body.clientWidth + 'px, 0, 0);' +
			'-ms-transform: translate3d(' + document.body.clientWidth + 'px, 0, 0);' +
			'-o-transform: translate3d(' + document.body.clientWidth + 'px, 0, 0);' +
			'ransform: translate3d(' + document.body.clientWidth + 'px, 0, 0); }');
	styles.appendChild(css);
	
	if (document.body.clientHeight > 400) {
		document.getElementById('startShelvingCut').style.margin = '2em auto';
		document.getElementById('startHardware').style.margin = '2em auto';
	}
			
	if (hasTouch) {
		
		if (isBlackberry)
		{
			document.body.style.fontSize = '1em';
			document.getElementById('popUpDiv').style.boxShadow = 'none';
			document.getElementById('popUpDiv').style.webkitBoxShadow = 'none';
		}
		
		window.scrollTo(0,1);
		
		window.baseClass = '';
		
		document.body.className = 'bodyTouch';
		
		var elems = document.getElementsByClassName('page');
		for (var i = 0; i < elems.length; i++) {
			if (isLandscape() && isLarge()) {
				elems[i].style.width = '75%';
			}
		}

		document.getElementById('startClosetMaidLogo').style.width = '80%';
		document.getElementById('startEmersonLogo').className = 'startEmersonLogoTouch';
		document.getElementById('settingsButton').className += ' settingsTouch';
		document.getElementById('shelvingTrash').className += ' trashTouch';
		document.getElementById('hardwareTrash').className += ' trashTouch';
	} else {
		window.baseClass = ' screenDesktop';
		
		document.body.className = 'bodyDesktop';
		var elems = document.getElementsByClassName('page');
		for (var i = 0; i < elems.length; i++) {
			elems[i].className += ' screenDesktop';
		}

		document.getElementById('startClosetMaidLogo').style.width = '60%';
		document.getElementById('startEmersonLogo').className = 'startEmersonLogoDesktop';
		
		if (isBrowser(/Firefox/)) {
			var pickers = document.getElementsByClassName('picker');
			for (var i = 0; i < pickers.length; i++) {
				pickers[i].style.paddingTop = '.3em';
			}
		}
	}
}

function orientationChange() {
	
	changeCSS('.transition', 'webkitTransitionDuration', '0.0s');
  	changeCSS('.transition', 'MozTransitionDuration', '0.0s');
  	changeCSS('.transition', 'OTransitionDuration', '0.0s');
  	changeCSS('.transition', 'transitionDuration', '0.0s');

	var styles = document.querySelector('style');
	var css = document.createTextNode(
			'.stage-left {' +
//			'left: -' + document.body.clientWidth + 'px; }' +
			'-webkit-transform: translate(-' + document.body.clientWidth + 'px, 0);' +
			'-moz-transform: translate(-' + document.body.clientWidth + 'px, 0);' +
			'-ms-transform: translate(-' + document.body.clientWidth + 'px, 0);' +
			'-o-transform: translate(-' + document.body.clientWidth + 'px, 0);' +
			'transform: translate(-' + document.body.clientWidth + 'px, 0); }' +
			'.stage-right {' +
//			'left: ' + document.body.clientWidth + 'px; }');
			'-webkit-transform: translate(' + document.body.clientWidth + 'px, 0);' +
			'-moz-transform: translate(' + document.body.clientWidth + 'px, 0);' +
			'-ms-transform: translate(' + document.body.clientWidth + 'px, 0);' +
			'-o-transform: translate(' + document.body.clientWidth + 'px, 0);' +
			'transform: translate(' + document.body.clientWidth + 'px, 0); }');
	styles.appendChild(css);	
	
	var elems = document.getElementsByClassName('page');
	for (var i = 0; i < elems.length; i++) {
		if (isLandscape() && isLarge()) {
			elems[i].style.width = '75%';
		} else {
			elems[i].style.width = '100%';
		}
	}

    setTimeout(function() { 
    	changeCSS('.transition', 'webkitTransitionDuration', '0.3s');
      	changeCSS('.transition', 'MozTransitionDuration', '0.3s');
      	changeCSS('.transition', 'OTransitionDuration', '0.3s');
      	changeCSS('.transition', 'transitionDuration', '0.3s');
	},100);
	
}


function changeCSS(theClass, theElement, theValue) {
	var cssSheet = null;
	for (var i in document.styleSheets) {
		if (document.styleSheets[i].href && (document.styleSheets[i].href.indexOf('sheet.css') > 0)) {
			cssSheet = document.styleSheets[i];
            break;
        }
    }
	
	var cssRules = cssSheet.cssRules? cssSheet.cssRules: cssSheet.rules;
	for (var i in cssRules) {
		if (cssRules[i].selectorText == theClass) {
			cssRules[i].style[theElement] = theValue;
		}
	}
}

function emailShelvingCuts() {
	var address = '';
	var subject = 'ClosetMaid Job: ';
	var shelfType = document.getElementById('shelfPicker');
	var shelfSize = document.getElementById('sizePicker');
	var msgBody;
	if (isiOS) {
		msgBody = 'Shelving Cut Calculator<br><br>';
		msgBody += 'Type of Shelving You Have: <span style="color:#ED1A2E;">' + shelfType.options[shelfType.selectedIndex].text + '</span><br>';
		msgBody += 'What You Will Need: <span style="color:#ED1A2E;">' + results.length + ' - ' + shelfSize.options[shelfSize.selectedIndex].value.replace('.', ',') + getUnit() + ' Sections of Shelving</span><br>';
		msgBody += 'Total Excess Shelving: <span style="color:#ED1A2E;">' + window.waste.toString().replace('.', ',') + getUnit() + '</span><br><br>';
		msgBody += 'How To Cut It:<br><br>';
		for (var i = 0; i < groupedResults.length; i++) 
		{
			msgBody += groupedResults[i].shelfCount + " x " + groupedResults[i].textual + "\n";
		}
	} else {
		msgBody = 'Shelving Cut Calculator\n\n';
		msgBody += 'Type of Shelving You Have: ' + shelfType.options[shelfType.selectedIndex].text + '\n';
		msgBody += 'What You Will Need: ' + results.length + ' - ' + shelfSize.options[shelfSize.selectedIndex].value + getUnit() + ' Sections of Shelving\n';
		msgBody += 'Total Excess Shelving: ' + window.waste + getUnit() + '\n\n';
		msgBody += 'How To Cut It:\n\n';
		for (var i = 0; i < groupedResults.length; i++) 
		{
			msgBody += groupedResults[i].shelfCount + " x " + groupedResults[i].textual + "\n";
		}
	}
	
	var url = 'mailto:' + address + '?subject=' + subject + '&body=' + encodeURIComponent(msgBody);
	window.location.href = url;
}

function emailHardware() {
	var address = '';
	var subject = 'ClosetMaid Job: ';
	var shelfType = document.getElementById('hardwareShelfPicker');
	var msgBody;
	if (isiOS) {
		msgBody = 'Hardware Calculator<br><br>';
		msgBody += 'Type of Shelving You Have: <span style="color:#ED1A2E;">' + shelfType.options[shelfType.selectedIndex].text + '</span><br>';
		msgBody += 'Shelving Lengths Needed:<br>';
		var table=document.getElementById("hardwareTable");
		for(var i = 0; i < table.rows.length; i++) {
			var cell = table.rows[i].cells[0];
			var inputQuantity = cell.children[0];
			var inputLocation = cell.children[1].children[0];
			var inputLength = cell.children[2];
			var lengthValue = inputLength.children[0].value.replace(getUnit(), '').replace(',', '.');
			var quantity = parseFloat(inputQuantity.value);
			var length = parseFloat(lengthValue);
			if(!isNaN(quantity) && !isNaN(length))
			{
				msgBody += inputQuantity.value + ' x ' + inputLocation.options[inputLocation.selectedIndex].text + ' of ' + inputLength.children[0].value + '<br>';
			}
		}
		msgBody += '<br>What You Will Need:<br>';
		msgBody += document.getElementById('hardwareNeedsTitle1').innerHTML + '     ' + document.getElementById('hardwareNeedsValue1').innerHTML + '<br>';
		msgBody += document.getElementById('hardwareNeedsTitle2').innerHTML + '     ' + document.getElementById('hardwareNeedsValue2').innerHTML + '<br>';
		msgBody += document.getElementById('hardwareNeedsTitle3').innerHTML + '     ' + document.getElementById('hardwareNeedsValue3').innerHTML + '<br>';
		msgBody += document.getElementById('hardwareNeedsTitle4').innerHTML + '     ' + document.getElementById('hardwareNeedsValue4').innerHTML + '<br>';
		msgBody += document.getElementById('hardwareNeedsTitle5').innerHTML + '     ' + document.getElementById('hardwareNeedsValue5').innerHTML + '<br>';
	} else {
		msgBody = 'Hardware Calculator\n\n';
		msgBody += 'Type of Shelving You Have: ' + shelfType.options[shelfType.selectedIndex].text + '\n';
		msgBody += 'Shelving Lengths Needed:\n';
		var table=document.getElementById("hardwareTable");
		for(var i = 0; i < table.rows.length; i++) {
			var cell = table.rows[i].cells[0];
			var inputQuantity = cell.children[0];
			var inputLocation = cell.children[1].children[0];
			var inputLength = cell.children[2];
			var lengthValue = inputLength.children[0].value.replace(getUnit(), '').replace(',', '.');
			var quantity = parseFloat(inputQuantity.value);
			var length = parseFloat(lengthValue);
			if(!isNaN(quantity) && !isNaN(length))
			{
				msgBody += inputQuantity.value + ' x ' + inputLocation.options[inputLocation.selectedIndex].text + ' of ' + inputLength.children[0].value + '\n';
			}
		}
		msgBody += '\nWhat You Will Need:\n';
		msgBody += document.getElementById('hardwareNeedsTitle1').innerHTML + '     ' + document.getElementById('hardwareNeedsValue1').innerHTML + '\n';
		msgBody += document.getElementById('hardwareNeedsTitle2').innerHTML + '     ' + document.getElementById('hardwareNeedsValue2').innerHTML + '\n';
		msgBody += document.getElementById('hardwareNeedsTitle3').innerHTML + '     ' + document.getElementById('hardwareNeedsValue3').innerHTML + '\n';
		msgBody += document.getElementById('hardwareNeedsTitle4').innerHTML + '     ' + document.getElementById('hardwareNeedsValue4').innerHTML + '\n';
		msgBody += document.getElementById('hardwareNeedsTitle5').innerHTML + '     ' + document.getElementById('hardwareNeedsValue5').innerHTML + '\n';
	}
	
	var url = 'mailto:' + address + '?subject=' + subject + '&body=' + encodeURIComponent(msgBody);
	window.location.href = url;
}
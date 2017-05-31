var ie = (function(){

    var undef,
        v = 3,
        div = document.createElement('div'),
        all = div.getElementsByTagName('i');

    while (
        div.innerHTML = '<!--[if gt IE ' + (++v) + ']><i></i><![endif]-->',
        all[0]
    );

    return v > 4 ? v : undef;

}());

function slideIn(origin, destination) {
	if (!window.alerted) {
		if (document.getElementById('imperialUnit').checked) {
			window.metric = false;
		} else {
			window.metric = true;
		}
		
		switch(destination) {
			case 'ShelvingCutCalculate': {
				var sizeSelect = document.getElementById('sizePicker');
				if (window.metric) {
					sizeSelect.options[0].value = '121,92';
					sizeSelect.options[0].text = '121,92cm';
					sizeSelect.options[1].value = '182,88';
					sizeSelect.options[1].text = '182,88cm';
					sizeSelect.options[2].value = '243,84';
					sizeSelect.options[2].text = '243,84cm';
					sizeSelect.options[3].value = '365,76';
					sizeSelect.options[3].text = '365,76cm';
				} else {
					sizeSelect.options[0].value = '48';
					sizeSelect.options[0].text = '48"';
					sizeSelect.options[1].value = '72';
					sizeSelect.options[1].text = '72"';
					sizeSelect.options[2].value = '96';
					sizeSelect.options[2].text = '96"';
					sizeSelect.options[3].value = '144';
					sizeSelect.options[3].text = '144"';
				}
				
				if(origin == "HomeScreen"){
					initShelvingCalculator();
					clearTable("shelvingTable");
					addRow("shelvingTable");
				}
				
				break;
			}
			
			case 'ShelvingCutResults': {
				var table = document.getElementById('shelvingTable');
				var valid = false;
				var measures = new Array();
				var totalPieces = 0;
				for(var i = 0; i < table.rows.length; i++) {
					var cell = table.rows[i].cells[0];
					var inputQuantity = cell.children[0];
					var inputLength = cell.children[1];
					var lengthValue = inputLength.children[0].value.replace(getUnit(), '').replace(',', '.');	
					var quantity = parseFloat(inputQuantity.value);
					var length = parseFloat(lengthValue);
					if(!isNaN(quantity) && !isNaN(length))
					{
						if(quantity>0)
						{
							measures.push(new Shelf(quantity, length));
							valid=true;
							totalPieces+=quantity;
						}
					}
				}
				if(totalPieces>1000)
					{
					alert('The maximum allowed number of total cuts is 1000.');
					return;
					}
				if(!valid)
					{
						alert('Please speficy at least one cut.');
						return;
					}
				
				var shelfSize = document.getElementById('sizePicker');
				var select = document.getElementById('shelfPicker');
				
				calculateResults(measures, shelfSize.options[shelfSize.selectedIndex].value.replace(',', '.'), select.selectedIndex);
				
				break;
			}
			
			case 'HardwareCalculate': {
				
				var typeSelect = document.getElementById('hardwareShelfPicker');
				if (window.metric) {
					typeSelect.options[0].text = '30,48cm SuperSlide or Closemesh';
					typeSelect.options[1].text = '40,64cm SuperSlide or Closemesh';
					typeSelect.options[2].text = '50,80cm Closemesh';
					typeSelect.options[3].text = '30,48cm Shelf & Rod';
					typeSelect.options[3].text = '40,64cm Shelf & Rod';
				} else {
					typeSelect.options[0].text = '12" SuperSlide or Closemesh';
					typeSelect.options[1].text = '16" SuperSlide or Closemesh';
					typeSelect.options[2].text = '20" Closemesh';
					typeSelect.options[3].text = '16" Shelf & Rod';
					typeSelect.options[3].text = '16" Shelf & Rod';
				}
				
				if(origin == "HomeScreen"){
					initHardwareCalculator();
					clearTable("hardwareTable");
					addRow("hardwareTable");
				}
				
				break;
			}
			
			case 'HardwareResults': {
				
				if(!calculateHardwareResults()){
					return;
				}
				break;
			}
		}
		
		window.currentPage = destination;
		window.goBackPage = origin;
		
		var FOCUS_PAGE = document.getElementById(origin);
		FOCUS_PAGE.className = 'page transition stage-left' + window.baseClass;
		if (ie <= 9) {//|| (navigator.userAgent.indexOf('Opera'))) {
			FOCUS_PAGE.className += ' display-none';
		}
		
		var target = document.getElementById(destination);
		target.className = 'page transition stage-right' + window.baseClass;
		
	    setTimeout(function() { 
			window.drawed = 0;
			target.className = 'page transition stage-center' + window.baseClass;
    	},1);
		
	    if (!isBlackberry)
	    {
		    setTimeout(function() {
		    	window.scrollTo(0,1); 
	    	},301);
	    }
	}
}

function slideOut() {
	FOCUS_PAGE = document.getElementById(window.currentPage);
	FOCUS_PAGE.className = 'page transition stage-right';
	setTimeout(function() {
		FOCUS_PAGE.className += ' display-none';
		// delete drawings
		var div_drawing = document.getElementById('drawingDiv');
		while(div_drawing.hasChildNodes()) {
			div_drawing.removeChild(div_drawing.lastChild);
		}
		results = null;
		document.getElementById('moreFooter').style.visibility = 'visible';
	}, 300);
	
	var target = document.getElementById(window.goBackPage);
	target.className = 'page transition stage-center' + window.baseClass;
	
	window.currentPage = window.goBackPage;
	window.goBackPage = 'HomeScreen';
	
	window.scrollTo(0,1);
}

//added by idiot
function initShelvingCalculator()
{
	var sizeSelect = document.getElementById('sizePicker');
	window.minValue=0;
	window.maxValue=sizeSelect.options[sizeSelect.selectedIndex].value.replace(',', '.');
}



function clearRows(tableId){
	if(confirm('Are you sure you want to clear the data?')){
		clearTable(tableId);
		addRow(tableId);
	}
}

function initHardwareCalculator()
{
	if(!window.metric){
		window.minValue=12;
		window.maxValue=144;
	}else{
		window.minValue=30.48;
		window.maxValue=365.76;
	}
}

function onShelfDimChange(){
	var sizeSelect = document.getElementById('sizePicker');
	window.maxValue=sizeSelect.options[sizeSelect.selectedIndex].value;
	var table = document.getElementById("shelvingTable");
	var warningWrongValues=false;
	for(var i=0;i<table.rows.length;i++){
		var input=table.rows[i].lengthInput;
		if(input.value.length>0){
			var value=parseFloat(input.value.replace(getUnit(),""));
			if(value>window.maxValue){
				value=window.maxValue;
				input.value=value+getUnit();
				warningWrongValues=true;
			}
		}
	}
	if(warningWrongValues){
		alert("The specified length does not fall within the expected range");
	}
}


function clearTable(tableId){
	var table = document.getElementById(tableId);
	var rowCount=table.rows.length;
	for (var i=0 ; i<rowCount; i++) {
		table.deleteRow(table.rows[i]);
	}
}
//end - by idiot

//modified by idiot
function addRow(tableId) {
	var table = document.getElementById(tableId);

	var rowCount = table.rows.length;
	var row = table.insertRow(rowCount);
	var cell = row.insertCell(0);
	var element1 = document.createElement("input");
	element1.type = "text";
//	element1.setAttribute("pattern", "[0-9]*");
	element1.className = "quantityText";
	element1.style = "";


	//added by idiot
	element1.table=table;
	element1.row=row;
	table.removableRow=row;
	element1.onkeydown=function(event){onKeyDown(element1,event);};
	// -end idiot

	cell.appendChild(element1);

	switch(tableId) {
	case 'shelvingTable': {
		var element2 = document.createElement("input");
		element2.type = "text";
//		element2.setAttribute("pattern", "\\d*");
		element2.className = "lengthText";
		element2.style = "";
		element2.onblur = function() { onBlur(element2); };
		element2.onfocus = function() { onFocus(element2); };

		//added by idiot
		element2.table=table;
		element2.row=row;
		element2.onkeydown=function(event){onKeyDown(element2,event);};
		element1.compadre=element2;
		element2.compadre=element1;
		row.lengthInput=element2;
		//-end idiot

		var el2Span = document.createElement("span");
		el2Span.appendChild(element2);
		cell.appendChild(el2Span);
		break;	
	}
	case 'hardwareTable': {
		var element2 = document.createElement("select");
		element2.className = "locationPicker picker";
		element2.style="";
		if (isBrowser(/Firefox/)) {
			element2.style.paddingTop = '.3em';
		}
		var option = document.createElement("option");
		option.value = "wall_to_wall";
		option.appendChild(document.createTextNode("Wall-to-Wall"));
		element2.appendChild(option);
		option = document.createElement("option");
		option.value = "wall_to_open";
		option.appendChild(document.createTextNode("Wall-to-Open"));
		element2.appendChild(option);
		option = document.createElement("option");
		option.value = "open_to_open";
		option.appendChild(document.createTextNode("Open-to-Open"));
		element2.appendChild(option);
		element2.options[1].selected = true;
		var el2Span = document.createElement("span");
		el2Span.className = "locationSpan";
		el2Span.appendChild(element2);
		cell.appendChild(el2Span);

		var element3 = document.createElement("input");
		element3.type = "text";
//		element2.setAttribute("pattern", "\\d*");
		element3.className = "lengthText";
		element3.style = "";
		element3.onblur = function() { onBlur(element3); };
		element3.onfocus = function() { onFocus(element3); };
		var el3Span = document.createElement("span");
		el3Span.appendChild(element3);
		cell.appendChild(el3Span);

		//added by idiot
		element3.table=table;
		element3.row=row;
		element3.onkeydown=function(event){onKeyDown(element3,event);};
		element1.compadre=element3;
		element3.compadre=element1;
		//-end idiot

		break;
	}
	}

	// scroll to bottom of page
	window.scrollTo(0, document.body.scrollHeight);
}


function deleteRemovableRow(table)
{
	table.deleteRow(table.removableRow.rowIndex);
}

function deleteRow(table,row){
	table.deleteRow(row.rowIndex);
}

//-idiot end

function Shelf(quantity,length)
{
	this.quantity=quantity;
	this.length=length;
}





function getUnit()
{
	var metric=window.metric;
	if(metric)
	{return "cm";}else{return "\"";}
}

function formatDecimal(svalue)
{	
	var value=svalue.toString().replace(",",".");
	var replaced=false;
	if(value!=svalue)
	{
		replaced=true;
	}
	var fvalue=parseFloat(value);
	var finalValue=fvalue.toFixed(2);
	svalue=finalValue.toString();
	if(svalue.charAt(svalue.length-1)=="0")
	{
		finalValue=fvalue.toFixed(1);
		svalue=finalValue.toString();
		if(svalue.charAt(svalue.length-1)=="0")
		{
			finalValue=fvalue.toFixed(0);
			svalue=finalValue.toString();
		}
	}
	if(replaced)
	{
		svalue=svalue.replace(".",",");
	}
	return svalue;
}

//added by idiot
function onKeyDown(input,e){
	var unicode=e.keyCode? e.keyCode : e.charCode;
	unicode=e.charCode?e.charCode:e.which;
	
	if(unicode==0){
		unicode=input.value.charCodeAt(input.value.length-1);
		if(unicode >= 48 && unicode <= 57){
			if(input.value.length==1 && input.compadre.value.length==0){
				addRow(input.table.id);
			}
		}else{
			input.value=input.value.substring(0,input.value.length-1);
		}
	}
	
	if (unicode >= 48 && unicode <= 57||unicode==8||unicode==177) {
		if(input.value=="" && unicode!=8 && input.compadre.value.length==0){
			addRow(input.table.id);
		}
	}
	else{
		e.preventDefault();
	}
	if(input.value.length==1 && unicode==8 && input.compadre.value.length==0){
		deleteRemovableRow(input.table);
		input.table.removableRow=input.row;
	}
	if(unicode==0){
		if(input.value.length==0 && input.compadre.value.length==0){
			addRow(input.table.id);
		}
	}
}



function onFocus(input)
{
	input.value=input.value.replace(getUnit(),"");	
	input.select();
}

function onBlur(input)
{	
	if(input.value.length>0){
		var value=parseFloat(input.value);
		if(value<=window.maxValue&value>=window.minValue)
		{
			input.shelf=value.toFixed(2);
			input.value=formatDecimal(input.value)+getUnit();
		}
		else
		{
			alert("The specified length does not fall within the expected range.");
			if(value > window.maxValue){
				input.value=window.maxValue+getUnit();
			} else if (value < window.minValue){
				input.value=window.minValue+getUnit();
			}
			window.alerted = true;
			setTimeout(function() { window.alerted = false; }, 10);
		}
	}
}




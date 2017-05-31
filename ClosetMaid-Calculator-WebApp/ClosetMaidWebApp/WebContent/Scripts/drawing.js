var ratio;
var h, w;


var results = null;
var groupedResults = null;
var shelvesR;
var shelfSizeR;
var typeR;

function calculateResults(shelves,shelfSize,type)
{
	shelvesR=shelves;
	shelfSizeR=shelfSize;
	typeR=type;
	if (type == 0) {
		results = GetResults(shelves, shelfSize, window.metric);
	}
	else {
		results = GetResultsTwo(shelves, shelfSize, window.metric);
	}
	groupedResults = GetGroupedResults(results);
	draw();
}

function draw()
{
//	if (window.drawed == 0) {
//	 window.drawed = 1;
		
	 var redLine=document.getElementById('red_line');
	 var lblInfoCutOut=document.getElementById('cutoutSpan');
	 redLine.style.visibility = 'hidden';
	 lblInfoCutOut.style.visibility = 'hidden';     
		
	 board=new Shelf(0, results[0].sectionSize);
	 var div_drawing = document.getElementById('drawingDiv');
	 while(div_drawing.hasChildNodes()) {
		 div_drawing.removeChild(div_drawing.lastChild);
	 }
	 if(ratio==undefined)
	 {
		 var rule=getCSSRule('#drawingDiv', false);
		 var style=rule.style;
		 ratio=parseFloat(style.height)/parseFloat(style.width);
	 }
	 document.getElementById('moreFooter').style.visibility = "visible";

	 //var w=div_drawing.offsetWidth/2;
	 w = Math.round(0.9 * document.getElementById('ShelvingCutCalculate').clientWidth / 2);
	 //w = Math.round(0.9 * div_drawing.clientWidth / 2);
	 h = Math.round(w * 2 * ratio);
	 if(h<200)
	 {
		 h=200;
	 }
	 width=w;
	 height=h;
	 shelfHeight=90*h/100;
	 shelfWidth=3*w/8;
	 
	 markingLine=shelfWidth/3;
	 initialX=shelfWidth+7;
	 finalX=shelfWidth+markingLine;
	 textHeight=h/18;
	 textWidth=5*textHeight/2;
	 excessTextHeight=textHeight/2;
	 totalWaste=0;
	 
	 for(var i=0;i<results.length;i++)
		 {
		 	totalWaste+=results[i].waste;
		 }
	 
	 window.waste = totalWaste;
	 
	 showMore();
	 
	 var lblInfo = document.getElementById('wasteSpan');
	 var lblSections = document.getElementById('sectionsSpan');

	 lblInfo.innerHTML = 'Excess Shelving: ' + totalWaste.toString().replace('.', ',') + getUnit();
	 lblSections.innerHTML = results.length + ' - '+ board.length.toString().replace('.', ',') + getUnit() + ' Sections of Shelving';

//	 setTimeout(function() { window.drawed = 0; }, 100);
//	}
}

function showMore()
{
	 var div_drawing = document.getElementById('drawingDiv');
	 var count=div_drawing.childNodes.length;
	 var toShow=4;
	 if (groupedResults.length-count<=4)
		 {
		 	toShow=groupedResults.length-count;
		 	document.getElementById('moreFooter').style.visibility = 'hidden';
		 }
	 for(var i=0;i<toShow;i++)
	 {
		 var canvas=document.createElement('canvas');
		 canvas.height=h;
		 canvas.width=w;
		 var context=canvas.getContext('2d');
		 var  backingStoreRatio = context.webkitBackingStorePixelRatio ||
	     context.mozBackingStorePixelRatio ||
	     context.msBackingStorePixelRatio ||
	     context.oBackingStorePixelRatio ||
	     context.backingStorePixelRatio || 1;
		 deviceRatio=window.devicePixelRatio/backingStoreRatio;
		 if(deviceRatio)
		 {
			  canvas.height=h*deviceRatio;
			  canvas.width=w*deviceRatio;
			  context.scale(deviceRatio,deviceRatio);
			  canvas.style.height=h+'px';
			  canvas.style.width=w+'px';
		 }
	     if (!context.constructor.prototype.fillRoundedRect) {
	    	  // Extend the canvaseContext class with a fillRoundedRect method
	    	  context.constructor.prototype.fillRoundedRect = 
	    	    function (xx,yy, ww,hh, rad, fill, stroke) {
	    	      if (typeof(rad) == 'undefined') rad = 5;
	    	      this.beginPath();
	    	      this.moveTo(xx+rad, yy);
	    	      this.arcTo(xx+ww, yy,    xx+ww, yy+hh, rad);
	    	      this.arcTo(xx+ww, yy+hh, xx,    yy+hh, rad);
	    	      this.arcTo(xx,    yy+hh, xx,    yy,    rad);
	    	      this.arcTo(xx,    yy,    xx+ww, yy,    rad);
	    	      if (stroke) this.stroke();  // Default to no stroke
	    	      if (fill || typeof(fill)=='undefined') this.fill();  // Default to fill
	    	  }; // end of fillRoundedRect method
	    	} 
	     var cuts = groupedResults[count+i];
	     context.translate(10,0);
		 DrawCuts(context,cuts);
		 //context.save();
		 canvas.style.float = 'left';
		
//		 canvas.style.boxSizing = 'border-box';
//		 canvas.style.webkitBoxSizing = 'border-box';
//		 canvas.style.MozBoxSizing = 'border-box';
		 
		 context.translate(-10,0);
		 DrawShelfCount(context, groupedResults[count+i].shelfCount);
		 div_drawing.appendChild(canvas);
	 }
	 div_drawing.style.height = ((count + toShow + ((count + toShow) % 2)) / 2) * h + 'px';
}

function DrawShelfCount(context,shelfCount)
{
	if (shelfCount > 1)
	{
		var shelfCountTextHeight = textHeight + 3;
		var message = shelfCount + "x";
		var txtWidth=context.measureText(message).width * 1.15;
		if(txtWidth<textWidth)
		{
			txtWidth=textWidth;
		}	
		var hh=shelfCountTextHeight * 1.15;
		var ww=txtWidth;
		var xx=0;
		var yy=20;
		context.save();
		context.fillStyle=  "rgba(129, 133, 139, 0.8)";
		if (isBrowser(/BlackBerry/i) || isBrowser(/MSIE/) || isBrowser(/Opera/)) {
			context.fillRect(xx,yy,ww,hh);
		} else {
			context.fillRoundedRect(xx,yy,ww,hh,3,true,false);
		}
		context.restore();
		
		context.save();
		context.font = shelfCountTextHeight+ 'px Helvetica';
		context.fillStyle='white';
		context.textAlign='center';
		context.fillText(message, xx + ww / 2, yy + (hh + shelfCountTextHeight / 2) / 2 + shelfCountTextHeight / 12);
		context.restore();
	}
}

var shelfHeight;
var shelfWidth;

var deviceRatio;
var results;
var board;
var totalWaste=0;

var CutType=Object({'Cut':0,'Waste':1,'CutOut':2});

var width;
var height;
var lineCount;
var lineWidth=2;
var initialX;
var finalX;
var markingLine;
var textWidth;
var textHeight;
var excessTextHeight;

//function zipFile(imgCut){
//	var zip = new JSZip();
//	zip.file("image.zip", imgCut.substr(imgCut.indexOf(',')+1), {base64: true});
//	return "image.zip";
//}
//
//
//function cutsFile(){
//	var columns = 2;
//	var maxCutsPerFile=10;
//	var magnifier=1;
//	
//	var index=0;
//	
//	while(index<results.length){
//		
//		var count=(results.length-index>maxCutsPerFile)?maxCutsPerFile:results.length-index;
//		
//		var rows=Math.ceil(count/columns);
//		
//		var canvasMajor=document.createElement('canvas');
//		
//		var cutWidth=w*magnifier;
//		var cutHeight=h*magnifier;
//			
//		canvasMajor.height=cutHeight*rows;
//		canvasMajor.width=cutWidth*columns;
//		var contextMajor=canvasMajor.getContext('2d');
//		
//		for(var i=0;i<count;i++){
//			 index++;
//			 var canvas=document.createElement('canvas');
//			 canvas.height=cutHeight;
//			 canvas.width=cutWidth;
//			 var context=canvas.getContext('2d');
//			 if (!context.constructor.prototype.fillRoundedRect) {
//		    	  // Extend the canvaseContext class with a fillRoundedRect method
//		    	  context.constructor.prototype.fillRoundedRect = 
//		    	    function (xx,yy, ww,hh, rad, fill, stroke) {
//		    	      if (typeof(rad) == 'undefined') rad = 5;
//		    	      this.beginPath();
//		    	      this.moveTo(xx+rad, yy);
//		    	      this.arcTo(xx+ww, yy,    xx+ww, yy+hh, rad);
//		    	      this.arcTo(xx+ww, yy+hh, xx,    yy+hh, rad);
//		    	      this.arcTo(xx,    yy+hh, xx,    yy,    rad);
//		    	      this.arcTo(xx,    yy,    xx+ww, yy,    rad);
//		    	      if (stroke) this.stroke();  // Default to no stroke
//		    	      if (fill || typeof(fill)=='undefined') this.fill();  // Default to fill
//		    	  }; // end of fillRoundedRect method
//		    	} 
//			 var cuts=results[i];
//			 DrawCuts(context,cuts);
//			 
//			 var columnIndex=i%columns;
//			 var rowIndex=Math.round(i/columns);
//			 
//			 contextMajor.drawImage(canvas,columnIndex*cutWidth,rowIndex*cutHeight);
//		}
//		
//		window.canvasImage = canvasMajor.toDataURL('image/png');
//		var zip=zipFile(window.canvasImage);
//		return zip;
//	}
//}

function DrawCuts(ctx,cuts)
{
	var segments=calculateSegments(cuts);
	lineCount=0;
	for(var i=0;i<segments.length;i++)
		{
			segments[i].DrawSegment(ctx);
		}
}

function Measures(data,sectionSize,metric,waste, shelfCount, textual)
{
	this.data = data;
	this.sectionSize = sectionSize;
	this.metric = metric;
	this.waste = waste;
	this.shelfCount = shelfCount;
	this.textual = textual;
}

function Segment(from,height,count,cutValue,type)
{
	this.from=from;
	this.height=height;
	this.count=count;
	this.type=type;
	this.to=from+count*height;
	this.cutValue=cutValue;
	this.DrawSegment=function(context)
	{
		if(type==CutType.Cut)
		{
			this.DrawCut(context);
		}
		else if(type==CutType.Waste)
			{
				this.DrawWaste(context);
			}
		else
			{
				this.DrawCutOut(context);
			}
		
	};

this.DrawCut=function(ctx)
{
	ctx.save();
	ctx.lineWidth=4;
	ctx.strokeStyle='black';
		
	ctx.beginPath();
	ctx.moveTo(shelfWidth-10,this.from);
	ctx.lineTo(shelfWidth-10,this.to);
	ctx.stroke();
	
	ctx.beginPath();
	ctx.moveTo(2,this.from);
	ctx.lineTo(2,this.to);
	ctx.stroke();
	
	ctx.beginPath();
	ctx.moveTo(shelfWidth,this.from);
	ctx.lineTo(shelfWidth,this.to);
	ctx.stroke();
	ctx.restore();
	
	ctx.save();
	ctx.strokeStyle='black';
	ctx.lineWidth=lineWidth;
	while((lineCount*lineWidth<this.to))
		{
			lineCount++;
			if(lineCount%2==0&&(lineCount*lineWidth<shelfHeight))
				{
					ctx.beginPath();
					ctx.moveTo(0,lineCount*lineWidth);
					ctx.lineTo(shelfWidth,lineCount*lineWidth);
					ctx.stroke();
				}
		}
	ctx.restore();
	
	ctx.save();
	ctx.lineWidth=2;
	ctx.strokeStyle='red';
	
	ctx.beginPath();
	ctx.moveTo(finalX,this.from);
	ctx.lineTo(finalX,this.to);
	ctx.stroke();
	
	ctx.beginPath();
	ctx.moveTo(initialX,this.from);
	ctx.lineTo(finalX,this.from);
	ctx.stroke();
	
	ctx.beginPath();
	ctx.moveTo(initialX,this.to);
	ctx.lineTo(finalX,this.to);
	ctx.stroke();
	ctx.restore();
	var message='';
	if(this.count>1)
		{
			message=count+'x';
		}
	
	message=message+formatDecimal(this.cutValue)+getUnit(window.metric);
	
	if((this.to-this.from)>textHeight)
		{
		ctx.font = textHeight+ 'px Helvetica';
		var txtWidth=ctx.measureText(message).width * 1.15;
		if(txtWidth<textWidth)
			{
			txtWidth=textWidth;
			}	
		var hh=textHeight * 1.15;
		var ww=txtWidth;
		var xx=finalX-txtWidth+3*markingLine/4;
		var yy=this.from+(this.to-this.from)/2-hh/2;
		ctx.save();
		ctx.fillStyle='red';
		if (isBrowser(/BlackBerry/i) || isBrowser(/MSIE/) || isBrowser(/Opera/)) {
			ctx.fillRect(xx,yy,ww,hh);
		} else {
			ctx.fillRoundedRect(xx,yy,ww,hh,3,true,false);
		}
		ctx.restore();
		
		
		ctx.save();
		ctx.font = textHeight+ 'px Helvetica';
		ctx.fillStyle='white';
		ctx.textAlign='center';
		ctx.fillText(message, xx + ww / 2, yy + (hh + textHeight / 2) / 2 + textHeight / 12);
		ctx.restore();
		} else{
			if((this.to-this.from)>excessTextHeight)
				{
				//write text;
				ctx.save();
				ctx.font=excessTextHeight+'px Helvetica';
				ctx.fillStyle='red';
				ctx.fillText(message,finalX+3,this.from+(this.to-this.from)/2+excessTextHeight/2);
				ctx.restore();
				}
		}
};
 
this.DrawCutOut=function(ctx)
{
    var redLine=document.getElementById('red_line');
    var lblInfoCutOut=document.getElementById('cutoutSpan');
      
	redLine.style.visibility = 'visible';
	lblInfoCutOut.style.visibility = 'visible';
    
    ctx.save();
	ctx.lineWidth=4;
	ctx.strokeStyle="red";
	
	ctx.beginPath();
	ctx.moveTo(2,this.from);
	ctx.lineTo(2,this.to);
	ctx.stroke();
	
	ctx.beginPath();
	ctx.moveTo(shelfWidth-10,this.from);
	ctx.lineTo(shelfWidth-10,this.to);
	ctx.stroke();
	
	ctx.beginPath();
	ctx.moveTo(shelfWidth,this.from);
	ctx.lineTo(shelfWidth,this.to);
	ctx.stroke();
	ctx.restore();
	
	ctx.save();
	ctx.lineWidth=lineWidth;
	ctx.strokeStyle='red';
	
	var delta=1;
	
	while((lineCount*lineWidth<this.to))
	{
		lineCount++;
		if(lineCount%2==0)
			{
				ctx.beginPath();
				ctx.moveTo(0,lineCount*lineWidth);
				ctx.lineTo(shelfWidth,lineCount*lineWidth);
				if(delta!=0){
					delta=0;
				}
				ctx.stroke();
			}
	}
	ctx.beginPath();
//	ctx.moveTo(0,this.from);
//	ctx.lineTo(shelfWidth,this.from);
	ctx.stroke();
	ctx.restore();
};


this.DrawWaste=function(ctx)
{
	ctx.lineWidth=4;
	ctx.strokeStyle='gray';
	
	ctx.beginPath();
	ctx.moveTo(shelfWidth-10,0);
	ctx.lineTo(shelfWidth-10,this.to);
	ctx.stroke();
	
	ctx.beginPath();
	ctx.moveTo(2,0);
	ctx.lineTo(2,this.to);
	ctx.stroke();
	
	ctx.beginPath();
	ctx.moveTo(shelfWidth,0);
	ctx.lineTo(shelfWidth,this.to);
	ctx.stroke();
	
	ctx.lineWidth=lineWidth;
	while(lineCount*lineWidth<this.to)
	{
		lineCount++;
		if((lineCount%2==0)&&(lineCount*lineWidth<shelfHeight))
			{
				ctx.beginPath();
				ctx.moveTo(0,lineCount*lineWidth);
				ctx.lineTo(shelfWidth,lineCount*lineWidth);
				ctx.stroke();
			}
	}
	
	
	
	ctx.lineWidth='0.1em';
	ctx.strokeColor='gray';
	
	ctx.beginPath();
	ctx.moveTo(initialX,2);
	ctx.lineTo(finalX,2);
	ctx.stroke();

	ctx.beginPath();
	ctx.moveTo(finalX,2);
	ctx.lineTo(finalX,this.to);
	ctx.stroke();

	ctx.beginPath();
	ctx.moveTo(initialX,this.to);
	ctx.lineTo(finalX,this.to);
	ctx.stroke();
	
	message=formatDecimal(this.cutValue)+getUnit(window.metric)+' Waste';
	
	ctx.font = excessTextHeight+'px Helvetica';
	ctx.fillStyle='black';
	var twaste=ctx.measureText(message);
	if(twaste.width<width-finalX-3)
		{
			ctx.fillText(message,finalX+3,(this.to-this.from)/2+excessTextHeight/2);
		}else{
			message=formatDecimal(this.cutValue)+getUnit(window.metric);
			ctx.fillText(message,finalX+3,(this.to-this.from)/2+excessTextHeight/2);
			message="Waste";
			ctx.fillText(message,finalX+3,(this.to-this.from)/2+3*excessTextHeight/2);
		}
};
}


function calculateSegments(cuts)
{
	cutSegments=new Array();
	var index=0;
	var unit=shelfHeight/cuts.sectionSize;
	var waste=cuts.waste;
	var wasteLine=unit*waste;
	if(waste>0)
	{
		if(wasteLine<excessTextHeight)
		{
			wasteLine=excessTextHeight;
		}
		cutSegments[index]=new Segment(0, wasteLine, 1, waste, CutType.Waste);
		index++;
	}
	var cutLine=shelfHeight-wasteLine;
	var cutUnit=cutLine/(cuts.sectionSize-cuts.waste);
	var cuttingFrom=wasteLine;
	for(var i=0;i<cuts.data.length;i++)
	{
		var type=CutType.Cut;
		if(cuts.data[i]<0)
		{
			type=CutType.CutOut;
		}
		var segment=Math.abs(cuts.data[i]);
		var segmentLine=segment*cutUnit;
		var count=1;
		if(type==CutType.Cut)
		{
			if(segmentLine<textHeight)
			{
				var flag=true;
				while(flag)
				{
					if(i<cuts.data.length-1)
					{
						if(cuts.data[i]==cuts.data[i+1])
						{
							i++;
							count++;
						}
						else
						{
							flag=false;
						}
					}
					else
					{
						flag=false;
					}
				}

			}
		}
		cutSegments[index]=new Segment(cuttingFrom,segmentLine, count, segment, type);
		index++;
		cuttingFrom=cuttingFrom+count*segmentLine;
	}
	return cutSegments;
}

function compare(a,b)
{
	if(a.length>=b.length)
		{
		return -1;
		}
	else
		{
		return 1;
		}
	}




function GetResults(original,shelfSize,metric)
{
	//array
	var input=new Array();
	for(var i=0;i<original.length;i++)
		{
			input[i]=new Shelf(original[i].quantity, original[i].length);
		}
	input.sort(compare);
	
	var more=true;
	var i=0;
	var results=new Array();
	var currentCuts=new Array();
	while(more)
		{
			var current=input[i];

			current.quantity--;
			currentCuts=new Array();
			currentCuts.push(current.length);
			//var total=current.length;
			var total=new BigDecimal(current.length.toString());
			var cutInProgress=true;
			var j=i;
			while(cutInProgress)
			{
				if(input[j].quantity==0)
				{
					if(j<input.length-1)
					{
						j++;
					}
					else
					{
						cutInProgress=false;
						var waste=shelfSize-parseFloat(total);
						if(waste<0.01)
						{
							waste=0;
						}
						currentCuts=currentCuts.reverse();
						var itm = new Measures(currentCuts, shelfSize, metric, waste, 0, "");
						results.push(itm);
					}
				}
				else
				{
					if(parseFloat(total)+input[j].length<=shelfSize)
						{
						// total+=input[j].length;
						 total=total.add(new BigDecimal(input[j].length.toString()));
						 currentCuts.push(input[j].length);
						 input[j].quantity--;
						}
					else
						{
						if(j<input.length-1)
							{
							j++;
							}
						else
							{
							cutInProgress=false;
							var waste=shelfSize-parseFloat(total);
							if(waste<0.01)
							{
								waste=0;
							}
							currentCuts=currentCuts.reverse();
							var itm=new Measures(currentCuts, shelfSize, metric, waste, 0, "");
							results.push(itm);
							}
						}
				}

			}
			if(current.quantity==0)
				{
				var next=true;
				while(next)
					{
					if(input[i].quantity==0)
						{
						i++;
						if(i==input.length)
							{
							next=false;
							more=false;
							}
						}
					else
						{
						next=false;
						}
					}
				}
		}
	return results;
}

function GetGroupedResults(results)
{
	var hash = new Object(); 
	var newResults = new Array();
	var lineCuts = "";
	for (var i = 0; i < results.length; i++) {
		lineCuts = "";
		for (var j = 0; j < results[i].data.length; j++) {
			if (results[i].data[j] < 0) {
				lineCuts += '[ downrod ]';
			} else {
				lineCuts += '[ ' + results[i].data[j] + getUnit() + ' ]';
			}
		}
		lineCuts += '[ ' + results[i].waste.toString().replace('.', ',') + getUnit() + ' waste ]';
		
		if (hash.hasOwnProperty(lineCuts))
		{
			hash[lineCuts].shelfCount++;
		}else
		{
			results[i].textual = lineCuts;
			results[i].shelfCount++;
			hash[lineCuts] = results[i];
		}
	}
	
	for (var key in hash) {
	    newResults.push(hash[key]);
	}
	
	return newResults;
}

function GetResultsTwo(original,shelfSize,metric)
{
	//array
	var input=new Array();
	for(var i=0;i<original.length;i++)
	{
		input[i]=new Shelf(original[i].quantity, original[i].length);
	}
	input.sort(compare);
	
	var more=true;
	var i=0;
	var results=new Array();
	//var currentCuts=new Array();
	var currentCuts;
	while(more)
		{
			var current=input[i];
			var cutInProgress=true;
			currentCuts=new Array();
			var total=new BigDecimal("0");
			//var total=0;
			var j=i;
			while(cutInProgress)
			{
				if(input[j].quantity==0)
				{
					if(j<input.length-1)
					{
						j++;
					}
					else
					{
						cutInProgress=false;
						var waste=shelfSize-parseFloat(total);
						if(waste<0.01)
						{
							waste=0;
						}
						currentCuts=currentCuts.reverse();
						var itm=new Measures(currentCuts, shelfSize, metric, waste, 0, "");
						results.push(itm);
					}
				}
				else
				{
					var add=true;
					if(metric)
						{
						var mod=(parseFloat(total)+input[j].length-15.24)%30.48;
						if(mod>=0&&mod<2.53||mod>30.479)
							if(parseFloat(total)+2.54+input[j].length<=shelfSize)
							{
								//total+=2.54;
								total=total.add(new BigDecimal("2.54"));
								currentCuts.push(-2.54);
							}
							else
							{
								add=false;
							}
						}
					else
						{
						var mod=(parseFloat(total)+input[j].length-6)%12;
						if(mod>=0&&mod<0.99)
							{
							if(parseFloat(total)+1+input[j].length<=shelfSize)
								{
								//total+=1;
								total=total.add(new BigDecimal("1"));
								currentCuts.push(-1);
								}
							else
								{
								add=false;
								}
							}
						}
					if(parseFloat(total)+input[j].length<=shelfSize&&add)
						{
						 //total+=input[j].length;
						 total=total.add(new BigDecimal(input[j].length.toString()));
						 currentCuts.push(input[j].length);
						 input[j].quantity--;
						}
					else
						{
						if(j<input.length-1)
							{
							j++;
							}
						else
							{
							cutInProgress=false;
							var waste=shelfSize-parseFloat(total);
							if(waste<0.01)
							{
								waste=0;
							}
							currentCuts=currentCuts.reverse();
							var itm=new Measures(currentCuts, shelfSize, metric, waste, 0, "");
							results.push(itm);
							}
						}
				}

			}
			if(current.quantity==0)
				{
				var next=true;
				while(next)
					{
					if(input[i].quantity==0)
						{
						i++;
						if(i==input.length)
							{
							next=false;
							more=false;
							}
						}
					else
						{
						next=false;
						}
					}
				}
		}
	return results;
}

function convert(board,shelves)
{
	if(window.metric)
		{
			board.length=board.length*2.54;
			for(var i=0;i<shelves.length;i++)
				{
					shelves[i].length=shelves[i].length*2.54;
				}
		}
	else
		{
			board.length=board.length/2.54;
			for(var i=0;i<shelves.length;i++)
			{
				shelves[i].length=shelves[i].length/2.54;
			}
		}
}


function getCSSRule(ruleName, deleteFlag) {               // Return requested style obejct
	   ruleName=ruleName.toLowerCase();                       // Convert test string to lower case.
	   if (document.styleSheets) {                            // If browser can play with stylesheets
	      for (var i=0; i<document.styleSheets.length; i++) { // For each stylesheet
	         var styleSheet=document.styleSheets[i];          // Get the current Stylesheet
	         var ii=0;                                        // Initialize subCounter.
	         var cssRule=false;                               // Initialize cssRule. 
	         do {                                             // For each rule in stylesheet
	            if (styleSheet.cssRules) {                    // Browser uses cssRules?
	               cssRule = styleSheet.cssRules[ii];         // Yes --Mozilla Style
	            } else {                                      // Browser usses rules?
	               cssRule = styleSheet.rules[ii];            // Yes IE style. 
	            }                                             // End IE check.
	            if (cssRule)  {       
	            	try
	            	{// If we found a rule...
	               if (cssRule.selectorText.toLowerCase()==ruleName) { //  match ruleName?
	                  if (deleteFlag=='delete') {             // Yes.  Are we deleteing?
	                     if (styleSheet.cssRules) {           // Yes, deleting...
	                        styleSheet.deleteRule(ii);        // Delete rule, Moz Style
	                     } else {                             // Still deleting.
	                        styleSheet.removeRule(ii);        // Delete rule IE style.
	                     }                                    // End IE check.
	                     return true;                         // return true, class deleted.
	                  } else {                                // found and not deleting.
	                     return cssRule;                      // return the style object.
	                  }                                       // End delete Check
	               	}   
	            	}
	            	catch(err)
	            	{
	            		
	            	}
	            	finally
	            	{};// ;End found rule name
	            }                                             // end found cssRule
	            ii++;                                         // Increment sub-counter
	         } while (cssRule)                                // end While loop
	      }                                                   // end For loop
	   }                                                      // end styleSheet ability check
	   return false;                                          // we found NOTHING!
	}     

	

function calculateHardwareResults(){
	var table=document.getElementById("hardwareTable");

	var totalSmallEndCaps=0;
	var totalLargeEndCaps=0;
	var totalWallBrackets=0;
	var totalSupportBrackets=0;
	var totalWallClips=0;
	
	var shelfType=document.getElementById("hardwareShelfPicker");
	var shelfTypeIndex=shelfType.selectedIndex;
	
	var valid=false;

	for(var i = 0; i < table.rows.length; i++) {
		var cell = table.rows[i].cells[0];
		var inputQuantity = cell.children[0];
		var inputLength = cell.children[2];
		var inputLocation = cell.children[1].children[0];
		var lengthValue = inputLength.children[0].value.replace(getUnit(), '').replace(',', '.');
		var quantity = parseFloat(inputQuantity.value);
		var length = parseFloat(lengthValue);
		if(!isNaN(quantity) && !isNaN(length))
		{
			valid=true;
			
			var shelfLocationIndex=inputLocation.selectedIndex;
			
			totalSmallEndCaps+=quantity*calculateSmallEndCaps(shelfTypeIndex);
			totalLargeEndCaps+=quantity*calculateLargeEndCaps(shelfTypeIndex);
			totalWallBrackets+=quantity*calculateWallBrackets(shelfLocationIndex);
			totalSupportBrackets+=quantity*calculateSupportBrackets(length,shelfLocationIndex);
			totalWallClips+=quantity*calculateWallClips(length);
		}

	}
	
	if(!valid){
		alert('Please speficy at least one cut.');
		return false;
	}
	
	var results=new Array();
	
	var zeroIndex=4;
	var nonZeroIndex=0;
	if(totalSmallEndCaps!=0){
		results[nonZeroIndex]=(new Result(totalSmallEndCaps, "Small End Caps"));
		nonZeroIndex++;
	}else{
		results[zeroIndex]=new Result(totalSmallEndCaps, "Small End Caps");
		zeroIndex--;
	}
	if(totalLargeEndCaps!=0){
		results[nonZeroIndex]=(new Result(totalLargeEndCaps, "Large End Caps"));
		nonZeroIndex++;
	}else{
		results[zeroIndex]=(new Result(totalLargeEndCaps, "Large End Caps"));
		zeroIndex--;
	}
	if(totalSupportBrackets!=0){
		results[nonZeroIndex]=(new Result(totalSupportBrackets, "Support Brackets"));
		nonZeroIndex++;
	}else{
		results[zeroIndex]=(new Result(totalSupportBrackets, "Support Brackets"));
		zeroIndex--;
	}
	
	if(totalWallBrackets){
		results[nonZeroIndex]=(new Result(totalWallBrackets, "Wall Brackets"));
		nonZeroIndex++;
	}else{
		results[zeroIndex]=(new Result(totalWallBrackets, "Wall Brackets"));
		zeroIndex--;
	}
	
	if(totalWallClips){
		results[nonZeroIndex]=(new Result(totalWallClips, "Wall Clips"));
		nonZeroIndex++;
	}else{
		results[zeroIndex]=(new Result(totalWallClips, "Wall Clips"));
		zeroIndex--;
	}
	
	displayResults(results);
	return true;
}


function displayResults(results){
	var title="hardwareNeedsTitle";
	var value="hardwareNeedsValue";
	for(var i=0;i<results.length;i++){
		var titleId=title+(i+1).toString();
		var hTitle=document.getElementById(titleId);
		hTitle.innerHTML=results[i].name;
		var valueId=value+(i+1).toString();
		var hValue=document.getElementById(valueId);
		hValue.innerHTML=results[i].value;
	}
}

function Result(value,name){
	this.value=value;
	this.name=name;
}


//<integer-array name="hardware_small_end_caps">
//<item>8</item>
//<item>10</item>
//<item>10</item>
//<item>4</item>
//<item>6</item>
//</integer-array>
function calculateSmallEndCaps(shelfTypeIndex){
	switch (shelfTypeIndex) {
	case 0:
		return 8;
		break;

	case 1:
		return 10;
		break;

	case 2:
		return 10;
		break;
		
	case 3:
		return 4;
		break;
	
	case 4:
		return 6;
		break;

	default:
		break;
	}
}

//<integer-array name="hardware_large_end_caps">
//<item>0</item>
//<item>0</item>
//<item>0</item>
//<item>4</item>
//<item>4</item>
//</integer-array>
function calculateLargeEndCaps(shelfTypeIndex){

	switch (shelfTypeIndex) {
	case 3:
		return 4;
		break;

	case 4:
		return 4;
		break;

	default:
		return 0;
		break;
	}
}

//<integer-array name="hardware_wall_brackest">
//<item>2</item>
//<item>1</item>
//<item>0</item>
//</integer-array>
function calculateWallBrackets(shelfLocationIndex){
	switch (shelfLocationIndex) {
	case 0:
		return 2;
		break;
	case 1:
		return 1;
		break;
	case 2:
		return 0;
		break;
	default:
		return 0;
		break;
	}
}



//<integer-array name="hardware_support_brackest">
//<item>0</item>
//<item>1</item>
//<item>2</item>
//</integer-array>

function truncate(n) {
	  return n | 0; // bitwise operators convert operands to 32-bit integers
	}

function calculateSupportBrackets(length,shelfLocationIndex){
	var addOn=0;
	switch (shelfLocationIndex) {
	case 0:
		addOn = 0;
		break;
	case 1:
		addOn = 1;
		break;
	case 2:
		addOn = 2;
		break;
	default:
		break;
	}
	var brackets = truncate((length-3)/36);
	brackets += addOn;
	return brackets;
}



//private int calculateWallClips(HardwareShelf s){
//int clips=(int) Math.ceil(((s.getLength() - 4.0) / 12.0) + 1);
//clips=(clips<3?3:clips);
//return clips;
//}
function calculateWallClips(length){
	var clips=Math.ceil((length-4) / 12 + 1);
	clips=(clips<3?3:clips);
	return clips;
}








//private int calculateSmallEndCaps(int shelfTypeIndex,int values[]){
//return values[shelfTypeIndex];
//}

//private int calculateLargeEndCaps(int shelfTypeIndex,int values[]){
//return values[shelfTypeIndex];
//}

//private int calculateSupportBrackets(HardwareShelf s,int values[]){
//int brackets=(int) ((s.getLength()-3)/36);
//brackets+=values[s.getLocationType()];
//return brackets;
//}

//private int calculateWallBrackets(HardwareShelf s,int values[]){
//return values[s.getLocationType()];
//}



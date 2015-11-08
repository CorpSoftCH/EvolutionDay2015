_spBodyOnLoadFunctionNames.push("colorizetasks");

function colorizetasks(){var doc = document.getElementById('scriptWPQ2');
var tables = doc.getElementsByTagName('table');
var tb = tables[1].getElementsByTagName('tbody');
var list = tb[0].childNodes;

for(var i = 0; i < list.length;i++){

	var item = list[i];	
	item.style.backgroundColor = "#0089B2";
	item.style.color = "white";

	i++;
		
}
}
var mainDoc = SpreadsheetApp.getActive().getSheetByName('main');
var dataDoc = SpreadsheetApp.getActive().getSheetByName('data');

function clearForm() {
  mainDoc.getRange('A10').clearContent();
  mainDoc.getRange('B10:C31').clearContent();
  mainDoc.getRange('E10:E31').clearContent();
  mainDoc.getRange('A11:A32').setValue('=if(weekday(A10+1,2)<6, if(month(A10+1) <> month(A10), "", A10+1), if(month(A10+3) <> month(A10), "", A10+3))');
  mainDoc.getRange('D10:D32').setValue('=CalculateMileage(E10)');
}


function CalculateMileage(siteString) {
  var siteArray = siteString.split(" ").join("").toUpperCase();
  siteArray = siteArray.split(",");
  var temp = 0;
  
  if (siteString == "") {
    return 0;
  } else {
    
    for (var i = 0; i < (siteArray.length - 1); i++) {
      
      temp += mileage(siteArray[i], siteArray[i+1]);
    }
    return temp;
  }
}
  
function mileage(start, end) {
  var range = dataDoc.getSheetValues(1, 1, 420, 3);
  var z = 0;
  var distance;
  
  for (var i = 0; i < range.length; i++) {
    if ((range[i][0] == start) && (range[i][1] == end)) {
      z = range[i][2];
    }
    
  }
  
  return z;
}

function print() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();  
  
  var gid = mainDoc.getSheetId();
  
  var pdfOpts = '&size=letter&fzr=false&portrait=true&fitw=true&gridlines=false&printtitle=false&sheetnames=false&pagenum=UNDEFINED&attachment=false&gid='+gid;
  
  var printRange = '&c1=0' + '&r1=1' + '&c2=6' + '&r2=45'
  var url = ss.getUrl().replace(/edit$/, '') + 'export?format=pdf' + pdfOpts + printRange;
  
  var htmlOut = HtmlService.createHtmlOutput('<a href="' + url + '" target="_blank">Get PDF</a>').setWidth(200).setHeight(200);
  SpreadsheetApp.getUi().showModalDialog(htmlOut, 'Print this sheet');
}

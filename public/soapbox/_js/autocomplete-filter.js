$(document).ready(function(){
  //for autocomplete controller
  $("#search_restaurant_eq_any_name").autocomplete({
    source: "/soapbox?name=restaurant",
  }).data("autocomplete")._renderItem = function (ul, item) {
    if(["No results found, please try a new search","RESTAURANTS BY NAME", "KEYWORD", "FEATURE", "CUISINE"].indexOf(item.label) > -1){
          return $("<li></li>")
             .data("item.autocomplete", item)
             .append("<font color='black'>" + item.label + "</font>")
             .appendTo(ul);
           }
           else{
              return $("<li></li>")
             .data("item.autocomplete", item)
             .append("<a>" + item.label + "</a>")
             .appendTo(ul);
           }
     };
  
  $("#search_restaurant_by_state_or_region").autocomplete({
    source: "/soapbox?name=region",
  }).data("autocomplete")._renderItem = function (ul, item) {
     if(["No results found, please try a new search","RESTAURANTS BY REGION", "RESTAURANTS BY STATE"].indexOf(item.label) > -1){
         return $("<li></li>")
             .data("item.autocomplete", item)
             .append("<font color='black'>" + item.label + "</font>")
             .appendTo(ul);
           }
           else{
              return $("<li></li>")
             .data("item.autocomplete", item)
             .append("<a>" + item.label + "</a>")
             .appendTo(ul);
           }
     };

  $('#search_person_eq_any_name').autocomplete({
    source: "/soapbox?soapbox=soapbox&person=person"
  }).data("autocomplete")._renderItem = function (ul, item) {
    if(["No results found, please try a new search","PERSONS BY NAME","PERSONS BY SPECIALITY","PERSONS BY CUISINE"].indexOf(item.label) > -1){
          return $("<li></li>")
             .data("item.autocomplete", item)
             .append("<font color='black'>" + item.label + "</font>")
             .appendTo(ul);
           }
           else{
              return $("<li></li>")
             .data("item.autocomplete", item)
             .append("<a>" + item.label + "</a>")
             .appendTo(ul);
           }
     };
  $("#search_person_by_state_or_region").autocomplete({
    source: "/soapbox?soapbox=soapbox&person=region"
  }).data("autocomplete")._renderItem = function (ul, item) {
    if(["No results found, please try a new search","PERSONS BY STATE","PERSONS BY REGION"].indexOf(item.label) > -1){
         return $("<li></li>")
             .data("item.autocomplete", item)
             .append("<font color='black'>" + item.label + "</font>")
             .appendTo(ul);
           }
           else{
              return $("<li></li>")
             .data("item.autocomplete", item)
             .append("<a>" + item.label + "</a>")
             .appendTo(ul);
           }
     };
  
});
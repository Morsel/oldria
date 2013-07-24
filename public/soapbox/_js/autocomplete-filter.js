$(document).ready(function(){
  //for autocomplete controller
  $("#search_restaurant_eq_any_name").autocomplete({
    source: "/auto_complete.js?name=restaurant",
  }).data("autocomplete")._renderItem = function (ul, item) {
    if(["This keyword does not yet exist in our database.","RESTAURANT BY NAME", "RESTAURANT BY OTM", "RESTAURANT BY FEATURE", "RESTAURANT BY CUISINE"].indexOf(item.label) > -1){
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
    source: "/auto_complete.js?name=region",
  }).data("autocomplete")._renderItem = function (ul, item) {
    if(["This keyword does not yet exist in our database.","RESTAURANT BY REGION", "RESTAURANT BY STATE"].indexOf(item.label) > -1){
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
    source: "/auto_complete.js?soapbox=soapbox&person=person"
  }).data("autocomplete")._renderItem = function (ul, item) {
    if(["This keyword does not yet exist in our database.","PERSON BY NAME","PERSON BY SPECIALITY","PERSON BY CUISINE"].indexOf(item.label) > -1){
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
    source: "/auto_complete.js?soapbox=soapbox&person=region"
  }).data("autocomplete")._renderItem = function (ul, item) {
    if(["This keyword does not yet exist in our database.","PERSON BY STATE","PERSON BY REGION"].indexOf(item.label) > -1){
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
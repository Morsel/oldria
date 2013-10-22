$(document).ready(function(){
  var i=0;
  var label="";
  //for autocomplete controller
  $("#search_restaurant_eq_any_name").autocomplete({
    source: "/auto_complete/index?name=restaurant",
    open: function(event,ui){
      if( (i>0) && (label!="No results found, please try a new search") )
      $('.ui-autocomplete').append("<li><a onclick=$.fn.search('"+label.toLowerCase()+"')><font color='green'>Keep typing to refine your search</font></a></li>");
      i=0;
      label="";
    }
  }).data("autocomplete")._renderItem = function (ul, item) {
      if(["No results found, please try a new search","RESTAURANTS BY NAME", "KEYWORD", "FEATURE", "CUISINE"].indexOf(item.label) > -1){
        if ( (label=="RESTAURANTS BY NAME") && (i>0) ){
          i=i+2;
          label=item.label;
          return $("<li></li>")
                 .data("item.autocomplete", $("#search_restaurant_eq_any_name").val())
                 .append("<a onclick=$.fn.search('name')><font color='green'>Keep typing to refine your search</font></a>")
                 .appendTo(ul)+$("<li></li>")
                 .data("item.autocomplete", item)
                 .append("<font color='black'>" + item.label + "</font>")
                 .appendTo(ul);
        }
        else if ( (label=="KEYWORD") && (i>0) ){
          i=i+2;
          label=item.label;
          return $("<li></li>")
                 .data("item.autocomplete", $("#search_restaurant_eq_any_name").val())
                 .append("<a onclick=$.fn.search('keyword')><font color='green'>Keep typing to refine your search</font></a>")
                 .appendTo(ul)+$("<li></li>")
                 .data("item.autocomplete", item)
                 .append("<font color='black'>" + item.label + "</font>")
                 .appendTo(ul);
        }
        else if ( (label=="FEATURE") && (i>0) ){
          i=i+2;
          label=item.label;
          return $("<li></li>")
                 .data("item.autocomplete", $("#search_restaurant_eq_any_name").val())
                 .append("<a onclick=$.fn.search('feature')><font color='green'>Keep typing to refine your search</font></a>")
                 .appendTo(ul)+$("<li></li>")
                 .data("item.autocomplete", item)
                 .append("<font color='black'>" + item.label + "</font>")
                 .appendTo(ul);
        }
        else if ( (label=="CUISINE") && (i>0) ){
          i=i+2;
          label=item.label;
          return $("<li></li>")
                 .data("item.autocomplete", $("#search_restaurant_eq_any_name").val())
                 .append("<a onclick=$.fn.search('cuisine')><font color='green'>Keep typing to refine your search</font></a>")
                 .appendTo(ul)+$("<li></li>")
                 .data("item.autocomplete", item)
                 .append("<font color='black'>" + item.label + "</font>")
                 .appendTo(ul);
        }
        else if (i==0){
          i++;
          label=item.label;
          console.log(label);
          return $("<li></li>")
               .data("item.autocomplete", item)
               .append("<font color='black'>" + item.label + "</font>")
               .appendTo(ul);
        }
      }
      else{
          i++;
          return $("<li></li>")
           .data("item.autocomplete", item)
           .append("<a>" + item.label + "</a>")
           .appendTo(ul);
      }
     };
  
  $("#search_restaurant_by_state_or_region").autocomplete({
    source: "/auto_complete/index?name=region",
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
    source: "/auto_complete/index?person=person"
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
    source: "/auto_complete/index?person=region"
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


  // Restaurant directory search
  var $restoDirectoryList = $("#restaurant_directory_list");
  // var $restoDirectoryInputs = $("#directory_search #restaurant_criteria #restaurant_search");
  var $restoDirectoryInputs;
  
  $.fn.search = function(arg){        
    $('ul.ui-autocomplete').hide();
    value=$("#search_restaurant_eq_any_name").val();
    $("#search_restaurant_eq_any_name").val(value);
    $restoDirectoryInputs = $("#directory_search #restaurant_criteria #search_restaurant_eq_any_name");
    input_string = $restoDirectoryInputs.serialize();
    $restoDirectoryList.hide();
    $('.loader').show();
    $restoDirectoryList.load('/directory/search_restaurant_by_name?name='+arg, input_string, function(responseText, textStatus){
      $('.loader').hide();
      $restoDirectoryList.fadeIn(300);
    });
  }

});
// $('form').on('submit',function(){
// 	$(this).validate();
// });

// $('form').each(function(){
// $(this).data("validator").settings.ignore = "";
// 	$(this).validate({
//          // ignore: ":hidden:not(.selectpicker)",
//           errorPlacement: function (error, element) {
//             // alert(element);
//             if ($(element).is('select')) {
//                 element.next().after(error); // special placement for select elements
//             } else {
//                 error.insertAfter(element);  // default placement for everything else
//             }
//         }
//     });
	   
	    

// });

  $('form').each(function(){
  
    $(this).validate({
         ignore: ":hidden:not(.selectpicker)",
          errorPlacement: function (error, element) {
            // alert(element);
            if ($(element).is('select')) {
                element.next().after(error); // special placement for select elements
            } else {
                error.insertAfter(element);  // default placement for everything else
            }
        }
    });
  });


$('.modal').on('shown.bs.modal', function() {
  FormsIcheck.init();
  $('.loader').fadeOut('slow')
  // $('form#new_phase').data("validator").settings.ignore = "";
  $('form').each(function(){
    $(this).validate({
         ignore: ":hidden:not(.selectpicker)",
          errorPlacement: function (error, element) {
            // alert(element);
            if ($(element).is('select')) {
                element.next().after(error); // special placement for select elements
            } else {
                error.insertAfter(element);  // default placement for everything else
            }
        }
    });
  });
});

  $(".color").colorpicker();

 $('.datepicker').datepicker({ 
    format: 'dd-mm-yyyy',orientation: 'auto',autoclose: true });



$('form').each(function(){
$(this).on('submit',function(){
    if($(this).valid()){
    $('.loader').show();
    }
});

   // $(this).validate();
//     $('.selectpicker').each(function(){

// if($(this).hasClass('error')){
   
//     var html_val = $(this).next('label.error').clone();

//     $(this).next('label.error').remove();
//     $(this).next('.bootstrap-select').parent('div').append(html_val);
// }
// });
});

// var t;

// $( document ).on(
//     'DOMMouseScroll mousewheel scroll',
//     '.modal', 
//     function(){       
//         window.clearTimeout( t );
//         t = window.setTimeout( function(){            
//             $('.datepicker').datepicker('place')
//         }, 100 );        
//     }
// );


$(document).on("click",".show_loader", function(){
  $(".loader").show();
})


$(document).ready(function () {
    $('.summernote').summernote();
    $('.summernote_rfl').summernote();
$(".lo_summary_summernote").summernote();
$(".report_lo_summernote").summernote();

$(".reportsubject_summernote").summernote();

lg_hide_empty = function(){
  $('.learning_group_select').empty();
$('.learning_group_select').hide();
$('.show_learning_group_students').empty();
$('.show_learning_group_students').hide();

}

tg_hide_empty = function(){
$('.tutor_group_select').empty();
$('.tutor_group_select').hide();
$('.show_tutor_group_students').empty();
$('.show_tutor_group_students').hide();
};
    Pleasure.init();
    Layout.init();
    TablesDataTables.init();
    FormsIcheck.init();
  });
 // $('select').select2();




 
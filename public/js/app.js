$(document).ready(function(){
	$('#add-transaction').on('click', function(){
		$('#new-transaction').slideDown('fast');
	});

	$('#cancel-btn').on( 'click', function(){
		$('#new-transaction').slideUp('fast');
	});

	$('.delete-btn').on('click', function(e){
  	$(e.target).parents('form').submit();
  });

  $('.transaction').on('click', function(e){
  	$('.show-buttons').hide();
  	$(e.target).find('.show-buttons').show();
  });
  
  $('.edit-btn').on('click', function(e){
    _id = $(e.target).data("id");
    $('#transactions-list').hide('slide',{direction:'left'},500);
    $('#edit-transaction').show('slide',{direction:'right'},500, function(e){
      $(this).load('transactions/'+_id+'/edit');
    });
  });

  $('#edit-transaction').on('click', '#edit-cancel-btn', function(e){
    $('#transactions-list').show('slide',{direction:'left'},500);
    $('#edit-transaction').hide('slide',{direction:'right'},500);
  })
	
});
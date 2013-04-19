// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require_tree .
$(function(){
	
	// Open/Close Attachment
	////////////////////////////////////////////////////////////
	$('.FILE_OPEN').click(function(){
		
		var c = $(this).closest('form').find('.open_close').val();
		var n = c;
		if (c == 1){
			n = 0;
		} else {
			n = 1;
		}
		
		$(this).closest('.ATTACHMENT').find('.INNER').slideToggle(100);
		if ($(this).val().toLowerCase() == 'open'){
			$(this).val('Close');
		} else {
			$(this).val('Open');
		}
		$(this).closest('form').find('.open_close').val(n);
		
	});
	////////////////////////////////////////////////////////////
	
	
	// Background Form Submit
	////////////////////////////////////////////////////////////
	$('.BSUB').submit(function(){
		
		var Action = $(this).closest('form').attr('caction');
		var Method = $(this).closest('form').attr('cmethod');
		var Data = $(this).closest('form').serialize();
		
		$.ajax({
			
			url: Action,
			type: Method,
			data: Data,
			//contentType: 'application/json',
			success: function(){
				
			},
			complete: function(){
				
			}
			
		});
		
		return false;
		
	});
	////////////////////////////////////////////////////////////
	
	
	// Update Attachment Keys
	////////////////////////////////////////////////////////////
	$('.UPKEY').change(function(){
		
		var Key = $(this).attr('key');
		$('#edit_keys_'+Key).submit();
		
	});
	////////////////////////////////////////////////////////////
	
	
	// Disable by 'off' attribute
	////////////////////////////////////////////////////////////
	disabledElements();
	////////////////////////////////////////////////////////////
	
	
	
	// Put Loading.. in parent
	////////////////////////////////////////////////////////////
	$('.RLOAD').click(function(){
		
		$(this).parent().parent().parent().html('LOADING...');
		
	});
	////////////////////////////////////////////////////////////
	
	
	
	// ZENDESK Test
	////////////////////////////////////////////////////////////
	$('.ZENDESK').click(function(){
		
		Zendesk(this);
		
	});
	////////////////////////////////////////////////////////////
	
	
	$('.ghost').focus(function() {
	  if ($(this).val()==$(this).attr("title")) { $(this).val(""); }
	}).blur(function() {
	  if ($(this).val()=="") { $(this).val($(this).attr("title")); }
	});
	
	
	$('.HOVER').mouseover(function(){
		
		$(this).attr('src',$(this).attr('over'));
		
	});
	$('.HOVER').mouseout(function(){
		
		$(this).attr('src',$(this).attr('up'));
		
	});
	
	$('.AUTOSELECT').change(function(){
		
		$(this).closest('form').submit();
		
	});
	
});


// Disable by 'off' attribute
////////////////////////////////////////////////////////////
function disabledElements(){
	
	$('input,select').each(function(){
		
		if ($(this).attr('off') == 'true'){
			$(this).attr('disabled','disabled');
		}
		
	});
	
}
////////////////////////////////////////////////////////////



// Test Zendesk Connection
////////////////////////////////////////////////////////////
function Zendesk(button){
	
	$(button).attr('disabled','disabled').val('Testing...');
	
	var Data = {}
	Data.client = {}
	Data.client.subdomain = $('#client_subdomain').val();
	Data.client.username = $('#client_username').val();
	Data.client.password = $('#client_password').val();
	Data = $.toJSON(Data);
	
	$.ajax({
		
		url: '/zendesk/test',
		type: 'POST',
		data: Data,
		contentType: 'application/json',
		success: function(data){
			alert(data.message);
		},
		error: function(data){
			
		},
		complete: function(){
			$(button).removeAttr('disabled').val('Test Connection');
		}
		
	});
	
}
////////////////////////////////////////////////////////////
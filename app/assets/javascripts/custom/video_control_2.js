
var survey_form=null;
var video_form=null;
var myModal=null;
var progress=null;
var progress_bar=null;
var myPlayer=null;
var device= new Object();
var next_btn=null;

var modal_dialog=null;
var modal_body=null;
var modal_header=null;
var modal_footer=null;
var rating=null;
var html_body=null;
var window_height=window.innerHeight;
var modal_header_height=56;
var modal_footer_height=53;
var modal_isopen=false;

function dom_caching(){

	survey_form=$('#survey_form');
	video_form=$("#video_form");
	progress=$(".progress");
	myModal=$("#myModal");
	progress_bar=$(".progress-bar");
	myPlayer=videojs(vid_tag_id);
	next_btn=$("#next_btn");
	modal_dialog=$(".modal-dialog");
	modal_body=$(".modal-body");
	modal_header=$(".modal-header");
	modal_footer=$(".modal-footer");
	rating=$("#rateYo");
	html_body=$('html, body');

}

$(document).ready(function() {
		
	//all dom obj caching
	dom_caching();

	//is touch device?
	if(is_touch_device()) {
		device.type='touch';
		//animation speed
		device.animation=0;
		//remove fade animation
		myModal.removeClass('fade');
		show_loading_bar();
	} else {
		//set default animation
		device.type='fast';
		device.animation='slow';
		if(myModal.hasClass('fade')){	
		} else{
			myModal.addClass('fade');
		}
		hide_loading_bar();
	}
	//for fullscreen layer
	setinner_modal();
	//survey
	hide_survey();

	//video
	hide_video();

	//video setting start
	myPlayer.ready(get_info);

});

function get_info() {
	
	this.off('ready',get_info);
	video_link=null;
	
	//rating in modal
	star_rating_on();
	

	//modal show/hide handler
	myModal.on('shown.bs.modal',function(e){
			modal_isopen=true;
			modal_header_height=modal_header.outerHeight();
			modal_footer_height=modal_footer.outerHeight();
			window_resize();
			modal_body.animate({scrollTop : 0}, 0);
			focus_modal();
		}
	);
	

	myModal.on('hidden.bs.modal',function(){
			modal_isopen=false;
			focus_video();
		}
	);
	//resize event handler	
	$(window).on("resize",window_resize).resize();

	
	
	//get method caching disable
	jQuery.ajaxSetup({cache:false});
	
	//get survey info
	$.ajax({
		type: 'GET',
		url: '/get_first_infomation',
		data: {survey: JSON.stringify('init'),},
		dataType: 'json',
		success: ajax_get_data,
		error: ajax_error
	});
		

}

function ajax_get_data(data) {
		
	if(video_link=='/assets/'+data[0].videoURL) {
		
		//링크가 일치하면 영상을 계속 진행
		count++;
		myPlayer.on("timeupdate",time_out);
		set_curtime();
		hide_survey();

		myPlayer.play();

	} else{
		//revoke url obj
		(window.URL).revokeObjectURL(myPlayer.currentSrc());
		//처음이거나 해당 영상의 샷을 다 진행해서 다음 링크를 받은경우
		video_link='/assets/'+data[0].videoURL;
		start_list=data[0].startTimeList;
					
		end_list=data[0].endTimeList;
		shot_id_list=data[0].shotIDList;
		cid=data[0].CID;
		filename=data[0].title;

		init();
	}	
	data=null;
}

function ajax_error(request, status, error ) {
			
	console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				
	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
																										
}

function init() {
	
	//reset count
	count=0;

	switch(device.type) {
		//바로시작
		case 'fast' : fast_start(); break;
		//다운로드 후 시작
		default : nomal_start(); break;
	}
}

function nomal_start() {
	
	video_download(video_link);
}

function video_download(url){
	
	//show_loading_bar();
	hide_video();

	var xhr = new XMLHttpRequest();
	xhr.open('GET', url, true);
	xhr.responseType = 'blob';
	xhr.onload = function(e) {
	  if (this.status == 200) {
			var myBlob = this.response;
			//var vid = (window.webkitURL ? webkitURL : URL).createObjectURL(myBlob);
			var vid = (window.URL).createObjectURL(myBlob);

			myPlayer.src(vid);
			//meta data downloading
			myPlayer.on('loadedmetadata',loading_metadata);
			xhr=null;
		}
	}
	xhr.onprogress = function(e) {
		if(e.lengthComputable) {
			
			set_loading_bar((e.loaded / e.total*100)+'%')
			
			if(e.loaded==e.total) {
				hide_loading_bar();
			}

		}
	}
	xhr.onreadystatechange= function(e) {
		if(xhr.readyState==4) {
			//응답을 받음
			if(xhr.status==404) {
				//파일이 없을때
				//hide progress bar
				hide_loading_bar();
				
				alert('video download fail please check file url or reload');
			} else if(xhr.status==200){
				//console.log("find file");
			} else {
				console.log("other error...");
				alert('server resopn: '+xhr.status);
			}
		}
	}

	xhr.send();	
}

function fast_start(){
	
	myPlayer.src(video_link);

	myPlayer.on('loadedmetadata',loading_metadata);

}

function loading_metadata() {
	
	count=0;
	this.off('loadedmetadata',loading_metadata);
	this.on('loadeddata',loading_data);
}

function loading_data() {
	this.off('loadeddata',loading_data);
	
	set_curtime();
	this.on("timeupdate",time_out);
	show_video();

	this.play();	

}

function time_out() {
	
	if(this.duration()<end_list[count]) {
		//영상의 전체길이보다 더 긴 경우 수정
		end_list[count]=this.duration();
	}

	if(this.currentTime()>=end_list[count]) {
		this.off("timeupdate",time_out);
		this.pause();
		show_survey();
	}
}

function set_curtime() {
	
	myPlayer.currentTime(start_list[count]);
}

function next_button() {
	
	//disable button
	next_btn.prop('disabled',true);
	
	var survey = new Object();
	
	survey.cid=cid;
	survey.filename=filename;
	survey.shot_id=shot_id_list[count];
	survey.comment='good';
	survey.ratinng= rating.rateYo('rating');
	survey.time=end_list[count];
	
	$.ajax(
		{	
			type: 'POST',
			url: '/get_first_infomation',
			data: {survey: JSON.stringify(survey),},
			dataType: 'json',
			success: ajax_get_data,
			error: ajax_error
		}
	);
	//release obj
	survey=null;
	
}


function show_loading_bar(){
	progress.show(device.animation);
}
function hide_loading_bar(){
	progress.hide();
}
function set_loading_bar(per){
	progress_bar.css('width',per);
}

function show_video() {
	
	video_form.show('slide',device.animation,focus_video);
}
function hide_video() {
	video_form.hide();
}

function show_survey() {
	
	survey_form.show(device.animation);

	video_form.css("float","left");
	
	if(myPlayer.isFullscreen()){
		myPlayer.children()[9].show();;	
	} else{
		myModal.modal("show",device.animation);	
	}
	
	
	
	next_btn.prop('disabled',false);
}

function hide_survey() {
	
	survey_form.hide();
	video_form.css("float","none");
	myModal.modal("hide");
	myPlayer.children()[9].hide();	
}



function star_rating_on() {
	rating.rateYo({
		rating: 3.0,//default rating
		numStars: 5,
		maxValue:10,
		halfStar: true
	});	 
}

function is_touch_device() {
  return 'ontouchstart' in window        // works on most browsers 
      || navigator.maxTouchPoints;       // works on IE10/11 and Surface
};


function window_resize(e){

	//screen height renewal
	window_height=this.innerHeight;
	if(modal_isopen){
		modal_resize();//modal resize

		focus_modal();//scroll to modal	
	} else{
		//scroll to video
		focus_video();
	}

}

function focus_video(){
	html_body.animate({scrollTop : video_form.offset().top}, device.animation);
}
function focus_modal(){
	html_body.animate({scrollTop : modal_footer.offset().top}, device.animation);
}
function modal_resize(){
	
	var dialog_height=window_height;
	var body_height=null;
	var extra=modal_header_height + modal_footer_height;
	
	if(device.type=='fast'){
		dialog_height/=2;
	}
	body_height=dialog_height - extra;
	
	modal_dialog.css('max-height',dialog_height);
	modal_body.css('max-height',body_height);
}

function setinner_modal(){
	domel=videojs.createEl('ModalDialog', {
		innerHTML: myModal.html()
	});
	aa=myPlayer.addChild('ModalDialog', {'el': domel});	
	myPlayer.children()[9].hide();
}












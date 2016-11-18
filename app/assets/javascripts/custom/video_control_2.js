$(document).ready(function() {
					
	//hide all object
	
	//survey
	$( '#survey_form' ).ready(hide_survey);
	//loading bar
	$( ".progress" ).ready(hide_loading_bar);
	//video
	$("#video_form").ready(hide_video);

	//video setting start
	videojs(vid_tag_id).ready(get_info);

});

function get_info() {
	
	video_link=null;
	
	//rating in modal
	star_rating_on();
	
	//screen rotaet handler
	$(window).bind('orientationchange',mobile_rotate);	
	
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
	//console.log('submit success '+data.link);
				
	if(video_link=='/assets/'+data[0].videoURL) {
		//링크가 일치하면 영상을 계속 진행
		count++;
		videojs(vid_tag_id).on("timeupdate",time_out);
		set_curtime(videojs(vid_tag_id));
		videojs(vid_tag_id).play();					
	} else{
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
	
	count=0;
	//시작옵션
	var option='fast';
	
	if(is_touch_device()) {
		option='touch';
		
	}


	switch(option) {
		//바로시작
		case 'fast' : fast_start(videojs(vid_tag_id)); break;
		//다운로드 후 시작
		default : nomal_start(videojs(vid_tag_id)); break;
	}
}

function nomal_start(myPlayer) {
	
	//기존에 받은 영상 해제
	(window.webkitURL ? webkitURL : URL).revokeObjectURL(myPlayer.currentSrc());
	video_download(myPlayer,video_link);
}

function video_download(myPlayer,url){
	
	show_loading_bar();
	hide_video();
	
	console.log("Downloading video...hellip;Please wait...")
	
	var xhr = new XMLHttpRequest();
	xhr.open('GET', url, true);
	xhr.responseType = 'blob';
	xhr.onload = function(e) {
	  if (this.status == 200) {
			console.log("got it");
			var myBlob = this.response;
			var vid = (window.webkitURL ? webkitURL : URL).createObjectURL(myBlob);

			console.log("set video source");
			myPlayer.src(vid);
			//meta data downloading
			myPlayer.on('loadedmetadata',loading_metadata);
			xhr=null;
		}
	}
	xhr.onprogress = function(e) {
		if(e.lengthComputable) {

			//console.log((e.loaded / e.total*100));
			
			$(".progress-bar").css('width',(e.loaded / e.total*100)+'%');
			
			if(e.loaded==e.total) {
				hide_loading_bar();
				show_video();
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
				console.log("find file");
			} else {
				console.log("other error...");
				alert('server resopn: '+xhr.status);
			}
		}
	}

	xhr.send();	
}

function fast_start(myPlayer){
	
	show_video();
	
	console.log('fast_start');
	myPlayer.src(video_link);

	
	myPlayer.on('loadedmetadata',loading_metadata);
	myPlayer=null;
}

function loading_metadata() {
	
	console.log('loadmetadata');
	count=0;
	this.off('loadedmetadata',loading_metadata);
	this.on('loadeddata',loading_data);

}

function loading_data() {
	this.off('loadeddata',loading_data);
	set_curtime(this);
	this.on("timeupdate",time_out);
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

function set_curtime(myPlayer) {
	
	myPlayer.currentTime(start_list[count]);
	myPlayer=null;
}

function next_button() {
	
	var survey = new Object();
	
	survey.cid=cid;
	survey.filename=filename;
	survey.shot_id=shot_id_list[count];
	survey.comment='good';
	survey.ratinng= $("#rateYo").rateYo('rating');
	survey.time=end_list[count];
	
	hide_survey();
	
	$.ajax({
		type: 'POST',
		url: '/get_first_infomation',
		data: {survey: JSON.stringify(survey),},
		dataType: 'json',
		success: ajax_get_data,
		error: ajax_error
	});
	
	
	
	dat=null;
	
}


function show_loading_bar(){
	$(".progress").show();
}
function hide_loading_bar(){
	$(".progress").hide();
}

function show_video() {
	$("#video_form").show('slide');
}
function hide_video() {
	$("#video_form").hide();
}

function show_survey() {
	
	$("#survey_form").show('slide');
	$("#video_form").css("float","left");
	$("#myModal").modal("show");
	//move scroll
	$('html, body').animate({scrollTop : $("#survey_form").offset().top}, 400);
}

function hide_survey() {
	$('.modal-backdrop').remove();
	$("#survey_form").hide();
	$("#video_form").css("float","none");
	$("#myModal").modal("hide");
	
	//move scroll
	$('html, body').animate({scrollTop : $("#video_form").offset().top}, 400);
}


function mobile_rotate() {

	if($('#survey_form').css('display') =='none') {
		$('html, body').animate({scrollTop : $("#video_form").offset().top}, 400);
	} else {
		$('html, body').animate({scrollTop : $(".modal-footer").offset().top}, 400);
	}
		
}

function star_rating_on() {
	
	$("#rateYo").rateYo({
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
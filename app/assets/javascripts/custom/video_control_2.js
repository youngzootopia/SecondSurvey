


$( document ).ready(function() {
					
	//시작하자마자 비디오를 숨긴다
	$( '#survey_form' ).ready(hide_survey);
	$( ".progress" ).ready(hide_loading_bar);
	first();
	
	$("#rateYo").rateYo({
    rating: 3.0,
	numStars: 5,
	maxValue:10,
	halfStar: true
  });
					
});

function first() {
	
	video_link=null;
	$.ajax({
		type: 'GET',
		url: '/get_first_infomation',
		data: {survey: JSON.stringify('init'),},
		dataType: 'json',
		success: ajax_get_data,
		error: ajax_error
	});
		
}



function init() {
	
	count=0;
	
	//시작옵션
	var option='fast';
	//var option='complete';
	
	switch(option) {
		//바로시작
		case 'fast' : fast_start(videojs(vid_tag_id)); break;
		//다운로드 후 시작
		default : nomal_start(videojs(vid_tag_id)); break;
	}
}

function fast_start(myPlayer){
	console.log('fast_start');
	myPlayer.src(video_link);
	//video_link=null;
	
	//myPlayer.on('loadeddata',loading_start);
	myPlayer.on('loadedmetadata',loading_end);
	myPlayer=null;
}
function loading_start() {
	this.off('loadeddata',loading_start);
	set_curtime(this);
	this.on("timeupdate",time_out);
	this.play();
}
function loading_end() {
	
	console.log('loadmetadata');
	count=0;
	this.off('loadedmetadata',loading_end);
	this.on('loadeddata',loading_start);

}
function set_curtime(myPlayer) {
	
	myPlayer.currentTime(start_list[count]);
	myPlayer=null;
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

function next_button() {
	
	var survey = new Object();
	
	survey.cid=cid;
	survey.filename=filename;
	survey.shot_id=shot_id_list[count];
	survey.comment='good';
	survey.ratinng= $("#rateYo").rateYo('rating');
	survey.time=end_list[count];
	

	
	$.ajax({
		type: 'POST',
		url: '/get_first_infomation',
		data: {survey: JSON.stringify(survey),},
		dataType: 'json',
		success: ajax_get_data,
		error: ajax_error
	});
	

	hide_survey();
	
	dat=null;
	
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
	$("#survey_form").hide();
	$("#video_form").css("float","none");
	$("#myModal").modal("hide");
	//move scroll
	$('html, body').animate({scrollTop : $("#video_form").offset().top}, 400);
}

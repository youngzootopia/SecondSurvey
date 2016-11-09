


$( document ).ready(function() {
					
	//시작하자마자 비디오를 숨긴다
	$( '#survey_form' ).ready(hide_survey);
	$( ".progress" ).ready(hide_loading_bar);
	first();
					
});

function first() {
	$.ajax({
		type: 'POST',
		url: 'serv.php',
		data: {},
		dataType: 'json',
		//무조건 json으로만통신하도록 수정
		success: function(data) {
			
				//console.log('submit success '+data.link);
				video_link=data.videoURL;
				start_list=JSON.parse(data.shotIDList);
				end_list=JSON.parse(data.endTimeList);
				shot_id_list=JSON.parse(data.shotIDList);
				cid=data.CID;
				filename=data.title;
				

				
				init();
				
			},
		error: function(request, status, error ) {
			
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
																										
			}
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
	video_link=null;
	
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
	
	//console.log('time is:'+start_list[count])
	
	myPlayer.currentTime(start_list[count]);
	myPlayer=null;
}
function time_out() {
	
	if(this.currentTime()>=end_list[count]) {
		this.off("timeupdate",time_out);
		this.pause();
		//console.log('shot end');
		
		show_survey();
	}
}

function next_button() {
	
	var dat = new Object();
	
	dat.cid=cid;
	dat.filename=filename;
	
	var is_Last=false;
	
	if(count>=(shot_id_list.length-1)) {	is_Last=true;}
	
	$.ajax({
		type: 'POST',
		url: 'serv.php',
		data: {
			survey: JSON.stringify(dat),
			},
		dataType: 'json',
		//무조건 json으로만통신하도록 수정
		success: function(data) {
				//console.log('submit success '+data.link);
				
				if(video_link==data.videoURL) {
					count++;
					videojs(vid_tag_id).on("timeupdate",time_out);
					set_curtime(videojs(vid_tag_id));
					videojs(vid_tag_id).play();					
				} else{

					video_link=data.videoURL;
					start_list=JSON.parse(data.shotIDList);
					end_list=JSON.parse(data.endTimeList);
					shot_id_list=JSON.parse(data.shotIDList);
					cid=data.CID;
					filename=data.title;				
				
					var myPlayer=videojs(vid_tag_id);	
					myPlayer.src(video_link);
					myPlayer.on('loadedmetadata',loading_end);
					myPlayer=null;				
				}		
			},
		error: function(request, status, error ) {
				
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
																									
			}
	});
	

	hide_survey();
	
	dat=null;
	isLast=null;
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
	//move scroll
	$('html, body').animate({scrollTop : $("#survey_form").offset().top}, 400);
}
function hide_survey() {
	$("#survey_form").hide();
	$("#video_form").css("float","none");
	//move scroll
	$('html, body').animate({scrollTop : $("#video_form").offset().top}, 400);
}

var html_body=null;
var device= null;

function Class_ProgressBar(){
	var progress=$(".progress");
	var progress_bar=$(".progress-bar");
	
	this.show_bar=function(){
		progress.show(device.animation);
	};
	this.hide_bar=function(){
		progress.hide();
	};
	this.set_bar=function(per){
		progress_bar.css('width',per);
	};
};

function Class_VideoForm(){
	
	var video_form=$("#video_form");
	
	this.show_video=function(){
		video_form.show('slide',device.animation,this.focus_video);
	};
	this.hide_video=function(){
		video_form.hide();
	};
	this.focus_video=function(){
		//html_body.animate({scrollTop : video_form.offset().top}, device.animation);
		html_body.animate({scrollTop : video_form.offset().top}, 0);
	};
	this.reset_pos=function(arg){
		video_form.after(arg);
	}
};

function Class_Modal(vid){

	var myModal=$("#myModal");
	var modal_dialog=$(".modal-dialog");
	var modal_body=$(".modal-body");
	var modal_header=$(".modal-header");
	var modal_footer=$(".modal-footer");
	var rating=$("#rateYo");//선호도
	var equal=$("#equal");//유사도
	var coincidence=$("#coincidence");//부합도
	var persent=$("#persent");
	var reason=$("textarea#id_reason");
	var open_state=false;
	var header_height=56;
	var footer_height=53;
	var video_form=vid;

	var state='5w1h_1';
	
	this.get_state=function(){return state};
	this.set_state=function(arg){state=arg};
	
	this.get_reason=function(){
		return reason.val();
	};	
	//선호도
	this.get_rating=function(){
		return rating.rateYo('rating');
	};
	this.show_rating=function(){
		//rating.show();
		$('div[class="form-group  rating"]').show();
	};
	this.hide_rating=function(){
		//rating.hide();
		$('div[class="form-group  rating"]').hide();
	};	
	//부합도
	this.get_coincidence=function(){
		return coincidence.rateYo('rating');
	};
	this.show_coincidence=function(){
		//coincidence.show();
		$('div[class="form-group  coincidence"]').show();
	};
	this.hide_coincidence=function(){
		//coincidence.hide();
		$('div[class="form-group  coincidence"]').hide();
	};	
	//유사도
	this.get_equal=function(){
		return equal.rateYo('rating');
	};
	this.show_equal=function(){
		//equal.show();
		$('div[class="form-group  equal"]').show();
	};
	this.hide_equal=function(){
		//equal.hide();
		$('div[class="form-group  equal"]').hide();
	};	
	
	this.set_persent=function(current){
		persent.text((current/totalShot*100).toFixed(2)+'%');
	}
	this.show_modal=function(){
		myModal.modal("show",device.animation,{backdrop: true});
	};
	this.hide_modal=function(){
		myModal.modal("hide");
	};
	this.focus_modal=function(){
		html_body.animate({scrollTop : modal_footer.offset().top}, device.animation);
	};

	
	this.set_5w1h=function(list){
		//body.html(null);
		
		var a = document.createElement("div");
		//a.className='form-inline';
		a.setAttribute("class", 'form-group 5w1h');
		a.setAttribute("style", 'margin-right:0px; display:none;');
		
		var b = document.createElement("span");
		b.innerHTML=list.id+':';//+'&nbsp; &nbsp; ';
		b.setAttribute("class", 'col-xs-4 col-sm-4 col-md-2 col-lg-2');
		
		var c = document.createElement("INPUT");
		
		c.setAttribute("list", list.id);
		c.setAttribute("class", 'col-xs-8 col-sm-8 col-md-10 col-lg-10');
		
		var d = document.createElement("DATALIST");
		d.setAttribute("id", list.id);
		
		
		modal_body.append(a);
		a.appendChild(b);
		a.appendChild(c);
		a.appendChild(d);
		var i=0;
		for(i=0;i<list.val.length;i++){
			var e = document.createElement("OPTION");
			e.setAttribute("value", list.val[i]);
			d.appendChild(e);
		}
	};
	this.set_img=function(){
		var a = document.createElement("select");
		a.setAttribute("class", 'image-picker show-html img_select');
		modal_body.append(a);
		var i=0;
		for(i=0;i<thumbList.length;i++){
			var e = document.createElement("OPTION");
			e.setAttribute("data-img-src", thumbList[i]);
			e.setAttribute("value", i);
			e.setAttribute("name", thumbList[i]);
			a.appendChild(e);
		}
		//$("select").imagepicker();
		$('.image-picker,.show-html').imagepicker();
		
		var b = document.createElement("textarea");
		b.setAttribute("class", 'img_select');
		b.setAttribute("id", 'select_reason');
		b.setAttribute("style", 'width:100%');
		modal_body.append(b);

		
	}
	this.show_5w1h=function(){
		$(".5w1h").show();
	}	
	this.hide_5w1h=function(){
		$(".5w1h").hide();
	}	
	
	var focus_modal=this.focus_modal;
	this.resize_modal=function(){
		var dialog_height=window.innerHeight;
		var body_height=null;
		var extra=header_height + footer_height;
		
		if(device.animation=='slow'){
			dialog_height/=2;
		}
		//body=modal-header-footer
		body_height=dialog_height - extra;
		
		modal_dialog.css('max-height',dialog_height);
		modal_body.css('max-height',body_height);		
	};
	var resize_modal=this.resize_modal;
	this.isopen_modal=function(){
		return open_state;
	};

	function is_touch_device() {
		
	  return 'ontouchstart' in window        // works on most browsers 
		  || navigator.maxTouchPoints;       // works on IE10/11 and Surface
	};

	//call once
	function init(){
		
		//rating in modal
		rating.rateYo({
			rating: 3.0,//default rating
			numStars: 5,
			maxValue:5,
			halfStar: true,
			//set min fill rate area
			onInit: function (rating, rateYoInstance){	$("div[class='jq-ry-rated-group jq-ry-group']").css('min-width','10%');},
			//set min value
			onSet: function (value, rateYoInstance){	if(value==0){rating.rateYo("rating", 1);}	}
		});
		equal.rateYo({
			rating: 3.5,//default rating
			numStars: 5,
			maxValue:5,
			halfStar: true,
			//set min fill rate area
			onInit: function (rating, rateYoInstance){	$("div[class='jq-ry-rated-group jq-ry-group']").css('min-width','10%');},
			//set min value
			onSet: function (value, rateYoInstance){	if(value==0){equal.rateYo("rating", 1);}	}
		});
		coincidence.rateYo({
			rating: 4.0,//default rating
			numStars: 5,
			maxValue:5,
			halfStar: true,
			//set min fill rate area
			onInit: function (rating, rateYoInstance){	$("div[class='jq-ry-rated-group jq-ry-group']").css('min-width','10%');},
			//set min value
			onSet: function (value, rateYoInstance){	if(value==0){coincidence.rateYo("rating", 1);}	}
		});
		//modal on/off
		//modal show/hide handler
		myModal.on('shown.bs.modal',function(e){
				//console.log(e.type);
				open_state=true;
				header_height=modal_header.outerHeight();
				footer_height=modal_footer.outerHeight();
				resize_modal();
				focus_modal();
			}
		);
		
		myModal.on('hide.bs.modal',function(e){
				//console.log(e.type);
				modal_isopen=false;
				video_form.focus_video();
				//window_resize();
			}
		);
		
		if(is_touch_device()){
			myModal.removeClass('fade');
		}
		
	};
	init();
}

function Class_SurveyForm(){
	
	var survey_form=$('#survey_form');
	
	var loading_bar=new Class_ProgressBar();
	
	var video_form=new Class_VideoForm();
	
	var myModal=new Class_Modal(video_form);
	
	var myPlayer=videojs(vid_tag_id);
	
	var next_btn=$("#next_btn");
	
	
	this.show_survey=function(){
		survey_form.show(device.animation);
		myModal.show_modal();
		next_btn.prop('disabled',false);
		
		switch(myModal.get_state()){
			case '5w1h_1': {
					myModal.show_5w1h();
					//선호도
					myModal.hide_rating();
					//부합도
					myModal.hide_coincidence();
					//유사도
					myModal.hide_equal();
					//클릭시 5w1h_1 쿼리를 서버로 전송
					next_btn.click(query_5w1h_1);
					break;
				}
			case 'query_1': {
					myModal.hide_5w1h();
					//선호도
					myModal.show_rating();
					//부합도
					myModal.show_coincidence();
					//유사도
					myModal.hide_equal();
					
					if(count+1>=video_link.length){
						count++;
						console.log('show image');
						myModal.set_img();
						//myModal.set_state('send_1');
					}
					
					break;
				}	
			default: {
					break;
				}
		};
		
	};
	var show_survey=this.show_survey;
	this.hide_survey=function(){
		survey_form.hide();
		myModal.hide_modal();
	};
	var hide_survey=this.hide_survey;
	
	myPlayer.set_curtime=function(){
		//console.log(start_list);
		myPlayer.currentTime(start_list[count]);
	};
	myPlayer.time_out=function(e){
		if(this.duration()<end_list[count]) {
			//영상의 전체길이보다 더 긴 경우 수정
			end_list[count]=this.duration();
		}

		if(this.currentTime()>=end_list[count]) {
			console.log(this.currentTime());
			
			this.off("timeupdate",myPlayer.time_out);
		
			
			this.pause();
			show_survey();
		}		
	};
	

	

	var ajax_error=function(){
		console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					
		alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	};

	
	
	function window_resize(e){
		if(e){console.log(e.type);};
		//screen height renewal
		if(myModal.isopen_modal()){
			myModal.resize_modal();
			myModal.focus_modal();//scroll to modal	
		} else{
			//scroll to video
			video_form.focus_video();
		}		
	}
	
	function query_5w1h_1(){
		console.log('click'+count);
		next_btn.prop('disabled',true);
		
		var params=null;
		var str=null;
		
		switch(myModal.get_state()){
			case '5w1h_1': {
					params={
						WHO:$("input[list=Who]").val(),
						WHATACTION:$("input[list=WhatAction]").val(),
						WHATOBJECT:$("input[list=WhatObject]").val(),
						WHERE:$("input[list=Where]").val(),
						WHEN:$("input[list=When]").val(),
						WHY:$("input[list=Why]").val(),
						HOW:$("input[list=How]").val(),
						VISUAL:$("input[list=Visual]").val(),
						AUDIO:$("input[list=Audio]").val(),
						type:'json'
					};
					//str = jQuery.param( params );
					str=JSON.stringify(params);
					break;
				}
			case 'query_1': {
					params={
						queryID:queryIDList[count],
						shotID:shot_id_list[count],
						totalScore:totalScoreList[count],
						correct:myModal.get_coincidence(),//부합도
						preference:myModal.get_rating(),//선호도
						//similar:myModal.get_equal(),//유사도
						//isSelect:(($('.image-picker,.show-html:selected').val())?true:false),
						isSelect:false,
						reason:''
					}
					surv.push(params);
					if($('.image-picker,.show-html:selected').length){
						surv[$('.image-picker,.show-html:selected').val()].isSelect=true;
						surv[$('.image-picker,.show-html:selected').val()].reason=$("textarea#select_reason").val();
						$('.img_select').remove();
						$('.thumbnails,image_picker_selector').remove();
					}

					count++;

					if(count>=video_link.length){
						str=JSON.stringify(surv);
						surv=[];
						count=0;
						break;
					} else{
						
						start();
						return;	
					}
										

				}
			default: {
					break;
				}
		};

		console.log(str);
		
		

		//send query info
		$.ajax({
				type: 'GET',
				//url: '/get_second_infomation_first',
				url: ((myModal.get_state().indexOf('_1'))?'/get_second_infomation_first':'/get_second_infomation_second'),
				data: {data:str},
				dataType: 'json',
				success: function(data){
						console.log('success',data[0]);
						end_list=data[0].endTimeList;
						queryIDList=data[0].queryIDList;
						shot_id_list=data[0].shotIDList;
						start_list=data[0].startTimeList;
						totalScoreList=data[0].totalScoreList;
						
						var i=0;
						for (i in data[0].videoURLList){
							data[0].videoURLList[i]='/assets/'+data[0].videoURLList[i];
						}
						video_link=data[0].videoURLList;
						
						i=0;
						for (i in data[0].thumbList){
							data[0].thumbList[i]='/assets/'+data[0].thumbList[i];
						}
						thumbList=data[0].thumbList;
						
						totalShot=data[0].totalShot;
						
						count=0;
						start();
					},
				error: ajax_error
			}
		);
		params=null;
		str=null;	
	}
	
	function file_down(url){
		loading_bar.show_bar();
		video_form.hide_video();
		var xhr = new XMLHttpRequest();
		xhr.open('GET', url, true);
		xhr.responseType = 'blob';
		////////////////////////////	
		xhr.onload = function(e) {
			if (this.status == 200) {
				//다운이 완료되면 src set
				var myBlob = this.response;
				//var vid = (window.webkitURL ? webkitURL : URL).createObjectURL(myBlob);
				var vid = (window.URL).createObjectURL(myBlob);
					myPlayer.src(vid);
					//meta data downloading
					myPlayer.on('loadedmetadata',function(e){
							console.log(e.type);										
							this.off('loadedmetadata',arguments.callee);
							//second event
							this.on('loadeddata',function(e){
									console.log(e.type);
									this.off('loadeddata',arguments.callee);
									myPlayer.set_curtime();
									this.on("timeupdate",myPlayer.time_out);
														
									video_form.show_video();
									this.play();	
								}
							);
						}
					);
				xhr=null;
			}
		}
		
		xhr.onprogress = function(e) {
			//다운받는동안 로딩바 갱신
			if(e.lengthComputable) {
				loading_bar.set_bar((e.loaded / e.total*100)+'%')
				if(e.loaded>=e.total) {
					loading_bar.set_bar('0%');
					loading_bar.hide_bar();
				}
			}
		}
		
		xhr.onreadystatechange= function(e) {
			//메소드 응답
			if(xhr.readyState==4) {
				//응답을 받음
				if(xhr.status==404) {
					//파일이 없을때
					//hide progress bar
					loading_bar.hide_bar();
											
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
		////////////////////////////	
	}	
	
	function start(){
		
		myModal.set_state('query_1');
		hide_survey();
		file_down(video_link[count]);

	}
	function init(){
		
		console.log('survey init');

		//window resize event handler	
		$(window).on("resize",window_resize).resize();
		
		// (full screen? width:100%, xs12 lg-6)
		myPlayer.on('fullscreenchange',function(e){
			
				//move survey dom
				if(myPlayer.isFullscreen()){
					$('#video_html5_api').after(survey_form);
				} else{
					video_form.reset_pos(survey_form);
				}		
			
				console.log(e.type);
				survey_form.toggleClass('col-lg-9');
				myModal.resize_modal();
			}
		);
		
		
		myModal.set_5w1h({id:'Who',val:[1,2,3]});
		myModal.set_5w1h({id:'WhatAction',val:[4,5,6]});
		myModal.set_5w1h({id:'WhatObject',val:[41,51,61]});
		myModal.set_5w1h({id:'Where',val:[7,8,9]});
		myModal.set_5w1h({id:'When',val:['a','b','c']});
		myModal.set_5w1h({id:'Why',val:[]})
		myModal.set_5w1h({id:'How',val:[]});
		myModal.set_5w1h({id:'Visual',val:[]});
		myModal.set_5w1h({id:'Audio',val:[]});;
		
		//console.log(myModal.get_rating());
		//console.log(myModal.get_equal());
		//console.log(myModal.get_coincidence());
		
	};
	
	
	init();
}


$(document).ready(function(){
	
	console.log('ready');
	html_body=$('html, body');
	device= {type:'touch',animation:0};
	survey_form=new Class_SurveyForm();
	survey_form.show_survey();
	//survey_form.myModal.show_5w1h();
	//survey_form.get_survey_info();
	console.log('end');
});

var html_body=null;
var device= {type:'touch',animation:0};

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
	var rating=$("#rateYo");
	var persent=$("#persent");
	var reason=$("textarea#id_reason");
	var open_state=false;
	var header_height=56;
	var footer_height=53;
	var video_form=vid;
	
	this.get_rating=function(){
		return rating.rateYo('rating');
	};
	this.get_reason=function(){
		return reason.val();
	};
	this.show_rating=function(){
		rating.show();
	};
	this.hide_rating=function(){
		rating.hide();
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
	this.body=function(){
		return modal_body;
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

	
	
	var Set_5w1h=function(list){
		body=myModal.body();
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
		
		
		body.append(a);
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
	this.Show_5w1h=function(){
		$(".5w1h").show();
	}	
	this.Hide_5w1h=function(){
		$(".5w1h").hide();
	}
	
	
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
	
	function query_5w1h(){
		console.log('click'+count);
		next_btn.prop('disabled',true);
		var params={
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
		var str = jQuery.param( params );
		console.log(str);
		

		//send query info
		$.ajax({
				type: 'GET',
				url: '/get_second_infomation',
				data: str,
				dataType: 'json',
				success: function(e){
					console.log('success',e);
					},
				error: ajax_error
			}
		);
		params=null;
		str=null;	
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
		
		next_btn.click(query_5w1h);
		
		
		Set_5w1h({id:'Who',val:[1,2,3]});
		Set_5w1h({id:'WhatAction',val:[4,5,6]});
		Set_5w1h({id:'WhatObject',val:[41,51,61]});
		Set_5w1h({id:'Where',val:[7,8,9]});
		Set_5w1h({id:'When',val:['a','b','c']});
		Set_5w1h({id:'Why',val:[]})
		Set_5w1h({id:'How',val:[]});
		Set_5w1h({id:'Visual',val:[]});
		Set_5w1h({id:'Audio',val:[]});;
		
	};
	
	
	init();
}


$(document).ready(function(){
	
	console.log('ready');
	html_body=$('html, body');
	survey_form=new Class_SurveyForm();
	survey_form.show_survey();

	survey_form.Show_5w1h();
	//survey_form.get_survey_info();
	console.log('end');
});

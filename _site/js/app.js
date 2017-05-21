$(document).ready(function(){
	// $(".sticky").stick_in_parent();
  // console.log("ready");
  $('.swatch').each(function(){
    var color = $(this).attr('data-color');
    $(this).css('background-color', color);
    // $(this:before).css('box-shadow', 'box-shadow: 0 4px 32px rgba(0,0,0,.2), 0 4px 32px' + color + ';')
  });

  //initialize swiper when document ready  

  var mySwiper = new Swiper ('#apps-multiselect .swiper-container', {
    // Optional parameters
    slidesPerView: 6,
    centeredSlides: true,
    spaceBetween: 32,
    pagination: '.swiper-pagination',
    paginationClickable: true,
    nextButton: '.swiper-button-next',
    prevButton: '.swiper-button-prev',
    grabCursor: true,
    breakpoints: {
      768: {
        slidesPerView: 3
      },
      400: {
        slidesPerView: 2
      }
    }

  });

  var academiaSwiper = new Swiper ('#aca-search .swiper-container', {
    // Optional parameters
    slidesPerView: 2,
    centeredSlides: true,
    spaceBetween: 64,
    pagination: '.swiper-pagination',
    paginationClickable: true,
    nextButton: '.swiper-button-next',
    prevButton: '.swiper-button-prev',
    grabCursor: true,
    breakpoints: {
      768: {
        slidesPerView: 1
      },
      400: {
        slidesPerView: 1
      }
    }
  });
  academiaSwiper.slideTo(8, 0);


});



// function textRotate(classSelector,animationTime,ease,intervalLength,color){
	
// var spanHeight = $(classSelector+" > p").height();
// $(classSelector).parent().css("height",spanHeight+"px")
// $(".sentence > p").css("display","inline");
// $("head").append("<style>.sentence p {display: inline-block;}.sentence span {overflow: hidden;display: inline-block;position: relative;-webkit-transform: translateY(20%);-ms-transform: translateY(20%);transform: translateY(20%);}.sentence span div {display: inline-block;}.sentence span div p {display: block;background-color: transparent;top: 0;}.sentence span div p span {top: 0;height: auto;display: inline;}</style>")
// if(color != ""){
// 	$(classSelector+" > p").css("color", color);
// }
// var iniElmWidth = $(classSelector+" > p:nth-child(1) > span").width();
// $(classSelector).css("width",iniElmWidth);
// $(classSelector+" > p").each(function(){
// 	var newValue = $(this).html().split(" ").join("&nbsp;");
// 	$(this).html(newValue);
// 	console.log(newValue);
// });
// var numOfWords = $(classSelector+" > p").length;
// var count = 1;
// $(classSelector).css("will-change","transform");
// $(classSelector).css("transform", "translateY(0)");
// $(classSelector).css("transition", "transform "+animationTime+"s "+ease+", width "+animationTime+"s "+ease);
// setInterval(function(){
// 	if(count < numOfWords){
// 		count++;
// 		console.log(count);
// 		var elmWidth = $(classSelector+" > p:nth-child("+count+") > span").width();
// 		$(classSelector).css("width",elmWidth);
// 		var move = (count - 1)*spanHeight;	$(classSelector).css("transform","translateY(-"+move+"px)");
// 	} else if (count >= numOfWords){	
// 		count = 1;
// 		var elmWidth = $(classSelector+" > p:nth-child(1) > span").width();
// 		$(classSelector).css("width",elmWidth);
// 		$(classSelector).css("transform","translateY(0px)");
// 	}
// 	},intervalLength);
// }

// textRotate(".rotate",1,"ease",5000,"#F30A49");

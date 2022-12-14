<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style type="text/css">

   #likeContainer th, #likeContainer td {
      /* text-align: center; */
      vertical-align: middle;
   }
   
   .paymentBtn {
      background-color: #1E7F15;
      color: white;
   }
   
   #likeContainer .reviewList input[type=button] {
      border: none;
      border-radius: 5%;
      height: 30px;
   }
   
   #likeContainer .likeButtons input[type=button] {
      border: none;
      border-radius: 5%;
      height: 35px;
   }

/*   
   img.img-thumbnail {
       display: inline-block;
       width: 250px;
       content: "";
   }
*/   
   #star{
	   color: red;
   } 
   
/*   
   #star a{
	   text-decoration: none;
	   color: gray;
   }
   
   #star a.on{
	   color: red;
   } 
*/   
   .page-link {
	  color: #666666; 
	  background-color: #fff;
	  border: 1px solid #ccc; 
	}
	
	.page-item.active .page-link {
	 z-index: 1;
	 color: white;
	 border-color: #1E7F15;
	 background-color: #1E7F15; 
	 
	}
	
	.page-link:focus, .page-link:hover {
	  color: #1E7F15;
	  background-color: #fafafa; 
	  border-color: #1E7F15;
	}
	
	.content{
		width: 500px;
		margin-left: 0;
    }
    
    .more {
    	display: block;
    	color: #1E7F15;
    }
	
	a {
       text-decoration: none;
    }
   
    a:link {
       text-decoration: none;
    }
   
    a:hover  {
       color: black;
       text-decoration: none;
    }
   
    a:visited  {
       text-decoration: none;
       color: #1E7F15;
    }
	
</style>

<script type="text/javascript">

   $(document).ready(function(){
      
	  // 찜목록 전체개수 값
      const allCnt = $("input[name='allCnt']").length;
      document.getElementById("reviewCnt").textContent = allCnt;
	   
      // 별점 주기
      $('#star a').click(function(){ 
    	  $(this).parent().children("a").removeClass("on");    
    	  $(this).addClass("on").prevAll("a").addClass("on");
    	  console.log($(this).attr("value"));
   	  });    
      
      // 리뷰 내용 및 이미지 더보기/접기
      $('.box').each(function(){  //  each() 메소드: object 와 배열 모두에서 사용할 수 있는 일반적인 반복 함수
    	  var content = $(this).children('.content');
          var content_txt = content.text();
          var content_txt_short = content_txt.substring(0,50)+"...";
          //var image = $(this).children('.image');
          var btn_more = $('<a href="javascript:void(0)" class="more">더보기</a>');
          

          //$(this).append(image);
          $(this).append(btn_more);
          
          if(content_txt.length >= 50){
              content.html(content_txt_short)
              //image.hide();  // 이미지 숨기기
              
          }else{  // 텍스트가 50 이하이고, 이미지가 없다면
              btn_more.hide();
          }
          
          btn_more.click(toggle_content);

          function toggle_content(){
              if($(this).hasClass('short')){
                  // 접기 상태
                  //image.hide();  // 이미지 숨기기
                  $(this).html('더보기');
                  content.html(content_txt_short)
                  $(this).removeClass('short');
              }else{
                  // 더보기 상태
                  //image.show();  // 이미지 보이기
                  $(this).html('접기');
                  content.html(content_txt);
                  $(this).addClass('short');

              }
          }
      });
	   
    });// end of $(document).ready()--------------------------
    
    
 	// 찜목록 테이블에서 특정제품 1개행을 찜목록에서 비우기
    function goDel(rnum) {   // 리뷰삭제 버튼 누르면  => 리뷰번호(시퀀스)로 구별하여 삭제하기

       const bool = confirm("해당상품 리뷰를 삭제하시겠습니까?");
       
       if(bool) {
     	  
     	  $.ajax({
     		  url:"<%= request.getContextPath()%>/mypage/reviewDel.tea",
     		  type:"POST",
     		  data:{"rnum":rnum},  // 리뷰번호(시퀀스)를 넘겨주어 알아온다.
     		  dataType:"JSON",
     		  success:function(json) {
     			  // {n:1}
     			  if(json.n == 1) {  // json.n 객체는 넘겨받은 {n:1} 을 의미함.
     				  location.href = "reviewList.tea";   // 삭제가 반영된 리뷰목록을 보여준다.
     			  }
     		  },
     		  error: function(request, status, error){
     			  alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
               }
     	  });
       }
       else {
     	  alert(pname+" 상품 삭제를 취소하셨습니다.");
     	  
       }
       
    }// end of function goDel(likeno) {}-------------------
    
    
 	// 모달창 띄우는 함수
	function openModal(rnum) {
		
		// 외부클릭막기
        $('#btnReview').modal({backdrop: 'static', keyboard: false});
		// 모달창 띄우기
        $('#btnReview').modal('show');
    }
	
   
</script>
   
<form name="prodStorageFrm"> 
     <div class="container" id="likeContainer">
      <i class="fas fa-comment-dots" style="font-size: 40px; float: left; padding-right: 10px;"></i>
      <h2 style="font-weight: bold">상품리뷰</h2><br>
         <hr style="background-color: black; height: 1.2px;"> 
      
      <div>
         <span id="check_all" style="font-weight: bold;">누적 리뷰 건수 <span style="color:#1E7F15; font-weight: bold;" id="reviewCnt"></span>건</span>
      </div>
      
      <br>
      
      <div class="reviewList">
         <table class="table mt-4">
	        <colgroup>
		          <col width="380px" />
		          <col />
		          <col width="150px" />
	      	</colgroup>
            <thead class="thead-light">
               <tr>
                  <th colspan='2' style="text-align: center;">상품정보</th>
                  <th style="padding-left: 30px;">리뷰</th>
               </tr>
            </thead>
            <tbody>
               <c:if test="${empty requestScope.reviewList}">
                     <tr>
                          <td colspan="4" align="center">
                            <span style="color: #1E7F15; font-weight: bold;"><br><br><br>
                               작성한 리뷰가 없습니다.
                            </span>
                          </td>   
                     </tr>
                  </c:if>  
                  
               <c:if test="${not empty requestScope.reviewList}">
                 <c:forEach var="reivewvo" items="${requestScope.reviewList}" varStatus="status">  <%-- reviewList 의 구성은 reivewvo 로 되어있음  --%>
                   <tr>
                     <td>
                         <a href="/OhSherlockProject/shop/productView.tea?pnum=${reivewvo.pnum}" style="text-align: right;">  <%-- 썸네일이미지 --%>
                            <img src="/OhSherlockProject/images/${reivewvo.prod.pimage}" class="img-thumbnail" style="margin-left: 20px; border: 0;" />
                         </a>
                         <input type="hidden" name="allCnt" id="hidden_pnum" for="pnum${status.index}" value="${reivewvo.rnum}" /> <%-- 상품번호 --%>  
                         <input type="hidden" for="pnum${status.index}" value="${reivewvo.pnum}" /> <%-- 상품번호 --%>  
                         <input type="hidden" for="pnum${status.index}" value="${reivewvo.odrcode}" /> <%-- 주문상세번호 --%>  
                     </td>
                     <td>    
                        <span class="like_pname" style="font-weight: bold;">${reivewvo.prod.pname}</span><br>  <%-- 상품명 --%>
                        <span>작성일 :&nbsp; ${fn:substring(reivewvo.writeDate, 0, 10)}</span><br>
                        <input type="hidden" name="score" id="score" value="${reivewvo.score}" />
	                    <%--   <P id="star"> <!-- 부모 -->
							    <a value="1">★</a> <!-- 자식들-->
							    <a value="2">★</a>
							    <a value="3">★</a>
							    <a value="4">★</a>
							    <a value="5">★</a>
							</p>
						--%> 	
						<c:forEach begin="1" end="${reivewvo.score}" varStatus="status">
							<a id="star" value="${status.index}"><span>★</span></a>
						</c:forEach><br><br>
							
							
						<span style="font-weight: bold;">${reivewvo.rsubject}</span><br>
						
						<div class="box">
						    <div class="content">
						    	${reivewvo.rcontent}
						    </div><br>
						    <%-- <img class="image" src="../images/${reivewvo.rimage}" style="width: 200px;" /> --%>
						</div>
						
                        <input type="hidden" class="reviewno" value="${reivewvo.rnum}" />  <%-- 상품리뷰번호(시퀀스)는 hidden 처리함. --%>
                      </td> 
                      <td>  
						<%-- <p><input class="paymentBtn" type="button" onClick="openModal('${reivewvo.rnum}')" style="clear:none;" value="리뷰수정"/></p> --%>
						<%-- 특정 상품리뷰 비우기 --%> 
						<p><input type="button" class="btn btn-secondary" onclick="goDel('${reivewvo.rnum}')" value="리뷰삭제" style="clear:none; height: 35px;" /></p>
                     </td> 
                   </tr>
			      </c:forEach>
               </c:if>
            </tbody>
         </table>
      </div>
	
	  <%-- 페이징처리 해주기★ --%> 
	  <nav aria-label="Page navigation example" style="margin-top: 60px; margin-bottom: 60px;">
		<ul class="pagination justify-content-center" style="margin:auto;">${requestScope.pageBar}</ul>
	  </nav>
	
	  <table class="table table-active table-borderless">
	    <tr>
	    	<td style="padding: 10px 15px; text-align: left; font-size: 16px;">아래와 같이 리뷰 정책 위반으로 블라인드된 리뷰는 상품상세페이지 리뷰목록에 노출되지 않습니다.</td>
	    </tr>
	    <tr>
			<td style="padding-top: 3px; text-align: left;">
				·&nbsp;특정인의 명예를 훼손하거나 저작권을 침해한 경우<br>
				·&nbsp;개인정보를 포함한 경우 (연락처, 이메일, SNS, 주소 등)<br>
				·&nbsp;상업적 목적이 담긴 경우<br>
				·&nbsp;사용하지 않거나, 구매 상품과 다른 상품에 대한 리뷰를 기재한 경우<br>
				·&nbsp;다른 상품 리뷰에 동일한 내용을 반복 기재한 경우<br>
			</td>
		<tr>
	  </table>
	</div>

</form>
<%@ include file="../footer.jsp"%>



<%-- *** 리뷰작성 모달창 *** --%>
<div class="modal fade" id="btnReview">
	<div class="modal-dialog ">
    	<div class="modal-content">
    
	      	<!-- Modal header -->
	      	<div class="modal-header">
	        	<h4 class="modal-title">상품 후기 작성</h4>
	        	<button type="button" class="close idFindClose" data-dismiss="modal">&times;</button>
	      	</div>
	      
	      	<!-- Modal body -->
	      	<div class="modal-body">
	        	<div id="reviewWrite">
	        	<%-- jsp 파일 연결을 위해서 iframe 을 사용하지 않고, 우선 include로 연결해 두었다. --%>
	        	<%-- <iframe id="iframe_reviewWrite" style="border: none; width: 100%; height: 350px;" src="<%= request.getContextPath()%>/shop/writeReview.tea?userid=${loginuser.userid}"></iframe> --%>
             	 	 <%@ include file="modal_review_update.jsp"%> 
	        	</div>
	      	</div>
	      
	      	<!-- Modal footer -->
	      	<div class="modal-footer">
	        	<button type="button" class="btn btn-light idFindClose" data-dismiss="modal">Close</button>
	        	<%-- close나 엑스 버튼을 누르면 아이디 찾기에 입력해 놓은 값을 날려주기 
	        		 close와 엑스버튼을 한번에 잡으려고 클래스를 idFindClose 로 동일하게 부여--%>
	      	</div>
	      	
		</div>
	</div>
</div>
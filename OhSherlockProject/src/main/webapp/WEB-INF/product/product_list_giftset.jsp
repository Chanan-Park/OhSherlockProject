<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<%@ include file="../header.jsp"%>

<%@ page import="common.model.ProductVO" %>

<style>

.productListContainer .sidebar {
  margin: 0;
  padding: 0;
  width: 200px;
  background-color: #f1f1f1;
  position: fixed;
  height: 100%;
  overflow: auto;
}

.productListContainer .sidebar a {
  display: block;
  color: black;
  padding: 16px;
  text-decoration: none;
}
 
.productListContainer .sidebar a.active {
  background-color: #04AA6D;
  color: white;
}

.productListContainer .sidebar a:hover:not(.active) {
  background-color: #555;
  color: white;
}

.productListContainer div.content {
  margin-left: 200px;
  padding: 1px 16px;
  height: 1000px;
}

@media screen and (max-width: 700px) {
  .sidebar {
    width: 100%;
    height: auto;
    position: relative;
  }
  .sidebar a {float: left;}
  div.content {margin-left: 0;}
}

@media screen and (max-width: 400px) {
  .sidebar a {
    text-align: center;
    float: none;
  }
}

#order_list {
	display: flex;
  	justify-content: flex-end;
}

.productListContainer a:hover {
	cursor: pointer;
	text-decoration-line: none;
	color: #1E7F15;
}

.badges {
	display: inline-block;
}

a, a:hover{
	color: black;
	text-decoration: none;
}

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

button.order {
	background-color: transparent; 
  	border-style: none;
  	padding: 0;

}

.selected {
	color: #1E7F15 !important;
	font-weight: bold;
}

input.cart { 
   background-color: transparent; 
     border-style: none;
}

</style>

<script>

let cnum;
let snum;
let currentShowPageNo;
let order;
let jsonPageBar;

$(()=>{
	
	cnum = "${cnum}";
	snum = "${snum}";
	currentShowPageNo = "${currentShowPageNo}";
	
	console.log(cnum);
	console.log(snum);
	console.log(currentShowPageNo);
	
	// ?????????(?????????) ????????? ?????? ??????
	$('i.heart').click(function() {
        $(this).removeClass("text-secondary");
        $(this).addClass("text-danger");
    });
	// ????????? ????????? ?????? ??????
	$('a.like').click(function(e) {
		const $target = $(e.target); // ???????????? ??????????????? ???
		$target.parent().find("i.heart").removeClass("text-secondary");
		$target.parent().find("i.heart").addClass("text-danger");
    });
	
	// ?????? ?????? ????????? ?????????
	 $(".order").click((e)=>{
		 order = $(e.target).attr('id'); // ????????????
		// ?????? ????????????
		getOrderedList();
		
		// ???????????? ????????????
		getPageBar();
		
		// ????????? ?????? ?????????, ??????
		$(".order").removeClass("selected");
		$(e.target).addClass("selected");
	}); 
	 
	// ????????? ???????????? ?????????, ??????
	 if (cnum == "" && snum == "") {
		 document.getElementById("allGoods").classList.add("selected");
	 } else if (cnum != "" && snum == ""){
		 document.getElementById(cnum).classList.add("selected");
	 } else if (cnum == "" && snum != ""){
		 document.getElementById("bestGoods").classList.add("selected");
	 }
	
	// ????????? ?????????
	$("#subtitle").text($(".categories.selected").text());
	
	
});

// ?????? ????????????
function getOrderedList() {
	
	$.ajax({
		url:"<%=ctxPath%>/shop/productGiftSetJSON.tea",
		type:"get",
		data:{"cnum":cnum, "order":order, "currentShowPageNo":currentShowPageNo, "snum":snum},
		dataType:"JSON",
		success:function(json){
	        let html = "";
	        
	        if(json.length != 0) {
	        
	     		$.each(json, function(index, item){
	   				
	   			html += 
	
		  		'<div class="card border-0 mb-4 mt-1 col-lg-4 col-md-6 "> '+
		    	'<a href="<%= ctxPath %>/shop/productView.tea?pnum=' + item.pnum + '"> '+
		    	'<img src="../images/'+item.pimage+'" class="card-img-top"/></a> '+
	    		'<div class="card-body">';
	    			
	    		if(item.sname=='BEST'){
					html +=
	   				'<div class="badges rounded text-light text-center mb-2 badge-danger" style="width:70px; font-weight:bold;"> '+
	   				item.sname+'</div> ';
	    		}
				if(item.sname=='NEW'){
					html +=
	  				'<div class="badges rounded text-light text-center mb-2" style="width:70px; font-weight:bold; background-color: #1E7F15;"> '+
	  				item.sname+'</div> ';
				}
				if(item.pqty==0)
							html +=
				'<div class="badges rounded text-light text-center mb-2 badge-dark"style="width: 70px; font-weight: bold; ">??????</div> ';
				
				if(item.sname==null){
					html += '<div class="badges mb-2">&nbsp;</div> ';
				}
					
				html += '<h5 class="card-title" style="font-weight:bold;"><a href="<%= ctxPath %>/shop/productView.tea?pnum=' + item.pnum + '"> '+item.pname+'</a></h5> '+
	   			'<p class="card-text">'+item.price.toLocaleString('en')+'???</p> '+
	   			
	   			
	   			'<a class="card-text mr-2"><i class="far fa-heart text-secondary fa-lg heart" onclick="goLike(' + item.pnum + ');"></i></a> '+
	   			'<a class="card-text text-secondary mr-5 like" onclick="goLike(' + item.pnum + ');">?????????</a> '+
	   							      			
	   			' <a class="card-text mr-2"><i class="fas fa-shopping-basket text-secondary fa-lg" onClick="clickCart('+item.pnum +');"></i></a> '+
	   			' <input class="card-text text-secondary cart" type="button" onClick="clickCart('+item.pnum +');" value="??????" style="padding-left: 0; margin-left: 0;"/> '+
	   			
	    			
	 			'</div> </div>';
	      		}); 
	        	
	        }
	        
	        else {
	        	html = "?????? ??????????????????.";
	        }
        	$("#giftSetList").html(html);
	        	
        	// ?????????(?????????) ????????? ?????? ??????
   	     	$('i.heart').click(function() {
   	             $(this).removeClass("text-secondary");
   	             $(this).addClass("text-danger");
   	         });
   	     	// ????????? ????????? ?????? ??????
   	     	$('a.like').click(function(e) {
   	     		const $target = $(e.target); // ???????????? ??????????????? ???
   	     		$target.parent().find("i.heart").removeClass("text-secondary");
   	     		$target.parent().find("i.heart").addClass("text-danger");
   	         });
	        
		},
		error: function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
        }
	});
	
}

// ???????????? ????????????
function getPageBar() {
	
	$.ajax({
		url:"<%=ctxPath%>/shop/pageBarJSON.tea",
		type:"get",
		data:{"cnum":cnum, "currentShowPageNo":currentShowPageNo, "snum":snum},
		dataType:"JSON",
		success:function(json){
			
			// ?????? ???????????? ?????????
			$("nav#nav_pageBar").hide();
			
			// json?????? ????????? ????????????
			jsonPageBar = json.pageBar;
			let html = '<nav id="nav_pageBar" aria-label="Page navigation example">'+
			'<ul id="jsonPageBar" class="pagination justify-content-center">'+jsonPageBar+'</ul></nav>';
			
			// json ???????????? ?????? 
			$("#div_pageBar").html(html);
	        
			// ?????? ????????? active
			$("button.ajaxPage[id='"+currentShowPageNo+"']").parent().addClass('active');
			
	        // ????????? ???????????? ???????????????
	    	$("button.ajaxPage").click((e)=>{
	    		currentShowPageNo = $(e.target).attr('id');
	    		$("button.ajaxPage").parent().removeClass('active');
	    		$(e.target).parent().addClass('active');
	    		
	    		getOrderedList();
	    	});
	        
	        // ??????,??????,??????,????????????????????? ?????? ?????????
	        $("button.move").click((e)=>{
	    		currentShowPageNo = $(e.target).attr('id');
	    		getPageBar();
	    		getOrderedList();
	    	});
	        
		},
		error: function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
        }
	});
	
}

// ????????? ????????????
function goLike(pnum){
	
	const frm = document.prodStorageFrm;
	
	$("#hidden_pnum").val(pnum);
	
	frm.method = "POST";
	frm.action = "<%= request.getContextPath()%>/shop/likeAdd.tea";
	frm.submit();
	
}

//???????????? ??????
function clickCart(pnum) { 
	
	const frm = document.prodStorageFrm;
	
	$("#hidden_pnum").val(pnum);
	
	frm.method = "POST"; 
	frm.action = "<%=request.getContextPath()%>/cart/cartAdd.tea";
	frm.submit();
	
} // end of function goCart()

</script>
	
	<div class="container productListContainer">
		<div><img src= "../images/giftset_header.png" width=100%/></div>
      
		<div class="row">
	      	<%-- ????????? ?????? ?????? --%>
	       	<div class="col-md-2" id="sideinfo" style="padding-left: 2%;  margin-top: 1.8%;">
				<div style="text-align: left; padding: 5%;">
	            	<span class="h4" style="font-weight:bold;">???????????????</span>
	         	</div>
	         	<div style="text-align: left; padding: 4%; margin-left:10%;">
	            	<a class="categories" id="allGoods" href="<%= ctxPath %>/shop/productGiftset.tea">?????? ??????</a>
	         	</div>
	         	<div style="text-align: left; padding: 4%; margin-left:10%;">
	            	<a class="categories" id="bestGoods" href="<%= ctxPath %>/shop/productGiftset.tea?snum=2">?????????</a>
	         	</div>
	         	<c:forEach var="map" items="${giftsetCategoryList}">
	         	<div style="text-align: left; padding: 4%; margin-left:10%;">
	            	<a class="categories" id="${map.cnum}" href="<%= ctxPath %>/shop/productGiftset.tea?cnum=${map.cnum}">${map.cname}</a>
	         	</div>
	         	</c:forEach>
	       	</div>
    	    <%-- ????????? ?????? ??? --%>
    	    
	       	<div class="col-md-10" id="maininfo" style="padding: 2.5%;">
	       		<%-- ?????? ?????? --%>
				<div id="maincontent">
		    	    <%-- ?????? ?????? ?????? ??? ?????? --%>
					<span id="subtitle" class="text-dark h5" style="font-weight:bold;">?????? ??????</span>
					
					<%-- ?????? ?????? ??? --%>
					<div class="text-right" >
					<button type="button" class="order selected" id="pnum desc">????????????</button>
					<span class="text-dark">|</span>
					<button type="button" class="order" id="price desc">???????????????</button>
					<span class="text-dark">|</span>
					<button type="button" class="order" id="price asc">???????????????</button>
					<span class="text-dark">|</span>
					<button type="button" class="order" id="reviewCnt desc">???????????????</button>
					<span class="text-dark">|</span>
					<button type="button" class="order" id="orderCnt desc">?????????</button>
					</div>
		    	    <%-- ?????? ?????? ?????? ??? ??? --%>
					
					<hr>
					
					<%-- ?????? ?????? ?????? --%>
					<div id="giftSetList" class="row"> 
						
						<%-- ??? ??????????????? ????????? ????????? for????????? ???????????? ??????. ??? ????????? ????????????. --%>
						<c:if test="${not empty productList}">
						<c:forEach var="pvo" items="${productList}">
				  		<div class="card border-0 mb-4 mt-1 col-lg-4 col-md-6 ">
				    		<a href="<%= ctxPath %>/shop/productView.tea?pnum=${pvo.pnum}"><img src="../images/${pvo.pimage}" class="card-img-top"/></a>
			    			<div class="card-body">
			    				
			    				<c:if test="${not empty pvo.spvo.sname}">
			    					<c:if test="${pvo.spvo.sname eq 'BEST'}">
				    				<div class="badges rounded text-light text-center mb-2 badge-danger" style="width:70px; font-weight:bold;">
				    				${pvo.spvo.sname}
				    				</div>
				    				</c:if>
			    					<c:if test="${pvo.spvo.sname eq 'NEW'}">
				    				<div class="badges rounded text-light text-center mb-2" style="width:70px; font-weight:bold; background-color: #1E7F15;">
				    				${pvo.spvo.sname}
				    				</div>
				    				</c:if>
			    				</c:if>

									<c:if test="${pvo.pqty eq 0 }">
									<div class="badges rounded text-light text-center mb-2 badge-dark"style="width: 70px; font-weight: bold; ">??????</div>
									</c:if>
								
								<c:if test="${empty pvo.spvo.sname}">
			    				<div class="badges mb-2" >&nbsp;</div>
			    				</c:if>
			    				
			      				<h5 class="card-title" style="font-weight:bold;"><a href="<%= ctxPath %>/shop/productView.tea?pnum=${pvo.pnum}"> ${pvo.pname}</a></h5>
				      			<p class="card-text"><fmt:formatNumber value="${pvo.price}" pattern="#,###"/>???</p>
				      			
				      			<a class="card-text mr-2"><i class="far fa-heart text-secondary fa-lg heart" onclick="goLike(${pvo.pnum})"></i></a>
				      			<a class="card-text text-secondary mr-5 like" onclick="goLike(${pvo.pnum})">?????????</a>
				      							      			
				      			<a class="card-text mr-2"><i class="fas fa-shopping-basket text-secondary fa-lg " onClick="clickCart(${pvo.pnum});"></i></a>
                           		<input class="card-text text-secondary cart" type="button" onClick="clickCart(${pvo.pnum});" value="??????" style="padding-left: 0; margin-left: 0;"/>
				      			
				   			</div>
				  		</div>
				  		</c:forEach>
				  		</c:if>
				  		<c:if test="${empty productList }">
				  		?????? ??????????????????.
				  		</c:if>
				  		</div>
				  		<%-- ??? ????????????! --%>
					
					<%-- ?????? ?????? ??? --%>					
					
					<div id="div_pageBar" style="margin-top : 100px">
						<nav id="nav_pageBar" aria-label="Page navigation example">
							<ul id = "originPageBar" class="pagination justify-content-center">${pageBar}</ul>
						</nav>
					</div>
				</div>
	       		<%-- ?????? ??? --%>
				
				<form name="prodStorageFrm">
				<%-- ????????????--%>
				<input type="hidden" name="pnum" id="hidden_pnum" />
				</form>
			</div>
    	    
		</div>
	</div>
	
<%@ include file="../footer.jsp"%>
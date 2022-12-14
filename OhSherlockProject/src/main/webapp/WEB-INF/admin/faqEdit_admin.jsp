<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<style>
* {
	box-sizing: border-box;
}

/* 문의 입력 css 외부에서 받아온 것 */
.faqContainer input[type=text], .faqContainer select, .faqContainer textarea {
	width: 100%;
	padding: 12px;
	border: 1px solid #ccc;
	border-radius: 4px;
	box-sizing: border-box;
	margin-top: 6px;
	margin-bottom: 16px;
	resize: vertical;
}

.writeBtns {
	width: 80px;
	margin: 15px;
	border-style: none;
	height: 30px;
	font-size: 14px;
}

.btn-secondary:hover {
	border: 2px none #1E7F15;
	background-color: #1E7F15;
	color: white;
}

.faqContainer input[type=submit]:hover {
	background-color: #45a049;
}

.faqContainer .container {
	border-radius: 5px;
	padding: 20px;
}

.faqContainer #qnaFrm {
	padding: 3%;
}
</style>


<script>

	$(document).ready(function(){
		
		$("input#EditBtn").click(function(e){
			const subVal = $("input#title").val().trim();
			const conVal = $("textarea#content").val();
			
			if( subVal != "" && conVal != "") {
				// 올바르게 입력할 경우
				goEdit();
			} else {
				// 올바르게 입력하지 않은 경우
				alert("질문과 답변을 모두 입력하세요!");
				return;
			} // end of if-else
		}); // end of $("input#registerBtn").click
		
	}); // end of $(document).ready

	
	// == Function Declaration == //
	// 등록하기 버튼 클릭 메소드
	function goEdit() {
		const frm = document.qnaFrm;
    	frm.action = "<%=request.getContextPath() %>/cs/faqEditEnd.tea"; // 상대경로로 맨 뒤에만 바뀌는 것이다.
    	frm.method = "post"; // 같은 주소이지만 post 로 받아준다.
    	frm.submit();
	} // end of function goRegister()
	
	
	// 취소 버튼 클릭 메소드
	function goCancel(){ 
		const doCancle = confirm("자주묻는질문 수정을 취소하시겠습니까?");
		if(doCancle){
			alert("자주묻는질문 수정을 취소하셨습니다.");
			location.href="javascript:history.back()";
		}
	} // end of function goCancel()

</script>


<div class="container faqContainer">

	<h2 class="col text-left" style="font-weight: bold">자주묻는질문</h2>
	<br>
	<hr style="background-color: black; height: 1.2px;">

	<form name="qnaFrm" id="qnaFrm">
		<label for="faq_category">질문유형<span class="text-danger">*</span></label>
		<select id="faq_category" name="faq_category">
			<option value="operation" ${requestScope.fvo.faq_category == 'operation' ? 'selected="selected"' : '' } >운영</option>
			<option value="product" ${requestScope.fvo.faq_category == 'product' ? 'selected="selected"' : '' }>상품</option>
			<option value="order" ${requestScope.fvo.faq_category == 'order' ? 'selected="selected"' : '' }>주문</option>
			<option value="delivery" ${requestScope.fvo.faq_category == 'delivery' ? 'selected="selected"' : '' }>배송</option>
			<option value="member" ${requestScope.fvo.faq_category == 'member' ? 'selected="selected"' : '' }>회원</option>
			<option value="else" ${requestScope.fvo.faq_category == 'else' ? 'selected="selected"' : '' }>기타</option>
		</select>

		<label for="title">질문<span class="text-danger">*</span></label> 
		<input type="text" id="title" name="title" placeholder="자주묻는질문을 입력하세요." value="${requestScope.fvo.faq_subject}"/>
		
		<label for="content">답변<span class="text-danger">*</span></label>
		<textarea id="content" name="content" placeholder="답변을 입력하세요."style="height: 200px" >${requestScope.fvo.faq_content}</textarea>

		<%-- faq_num 히든 input으로 전송 --%>
		<input type="hidden" id="faq_num" name="faq_num" value="${requestScope.fvo.faq_num}" />

		<div class="text-right" style="margin-top: 30px;">
			<input type="button" class="writeBtns" value="취소" style="margin-right: 0" onclick="goCancel();"/>&nbsp;
			<input type="button" id="EditBtn" class="btn-secondary writeBtns" value="수정" style="margin-left: 5px;" />
		</div>
	</form>
	
</div>

<%@ include file="../footer.jsp"%>

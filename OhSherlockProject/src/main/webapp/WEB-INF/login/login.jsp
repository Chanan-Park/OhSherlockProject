<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style type="text/css">
	
	form#login_frm {
  	padding: 48px 0;
    margin: 0 auto;
    margin-top: 40px;
    margin-bottom: 40px;
    border-top: 0;
	}
	
	/* 로그인폼 내용 전체 */
	div#login_box{
		width:380px;
	}
	
	/* 아이디, 비밀번호 박스랑 로그인, 회원가입 버튼 */
 	div#input_login > input {
	  width: 100%;
	  padding: 12px;
	  border: 1px solid gray;
	  margin: 5px 0;
	  opacity: 0.85;
	  font-size: 17px;
	  line-height: 20px;
	} 
 	
	button#btn_submit,
	button#btn_register {
	  width: 100%;
	  padding: 12px;
	  border-style: none;
	  margin: 5px 0;
	  opacity: 0.85;
	  font-size: 17px;
	  line-height: 20px;
	} 
	
	div#input_login > input:hover,
	button#btn_submit:hover,
	button#btn_register:hover {
	 	opacity: 1;
	}
	
	/* 아이디, 비밀번호 박스 */
	div#input_login > input {
		border-radius: 4px;
	}

	/* 버튼로그인 */
	button#btn_submit{
	    height: 45px;
	    border-radius: 90px;
	    border-style: none;
	    background-color: #1E7F15;
	    color: white;
	    cursor: pointer;
	}
	
	/* 버튼회원가입 */
	button#btn_register {
		height:45px;
		border-radius: 90px;
		border-style: none;
		background-color: #c6c6c6;
		border:none;
		color: white;
		cursor: pointer;
	}

</style>

<script>
	$(document).ready(function(){
		// 로그인을 안 한 상태일 때
		if(${empty sessionScope.loginuser}){ 
			// 로컬스토리지에 저장된 saveId를 불러와서 아이디 input태그에 넣어준다.
			const loginUserid = localStorage.getItem("saveId");
		
			if(loginUserid != null) {
				$("input#loginUserid").val(loginUserid);
				$("input:checkbox[id='saveId']").prop('checked', true);
			}
		}
		
		// 로그인 버튼 클릭 시
		$("button#btn_submit").click(function(){
			goLogin(); // 로그인 함수 호출
		});
		
		// 비밀번호 입력란에 엔터 시
		$("input#loginPwd").bind("keydown", function(event){
			if(event.keyCode == 13) { 
				goLogin(); // 로그인 함수 호출
			}
		});
		
		// 아이디 찾기 창 닫기 버튼 클릭 시
		$("button.idFindClose").click(function() {

			const iframe_idFind = document.getElementById("iframe_idFind"); // 대상 아이프레임 선택
			const iframe_window = iframe_idFind.contentWindow;

			iframe_window.func_form_reset_empty();

		});

		// 비밀번호 찾기 창 닫기 버튼 클릭 시
		$("button.passwdFindClose").click(function() {
			javascript: history.go(0);
		});
		
	});

	// 로그인 처리 함수
	function goLogin() {

		const loginUserid = $("input#loginUserid").val().trim();
		const loginPwd = $("input#loginPwd").val().trim();

		if (loginUserid == "") {
			alert("아이디를 입력하세요!");
			$("input#loginUserid").val("");
			$("input#loginUserid").focus();
			return; // 함수 종료
		}

		if (loginPwd == "") {
			alert("비밀번호를 입력하세요!");
			$("input#loginPwd").val("");
			$("input#loginPwd").focus();
			return; // 함수 종료
		}
		
		// 아이디 저장을 체크했을 경우
		if ($("#saveId").prop("checked")) {
			localStorage.setItem("saveId", loginUserid);
		}
		// 아이디 저장 체크 해제했을 경우
		else{
			localStorage.removeItem("saveId");
		}
		
		const frm = document.login_frm;
		frm.action = "<%=ctxPath%>/login/login.tea";
	    frm.method = "post";
	    frm.submit();
		
	}
	
</script>

</head>


<div class="container">

	<%-- **** 로그인 폼 **** --%>
	<form id="login_frm" name="login_frm">
		<div id="login_box" class="d-flex flex-column m-auto">
			<div id="login_title">
				<h2
					style="text-align: center; font-size: 30px; line-height: 40px; font-weight: bold">LOGIN</h2>
			</div>

			<div id="input_login" class="d-flex flex-column">
				<input type="text" name="userid" id="loginUserid" placeholder="아이디"
					required> <input type="password" name="passwd"
					id="loginPwd" placeholder="8자리 이상 15자리 이하의 영문, 숫자, 특수문자" required>
			</div>

			<div id="id_save_find" class="w-98 d-flex justify-content-between">

				<div id="idPwdSave">
					<input type="checkbox" id="saveId" title="아이디 저장 선택" />
					<label for="saveId">아이디 저장</label>
				</div>

				<div id="idFind">
					<a style="cursor: pointer;" data-toggle="modal" data-target="#userIdfind" data-dismiss="modal" data-backdrop="static">아이디 찾기 |</a>
					<a style="cursor: pointer;" data-toggle="modal" data-target="#passwdFind" data-dismiss="modal" data-backdrop="static">비밀번호찾기</a>
				</div>

			</div>

			<div class="d-flex flex-column">
				<button type="button" id="btn_submit">로그인</button>
				<a href="<%= ctxPath %>/member/memberRegister.tea"><button type="button" id="btn_register">회원가입</button></a>
			</div>
		</div>
	</form>

	<%-- **** 아이디 찾기 Modal **** --%>
	<div class="modal fade" id="userIdfind">
		<div class="modal-dialog">
			<div class="modal-content">

				<!-- Modal header -->
				<div class="modal-header">
					<h4 class="modal-title">아이디 찾기</h4>
					<button type="button" class="close idFindClose"
						data-dismiss="modal">&times;</button>
				</div>

				<!-- Modal body -->
				<div class="modal-body">
					<div id="idFind">
						<iframe id="iframe_idFind"
							style="border: none; width: 100%; height: 350px;"
							src="<%=ctxPath%>/login/idFind.tea"> </iframe>
					</div>
				</div>

				<!-- Modal footer -->
				<div class="modal-footer">
					<button type="button" class="btn btn-danger idFindClose"
						data-dismiss="modal">Close</button>
				</div>
			</div>

		</div>
	</div>

	<%-- **** 비밀번호 찾기 Modal **** --%>
	<div class="modal fade" id="passwdFind">
		<div class="modal-dialog">
			<div class="modal-content">

				<!-- Modal header -->
				<div class="modal-header">
					<h4 class="modal-title">비밀번호 찾기</h4>
					<button type="button" class="close passwdFindClose"
						data-dismiss="modal">&times;</button>
				</div>

				<!-- Modal body -->
				<div class="modal-body">
					<div id="pwFind">
						<iframe style="border: none; width: 100%; height: 350px;"
							src="<%=ctxPath%>/login/passwdFind.tea"> </iframe>
					</div>
				</div>

				<!-- Modal footer -->
				<div class="modal-footer">
					<button type="button" class="btn btn-danger passwdFindClose"
						data-dismiss="modal">Close</button>
				</div>
			</div>

		</div>
	</div>

</div>

<%@ include file="../footer.jsp"%>
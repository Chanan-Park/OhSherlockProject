package lsw.member.controller;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import common.model.MemberVO;
import lsw.member.model.InterMemberDAO;
import lsw.member.model.MemberDAO;


public class MemberRegister extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod(); 
		
		if("GET".equalsIgnoreCase(method)) {
		// GET 방식이라면    
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/member/memberRegister.jsp");
			
		}
		
		else {
		 // POST 방식이라면(즉, 회원가입 버튼을 클릭한 경우) 
			String userid = request.getParameter("userid"); 
			String passwd = request.getParameter("passwd"); 
			String name = request.getParameter("name"); 
			String postcode = request.getParameter("postcode");
			String address = request.getParameter("address"); 
			String detail_address = request.getParameter("detail_address"); 
			String extra_address = request.getParameter("extra_address"); 
			String hp1 = request.getParameter("hp1"); 
			String hp2 = request.getParameter("hp2"); 
			String hp3 = request.getParameter("hp3"); 
			String email = request.getParameter("email"); 
			String gender = request.getParameter("gender"); 
			
			String birthyyyy = request.getParameter("birthyyyy");
	         if(birthyyyy.equals("")) {
	            birthyyyy = "0000";
	        }
	        String birthmm = request.getParameter("birthmm"); 
	        if(birthmm.equals("")) {
	           birthmm = "00";
	        }
	        String birthdd = request.getParameter("birthdd");
	        if(birthdd.equals("")) {
	           birthdd = "00";
	        }
			
			String mobile = hp1 + hp2 + hp3; // "01023456789"
			String birthday = birthyyyy+"-"+birthmm+"-"+birthdd;  // "1996-10-25"
			
			MemberVO member = new MemberVO(userid, passwd, name, email, mobile, postcode, address, detail_address, extra_address, gender, birthday); 
			
			InterMemberDAO mdao = new MemberDAO();
			
			// ##### 회원가입이 성공되면 자동으로 로그인 되도록 하겠다. ##### //
			try {
				int n = mdao.registerMember(member);
				
				if(n==1) {  // DB 에 정상적으로 insert 됐다면,
					request.setAttribute("userid", userid);
					request.setAttribute("name", name);
					request.setAttribute("email", email);
					request.setAttribute("passwd", passwd);
					
				//	super.setRedirect(false);  
					super.setViewPage("/WEB-INF/member/memberRegister_success.jsp");  
					
				}
				
			} catch(SQLException e) {
				e.printStackTrace();
				super.setRedirect(true);   
			    super.setViewPage(request.getContextPath()+"/error.tea");
			}

		}
		
	}

}

package pca.cs.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import common.model.MemberVO;
import common.model.NoticeVO;

public class NoticeDAO implements InterNoticeDAO {
	
	private DataSource ds;  // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool) 이다.  
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	 
	// 생성자
	public NoticeDAO() {
		
		try {
			Context initContext = new InitialContext();
		    Context envContext  = (Context)initContext.lookup("java:/comp/env");
		    ds = (DataSource)envContext.lookup("jdbc/myprjoracle");
		    
		} catch(NamingException e) {
			e.printStackTrace();
		} 
	}
	
	// 자원 반납 메소드
	private void close() {
		try {
			if(rs != null)    {rs.close();    rs=null;}
			if(pstmt != null) {pstmt.close(); pstmt=null;}
			if(conn != null)  {conn.close();  conn=null;}
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}


	@Override
	public List<NoticeVO> showNoticeList() throws SQLException {
		
		List<NoticeVO> noticeList = new ArrayList<>();
		
		try {
			conn = ds.getConnection();

			String sql = "select noticeNo, noticeSubject, noticeContent, noticeHit, noticeDate from tbl_notice "
					+ "order by 1 desc";

			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				NoticeVO notice = new NoticeVO();
				notice.setNoticeNo(rs.getInt(1));
				notice.setNoticeSubject(rs.getString(2));
				notice.setNoticeContent(rs.getString(3));
				notice.setNoticeHit(rs.getInt(4));
				notice.setNoticeDate(rs.getDate(5));
				
				Date now = new Date();
				SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
				int nowDate = Integer.parseInt(df.format(now)); // 현재 날짜
				int regDate = Integer.parseInt(df.format(notice.getNoticeDate())); // 공지 등록 날짜
				
				if ((nowDate - regDate) < 7) {
					notice.setFresh(true); // 등록된지 7일 이내의 글이라면 최신글
				}
				
				noticeList.add(notice);
			}

		} finally {
			close();
		}		
		
		return noticeList;
	}

	@Override
	public NoticeVO showNoticeDetail(String noticeNo, MemberVO loginuser) throws SQLException {
		NoticeVO noticeDetail = new NoticeVO();
		
		try {
			conn = ds.getConnection();

			String sql = "select noticeSubject, noticeContent, noticeHit, noticeDate, noticeFile from tbl_notice where noticeNo = ?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, noticeNo);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				noticeDetail = new NoticeVO();
				noticeDetail.setNoticeSubject(rs.getString(1));
				noticeDetail.setNoticeContent(rs.getString(2));
				noticeDetail.setNoticeHit(rs.getInt(3));
				noticeDetail.setNoticeDate(rs.getDate(4));
				noticeDetail.setNoticeFile(rs.getString(5));
				
				// 조회수 증가시키기
				// 로그인 안 한 상태이거나 일반유저로 로그인한 경우
				if (loginuser == null || (loginuser != null && !loginuser.getUserid().equals("admin"))) {
					sql = "update tbl_notice set noticeHit = noticeHit + 1 where noticeNo = ?";
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, noticeNo);
					int n = pstmt.executeUpdate();
					
					if (n != 1) {
						throw new SQLException("조회수 증가 실패");
					}
				}
			}

		} finally {
			close();
		}	
		
		return noticeDetail;
	}

	@Override
	public int getSeqNo() throws SQLException {

		int seq = 0;

		try {
			conn = ds.getConnection();

			String sql = "select seq_notice.nextval from dual";

			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			rs.next();
			seq = rs.getInt(1);

		} finally {
			close();
		}
		return seq;
	}

	@Override
	public int registerNotice(int seq, String subject, String content, String file) throws SQLException {
		int n = 0;

		try {
			conn = ds.getConnection();

			String sql = "insert into tbl_notice(noticeNo, noticeSubject, noticeContent, noticeFile)\n"+
					"values(?, ?, ?, ?)";

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, seq);
			pstmt.setString(2, subject);
			pstmt.setString(3, content);
			pstmt.setString(4, file);
			n = pstmt.executeUpdate();

		} finally {
			close();
		}	
		
		return n;
	}

}

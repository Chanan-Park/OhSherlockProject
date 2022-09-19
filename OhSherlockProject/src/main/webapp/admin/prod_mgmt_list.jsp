<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    

<style>
	button {
		border-style: none;
	}
	
	input[type=button] {
		border-style: none;
	}
	
	.page-link {
	  color: #666666; 
	  background-color: #fff;
	  border: 1px solid #ccc; 
	}
	
	.page-item.active .page-link {
	 z-index: 1;
	 color: #1E7F15;
	 border-color: #1E7F15;
	 
	}
	
	.page-link:focus, .page-link:hover {
	  color: #1E7F15;
	  background-color: #fafafa; 
	  border-color: #1E7F15;
	}
	
</style>

<div class="container">

   <h2 class="col text-left" style="font-weight:bold">상품관리</h2><br>
   <hr style="background-color: black; height: 1.2px;"><br>
  
  	<div class="text-right">
	  	<input type="text" value="상품코드를 입력하세요"/>&nbsp;
	  	<button type="button"><i class="fas fa-search"></i></button>
  	</div>
  	<table class="table mt-4 prodList text-center">
			<thead class="thead-light">
				<tr>
					<th>상품코드</th>
					<th>상품명</th>
					<th>가격</th>
					<th>할인가격</th>
					<th>재고</th>
					<th>처리</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="prodNo">1234</td>
					<td>콤부차 리치피치</td>
					<td>8,000</td>
					<td>7,200</td>
					<td>12,000</td>
					<td>
						<div class="adminOnlyBtns mb-1">
							<input type="button" value="수정" /> 
							<input class="btn-dark" type="button" value="품절" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="prodNo">2345</td>
					<td>제주 순수녹차</td>
					<td>9,500</td>
					<td>-</td>
					<td>10,000</td>
					<td>
						<div class="adminOnlyBtns mb-1">
							<input type="button" value="수정" /> 
							<input class="btn-dark" type="button" value="품절" />
						</div>
					</td>
				</tr>
				
			</tbody>
		</table>
		
		<nav aria-label="Page navigation example" style="margin-top: 60px;">
		<ul class="pagination justify-content-center">
			<li class="page-item"><a class="page-link" href="#"
				aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
			</a></li>
			<li class="page-item"><a class="page-link" href="#">1</a></li>
			<li class="page-item"><a class="page-link" href="#">2</a></li>
			<li class="page-item"><a class="page-link" href="#">3</a></li>
			<li class="page-item"><a class="page-link" href="#"
				aria-label="Next"> <span aria-hidden="true">&raquo;</span>
			</a></li>
		</ul>
	</nav>
</div>

<%@ include file="../footer.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>OMS 전송 이력</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/analysis.css">
</head>
<body>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/menu.jsp"/>
<h2> OMS 전송 이력 </h2>

<form method="get" action="${pageContext.request.contextPath}/oms-history" class="search-form">
    <div class="form-group">
        <label for="clientId">업체(고객사)</label>
        <select id="clientId" name="clientId">
            <option value="">전체</option>
        </select>
    </div>
    <div class="form-row">
        <div class="form-item">
            <label for="sentDate">전송일</label>
            <input type="date" id="sentDate" name="sentDate">
        </div>
        <div class="form-item">
            <label for="sendType">전송유형</label>
            <select id="sendType" name="sendType">
                <option value="">전체</option>
                <option value="INBOUND_GUIDE">입고가이드</option>
                <option value="STOCK_DISPOSAL">재고처리</option>
            </select>
        </div>
        <div class="form-item form-item-btn">
            <button type="submit">조회</button>
        </div>
    </div>
</form>

<table>
    <thead>
        <tr>
            <th>전송일</th>
            <th>전송유형</th>
            <th>전송결과</th>
            <th>보기</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td colspan="5" class="no-data">데이터가 없습니다.</td>
        </tr>
    </tbody>
</table>

</body>
</html>
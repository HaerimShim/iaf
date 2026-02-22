<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>배치 실행 이력</title>
</head>
<body>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/menu.jsp"/>
<h2> 배치 실행 이력 </h2>

<form method="get" action="${pageContext.request.contextPath}/batchLog" class="search-form" novalidate>
    <div class="form-row">
        <div class="form-item">
            <label>기준일</label>
            <div class="date-range">
                <input type="date" id="baseDateFrom" name="baseDateFrom" value="${searchParam.baseDateFrom}">
                <span>~</span>
                <input type="date" id="baseDateTo" name="baseDateTo" value="${searchParam.baseDateTo}">
            </div>
        </div>
        <div class="form-item">
            <label for="batchName">배치명</label>
            <select id="batchName" name="batchName">
                <option value="">전체</option>
                <option value="IAF_ANALYSIS_RESULT" <c:if test="${searchParam.batchName == 'IAF_ANALYSIS_RESULT'}">selected</c:if>>분석 적재 (IAF_ANALYSIS_RESULT)</option>
                <option value="IAF_OMS_NOTIFICATION" <c:if test="${searchParam.batchName == 'IAF_OMS_NOTIFICATION'}">selected</c:if>>OMS 전송 (IAF_OMS_NOTIFICATION)</option>
            </select>
        </div>
        <div class="form-item">
            <label for="status">상태</label>
            <select id="status" name="status">
                <option value="">전체</option>
                <option value="SUCCESS" <c:if test="${searchParam.status == 'SUCCESS'}">selected</c:if>>성공</option>
                <option value="WARNING" <c:if test="${searchParam.status == 'WARNING'}">selected</c:if>>경고</option>
                <option value="FAIL" <c:if test="${searchParam.status == 'FAIL'}">selected</c:if>>실패</option>
                <option value="SKIP" <c:if test="${searchParam.status == 'SKIP'}">selected</c:if>>보류</option>
            </select>
        </div>
        <div class="form-item form-item-btn">
            <input type="hidden" name="search" value="true">
            <input type="hidden" id="page" name="page" value="1">
            <button type="submit">조회</button>
        </div>
    </div>
</form>

<h3 class="section-title">▪ 배치 실행 이력</h3>
<table>
    <colgroup>
        <col style="width:24%">
        <col style="width:10%">
        <col style="width:8%">
        <col style="width:8%">
        <col style="width:10%">
        <col style="width:18%">
        <col style="width:22%">
    </colgroup>
    <thead>
        <tr>
            <th>배치명</th>
            <th>기준일</th>
            <th>상태</th>
            <th>적재건수</th>
            <th>소요시간</th>
            <th>실행일시</th>
            <th>메세지</th>
        </tr>
    </thead>
    <tbody>
        <c:choose>
            <c:when test="${not empty batchLogList}">
                <c:forEach var="row" items="${batchLogList}">
                    <tr>
                        <td>${row.batchName}</td>
                        <td>${row.baseDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${row.status == 'SUCCESS'}"><span class="status-success">성공</span></c:when>
                                <c:when test="${row.status == 'WARNING'}"><span class="status-warning">경고</span></c:when>
                                <c:when test="${row.status == 'FAIL'}"><span class="status-fail">실패</span></c:when>
                                <c:when test="${row.status == 'SKIP'}"><span class="status-skip">보류</span></c:when>
                            </c:choose>
                        </td>
                        <td>${row.insertCount}</td>
                        <td>${row.elapsedMs}ms</td>
                        <td>${row.createdAt}</td>
                        <td style="text-align:left;">${row.errorMessage}</td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="7" class="no-data">데이터가 없습니다.</td>
                </tr>
            </c:otherwise>
        </c:choose>
    </tbody>
</table>

<c:if test="${totalPages > 0}">
<div class="pagination">
    <c:if test="${currentPage > 1}">
        <a href="#" onclick="goPage(${currentPage - 1}); return false;">&#8249;</a>
    </c:if>
    <c:forEach begin="${startPage}" end="${endPage}" var="p">
        <a href="#" onclick="goPage(${p}); return false;" class="${p == currentPage ? 'active' : ''}">${p}</a>
    </c:forEach>
    <c:if test="${currentPage < totalPages}">
        <a href="#" onclick="goPage(${currentPage + 1}); return false;">&#8250;</a>
    </c:if>
</div>
</c:if>

<script>
    var now = new Date();
    var today = now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0') + '-' + String(now.getDate()).padStart(2, '0');
    var fromEl = document.getElementById('baseDateFrom');
    var toEl = document.getElementById('baseDateTo');
    fromEl.max = today;
    toEl.max = today;
    var firstDay = now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0') + '-01';
    if (!fromEl.value) fromEl.value = firstDay;
    if (!toEl.value) toEl.value = today;

    var isGoPage = false;

    function goPage(page) {
        isGoPage = true;
        document.getElementById('page').value = page;
        document.querySelector('.search-form').submit();
    }

    document.querySelector('.search-form').addEventListener('submit', function() {
        if (!isGoPage) {
            document.getElementById('page').value = 1;
        }
    });
</script>
</body>
</html>
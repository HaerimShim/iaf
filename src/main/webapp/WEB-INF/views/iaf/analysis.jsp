<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>업체별 입·출고 분석</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/analysis.css">
</head>
<body>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/menu.jsp"/>
<h2> 업체별 입·출고 분석 </h2>

<form method="get" action="${pageContext.request.contextPath}/analysis" class="search-form">
    <div class="form-row">
        <div class="form-item">
            <label for="clientId">업체(고객사)</label>
            <select id="clientId" name="clientId">
                <option value="">전체</option>
                <c:forEach var="client" items="${clientList}">
                    <option value="${client.clientId}" <c:if test="${searchParam.clientId == client.clientId}">selected</c:if>>${client.clientName}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-item">
            <label for="category">카테고리</label>
            <select id="category" name="category">
                <option value="">전체</option>
                <c:forEach var="cat" items="${categoryList}">
                    <option value="${cat}" <c:if test="${searchParam.category == cat}">selected</c:if>>${cat}</option>
                </c:forEach>
            </select>
        </div>
    </div>
    <div class="form-row">
        <div class="form-item">
            <label for="baseDate">기준일</label>
            <input type="date" id="baseDate" name="baseDate" value="${searchParam.baseDate}">
        </div>
        <div class="form-item">
            <label for="statusFilter">상태 필터</label>
            <select id="statusFilter" name="statusFilter">
                <option value="">전체</option>
                <option value="SAFE" <c:if test="${searchParam.statusFilter == 'SAFE'}">selected</c:if>>✅안전</option>
                <option value="WARNING" <c:if test="${searchParam.statusFilter == 'WARNING'}">selected</c:if>>⚠️주의 (예상 소진일: 14일 이상)</option>
                <option value="DANGER" <c:if test="${searchParam.statusFilter == 'DANGER'}">selected</c:if>>🚨위험 (예상 소진일: 7일 이상)</option>
            </select>
        </div>
        <div class="form-item form-item-btn">
            <input type="hidden" name="search" value="true">
            <button type="submit">조회</button>
        </div>
    </div>
</form>

<table>
    <colgroup>
        <col style="width:12%">
        <col style="width:12%">
        <col style="width:12%">
        <col style="width:8%">
        <col style="width:8%">
        <col style="width:8%">
        <col style="width:8%">
        <col style="width:8%">
        <col style="width:8%">
        <col style="width:8%">
        <col style="width:8%">
    </colgroup>
    <thead>
        <tr>
            <th colspan="4">기준 데이터</th>
            <th colspan="6" class="analysis-result">분석</th>
            <th colspan="1" class="analysis-oms">조치</th>
        </tr>
        <tr>
            <th rowspan="2">카테고리</th>
            <th rowspan="2">SKU 코드</th>
            <th rowspan="2">SKU 명</th>
            <th rowspan="2">가용 재고</th>
            <th colspan="2" class="analysis-result">최근 7일</th>
            <th colspan="2" class="analysis-result">최근 28일</th>
            <th rowspan="2" class="analysis-result">상태</th>
            <th rowspan="2" class="analysis-result">권고사항</th>
            <th rowspan="2" class="analysis-oms">OMS 전송 결과</th>
        </tr>
        <tr>
            <th class="analysis-result">일평균 출고</th>
            <th class="analysis-result">예상 소진일</th>
            <th class="analysis-result">일평균 출고</th>
            <th class="analysis-result">예상 소진일</th>
        </tr>
    </thead>
    <tbody>
        <c:choose>
            <c:when test="${not empty analysisList}">
                <c:forEach var="row" items="${analysisList}">
                    <tr>
                        <td>${row.category}</td>
                        <td>${row.skuCode}</td>
                        <td>${row.skuName}</td>
                        <td class="num"><fmt:formatNumber value="${row.availableQty}" pattern="#,###"/></td>
                        <td class="num"><fmt:formatNumber value="${row.avgDailyOutboundRecent7days}" pattern="#,###.##"/></td>
                        <td class="analysis-result">${row.estimatedSoldOutDateRecent7days}</td>
                        <td class="num"><fmt:formatNumber value="${row.avgDailyOutboundRecent28days}" pattern="#,###.##"/></td>
                        <td class="analysis-result">${row.estimatedSoldOutDateRecent28days}</td>
                        <td class="analysis-result">
                            <c:choose>
                                <c:when test="${row.status == 'SAFE'}"><span class="status-safe">✅안전</span></c:when>
                                <c:when test="${row.status == 'DANGER'}"><span class="status-danger">🚨위험</span></c:when>
                                <c:when test="${row.status == 'WARNING'}"><span class="status-warning">⚠️주의</span></c:when>
                            </c:choose>
                        </td>
                        <td class="analysis-result">${row.recommendation}</td>
                        <td class="analysis-oms">
                            <c:choose>
                                <c:when test="${row.status == 'SAFE'}">N/A</c:when>
                                <c:when test="${row.omsStatus == 'SUCCESS'}"><span class="status-safe">발송완료</span></c:when>
                                <c:when test="${row.omsStatus == 'FAIL'}"><span class="status-danger">발송실패</span></c:when>
                                <c:otherwise>미발송</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="12" class="no-data">데이터가 없습니다.</td>
                </tr>
            </c:otherwise>
        </c:choose>
   </tbody>
</table>

<script>
    if (!document.getElementById('baseDate').value) {
        document.getElementById('baseDate').value = new Date().toISOString().substring(0, 10);
    }

    document.querySelector('.search-form').addEventListener('submit', function(e) {
        if (!document.getElementById('clientId').value) {
            e.preventDefault();
            alert('고객사를 선택해주세요.');
        }
    });

    document.getElementById('clientId').addEventListener('change', function() {
        var clientId = this.value;
        var categorySelect = document.getElementById('category');
        categorySelect.innerHTML = '<option value="">전체</option>';

        if (!clientId) return;

        fetch('${pageContext.request.contextPath}/analysis/categories?clientId=' + clientId)
            .then(function(response) { return response.json(); })
            .then(function(categories) {
                categories.forEach(function(cat) {
                    var option = document.createElement('option');
                    option.value = cat;
                    option.textContent = cat;
                    categorySelect.appendChild(option);
                });
            });
    });
</script>
</body>
</html>

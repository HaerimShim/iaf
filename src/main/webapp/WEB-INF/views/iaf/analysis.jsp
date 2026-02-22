<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>업체별 입·출고 분석</title>
</head>
<body>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/menu.jsp"/>
<h2> 업체별 입·출고 분석 </h2>

<form method="get" action="${pageContext.request.contextPath}/analysis" class="search-form">
    <div class="form-row">
        <div class="form-item">
            <label for="baseDate">기준일</label>
            <input type="date" id="baseDate" name="baseDate" value="${searchParam.baseDate}">
        </div>
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
        <div class="form-item">
            <label for="status">상태</label>
            <select id="status" name="status">
                <option value="">전체</option>
                <option value="SAFE" <c:if test="${searchParam.status == 'SAFE'}">selected</c:if>>안전</option>
                <option value="WARNING" <c:if test="${searchParam.status == 'WARNING'}">selected</c:if>>주의 (예상 소진일: 14일 이상)</option>
                <option value="DANGER" <c:if test="${searchParam.status == 'DANGER'}">selected</c:if>>위험 (예상 소진일: 7일 이상)</option>
            </select>
        </div>
        <div class="form-item form-item-btn">
            <input type="hidden" name="search" value="true">
            <input type="hidden" id="page" name="page" value="1">
            <button type="submit">조회</button>
        </div>
    </div>
</form>

<h3 class="section-title">▪ 분석 요약</h3>
<c:set var="selectedClientName" value="전체"/>
<c:forEach var="client" items="${clientList}">
    <c:if test="${client.clientId == searchParam.clientId}">
        <c:set var="selectedClientName" value="${client.clientName}"/>
    </c:if>
</c:forEach>
<table class="status-summary-table">
    <thead>
        <tr>
            <th>기준일</th>
            <th>업체(고객사)</th>
            <th>카테고리</th>
            <th class="status-safe">안전</th>
            <th class="status-warning">주의</th>
            <th class="status-danger">위험</th>
            <th>총계</th>
            <th class="summary-gap"></th>
            <th>주의/위험 업체수</th>
            <th>OMS 전송 건수</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><c:choose><c:when test="${not empty searchParam.baseDate}">${searchParam.baseDate}</c:when><c:otherwise>-</c:otherwise></c:choose></td>
            <td><c:choose><c:when test="${not empty statusSummary}">${selectedClientName}</c:when><c:otherwise>-</c:otherwise></c:choose></td>
            <td><c:choose><c:when test="${not empty statusSummary and not empty searchParam.category}">${searchParam.category}</c:when><c:when test="${not empty statusSummary}">전체</c:when><c:otherwise>-</c:otherwise></c:choose></td>
            <td class="status-safe"><c:choose><c:when test="${not empty statusSummary}">${statusSummary.safeCount}건</c:when><c:otherwise>-</c:otherwise></c:choose></td>
            <td class="status-warning"><c:choose><c:when test="${not empty statusSummary}">${statusSummary.warningCount}건</c:when><c:otherwise>-</c:otherwise></c:choose></td>
            <td class="status-danger"><c:choose><c:when test="${not empty statusSummary}">${statusSummary.dangerCount}건</c:when><c:otherwise>-</c:otherwise></c:choose></td>
            <td><c:choose><c:when test="${not empty statusSummary}">${totalCount}건</c:when><c:otherwise>-</c:otherwise></c:choose></td>
            <td class="summary-gap"></td>
            <td><c:choose><c:when test="${not empty statusSummary}">${alertClientCount}개</c:when><c:otherwise>-</c:otherwise></c:choose></td>
            <td><c:choose><c:when test="${not empty statusSummary}">${omsSuccessCount}건</c:when><c:otherwise>-</c:otherwise></c:choose></td>
        </tr>
    </tbody>
</table>

<h3 class="section-title">▪ 분석 상세</h3>
<table class="detail-table">
    <colgroup>
        <col style="width:10%">
        <col style="width:10%">
        <col style="width:10%">
        <col style="width:10%">
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
            <th colspan="5">기준 데이터</th>
            <th colspan="6" class="analysis-result section-border-l">분석</th>
            <th colspan="1" class="analysis-oms section-border-l">조치</th>
        </tr>
        <tr>
            <th rowspan="2">업체(고객사)</th>
            <th rowspan="2">카테고리</th>
            <th rowspan="2">SKU 코드</th>
            <th rowspan="2">SKU 명</th>
            <th rowspan="2">가용 재고</th>
            <th colspan="2" class="analysis-result section-border-l">최근 7일</th>
            <th colspan="2" class="analysis-result">최근 28일</th>
            <th rowspan="2" class="analysis-result">상태</th>
            <th rowspan="2" class="analysis-result">권고사항</th>
            <th rowspan="2" class="analysis-oms section-border-l">OMS<br>전송 결과</th>
        </tr>
        <tr>
            <th class="analysis-result section-border-l">일평균 출고</th>
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
                        <td>${row.clientName}</td>
                        <td>${row.category}</td>
                        <td>${row.skuCode}</td>
                        <td>${row.skuName}</td>
                        <td class="num"><fmt:formatNumber value="${row.availableQty}" pattern="#,###"/></td>
                        <td class="num section-border-l"><fmt:formatNumber value="${row.avgDailyOutboundRecent7days}" pattern="#,###.##"/></td>
                        <td class="analysis-result">${row.estimatedSoldOutDateRecent7days}</td>
                        <td class="num"><fmt:formatNumber value="${row.avgDailyOutboundRecent28days}" pattern="#,###.##"/></td>
                        <td class="analysis-result">${row.estimatedSoldOutDateRecent28days}</td>
                        <td class="analysis-result">
                            <c:choose>
                                <c:when test="${row.status == 'SAFE'}"><span class="status-safe">안전</span></c:when>
                                <c:when test="${row.status == 'DANGER'}"><span class="status-danger">위험</span></c:when>
                                <c:when test="${row.status == 'WARNING'}"><span class="status-warning">️주의</span></c:when>
                            </c:choose>
                        </td>
                        <td class="analysis-result">${row.recommendation}</td>
                        <td class="analysis-oms section-border-l">
                            <c:choose>
                                <c:when test="${row.status == 'SAFE'}">N/A</c:when>
                                <c:when test="${row.omsStatus == 'SUCCESS'}"><span class="status-success">성공</span></c:when>
                                <c:when test="${row.omsStatus == 'FAIL'}"><span class="status-fail">실패</span></c:when>
                                <c:when test="${row.omsStatus == 'SKIP'}"><span class="status-skip">보류</span></c:when>
                                <c:otherwise>N/A</c:otherwise>
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
    var baseDateEl = document.getElementById('baseDate');
    baseDateEl.max = today;
    if (!baseDateEl.value) {
        baseDateEl.value = today;
    }

    var isGoPage = false;

    function goPage(page) {
        isGoPage = true;
        document.getElementById('page').value = page;
        document.querySelector('.search-form').submit();
    }

    document.querySelector('.search-form').addEventListener('submit', function(e) {
        if (!isGoPage) {
            document.getElementById('page').value = 1;
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

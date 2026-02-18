<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>OMS 전송 이력</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/analysis.css">
    <style>
        .status-link { cursor: pointer; text-decoration: underline; }
        .status-success { color: #28a745; }
        .status-fail { color: #dc3545; }
        .status-skip { color: #ffc107; }
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center; }
        .modal-overlay.active { display: flex; }
        .modal { background: #fff; border-radius: 8px; width: 700px; max-height: 80vh; display: flex; flex-direction: column; }
        .modal-header { display: flex; justify-content: space-between; align-items: center; padding: 16px 20px; border-bottom: 1px solid #ddd; }
        .modal-header h3 { margin: 0; font-size: 16px; }
        .modal-close { background: none; border: none; font-size: 20px; cursor: pointer; color: #666; }
        .modal-body { padding: 20px; overflow-y: auto; }
        .modal-body pre { background: #f5f5f5; padding: 16px; border-radius: 4px; font-size: 13px; white-space: pre-wrap; word-break: break-all; margin: 0; max-height: 50vh; overflow-y: auto; }
        .modal-label { font-weight: bold; font-size: 13px; margin-bottom: 8px; color: #555; }
    </style>
</head>
<body>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/menu.jsp"/>
<h2> OMS 전송 이력 </h2>

<form method="get" action="${pageContext.request.contextPath}/oms-history" class="search-form">
    <div class="form-row">
        <div class="form-item">
            <label for="clientId">업체(고객사)</label>
            <select id="clientId" name="clientId">
                <option value="">전체</option>
                <c:forEach var="client" items="${clientList}">
                    <option value="${client.clientId}" <c:if test="${clientId == client.clientId}">selected</c:if>>${client.clientName}</option>
                </c:forEach>
            </select>
        </div>
    </div>
    <div class="form-row">
        <div class="form-item">
            <label for="baseDate">기준일</label>
            <input type="date" id="baseDate" name="baseDate" value="${baseDate}">
        </div>
        <div class="form-item">
            <label for="status">전송유형</label>
            <select id="status" name="status">
                <option value="">전체</option>
                <option value="SUCCESS" <c:if test="${status == 'SUCCESS'}">selected</c:if>>성공</option>
                <option value="FAIL" <c:if test="${status == 'FAIL'}">selected</c:if>>실패</option>
                <option value="SKIP" <c:if test="${status == 'SKIP'}">selected</c:if>>보류</option>
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
        <col style="width:26%">
        <col style="width:12%">
        <col style="width:12%">
        <col style="width:20%">
    </colgroup>
    <thead>
        <tr>
            <th>고객사</th>
            <th>발송 URL</th>
            <th>전송결과</th>
            <th>소요시간</th>
            <th>전송일시</th>
        </tr>
    </thead>
    <tbody>
        <c:choose>
            <c:when test="${not empty historyList}">
                <c:forEach var="row" items="${historyList}" varStatus="idx">
                    <tr>
                        <td>${row.clientName}</td>
                        <td>${row.omsUrl}</td>
                        <td>
                            <c:choose>
                                <c:when test="${row.status == 'SUCCESS'}">
                                    <span class="status-link status-success" onclick="showDetail(${idx.index})">성공</span>
                                </c:when>
                                <c:when test="${row.status == 'FAIL'}">
                                    <span class="status-link status-fail" onclick="showDetail(${idx.index})">실패</span>
                                </c:when>
                                <c:when test="${row.status == 'SKIP'}">
                                    <span class="status-link status-skip" onclick="showDetail(${idx.index})">보류</span>
                                </c:when>
                            </c:choose>
                        </td>
                        <td>${row.elapsedMs}ms</td>
                        <td>${row.createdAt}</td>
                    </tr>
                    <textarea class="hidden-payload" style="display:none" data-status="${row.status}" data-client="${row.clientName}" data-error="${row.errorMessage}">${row.requestPayload}</textarea>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="5" class="no-data">데이터가 없습니다.</td>
                </tr>
            </c:otherwise>
        </c:choose>
    </tbody>
</table>

<div id="detailModal" class="modal-overlay" onclick="closeModal(event)">
    <div class="modal" onclick="event.stopPropagation()">
        <div class="modal-header">
            <h3 id="modalTitle">상세 정보</h3>
            <button class="modal-close" onclick="closeModal()">&times;</button>
        </div>
        <div class="modal-body">
            <div id="modalContent"></div>
        </div>
    </div>
</div>

<script>
    if (!document.getElementById('baseDate').value) {
        document.getElementById('baseDate').value = new Date().toISOString().substring(0, 10);
    }

    function sortKeys(obj) {
        if (Array.isArray(obj)) return obj.map(sortKeys);
        if (obj !== null && typeof obj === 'object') {
            return Object.keys(obj).sort().reduce(function(sorted, key) {
                sorted[key] = sortKeys(obj[key]);
                return sorted;
            }, {});
        }
        return obj;
    }

    function showDetail(index) {
        var el = document.querySelectorAll('.hidden-payload')[index];
        var status = el.dataset.status;
        var clientName = el.dataset.client;
        var errorMessage = el.dataset.error;
        var modal = document.getElementById('detailModal');
        var title = document.getElementById('modalTitle');
        var content = document.getElementById('modalContent');

        if (status === 'SUCCESS') {
            title.textContent = clientName + ' - 발송 JSON';
            try {
                var json = sortKeys(JSON.parse(el.value));
                content.innerHTML = '<pre>' + JSON.stringify(json, null, 2) + '</pre>';
            } catch(e) {
                content.textContent = el.value;
            }
        } else if (status === 'FAIL') {
            title.textContent = clientName + ' - 에러 메시지';
            content.innerHTML = '<pre>' + (errorMessage || '에러 메시지 없음') + '</pre>';
        } else {
            title.textContent = clientName + ' - 보류 사유';
            content.innerHTML = '<pre>' + (errorMessage || '사유 없음') + '</pre>';
        }

        modal.classList.add('active');
    }

    function closeModal(event) {
        if (!event || event.target === document.getElementById('detailModal')) {
            document.getElementById('detailModal').classList.remove('active');
        }
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeModal();
    });
</script>
</body>
</html>

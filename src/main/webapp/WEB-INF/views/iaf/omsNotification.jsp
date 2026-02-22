<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>OMS 전송 이력</title>

</head>
<body>

<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/menu.jsp"/>
<h2> OMS 전송 이력 </h2>

<form method="get" action="${pageContext.request.contextPath}/omsNotification" class="search-form">
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
            <label for="status">전송결과</label>
            <select id="status" name="status">
                <option value="">전체</option>
                <option value="SUCCESS" <c:if test="${searchParam.status == 'SUCCESS'}">selected</c:if>>성공</option>
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

<h3 class="section-title">▪ 전송 이력 요약 </h3>
<h3 class="section-title-sub">( 업체별 마지막 전송 이력을 기준으로 조회합니다. 보류 - 보류 - 성공 시, '성공 1건' )</h3>
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
            <th class="status-success">성공</th>
            <th class="status-fail">실패</th>
            <th class="status-skip">보류</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><c:choose><c:when test="${not empty searchParam.baseDate}">${searchParam.baseDate}</c:when><c:otherwise>-</c:otherwise></c:choose></td>
            <td><c:choose><c:when test="${not empty statusSummary}">${selectedClientName}</c:when><c:otherwise>-</c:otherwise></c:choose></td>
            <td class="status-success"><c:choose><c:when test="${not empty statusSummary}">${statusSummary.successCount}건</c:when><c:otherwise>-</c:otherwise></c:choose></td>
            <td class="status-fail"><c:choose><c:when test="${not empty statusSummary}">${statusSummary.failCount}건</c:when><c:otherwise>-</c:otherwise></c:choose></td>
            <td class="status-skip"><c:choose><c:when test="${not empty statusSummary}">${statusSummary.skipCount}건</c:when><c:otherwise>-</c:otherwise></c:choose></td>
        </tr>
    </tbody>
</table>

<h3 class="section-title">▪️전송 이력 상세</h3>
<table class="oms-detail">
    <colgroup>
        <col style="width:10%">
        <col style="width:18%">
        <col style="width:8%">
        <col style="width:8%">
        <col style="width:14%">
        <col style="width:34%">
        <col style="width:8%">
    </colgroup>
    <thead>
        <tr>
            <th>고객사</th>
            <th>OMS URL</th>
            <th>전송결과</th>
            <th>소요시간</th>
            <th>전송일시</th>
            <th>메세지</th>
            <th>재발송</th>
        </tr>
    </thead>
    <tbody>
        <c:choose>
            <c:when test="${not empty historyList}">
                <c:forEach var="row" items="${historyList}" varStatus="idx">
                    <tr data-client-id="${row.clientId}">
                        <td>${row.clientName}</td>
                        <td>${row.omsUrl}</td>
                        <td>
                            <c:choose>
                                <c:when test="${row.status == 'SUCCESS'}"><span class="status-success">성공</span></c:when>
                                <c:when test="${row.status == 'FAIL'}"><span class="status-fail">실패</span></c:when>
                                <c:when test="${row.status == 'SKIP'}"><span class="status-skip">보류</span></c:when>
                            </c:choose>
                        </td>
                        <td>${row.elapsedMs}ms</td>
                        <td>${row.createdAt}</td>
                        <td style="text-align:left;">
                            <c:choose>
                                <c:when test="${row.status == 'SUCCESS'}">
                                    <span class="status-link" onclick="showDetail(${idx.index})">전송 메세지 상세보기</span>
                                </c:when>
                                <c:otherwise>${row.errorMessage}</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${row.status == 'FAIL' or row.status == 'SKIP'}">
                                <button class="resend-btn" onclick="resend('${row.baseDate}', ${row.clientId}, '${row.clientName}', this)">재발송</button>
                            </c:if>
                        </td>
                    </tr>
                    <textarea class="hidden-payload" style="display:none" data-status="${row.status}" data-client="${row.clientName}" data-error="${row.errorMessage}">${row.requestPayload}</textarea>
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

    document.querySelector('.search-form').addEventListener('submit', function() {
        if (!isGoPage) {
            document.getElementById('page').value = 1;
        }
    });

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

    var contextPath = '${pageContext.request.contextPath}';

    document.addEventListener('DOMContentLoaded', function() {
        var seen = {};
        document.querySelectorAll('tbody tr[data-client-id]').forEach(function(tr) {
            var clientId = tr.dataset.clientId;
            if (seen[clientId]) {
                var btn = tr.querySelector('.resend-btn');
                if (btn) btn.remove();
            } else {
                seen[clientId] = true;
            }
        });
    });

    function resend(baseDate, clientId, clientName, btn) {
        if (!confirm('[' + baseDate + '] ' + clientName + '\n재발송하시겠습니까?')) return;
        btn.disabled = true;
        btn.textContent = '발송중';
        fetch(contextPath + '/oms/resendOne', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'baseDate=' + encodeURIComponent(baseDate) + '&clientId=' + clientId
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.result === 'OK') {
                alert('재발송 완료. 이력을 새로고침합니다.');
            } else {
                alert('재발송 실패: ' + (data.message || '알 수 없는 오류'));
            }
            location.reload();
        })
        .catch(function() {
            alert('재발송 중 오류가 발생했습니다.');
            btn.disabled = false;
            btn.textContent = '재발송';
        });
    }
</script>
</body>
</html>

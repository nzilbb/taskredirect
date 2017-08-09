<%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<h1>${page.title}</h1>

<c:if test="${notunique}"><div id="notunique">
    <div id="alreadydone">${task.already_done_message}</div>
</div></c:if>

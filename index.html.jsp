<%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<h1>${page.title}</h1>

<c:if test="${!empty tasks}">
  <ul id="tasks">
    <c:forEach var="task" items="${tasks}">
    <li id="${task.task_id}"><a href="?task_id=${task.task_id}">${task.name}</a></li></c:forEach>
  </ul>
</c:if>

<c:if test="${!empty task}">
  <c:if test="${task.active eq 1}">
    <div id="description">${task.description}</div>
    <hex:button text="${resources['Start']}" 
		title="${resources['Start the task now']}"
		icon="${template_path}/icon/go-next.png"
		url="consent?task_id=${task.task_id}"/>
  </c:if>
  
  <c:if test="${task.active ne 1}">
    <div id="consent">${task.inactive_message}</div>
  </c:if>
  
</c:if>

<c:if test="${empty tasks and empty task}">
  <p>${resources["Sorry, there are currently no active tasks."]}</p>
</c:if>

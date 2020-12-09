<%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"
%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" 
%>

<h1>${page.title}</h1>

<c:if test="${!empty task}">
  
  <c:if test="${task.active eq 1}">
    <div id="consent">${task.consent}</div>
    <form id="consentform" action="start" method="post" onpost="return consent();">
      <c:forEach var="field" items="${fields}">
	<div class="field" id="${field.name}">
	  <label><input type="checkbox"
                        name="${field.name}"
                        id="f_${field.name}"
                        value="true"
                        <c:if test="${field.required eq 1}">required</c:if>
                        ><span class="description">${field.description}</span></label>
      </div></c:forEach>
      <div class="signature">
	<input type="hidden" name="task_id" value="${task.task_id}"/>
	<input type="hidden" name="client_id" id="client_id" value=""/>
	<input type="email" name="signature" class="signature" placeholder="${resources['Email Address']}" autofocus required />
      </div>
      <div class="consentbutton">
	<hex:submitbutton text="${resources['Start']}" 
			  title="${resources['Start the task now']}"
			  onclick="return consent();"
			  icon="${template_path}/icon/go-next.png"/>
      </div>
    </form>
    <script type="text/javascript">//<![CDATA[
// get consent
function consent() {
    var frm = document.getElementById("consentform");
        <c:forEach var="field" items="${fields}">
        <c:if test="${field.required eq 1}">
        if (!document.getElementById("f_${field.name}").checked) {
            alert('${resources['Please tick indicate your consent:']} ${field.description}');
            document.getElementById("f_${field.name}").focus();
            return false;
        }
        </c:if>
        </c:forEach>
  if (frm.signature.value.trim() == "") {
    alert("${resources['Please fill in the box to indicate your consent.']}");
    frm.signature.focus();
    return false;
<c:if test="${!empty task.valid_signature_pattern}">
  } else if (!new RegExp("${task.valid_signature_pattern}").test(frm.signature.value)) {
    alert("${resources['Please fill in the box to indicate your consent.']}");
    frm.signature.focus();
    return false;
</c:if>
  }
  document.getElementById("client_id").value = clientid; // unique client ID from clientid script
  return true;
}
//]]></script>
  </c:if>

  <c:if test="${task.active ne 1}">
    <div id="consent">${task.inactive_message}</div>
  </c:if>
  
</c:if>

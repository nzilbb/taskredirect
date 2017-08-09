<%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%><%@ taglib  prefix="db" uri="/WEB-INF/dbtags.tld" 
%><%@ page import = "java.sql.*" 
%><%
Page pg = (Page) request.getAttribute("page");
pg.setTitle("Tasks");
pg.addBreadCrumb("Tasks", "tasks");
PreparedStatement sql = pg.prepareStatement(
   "SELECT name FROM " + pg.getModule() + "_task_definition WHERE task_id = ?");
sql.setString(1, request.getParameter("task_id"));
ResultSet rs = sql.executeQuery();
rs.next();
pg.addBreadCrumb(rs.getString("name"), "task?task_id="+request.getParameter("task_id"));
rs.close();
sql.close();
pg.set("folder", pg.getModule().getModuleRoot() + "/files", false);
%><c:set var="db_table" scope="request"><db:table 
   type="edit"
   insert="false" 
   view="form" 
   columns="2"
   tableName="{module}_task_definition"
   title="${resources['Tasks']}"
   connection="${page.connection}"	
   deleteQuery="SELECT count(*) FROM {module}_participant WHERE task_id = ?"
   deleteError="Could not delete - there have already been experiments using this task."
   deleteButton="{template_path}icon/user-trash.png"
   insertButton="{template_path}icon/document-new.png"
   saveButton="{template_path}icon/document-save.png"
   iconAndText="true"
   >
  <db:field
     name="task_id"
     label="ID"
     type="integer"
     access="hidden"
     isId="true"
     newValueQuery="SELECT COALESCE(MAX(task_id) + 1, 1) FROM {module}_task_definition"
     required="true"
     deleteQuery="0"
     linkAs="task_id"	
     where="1"
     />				
  <db:field
     name="name"	
     label="${resources['Name']}"
     description="${resources['Title for the task']}"     
     type="string"
     access="readwrite"
     required="true"
     order="2"
     languages="${languages}"
     language="${language}"
     size="30"
     columns="2"
     />
  <db:field
     name="active"
     label="${resources['Active']}"
     type="select"
     access="readwrite"
     required="true"
     optionValues="${resources['0:Disabled|1:Enabled']}"
     defaultValue="1"
     />
  <db:field
     name="max_participants"
     label="${resources['Max Participants']}"
     description="${resources['Maximum number of participants, or zero for no maximum']}"
     type="integer"
     access="readwrite"
     required="true"
     size="2"
     defaultValue="0"
     />
  <db:field
     name="email"	
     label="${resources['Email']}"
     description="${resources['Email for notifications']}"     
     type="string"
     access="readwrite"
     required="false"
     columns="2"
     size="50"
     />
  <db:field
     name="url"	
     label="${resources['URL']}"
     description="${resources['Send participants to this address']}"     
     type="string"
     access="readwrite"
     required="false"
     columns="2"
     size="50"
     />
  <db:field
     name="description"
     label="${resources['Description']}"
     description="${resources['Description and instructions for the task']}"     
     type="html"
     toolbar="Full"
     folder="${folder}"
     size="0" rows="12"
     access="readwrite"
     required="false"
     languages="${languages}"
     language="${language}"
     columns="2"
     />
  <db:field
     name="consent"
     label="${resources['Consent']}"
     description="${resources['Consent form text']}"     
     type="html"
     toolbar="Full"
     folder="${folder}"
     size="0" rows="12"
     access="readwrite"
     required="false"
     languages="${languages}"
     language="${language}"
     columns="2"
     />
  <db:field
     name="valid_signature_pattern"	
     label="${resources['Consent Pattern']}"
     description="${resources['Regular expression defining valid signatures, if it is to be restricted - e.g. ACCEPT']}"     
     type="string"
     access="readwrite"
     required="false"
     columns="2"
     size="20"
     />
  <db:field
     name="already_done_message"
     label="${resources['Already Done Message']}"
     description="${resources['Message displayed when participant enters an email that has already been entered for the task']}"     
     type="html"
     toolbar="Full"
     folder="${folder}"
     size="0" rows="12"
     access="readwrite"
     required="false"
     languages="${languages}"
     language="${language}"
     columns="2"
     />
  <db:field
     name="inactive_message"
     label="${resources['Inactive Message']}"
     description="${resources['Message displayed when the task is marked as inactive']}"     
     type="html"
     toolbar="Full"
     folder="${folder}"
     size="0" rows="12"
     access="readwrite"
     required="false"
     languages="${languages}"
     language="${language}"
     columns="2"
     />
  <db:link 
     url="task_fields"
     htmlTitle="${resources['Fields']}"
     text="${resources['Fields']}"
     icon="${template_path}icon/preferences-desktop.png"
     />

</db:table></c:set>

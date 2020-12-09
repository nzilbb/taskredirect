<%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%><%@ taglib  prefix="db" uri="/WEB-INF/dbtags.tld" 
%><%@ page import = "java.sql.*" 
%><%
Page pg = (Page) request.getAttribute("page");
pg.addBreadCrumb("Tasks", "tasks");
PreparedStatement sql = pg.prepareStatement(
   "SELECT name FROM " + pg.getModule() + "_task_definition WHERE task_id = ?");
sql.setString(1, request.getParameter("task_id"));
ResultSet rs = sql.executeQuery();
rs.next();
pg.addBreadCrumb(rs.getString("name"), "task?task_id="+request.getParameter("task_id"));
pg.setTitle("Fields: " + rs.getString("name"));
rs.close();
sql.close();
pg.addBreadCrumb("Fields");
%><c:set var="db_table" scope="request"><db:table 
   type="editdelete"
   insert="true" 
   view="list" 
   tableName="{module}_task_field"
   title="${pg.title}"
   connection="${page.connection}"	
   deleteButton="{template_path}icon/user-trash.png"
   insertButton="{template_path}icon/document-new.png"
   saveButton="{template_path}icon/document-save.png"
   iconAndText="true"
   >
  <db:field
     name="task_id"
     forceValue="{task_id}"
     defaultValue="{task_id}"
     label="ID"
     type="integer"
     access="hidden"
     isId="true"
     required="true"
     deleteQuery="0"
     linkAs="task_id"	
     where="1"
     />				
  <db:field
     name="name"	
     label="${resources['Name']}"
     description="${resources['Name of field']}"     
     type="string"
     access="readwriteonce"
     isId="true"
     required="true"
     order="2"
     size="5"
     />
  <db:field
     name="description"
     label="${resources['Description']}"
     type="string"
     access="readwrite"
     languages="${languages}"
     language="${language}"
     required="true"
     size="30"
     />
  <db:field
     name="required"
     label="${resources['Required']}"
     type="integer"
     access="readwrite"
     optionValues="${resources['1:yes|0:no']}"
     required="true"
     />
</db:table></c:set>

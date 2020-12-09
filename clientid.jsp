<%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ page import = "java.security.MessageDigest" 
%><%@ page import = "org.apache.commons.codec.binary.Hex" 
%><%
{
   String etag = request.getHeader("If-None-Match");
   if (etag == null)
   { // no etag, so generate one
      MessageDigest md5 = MessageDigest.getInstance("MD5");
      md5.update(("TODO-random something" //
		  + new java.util.Date().toString()) // with current time as a nonce
		 .getBytes());
      byte[] hash = md5.digest();
      etag = new String(Hex.encodeHex(hash));
   }
   Page pg = (Page) request.getAttribute("page");
   pg.set("etag", etag);
   pg.addResponseHeader("ETag", etag);
   pg.setContentType("application/javascript");
   pg.setTemplatePage(null);
}
%>

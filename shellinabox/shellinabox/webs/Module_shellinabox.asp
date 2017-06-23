<script language="javascript">
var current_url = window.location.href;
//console.log(current_url.indexOf("ddns.to"));
sub_domain = current_url.split("/")[2].split(".")[0];
if(current_url.indexOf("ddns.to") != -1){
	$("#shell").attr("src","https://" + sub_domain + "-cmd.ddns.to/");
}else{
	$("#shell").attr("src","http://" + location.hostname + ":4200/");
}
location.href = "http://" + location.hostname + ":4200/"
</script>

<script type="text/javascript" src="/js/jquery.js"></script>
<script language="javascript">
var current_url = window.location.href;
console.log(current_url.indexOf("ddns.to"));
sub_domain = current_url.split("/")[2].split(".")[0];
if(current_url.indexOf("ddns.to") != -1){
	location.href = "https://" + sub_domain + "-cmd.ddns.to/"
}else{
	location.href = "http://" + location.hostname + ":4200/"
}
</script>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>FC64 with memory debug</title>
<script src="js/jquery-1.3.min.js" language="javascript"></script>
<script src="js/jquery.flash.js" language="javascript"></script>
</head>
<body style="background: #000;">
	<div id="fc64"></div>

	<script>

	$(document).ready(function()
	{
		$('#fc64').flash(
		{ 
			src: 'FC64.swf',
			width: 440,
			height: 620,
			flashvars:
			{
			    <?php if (isset($_GET['url'])) echo "prgURL: \"".$_GET['url']."\""; ?>
			}
		}, { version: 9 });
	});
	</script>

</body>
</html>
